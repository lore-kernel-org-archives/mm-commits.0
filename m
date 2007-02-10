From: akpm@linux-foundation.org
Subject: + fix-quadratic-behavior-of-shrink_dcache_parent.patch added to -mm tree
Date: Fri, 09 Feb 2007 16:01:02 -0800
Message-ID: <200702100001.l1A012Ca030398@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946785AbXBJAOU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 19:14:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, dipankar@in.ibm.com, hch@lst.de, maneesh@in.ibm.com, neilb@suse.de, paulmck@us.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     fix quadratic behavior of shrink_dcache_parent()
has been added to the -mm tree.  Its filename is
     fix-quadratic-behavior-of-shrink_dcache_parent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix quadratic behavior of shrink_dcache_parent()
From: Miklos Szeredi <mszeredi@suse.cz>

The time shrink_dcache_parent() takes, grows quadratically with the depth
of the tree under 'parent'.  This starts to get noticable at about 10,000.

These kinds of depths don't occur normally, and filesystems which invoke
shrink_dcache_parent() via d_invalidate() seem to have other depth
dependent timings, so it's not even easy to expose this problem.

However with FUSE it's easy to create a deep tree and d_invalidate()
will also get called.  This can make a syscall hang for a very long
time.

This is the original discovery of the problem by Russ Cox:

  http://article.gmane.org/gmane.comp.file-systems.fuse.devel/3826

The following patch fixes the quadratic behavior, by optionally allowing
prune_dcache() to prune ancestors of a dentry in one go, instead of doing
it one at a time.

Common code in dput() and prune_one_dentry() is extracted into a new helper
function d_kill().

shrink_dcache_parent() as well as shrink_dcache_sb() are converted to use
the ancestry-pruner option.  Only for shrink_dcache_memory() is this
behavior not desirable, so it keeps using the old algorithm.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |  105 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 68 insertions(+), 37 deletions(-)

diff -puN fs/dcache.c~fix-quadratic-behavior-of-shrink_dcache_parent fs/dcache.c
--- a/fs/dcache.c~fix-quadratic-behavior-of-shrink_dcache_parent
+++ a/fs/dcache.c
@@ -121,6 +121,28 @@ static void dentry_iput(struct dentry * 
 	}
 }
 
+/**
+ * d_kill - kill dentry and return parent
+ * @dentry: dentry to kill
+ *
+ * Called with dcache_lock and d_lock, releases both.  The dentry must
+ * already be unhashed and removed from the LRU.
+ *
+ * If this is the root of the dentry tree, return NULL.
+ */
+static struct dentry *d_kill(struct dentry *dentry)
+{
+	struct dentry *parent;
+
+	list_del(&dentry->d_u.d_child);
+	dentry_stat.nr_dentry--;	/* For d_free, below */
+	/*drops the locks, at that point nobody can reach this dentry */
+	dentry_iput(dentry);
+	parent = dentry->d_parent;
+	d_free(dentry);
+	return dentry == parent ? NULL : parent;
+}
+
 /* 
  * This is dput
  *
@@ -189,28 +211,17 @@ repeat:
 
 unhash_it:
 	__d_drop(dentry);
-
-kill_it: {
-		struct dentry *parent;
-
-		/* If dentry was on d_lru list
-		 * delete it from there
-		 */
-  		if (!list_empty(&dentry->d_lru)) {
-  			list_del(&dentry->d_lru);
-  			dentry_stat.nr_unused--;
-  		}
-  		list_del(&dentry->d_u.d_child);
-		dentry_stat.nr_dentry--;	/* For d_free, below */
-		/*drops the locks, at that point nobody can reach this dentry */
-		dentry_iput(dentry);
-		parent = dentry->d_parent;
-		d_free(dentry);
-		if (dentry == parent)
-			return;
-		dentry = parent;
-		goto repeat;
+kill_it:
+	/* If dentry was on d_lru list
+	 * delete it from there
+	 */
+	if (!list_empty(&dentry->d_lru)) {
+		list_del(&dentry->d_lru);
+		dentry_stat.nr_unused--;
 	}
+	dentry = d_kill(dentry);
+	if (dentry)
+		goto repeat;
 }
 
 /**
@@ -371,22 +382,41 @@ restart:
  * Throw away a dentry - free the inode, dput the parent.  This requires that
  * the LRU list has already been removed.
  *
+ * If prune_parents is true, try to prune ancestors as well.
+ *
  * Called with dcache_lock, drops it and then regains.
  * Called with dentry->d_lock held, drops it.
  */
-static void prune_one_dentry(struct dentry * dentry)
+static void prune_one_dentry(struct dentry * dentry, int prune_parents)
 {
-	struct dentry * parent;
-
 	__d_drop(dentry);
-	list_del(&dentry->d_u.d_child);
-	dentry_stat.nr_dentry--;	/* For d_free, below */
-	dentry_iput(dentry);
-	parent = dentry->d_parent;
-	d_free(dentry);
-	if (parent != dentry)
-		dput(parent);
+	dentry = d_kill(dentry);
+	if (!prune_parents) {
+		if (dentry)
+			dput(dentry);
+		spin_lock(&dcache_lock);
+		return;
+	}
+
+	/*
+	 * Prune ancestors.  Locking is simpler than in dput(),
+	 * because dcache_lock needs to be taken anyway.
+	 */
 	spin_lock(&dcache_lock);
+	while (dentry) {
+		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock))
+			return;
+
+		if (dentry->d_op && dentry->d_op->d_delete)
+			dentry->d_op->d_delete(dentry);
+		if (!list_empty(&dentry->d_lru)) {
+			list_del(&dentry->d_lru);
+			dentry_stat.nr_unused--;
+		}
+		__d_drop(dentry);
+		dentry = d_kill(dentry);
+		spin_lock(&dcache_lock);
+	}
 }
 
 /**
@@ -394,6 +424,7 @@ static void prune_one_dentry(struct dent
  * @count: number of entries to try and free
  * @sb: if given, ignore dentries for other superblocks
  *         which are being unmounted.
+ * @prune_parents: if true, try to prune ancestors as well in one go
  *
  * Shrink the dcache. This is done when we need
  * more memory, or simply when we need to unmount
@@ -404,7 +435,7 @@ static void prune_one_dentry(struct dent
  * all the dentries are in use.
  */
  
-static void prune_dcache(int count, struct super_block *sb)
+static void prune_dcache(int count, struct super_block *sb, int prune_parents)
 {
 	spin_lock(&dcache_lock);
 	for (; count ; count--) {
@@ -464,7 +495,7 @@ static void prune_dcache(int count, stru
 		 * without taking the s_umount lock (I already hold it).
 		 */
 		if (sb && dentry->d_sb == sb) {
-			prune_one_dentry(dentry);
+			prune_one_dentry(dentry, prune_parents);
 			continue;
 		}
 		/*
@@ -479,7 +510,7 @@ static void prune_dcache(int count, stru
 		s_umount = &dentry->d_sb->s_umount;
 		if (down_read_trylock(s_umount)) {
 			if (dentry->d_sb->s_root != NULL) {
-				prune_one_dentry(dentry);
+				prune_one_dentry(dentry, prune_parents);
 				up_read(s_umount);
 				continue;
 			}
@@ -550,7 +581,7 @@ repeat:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-		prune_one_dentry(dentry);
+		prune_one_dentry(dentry, 1);
 		cond_resched_lock(&dcache_lock);
 		goto repeat;
 	}
@@ -829,7 +860,7 @@ void shrink_dcache_parent(struct dentry 
 	int found;
 
 	while ((found = select_parent(parent)) != 0)
-		prune_dcache(found, parent->d_sb);
+		prune_dcache(found, parent->d_sb, 1);
 }
 
 /*
@@ -849,7 +880,7 @@ static int shrink_dcache_memory(int nr, 
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
-		prune_dcache(nr, NULL);
+		prune_dcache(nr, NULL, 0);
 	}
 	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fix-quadratic-behavior-of-shrink_dcache_parent.patch

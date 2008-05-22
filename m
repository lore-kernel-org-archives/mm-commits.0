From: akpm@linux-foundation.org
Subject: + fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch added to -mm tree
Date: Wed, 21 May 2008 23:55:21 -0700
Message-ID: <200805220655.m4M6tLsK021996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758149AbYEVGzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 02:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: k-makita@np.css.fujitsu.com, bfields@fieldses.org, dgc@sgi.com, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     fix soft lock up at NFS mount via per-SB LRU-list of unused dentries
has been added to the -mm tree.  Its filename is
     fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix soft lock up at NFS mount via per-SB LRU-list of unused dentries
From: Kentaro Makita <k-makita@np.css.fujitsu.com>

[Summary]

 Split LRU-list of unused dentries to one per superblock to avoid soft
 lock up during NFS mounts and remounting of any filesystem.

 Previously I posted here:
 http://lkml.org/lkml/2008/3/5/590

[Descriptions]

- background

  dentry_unused is a list of dentries which are not referenced. 
  dentry_unused grows up when references on directories or files are
  released.  This list can be very long if there is huge free memory.

- the problem

  When shrink_dcache_sb() is called, it scans all dentry_unused linearly
  under spin_lock(), and if dentry->d_sb is differnt from given
  superblock, scan next dentry.  This scan costs very much if there are
  many entries, and very ineffective if there are many superblocks.

  IOW, When we need to shrink unused dentries on one dentry, but scans
  unused dentries on all superblocks in the system.  For example, we scan
  500 dentries to unmount a filesystem, but scans 1,000,000 or more unused
  dentries on other superblocks.

  In our case , At mounting NFS*, shrink_dcache_sb() is called to shrink
  unused dentries on NFS, but scans 100,000,000 unused dentries on
  superblocks in the system such as local ext3 filesystems.  I hear NFS
  mounting took 1 min on some system in use.

* : NFS uses virtual filesystem in rpc layer, so NFS is affected by
  this problem.

  100,000,000 is possible number on large systems.

  Per-superblock LRU of unused dentried can reduce the cost in
  reasonable manner.

- How to fix

  I found this problem is solved by David Chinner's "Per-superblock
  unused dentry LRU lists V3"(1), so I rebase it and add some fix to
  reclaim with fairness, which is in Andrew Morton's comments(2).

  1) http://lkml.org/lkml/2006/5/25/318
  2) http://lkml.org/lkml/2006/5/25/320

  Split LRU-list of unused dentries to each superblocks.  Then, NFS
  mounting will check dentries under a superblock instead of all.  But
  this spliting will break LRU of dentry-unused.  So, I've attempted to
  make reclaim unused dentrins with fairness by calculate number of
  dentries to scan on this sb based on following way

  number of dentries to scan on this sb =
  count * (number of dentries on this sb / number of dentries in the machine)

- ToDo
 - I have to measuring performance number and do stress tests.

 - When unmount occurs during prune_dcache(), scanning on same
  superblock, It is unable to reach next superblock because it is gone
  away.  We restart scannig superblock from first one, it causes
  unfairness of reclaim unused dentries on first superblock.  But I think
  this happens very rarely.

- Test Results

  Result on 6GB boxes with excessive unused dentries.

Without patch:

$ cat /proc/sys/fs/dentry-state
10181835        10180203        45      0       0       0
# mount -t nfs 10.124.60.70:/work/kernel-src nfs
real    0m1.830s
user    0m0.001s
sys     0m1.653s

 With this patch:
$ cat /proc/sys/fs/dentry-state
10236610        10234751        45      0       0       0
# mount -t nfs 10.124.60.70:/work/kernel-src nfs
real    0m0.106s
user    0m0.002s
sys     0m0.032s

Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: David Chinner <dgc@sgi.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c        |  332 +++++++++++++++++++++++--------------------
 fs/super.c         |    1 
 include/linux/fs.h |    3 
 3 files changed, 185 insertions(+), 151 deletions(-)

diff -puN fs/dcache.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries fs/dcache.c
--- a/fs/dcache.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries
+++ a/fs/dcache.c
@@ -60,7 +60,6 @@ static struct kmem_cache *dentry_cache _
 static unsigned int d_hash_mask __read_mostly;
 static unsigned int d_hash_shift __read_mostly;
 static struct hlist_head *dentry_hashtable __read_mostly;
-static LIST_HEAD(dentry_unused);
 
 /* Statistics gathering. */
 struct dentry_stat_t dentry_stat = {
@@ -95,14 +94,6 @@ static void d_free(struct dentry *dentry
 		call_rcu(&dentry->d_u.d_rcu, d_callback);
 }
 
-static void dentry_lru_remove(struct dentry *dentry)
-{
-	if (!list_empty(&dentry->d_lru)) {
-		list_del_init(&dentry->d_lru);
-		dentry_stat.nr_unused--;
-	}
-}
-
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
@@ -128,6 +119,42 @@ static void dentry_iput(struct dentry * 
 	}
 }
 
+/*
+ * Following dentry_lru_(add|add_tail|del|del_init) is must
+ * called with dcache_lock held.
+ */
+static void dentry_lru_add(struct dentry *dentry)
+{
+	list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
+	dentry->d_sb->s_nr_dentry_unused++;
+	dentry_stat.nr_unused++;
+}
+
+static void dentry_lru_add_tail(struct dentry *dentry)
+{
+	list_add_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
+	dentry->d_sb->s_nr_dentry_unused++;
+	dentry_stat.nr_unused++;
+}
+
+static void dentry_lru_del(struct dentry *dentry)
+{
+	if (!list_empty(&dentry->d_lru)) {
+		list_del(&dentry->d_lru);
+		dentry->d_sb->s_nr_dentry_unused--;
+		dentry_stat.nr_unused--;
+	}
+}
+
+static void dentry_lru_del_init(struct dentry *dentry)
+{
+	if (likely(!list_empty(&dentry->d_lru))) {
+		list_del_init(&dentry->d_lru);
+		dentry->d_sb->s_nr_dentry_unused--;
+		dentry_stat.nr_unused--;
+	}
+}
+
 /**
  * d_kill - kill dentry and return parent
  * @dentry: dentry to kill
@@ -209,8 +236,7 @@ repeat:
 		goto kill_it;
   	if (list_empty(&dentry->d_lru)) {
   		dentry->d_flags |= DCACHE_REFERENCED;
-  		list_add(&dentry->d_lru, &dentry_unused);
-  		dentry_stat.nr_unused++;
+		dentry_lru_add(dentry);
   	}
  	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
@@ -219,7 +245,8 @@ repeat:
 unhash_it:
 	__d_drop(dentry);
 kill_it:
-	dentry_lru_remove(dentry);
+	/* if dentry was on d_lru list delete it from there */
+	dentry_lru_del(dentry);
 	dentry = d_kill(dentry);
 	if (dentry)
 		goto repeat;
@@ -287,7 +314,7 @@ int d_invalidate(struct dentry * dentry)
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
 	atomic_inc(&dentry->d_count);
-	dentry_lru_remove(dentry);
+	dentry_lru_del_init(dentry);
 	return dentry;
 }
 
@@ -403,18 +430,92 @@ static void prune_one_dentry(struct dent
 
 		if (dentry->d_op && dentry->d_op->d_delete)
 			dentry->d_op->d_delete(dentry);
-		dentry_lru_remove(dentry);
+		dentry_lru_del_init(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
 		spin_lock(&dcache_lock);
 	}
 }
 
+/*
+ * Shrink the dentry LRU on a given superblock.
+ * @sb   : superblock to shrink dentry LRU.
+ * @count: If count is NULL, we prune all dentries on superblock.
+ * @flags: If flags is non-zero, we need to do special processing based on
+ * which flags are set. This means we don't need to maintain multiple
+ * similar copies of this loop.
+ */
+static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
+{
+	LIST_HEAD(referenced);
+	LIST_HEAD(tmp);
+	struct dentry *dentry;
+	int cnt = 0;
+
+	BUG_ON(!sb);
+	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
+	spin_lock(&dcache_lock);
+	if (count != NULL)
+		/* called from prune_dcache() and shrink_dcache_parent() */
+		cnt = *count;
+restart:
+	if (count == NULL)
+		list_splice_init(&sb->s_dentry_lru, &tmp);
+	else {
+		while (!list_empty(&sb->s_dentry_lru)) {
+			dentry = list_entry(sb->s_dentry_lru.prev,
+					struct dentry, d_lru);
+			BUG_ON(dentry->d_sb != sb);
+
+			spin_lock(&dentry->d_lock);
+		/*
+		 * If we are honouring the DCACHE_REFERENCED flag and the
+		 * dentry has this flag set, don't free it. Clear the flag
+		 * and put it back on the LRU
+		 */
+			if ((flags & DCACHE_REFERENCED)
+				&& (dentry->d_flags & DCACHE_REFERENCED)) {
+				dentry->d_flags &= ~DCACHE_REFERENCED;
+				list_move_tail(&dentry->d_lru, &referenced);
+				spin_unlock(&dentry->d_lock);
+			} else {
+				list_move_tail(&dentry->d_lru, &tmp);
+				spin_unlock(&dentry->d_lock);
+				cnt--;
+				if (!cnt)
+					break;
+			}
+		}
+	}
+	while (!list_empty(&tmp)) {
+		dentry = list_entry(tmp.prev, struct dentry, d_lru);
+		dentry_lru_del_init(dentry);
+		spin_lock(&dentry->d_lock);
+		/*
+		 * We found an inuse dentry which was not removed from
+		 * the LRU because of laziness during lookup.  Do not free
+		 * it - just keep it off the LRU list.
+		 */
+		if (atomic_read(&dentry->d_count)) {
+			spin_unlock(&dentry->d_lock);
+			continue;
+		}
+		prune_one_dentry(dentry);
+		/* dentry->d_lock is dropped in prune_one_dentry() */
+		cond_resched_lock(&dcache_lock);
+	}
+	if ((count == NULL) && (!list_empty(&sb->s_dentry_lru)))
+		goto restart;
+	if (count != NULL)
+		*count = cnt;
+	if (!list_empty(&referenced))
+		list_splice(&referenced, &sb->s_dentry_lru);
+	spin_unlock(&dcache_lock);
+}
+
 /**
  * prune_dcache - shrink the dcache
  * @count: number of entries to try and free
- * @sb: if given, ignore dentries for other superblocks
- *         which are being unmounted.
  *
  * Shrink the dcache. This is done when we need
  * more memory, or simply when we need to unmount
@@ -425,111 +526,75 @@ static void prune_one_dentry(struct dent
  * all the dentries are in use.
  */
  
-static void prune_dcache(int count, struct super_block *sb)
+static void prune_dcache(int count)
 {
-	spin_lock(&dcache_lock);
-	for (; count ; count--) {
-		struct dentry *dentry;
-		struct list_head *tmp;
-		struct rw_semaphore *s_umount;
+	struct super_block *sb;
+	int w_count;
+	int unused = dentry_stat.nr_unused;
+	int prune_ratio;
+	int pruned;
 
-		cond_resched_lock(&dcache_lock);
-
-		tmp = dentry_unused.prev;
-		if (sb) {
-			/* Try to find a dentry for this sb, but don't try
-			 * too hard, if they aren't near the tail they will
-			 * be moved down again soon
-			 */
-			int skip = count;
-			while (skip && tmp != &dentry_unused &&
-			    list_entry(tmp, struct dentry, d_lru)->d_sb != sb) {
-				skip--;
-				tmp = tmp->prev;
-			}
-		}
-		if (tmp == &dentry_unused)
-			break;
-		list_del_init(tmp);
-		prefetch(dentry_unused.prev);
- 		dentry_stat.nr_unused--;
-		dentry = list_entry(tmp, struct dentry, d_lru);
-
- 		spin_lock(&dentry->d_lock);
-		/*
-		 * We found an inuse dentry which was not removed from
-		 * dentry_unused because of laziness during lookup.  Do not free
-		 * it - just keep it off the dentry_unused list.
-		 */
- 		if (atomic_read(&dentry->d_count)) {
- 			spin_unlock(&dentry->d_lock);
-			continue;
-		}
-		/* If the dentry was recently referenced, don't free it. */
-		if (dentry->d_flags & DCACHE_REFERENCED) {
-			dentry->d_flags &= ~DCACHE_REFERENCED;
- 			list_add(&dentry->d_lru, &dentry_unused);
- 			dentry_stat.nr_unused++;
- 			spin_unlock(&dentry->d_lock);
+	if (unused == 0 || count == 0)
+		return;
+	spin_lock(&dcache_lock);
+restart:
+	if (count >= unused)
+		prune_ratio = 1;
+	else
+		prune_ratio = unused / count;
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_nr_dentry_unused == 0)
 			continue;
-		}
-		/*
-		 * If the dentry is not DCACHED_REFERENCED, it is time
-		 * to remove it from the dcache, provided the super block is
-		 * NULL (which means we are trying to reclaim memory)
-		 * or this dentry belongs to the same super block that
-		 * we want to shrink.
+		sb->s_count++;
+		/* Now, we reclaim unused dentrins with fairness.
+		 * we reclaim them same percentage on each superblocks.
+		 * we calculate number of dentries to scan on this sb
+		 * based on following way, but impelementation is arranged
+		 * to avoid overflow.
+		 * number of dentries to scan on this sb =
+		 * count * (number of dentries on this sb /
+		 * number of dentries in the machine)
 		 */
+		spin_unlock(&sb_lock);
+		if (prune_ratio != 1)
+			w_count = (sb->s_nr_dentry_unused / prune_ratio) + 1;
+		else
+			w_count = sb->s_nr_dentry_unused;
+		pruned = w_count;
 		/*
-		 * If this dentry is for "my" filesystem, then I can prune it
-		 * without taking the s_umount lock (I already hold it).
-		 */
-		if (sb && dentry->d_sb == sb) {
-			prune_one_dentry(dentry);
-			continue;
-		}
-		/*
-		 * ...otherwise we need to be sure this filesystem isn't being
-		 * unmounted, otherwise we could race with
-		 * generic_shutdown_super(), and end up holding a reference to
-		 * an inode while the filesystem is unmounted.
-		 * So we try to get s_umount, and make sure s_root isn't NULL.
-		 * (Take a local copy of s_umount to avoid a use-after-free of
-		 * `dentry').
+		 * We need to be sure this filesystem isn't being unmounted,
+		 * otherwise we could race with generic_shutdown_super(), and
+		 * end up holding a reference to an inode while the filesystem
+		 * is unmounted.  So we try to get s_umount, and make sure
+		 * s_root isn't NULL.
 		 */
-		s_umount = &dentry->d_sb->s_umount;
-		if (down_read_trylock(s_umount)) {
-			if (dentry->d_sb->s_root != NULL) {
-				prune_one_dentry(dentry);
-				up_read(s_umount);
-				continue;
+		if (down_read_trylock(&sb->s_umount)) {
+			if ((sb->s_root != NULL) &&
+			    (!list_empty(&sb->s_dentry_lru))) {
+				spin_unlock(&dcache_lock);
+				__shrink_dcache_sb(sb, &w_count,
+						DCACHE_REFERENCED);
+				pruned -= w_count;
+				spin_lock(&dcache_lock);
 			}
-			up_read(s_umount);
+			up_read(&sb->s_umount);
 		}
-		spin_unlock(&dentry->d_lock);
+		spin_lock(&sb_lock);
+		count -= pruned;
 		/*
-		 * Insert dentry at the head of the list as inserting at the
-		 * tail leads to a cycle.
+		 * restart only when sb is no longer on the list and
+		 * we have more work to do.
 		 */
- 		list_add(&dentry->d_lru, &dentry_unused);
-		dentry_stat.nr_unused++;
+		if (__put_super_and_need_restart(sb) && count > 0) {
+			spin_unlock(&sb_lock);
+			goto restart;
+		}
 	}
+	spin_unlock(&sb_lock);
 	spin_unlock(&dcache_lock);
 }
 
-/*
- * Shrink the dcache for the specified super block.
- * This allows us to unmount a device without disturbing
- * the dcache for the other devices.
- *
- * This implementation makes just two traversals of the
- * unused list.  On the first pass we move the selected
- * dentries to the most recent end, and on the second
- * pass we free them.  The second pass must restart after
- * each dput(), but since the target dentries are all at
- * the end, it's really just a single traversal.
- */
-
 /**
  * shrink_dcache_sb - shrink dcache for a superblock
  * @sb: superblock
@@ -538,44 +603,9 @@ static void prune_dcache(int count, stru
  * is used to free the dcache before unmounting a file
  * system
  */
-
 void shrink_dcache_sb(struct super_block * sb)
 {
-	struct list_head *tmp, *next;
-	struct dentry *dentry;
-
-	/*
-	 * Pass one ... move the dentries for the specified
-	 * superblock to the most recent end of the unused list.
-	 */
-	spin_lock(&dcache_lock);
-	list_for_each_prev_safe(tmp, next, &dentry_unused) {
-		dentry = list_entry(tmp, struct dentry, d_lru);
-		if (dentry->d_sb != sb)
-			continue;
-		list_move_tail(tmp, &dentry_unused);
-	}
-
-	/*
-	 * Pass two ... free the dentries for this superblock.
-	 */
-repeat:
-	list_for_each_prev_safe(tmp, next, &dentry_unused) {
-		dentry = list_entry(tmp, struct dentry, d_lru);
-		if (dentry->d_sb != sb)
-			continue;
-		dentry_stat.nr_unused--;
-		list_del_init(tmp);
-		spin_lock(&dentry->d_lock);
-		if (atomic_read(&dentry->d_count)) {
-			spin_unlock(&dentry->d_lock);
-			continue;
-		}
-		prune_one_dentry(dentry);
-		cond_resched_lock(&dcache_lock);
-		goto repeat;
-	}
-	spin_unlock(&dcache_lock);
+	__shrink_dcache_sb(sb, NULL, 0);
 }
 
 /*
@@ -592,7 +622,7 @@ static void shrink_dcache_for_umount_sub
 
 	/* detach this root from the system */
 	spin_lock(&dcache_lock);
-	dentry_lru_remove(dentry);
+	dentry_lru_del_init(dentry);
 	__d_drop(dentry);
 	spin_unlock(&dcache_lock);
 
@@ -606,7 +636,7 @@ static void shrink_dcache_for_umount_sub
 			spin_lock(&dcache_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				dentry_lru_remove(loop);
+				dentry_lru_del_init(loop);
 				__d_drop(loop);
 				cond_resched_lock(&dcache_lock);
 			}
@@ -788,14 +818,13 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		dentry_lru_remove(dentry);
+		dentry_lru_del_init(dentry);
 		/* 
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
 		 */
 		if (!atomic_read(&dentry->d_count)) {
-			list_add_tail(&dentry->d_lru, &dentry_unused);
-			dentry_stat.nr_unused++;
+			dentry_lru_add_tail(dentry);
 			found++;
 		}
 
@@ -837,10 +866,11 @@ out:
  
 void shrink_dcache_parent(struct dentry * parent)
 {
+	struct super_block *sb = parent->d_sb;
 	int found;
 
 	while ((found = select_parent(parent)) != 0)
-		prune_dcache(found, parent->d_sb);
+		__shrink_dcache_sb(sb, &found, 0);
 }
 
 /*
@@ -860,7 +890,7 @@ static int shrink_dcache_memory(int nr, 
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
-		prune_dcache(nr, NULL);
+		prune_dcache(nr);
 	}
 	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
@@ -1212,7 +1242,7 @@ struct dentry *d_splice_alias(struct ino
  * rcu_read_lock() and rcu_read_unlock() are used to disable preemption while
  * lookup is going on.
  *
- * dentry_unused list is not updated even if lookup finds the required dentry
+ * The dentry unused LRU is not updated even if lookup finds the required dentry
  * in there. It is updated in places such as prune_dcache, shrink_dcache_sb,
  * select_parent and __dget_locked. This laziness saves lookup from dcache_lock
  * acquisition.
diff -puN fs/super.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries fs/super.c
--- a/fs/super.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries
+++ a/fs/super.c
@@ -70,6 +70,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
+		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
diff -puN include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries include/linux/fs.h
--- a/include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries
+++ a/include/linux/fs.h
@@ -1029,6 +1029,7 @@ extern int send_sigurg(struct fown_struc
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
+#define sb_entry(list)  list_entry((list), struct super_block, s_list)
 #define S_BIAS (1<<30)
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
@@ -1062,6 +1063,8 @@ struct super_block {
 	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
+	struct list_head	s_dentry_lru;	/* unused dentry lru */
+	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
 	struct block_device	*s_bdev;
 	struct mtd_info		*s_mtd;
_

Patches currently in -mm which might be from k-makita@np.css.fujitsu.com are

fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch


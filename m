From: akpm@linux-foundation.org
Subject: [wrecked] vfs-clean-up-real_lookup.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:36:50 -0800
Message-ID: <200912172036.nBHKaoKd017429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762932AbZLQUhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:37:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sage@newdream.net, adilger@sun.com, hch@infradead.org, mszeredi@suse.cz, raven@themaw.net, viro@zeniv.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     vfs: clean up real_lookup()
has been removed from the -mm tree.  Its filename was
     vfs-clean-up-real_lookup.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: clean up real_lookup()
From: Sage Weil <sage@newdream.net>

Get rid of the goto by flipping the if (!result) over.  Make the comments
a bit more descriptive.  Fix a few kernel style problems.  No functional
changes.

Cc: Ian Kent <raven@themaw.net>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   65 ++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff -puN fs/namei.c~vfs-clean-up-real_lookup fs/namei.c
--- a/fs/namei.c~vfs-clean-up-real_lookup
+++ a/fs/namei.c
@@ -469,19 +469,20 @@ ok:
  * This is called when everything else fails, and we actually have
  * to go to the low-level filesystem to find out what we should do..
  *
- * We get the directory semaphore, and after getting that we also
+ * We get the directory mutex, and after getting that we also
  * make sure that nobody added the entry to the dcache in the meantime..
  * SMP-safe
  */
-static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
+static struct dentry *real_lookup(struct dentry *parent, struct qstr *name,
+				  struct nameidata *nd)
 {
-	struct dentry * result;
+	struct dentry *result, *dentry;
 	struct inode *dir = parent->d_inode;
 
 	mutex_lock(&dir->i_mutex);
 	/*
 	 * First re-do the cached lookup just in case it was created
-	 * while we waited for the directory semaphore..
+	 * while we waited for the directory mutex.
 	 *
 	 * FIXME! This could use version numbering or similar to
 	 * avoid unnecessary cache lookups.
@@ -494,38 +495,40 @@ static struct dentry * real_lookup(struc
 	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
 	 */
 	result = d_lookup(parent, name);
-	if (!result) {
-		struct dentry *dentry;
-
-do_the_lookup:
-		/* Don't create child dentry for a dead directory. */
-		result = ERR_PTR(-ENOENT);
-		if (IS_DEADDIR(dir))
-			goto out_unlock;
-
-		dentry = d_alloc(parent, name);
-		result = ERR_PTR(-ENOMEM);
-		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
+	if (result) {
+		/*
+		 * The cache was re-populated while we waited on the
+		 * mutex.  We need to revalidate, this time while
+		 * holding i_mutex (to avoid another race).
+		 */
+		if (result->d_op && result->d_op->d_revalidate) {
+			result = do_revalidate(result, nd);
 			if (result)
-				dput(dentry);
-			else
-				result = dentry;
+				goto out_unlock;
+			/*
+			 * The dentry was left behind invalid.  Just
+			 * do the lookup.
+			 */
+		} else {
+			goto out_unlock;
 		}
-out_unlock:
-		mutex_unlock(&dir->i_mutex);
-		return result;
 	}
 
-	/*
-	 * Uhhuh! Nasty case: the cache was re-populated while
-	 * we waited on the semaphore. Need to revalidate.
-	 */
-	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
-		if (!result)
-			goto do_the_lookup;
+	/* Don't create child dentry for a dead directory. */
+	result = ERR_PTR(-ENOENT);
+	if (IS_DEADDIR(dir))
+		goto out_unlock;
+
+	dentry = d_alloc(parent, name);
+	result = ERR_PTR(-ENOMEM);
+	if (dentry) {
+		result = dir->i_op->lookup(dir, dentry, nd);
+		if (result)
+			dput(dentry);
+		else
+			result = dentry;
 	}
+out_unlock:
 	mutex_unlock(&dir->i_mutex);
 	return result;
 }
_

Patches currently in -mm which might be from sage@newdream.net are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-clean-up-real_lookup.patch


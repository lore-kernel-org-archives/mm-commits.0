From: akpm@linux-foundation.org
Subject: - clean-out-unused-code-in-dentry-pruning.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:08 -0700
Message-ID: <200710180656.l9I6u8Xl030678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763027AbXJRHPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     clean out unused code in dentry pruning
has been removed from the -mm tree.  Its filename was
     clean-out-unused-code-in-dentry-pruning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clean out unused code in dentry pruning
From: Miklos Szeredi <mszeredi@suse.cz>

It looks like in the end all pruners want parents removed.

So remove unused code and function arguments.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN fs/dcache.c~clean-out-unused-code-in-dentry-pruning fs/dcache.c
--- a/fs/dcache.c~clean-out-unused-code-in-dentry-pruning
+++ a/fs/dcache.c
@@ -381,20 +381,17 @@ restart:
  * Throw away a dentry - free the inode, dput the parent.  This requires that
  * the LRU list has already been removed.
  *
- * If prune_parents is true, try to prune ancestors as well.
+ * Try to prune ancestors as well.  This is necessary to prevent
+ * quadratic behavior of shrink_dcache_parent(), but is also expected
+ * to be beneficial in reducing dentry cache fragmentation.
  *
  * Called with dcache_lock, drops it and then regains.
  * Called with dentry->d_lock held, drops it.
  */
-static void prune_one_dentry(struct dentry * dentry, int prune_parents)
+static void prune_one_dentry(struct dentry * dentry)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
-	if (!prune_parents) {
-		dput(dentry);
-		spin_lock(&dcache_lock);
-		return;
-	}
 
 	/*
 	 * Prune ancestors.  Locking is simpler than in dput(),
@@ -422,7 +419,6 @@ static void prune_one_dentry(struct dent
  * @count: number of entries to try and free
  * @sb: if given, ignore dentries for other superblocks
  *         which are being unmounted.
- * @prune_parents: if true, try to prune ancestors as well in one go
  *
  * Shrink the dcache. This is done when we need
  * more memory, or simply when we need to unmount
@@ -433,7 +429,7 @@ static void prune_one_dentry(struct dent
  * all the dentries are in use.
  */
  
-static void prune_dcache(int count, struct super_block *sb, int prune_parents)
+static void prune_dcache(int count, struct super_block *sb)
 {
 	spin_lock(&dcache_lock);
 	for (; count ; count--) {
@@ -493,7 +489,7 @@ static void prune_dcache(int count, stru
 		 * without taking the s_umount lock (I already hold it).
 		 */
 		if (sb && dentry->d_sb == sb) {
-			prune_one_dentry(dentry, prune_parents);
+			prune_one_dentry(dentry);
 			continue;
 		}
 		/*
@@ -508,7 +504,7 @@ static void prune_dcache(int count, stru
 		s_umount = &dentry->d_sb->s_umount;
 		if (down_read_trylock(s_umount)) {
 			if (dentry->d_sb->s_root != NULL) {
-				prune_one_dentry(dentry, prune_parents);
+				prune_one_dentry(dentry);
 				up_read(s_umount);
 				continue;
 			}
@@ -579,7 +575,7 @@ repeat:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-		prune_one_dentry(dentry, 1);
+		prune_one_dentry(dentry);
 		cond_resched_lock(&dcache_lock);
 		goto repeat;
 	}
@@ -858,7 +854,7 @@ void shrink_dcache_parent(struct dentry 
 	int found;
 
 	while ((found = select_parent(parent)) != 0)
-		prune_dcache(found, parent->d_sb, 1);
+		prune_dcache(found, parent->d_sb);
 }
 
 /*
@@ -878,7 +874,7 @@ static int shrink_dcache_memory(int nr, 
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
-		prune_dcache(nr, NULL, 1);
+		prune_dcache(nr, NULL);
 	}
 	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
fuse-fix-allowing-operations.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
fuse-clean-up-open-file-passing-in-setattr.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
fuse-improve-utimes-support.patch
fuse-add-atomic-opentruncate-support.patch
fuse-support-bsd-locking-semantics.patch
fuse-add-list-of-writable-files-to-fuse_inode.patch
fuse-add-helper-for-asynchronous-writes.patch
fuse-add-support-for-mandatory-locking.patch
fuse-add-blksize-field-to-fuse_attr.patch

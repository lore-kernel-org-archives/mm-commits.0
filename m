From: akpm@linux-foundation.org
Subject: + clean-out-unused-code-in-dentry-pruning.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:34:58 -0700
Message-ID: <200708092134.l79LYwRt020728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbXHIVfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     clean out unused code in dentry pruning
has been added to the -mm tree.  Its filename is
     clean-out-unused-code-in-dentry-pruning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clean out unused code in dentry pruning
From: Miklos Szeredi <mszeredi@suse.cz>

It looks like in the end all pruners want parents removed.

So remove unused code and function arguments.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

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

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
clean-out-unused-code-in-dentry-pruning.patch
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
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-bits.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
fuse-clean-up-execute-permission-checking.patch
uml-remove-unnecessary-hostfs_getattr.patch
fix-warnings-in-revoked_inodec.patch

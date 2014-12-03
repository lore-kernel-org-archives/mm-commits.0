From: akpm@linux-foundation.org
Subject: [merged] fat-fix-oops-on-corrupted-vfat-fs.patch removed from -mm tree
Date: Wed, 03 Dec 2014 13:29:43 -0800
Message-ID: <547f80c7.Axt/oL+w3TyPeKwk%akpm__2367.46081286601$1417642197$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCV3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 16:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@zeniv.linux.org.uk, hirofumi@mail.parknet.co.jp, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix oops on corrupted vfat fs
has been removed from the -mm tree.  Its filename was
     fat-fix-oops-on-corrupted-vfat-fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: fat: fix oops on corrupted vfat fs

a) don't bother with ->d_time for positives - we only check it for
   negatives anyway.

b) make sure to set it at unlink and rmdir time - at *that* point
   soon-to-be negative dentry matches then-current directory contents

c) don't go into renaming of old alias in vfat_lookup() unless it
   has the same parent (which it will, unless we are seeing corrupted
   image)

[hirofumi@mail.parknet.co.jp: make change minimum, don't call d_move() for dir]
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@vger.kernel.org>	[3.17.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-fix-oops-on-corrupted-vfat-fs fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-fix-oops-on-corrupted-vfat-fs
+++ a/fs/fat/namei_vfat.c
@@ -736,7 +736,12 @@ static struct dentry *vfat_lookup(struct
 	}
 
 	alias = d_find_alias(inode);
-	if (alias && !vfat_d_anon_disconn(alias)) {
+	/*
+	 * Checking "alias->d_parent == dentry->d_parent" to make sure
+	 * FS is not corrupted (especially double linked dir).
+	 */
+	if (alias && alias->d_parent == dentry->d_parent &&
+	    !vfat_d_anon_disconn(alias)) {
 		/*
 		 * This inode has non anonymous-DCACHE_DISCONNECTED
 		 * dentry. This means, the user did ->lookup() by an
@@ -755,12 +760,9 @@ static struct dentry *vfat_lookup(struct
 
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
-	dentry = d_splice_alias(inode, dentry);
-	if (dentry)
-		dentry->d_time = dentry->d_parent->d_inode->i_version;
-	return dentry;
-
+	if (!inode)
+		dentry->d_time = dir->i_version;
+	return d_splice_alias(inode, dentry);
 error:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return ERR_PTR(err);
@@ -793,7 +795,6 @@ static int vfat_create(struct inode *dir
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -824,6 +825,7 @@ static int vfat_rmdir(struct inode *dir,
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -849,6 +851,7 @@ static int vfat_unlink(struct inode *dir
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -889,7 +892,6 @@ static int vfat_mkdir(struct inode *dir,
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
_

Patches currently in -mm which might be from viro@zeniv.linux.org.uk are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
procfs-fix-error-handling-of-proc_register.patch
ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
ppc-cell-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
binfmt_misc-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
file-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
file-remove-get_unused_fd-macro.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
nilfs2-fix-the-nilfs_iget-vs-nilfs_new_inode-races.patch
syscalls-implement-execveat-system-call.patch
x86-hook-up-execveat-system-call.patch
syscalls-add-selftest-for-execveat2.patch
fs-affs-filec-adding-support-to-o_direct.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
kernel-forkc-export-kernel_thread-to-modules.patch


From: akpm@linux-foundation.org
Subject: - bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:32 -0800
Message-ID: <200802070030.m170UDYp007364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933910AbYBGAoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     BKL-removal: convert ext2 over to use unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BKL-removal: convert ext2 over to use unlocked_ioctl
From: Andi Kleen <ak@suse.de>

I checked ext2_ioctl and could not find anything in there that would need the
BKL.  So convert it over to use unlocked_ioctl

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c   |    2 +-
 fs/ext2/ext2.h  |    3 +--
 fs/ext2/file.c  |    4 ++--
 fs/ext2/ioctl.c |   12 +++---------
 4 files changed, 7 insertions(+), 14 deletions(-)

diff -puN fs/ext2/dir.c~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl fs/ext2/dir.c
--- a/fs/ext2/dir.c~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl
+++ a/fs/ext2/dir.c
@@ -703,7 +703,7 @@ const struct file_operations ext2_dir_op
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext2_readdir,
-	.ioctl		= ext2_ioctl,
+	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
diff -puN fs/ext2/ext2.h~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl
+++ a/fs/ext2/ext2.h
@@ -139,8 +139,7 @@ int __ext2_write_begin(struct file *file
 		struct page **pagep, void **fsdata);
 
 /* ioctl.c */
-extern int ext2_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext2_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext2_compat_ioctl(struct file *, unsigned int, unsigned long);
 
 /* namei.c */
diff -puN fs/ext2/file.c~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl fs/ext2/file.c
--- a/fs/ext2/file.c~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl
+++ a/fs/ext2/file.c
@@ -48,7 +48,7 @@ const struct file_operations ext2_file_o
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
-	.ioctl		= ext2_ioctl,
+	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
@@ -65,7 +65,7 @@ const struct file_operations ext2_xip_fi
 	.llseek		= generic_file_llseek,
 	.read		= xip_file_read,
 	.write		= xip_file_write,
-	.ioctl		= ext2_ioctl,
+	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
diff -puN fs/ext2/ioctl.c~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~bkl-removal-convert-ext2-over-to-use-unlocked_ioctl
+++ a/fs/ext2/ioctl.c
@@ -17,9 +17,9 @@
 #include <asm/uaccess.h>
 
 
-int ext2_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -141,9 +141,6 @@ int ext2_ioctl (struct inode * inode, st
 #ifdef CONFIG_COMPAT
 long ext2_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT2_IOC32_GETFLAGS:
@@ -161,9 +158,6 @@ long ext2_compat_ioctl(struct file *file
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
-	ret = ext2_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
-	return ret;
+	return ext2_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-jfs.patch
git-ocfs2.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
git-xfs.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
allow-executables-larger-than-2gb.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
remove-aout-interpreter-support-in-elf-loader.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

From: akpm@linux-foundation.org
Subject: + bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:13:44 -0800
Message-ID: <200801280514.m0S5Eipl013411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYA1FPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:15:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, sfrench@us.ibm.com


The patch titled
     BKL-removal: convert CIFS over to unlocked_ioctl
has been added to the -mm tree.  Its filename is
     bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch

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
Subject: BKL-removal: convert CIFS over to unlocked_ioctl
From: Andi Kleen <ak@suse.de>

cifs_ioctl doesn't seem to need the BKL for anything, so convert it over to
use unlocked_ioctl.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |   10 +++++-----
 fs/cifs/cifsfs.h |    4 ++--
 fs/cifs/ioctl.c  |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/cifs/cifsfs.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl
+++ a/fs/cifs/cifsfs.c
@@ -661,7 +661,7 @@ const struct file_operations cifs_file_o
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -681,7 +681,7 @@ const struct file_operations cifs_file_d
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -701,7 +701,7 @@ const struct file_operations cifs_file_n
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -720,7 +720,7 @@ const struct file_operations cifs_file_d
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -735,7 +735,7 @@ const struct file_operations cifs_dir_op
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	.dir_notify = cifs_dir_notify,
 #endif /* CONFIG_CIFS_EXPERIMENTAL */
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl = cifs_ioctl,
 };
 
 static void
diff -puN fs/cifs/cifsfs.h~bkl-removal-convert-cifs-over-to-unlocked_ioctl fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h~bkl-removal-convert-cifs-over-to-unlocked_ioctl
+++ a/fs/cifs/cifsfs.h
@@ -100,8 +100,8 @@ extern int 	cifs_setxattr(struct dentry 
 			size_t, int);
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
-extern int cifs_ioctl(struct inode *inode, struct file *filep,
-		       unsigned int command, unsigned long arg);
+extern long cifs_ioctl(struct file *filep, unsigned int command,
+		unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern const struct export_operations cifs_export_ops;
diff -puN fs/cifs/ioctl.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl fs/cifs/ioctl.c
--- a/fs/cifs/ioctl.c~bkl-removal-convert-cifs-over-to-unlocked_ioctl
+++ a/fs/cifs/ioctl.c
@@ -30,9 +30,9 @@
 
 #define CIFS_IOC_CHECKUMOUNT _IO(0xCF, 2)
 
-int cifs_ioctl (struct inode *inode, struct file *filep,
-		unsigned int command, unsigned long arg)
+long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
+	struct inode *inode = filep->f_dentry->d_inode;
 	int rc = -ENOTTY; /* strange error - but the precedent */
 	int xid;
 	struct cifs_sb_info *cifs_sb;
_

Patches currently in -mm which might be from ak@suse.de are

git-cifs.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-kbuild.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-scsi-misc.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-fix-early-cpu_to_node-panic-from-nr_free_zone_pages.patch
x86-reboot-remove-inb_p-usage.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-xfs.patch
swapin_readahead-excise-numa-bogosity.patch
remove-unused-arguments-in-zone_init_free_lists.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
make-config_hpet_emulate_rtc-usable-from-modules.patch
use-the-irq-callback-interface-in-old-rtc-driver.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch
modules-handle-symbols-that-have-a-zero-value.patch
allow-executables-larger-than-2gb.patch
remove-ibcs-support.patch
bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch
bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

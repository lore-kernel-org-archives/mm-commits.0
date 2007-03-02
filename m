From: akpm@linux-foundation.org
Subject: - kvm-add-internal-filesystem-for-generating-inodes-tweak.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:50 -0800
Message-ID: <200703020507.l2257ood000899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422781AbXCBFHy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm-add-internal-filesystem-for-generating-inodes tweak
has been removed from the -mm tree.  Its filename was
     kvm-add-internal-filesystem-for-generating-inodes-tweak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm-add-internal-filesystem-for-generating-inodes tweak
From: Andrew Morton <akpm@linux-foundation.org>

Use the standard magic.h for kvmfs.

Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    4 ++--
 include/linux/magic.h  |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-add-internal-filesystem-for-generating-inodes-tweak drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-internal-filesystem-for-generating-inodes-tweak
+++ a/drivers/kvm/kvm_main.c
@@ -20,6 +20,7 @@
 #include <linux/kvm.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/magic.h>
 #include <asm/processor.h>
 #include <linux/percpu.h>
 #include <linux/gfp.h>
@@ -75,7 +76,6 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
-#define KVMFS_MAGIC 0x19700426
 struct vfsmount *kvmfs_mnt;
 
 #define MAX_IO_MSRS 256
@@ -2433,7 +2433,7 @@ hpa_t bad_page_address;
 static int kvmfs_get_sb(struct file_system_type *fs_type, int flags,
 			const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "kvm:", NULL, KVMFS_MAGIC, mnt);
+	return get_sb_pseudo(fs_type, "kvm:", NULL, KVMFS_SUPER_MAGIC, mnt);
 }
 
 static struct file_system_type kvm_fs_type = {
diff -puN include/linux/magic.h~kvm-add-internal-filesystem-for-generating-inodes-tweak include/linux/magic.h
--- a/include/linux/magic.h~kvm-add-internal-filesystem-for-generating-inodes-tweak
+++ a/include/linux/magic.h
@@ -13,6 +13,7 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
+#define KVMFS_SUPER_MAGIC	0x19700426
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch

From: akpm@linux-foundation.org
Subject: + kvm-add-internal-filesystem-for-generating-inodes-tweak.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:20:55 -0800
Message-ID: <200702220220.l1M2KtiC001685@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbXBVCU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, avi@qumranet.com


The patch titled
     kvm-add-internal-filesystem-for-generating-inodes-tweak
has been added to the -mm tree.  Its filename is
     kvm-add-internal-filesystem-for-generating-inodes-tweak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm-add-internal-filesystem-for-generating-inodes-tweak
From: Andrew Morton <akpm@linux-foundation.org>

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
@@ -74,7 +75,6 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
-#define KVMFS_MAGIC 0x19700426
 struct vfsmount *kvmfs_mnt;
 
 #define MAX_IO_MSRS 256
@@ -2260,7 +2260,7 @@ hpa_t bad_page_address;
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

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
git-md-accel-vs-md.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch

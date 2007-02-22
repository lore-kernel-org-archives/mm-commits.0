From: akpm@linux-foundation.org
Subject: - cciss-add-reboot-notifier-support-to-driver-fix.patch removed from -mm tree
Date: Wed, 21 Feb 2007 19:35:25 -0800
Message-ID: <200702220335.l1M3ZP45003366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35662 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbXBVDfa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 22:35:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss-add-reboot-notifier-support-to-driver-fix
has been removed from the -mm tree.  Its filename was
     cciss-add-reboot-notifier-support-to-driver-fix.patch

This patch was dropped because it was folded into cciss-add-reboot-notifier-support-to-driver.patch

------------------------------------------------------
Subject: cciss-add-reboot-notifier-support-to-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Mike Miller <mike.miller@hp.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss-add-reboot-notifier-support-to-driver-fix drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-reboot-notifier-support-to-driver-fix
+++ a/drivers/block/cciss.c
@@ -133,7 +133,7 @@ static struct board_type products[] = {
 #define MAX_CTLR_ORIG 	8
 
 static ctlr_info_t *hba[MAX_CTLR];
-static int notify_count=0;
+static int notify_count;
 
 static void do_cciss_request(request_queue_t *q);
 static irqreturn_t do_cciss_intr(int irq, void *dev_id);
@@ -3534,7 +3534,8 @@ static void __exit cciss_cleanup(void)
 	int i;
 
 	pci_unregister_driver(&cciss_pci_driver);
-	unregister_reboot_notifier(&cciss_notifier);
+	if (notify_count)
+		unregister_reboot_notifier(&cciss_notifier);
 	/* double check that all controller entrys have been removed */
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (hba[i] != NULL) {
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
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
cciss-add-reboot-notifier-support-to-driver.patch
cciss-add-reboot-notifier-support-to-driver-fix.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch

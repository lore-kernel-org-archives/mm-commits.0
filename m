From: akpm@linux-foundation.org
Subject: - drivers-misc-lkdtmc-cleanups.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:15 -0800
Message-ID: <200802070021.m170LuCO006380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932462AbYBGApF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ankita@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/lkdtm.c: cleanups
has been removed from the -mm tree.  Its filename was
     drivers-misc-lkdtmc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/lkdtm.c: cleanups
From: Adrian Bunk <bunk@kernel.org>

- make needlessly global functions static
- make lkdtm_module_{init,exit}() as __{init,exit}

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ankita Garg <ankita@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN drivers/misc/lkdtm.c~drivers-misc-lkdtmc-cleanups drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~drivers-misc-lkdtmc-cleanups
+++ a/drivers/misc/lkdtm.c
@@ -129,27 +129,28 @@ module_param(cpoint_count, int, 0644);
 MODULE_PARM_DESC(cpoint_count, " Crash Point Count, number of times the "\
 				"crash point is to be hit to trigger action");
 
-unsigned int jp_do_irq(unsigned int irq)
+static unsigned int jp_do_irq(unsigned int irq)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-irqreturn_t jp_handle_irq_event(unsigned int irq, struct irqaction *action)
+static irqreturn_t jp_handle_irq_event(unsigned int irq,
+				       struct irqaction *action)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-void jp_tasklet_action(struct softirq_action *a)
+static void jp_tasklet_action(struct softirq_action *a)
 {
 	lkdtm_handler();
 	jprobe_return();
 }
 
-void jp_ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
+static void jp_ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 {
 	lkdtm_handler();
 	jprobe_return();
@@ -157,23 +158,24 @@ void jp_ll_rw_block(int rw, int nr, stru
 
 struct scan_control;
 
-unsigned long jp_shrink_inactive_list(unsigned long max_scan,
-				struct zone *zone, struct scan_control *sc)
+static unsigned long jp_shrink_inactive_list(unsigned long max_scan,
+					     struct zone *zone,
+					     struct scan_control *sc)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-int jp_hrtimer_start(struct hrtimer *timer, ktime_t tim,
-				const enum hrtimer_mode mode)
+static int jp_hrtimer_start(struct hrtimer *timer, ktime_t tim,
+			    const enum hrtimer_mode mode)
 {
 	lkdtm_handler();
 	jprobe_return();
 	return 0;
 }
 
-int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
+static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	lkdtm_handler();
 	jprobe_return();
@@ -270,7 +272,7 @@ void lkdtm_handler(void)
 	}
 }
 
-int lkdtm_module_init(void)
+static int __init lkdtm_module_init(void)
 {
 	int ret;
 
@@ -331,7 +333,7 @@ int lkdtm_module_init(void)
 	return 0;
 }
 
-void lkdtm_module_exit(void)
+static void __exit lkdtm_module_exit(void)
 {
         unregister_jprobe(&lkdtm);
         printk(KERN_INFO "lkdtm : Crash point unregistered\n");
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch

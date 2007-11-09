From: akpm@linux-foundation.org
Subject: + drivers-misc-lkdtmc-cleanups.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:52:55 -0800
Message-ID: <200711090452.lA94qtst030211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759958AbXKIExb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:53:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, ankita@in.ibm.com


The patch titled
     drivers/misc/lkdtm.c: cleanups
has been added to the -mm tree.  Its filename is
     drivers-misc-lkdtmc-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
dvb-bt8xx-dstc-make-code-static.patch
dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch
dvb-usb-vp702xc-cleanups.patch
dvb-usb-make-some-debug-vars-static.patch
media-common-ir-functionsc-make-a-function-static.patch
cx88-mpegc-make-4-functions-static.patch
media-video-et61x251-make-5-functions-static.patch
git-hwmon.patch
fs-dlm-proper-prototypes.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch

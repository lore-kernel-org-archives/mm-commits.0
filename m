From: akpm@linux-foundation.org
Subject: - throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:57 -0800
Message-ID: <200703020506.l2256vFO000841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42460 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770AbXCBFIY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:08:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, galak@kernel.crashing.org, hirofumi@mail.parknet.co.jp, nickpiggin@yahoo.com.au, stable@kernel.org, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     throttle_vm_writeout(): don't loop on GFP_NOFS and GFP_NOIO allocations
has been removed from the -mm tree.  Its filename was
     throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: throttle_vm_writeout(): don't loop on GFP_NOFS and GFP_NOIO allocations
From: Andrew Morton <akpm@linux-foundation.org>

throttle_vm_writeout() is designed to wait for the dirty levels to subside. 
But if the caller holds IO or FS locks, we might be holding up that writeout.

So change it to take a single nap to give other devices a chance to clean some
memory, then return.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 +-
 mm/page-writeback.c       |   13 +++++++++++--
 mm/vmscan.c               |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff -puN include/linux/writeback.h~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations include/linux/writeback.h
--- a/include/linux/writeback.h~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
+++ a/include/linux/writeback.h
@@ -84,7 +84,7 @@ static inline void wait_on_inode(struct 
 int wakeup_pdflush(long nr_pages);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
-void throttle_vm_writeout(void);
+void throttle_vm_writeout(gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
diff -puN mm/page-writeback.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations mm/page-writeback.c
--- a/mm/page-writeback.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
+++ a/mm/page-writeback.c
@@ -296,11 +296,21 @@ void balance_dirty_pages_ratelimited_nr(
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
-void throttle_vm_writeout(void)
+void throttle_vm_writeout(gfp_t gfp_mask)
 {
 	long background_thresh;
 	long dirty_thresh;
 
+	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
+		/*
+		 * The caller might hold locks which can prevent IO completion
+		 * or progress in the filesystem.  So we cannot just sit here
+		 * waiting for IO to complete.
+		 */
+		congestion_wait(WRITE, HZ/10);
+		return;
+	}
+
         for ( ; ; ) {
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
 
@@ -317,7 +327,6 @@ void throttle_vm_writeout(void)
         }
 }
 
-
 /*
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
diff -puN mm/vmscan.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations mm/vmscan.c
--- a/mm/vmscan.c~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations
+++ a/mm/vmscan.c
@@ -952,7 +952,7 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	throttle_vm_writeout();
+	throttle_vm_writeout(sc->gfp_mask);
 
 	atomic_dec(&zone->reclaim_in_progress);
 	return nr_reclaimed;
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

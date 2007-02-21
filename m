From: akpm@linux-foundation.org
Subject: + throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:06:26 -0800
Message-ID: <200702212106.l1LL6Q93026026@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423123AbXBUVGi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 16:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, galak@kernel.crashing.org, hirofumi@mail.parknet.co.jp, nickpiggin@yahoo.com.au, zaitcev@redhat.com


The patch titled
     throttle_vm_writeout(): don't loop on GFP_NOFS and GFP_NOIO allocations
has been added to the -mm tree.  Its filename is
     throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux/writeback.h   |    0 
 mm/page-writeback.c |   13 +++++++++++--
 mm/vmscan.c         |    2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

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
 
+	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != __GFP_FS|__GFP_IO) {
+		/*
+		 * The caller might hold locks which can prevert IO completion
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
diff -puN include/linux/writeback.h~throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations include/linux/writeback.h
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
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch

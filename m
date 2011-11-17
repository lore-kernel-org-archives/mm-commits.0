From: akpm@linux-foundation.org
Subject: [folded] mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch removed from -mm tree
Date: Thu, 17 Nov 2011 13:33:48 -0800
Message-ID: <201111172133.pAHLXnTx023458@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:34698 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1KQVdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 16:33:52 -0500
Received: by qyd20 with SMTP id 20so401051qyd.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 13:33:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, ccross@android.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-avoid-livelock-on-__gfp_fs-allocations-fix
has been removed from the -mm tree.  Its filename was
     mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch

This patch was dropped because it was folded into mm-avoid-livelock-on-__gfp_fs-allocations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-avoid-livelock-on-__gfp_fs-allocations-fix

augment comment



Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Colin Cross <ccross@android.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-avoid-livelock-on-__gfp_fs-allocations-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-avoid-livelock-on-__gfp_fs-allocations-fix
+++ a/mm/page_alloc.c
@@ -2263,9 +2263,10 @@ rebalance:
 		}
 
 		/*
-		 * Suspend converts GFP_KERNEL to __GFP_WAIT which can
-		 * prevent reclaim making forward progress without
-		 * invoking OOM. Bail if we are suspending
+		 * Suspend converts GFP_KERNEL to __GFP_WAIT which can prevent
+		 * reclaim making forward progress without invoking OOM.
+		 * Suspend also disables storage devices so kswapd cannot save
+		 * us.  Bail if we are suspending.
 		 */
 		if (pm_suspending())
 			goto nopage;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


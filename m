From: akpm@linux-foundation.org
Subject: [merged] mm-use-global_dirty_limit-in-throttle_vm_writeout.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:47 -0700
Message-ID: <20120322201847.A5AE6A06FD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:46452 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107Ab2CVUSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:49 -0400
Received: by mail-wi0-f202.google.com with SMTP id hj13so59596wib.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, riel@redhat.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use global_dirty_limit in throttle_vm_writeout()
has been removed from the -mm tree.  Its filename was
     mm-use-global_dirty_limit-in-throttle_vm_writeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: mm: use global_dirty_limit in throttle_vm_writeout()

When starting a memory hog task, a desktop box w/o swap is found to go
unresponsive for a long time.  It's solely caused by lots of congestion
waits in throttle_vm_writeout():

 gnome-system-mo-4201 553.073384: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
 gnome-system-mo-4201 553.073386: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
           gtali-4237 553.080377: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
           gtali-4237 553.080378: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000
            Xorg-3483 553.103375: congestion_wait: throttle_vm_writeout+0x70/0x7f shrink_mem_cgroup_zone+0x48f/0x4a1
            Xorg-3483 553.103377: writeback_congestion_wait: usec_timeout=100000 usec_delayed=100000

The root cause is, the dirty threshold is knocked down a lot by the memory
hog task.  Fixed by using global_dirty_limit which decreases gradually on
such events and can guarantee we stay above (the also decreasing) nr_dirty
in the progress of following down to the new dirty threshold.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page-writeback.c~mm-use-global_dirty_limit-in-throttle_vm_writeout mm/page-writeback.c
--- a/mm/page-writeback.c~mm-use-global_dirty_limit-in-throttle_vm_writeout
+++ a/mm/page-writeback.c
@@ -1472,6 +1472,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 
         for ( ; ; ) {
 		global_dirty_limits(&background_thresh, &dirty_thresh);
+		dirty_thresh = hard_dirty_limit(dirty_thresh);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch


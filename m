From: akpm@linux-foundation.org
Subject: + mm-use-global_dirty_limit-in-throttle_vm_writeout.patch added to -mm tree
Date: Fri, 02 Mar 2012 14:16:29 -0800
Message-ID: <20120302221629.DB26CA01CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:60439 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2CBWQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Mar 2012 17:16:32 -0500
Received: by bkcjm19 with SMTP id jm19so76626bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 02 Mar 2012 14:16:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: mm: use global_dirty_limit in throttle_vm_writeout()
has been added to the -mm tree.  Its filename is
     mm-use-global_dirty_limit-in-throttle_vm_writeout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Rik van Riel <riel@redhat.com>
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
Subject: Subject: mm: use global_dirty_limit in throttle_vm_writeout()

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-dont-set-__gfp_write-on-ramfs-sysfs-writes.patch
mm-use-global_dirty_limit-in-throttle_vm_writeout.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch


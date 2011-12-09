From: akpm@linux-foundation.org
Subject: [merged] thp-reduce-khugepaged-freezing-latency.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:07:51 -0800
Message-ID: <201112092007.pB9K7qQV027211@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:55076 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1LIUHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:07:54 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so393517ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:07:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jslaby@suse.cz, oleg@redhat.com, rjw@suse.com, srivatsa.bhat@linux.vnet.ibm.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: reduce khugepaged freezing latency
has been removed from the -mm tree.  Its filename was
     thp-reduce-khugepaged-freezing-latency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thp: reduce khugepaged freezing latency

khugepaged can sometimes cause suspend to fail, requiring that the user
retry the suspend operation.

Use wait_event_freezable_timeout() instead of
schedule_timeout_interruptible() to avoid missing freezer wakeups.  A
try_to_freeze() would have been needed in the khugepaged_alloc_hugepage
tight loop too in case of the allocation failing repeatedly, and
wait_event_freezable_timeout will provide it too.

khugepaged would still freeze just fine by trying again the next minute
but it's better if it freezes immediately.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN mm/huge_memory.c~thp-reduce-khugepaged-freezing-latency mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reduce-khugepaged-freezing-latency
+++ a/mm/huge_memory.c
@@ -2259,12 +2259,8 @@ static void khugepaged_do_scan(struct pa
 
 static void khugepaged_alloc_sleep(void)
 {
-	DEFINE_WAIT(wait);
-	add_wait_queue(&khugepaged_wait, &wait);
-	schedule_timeout_interruptible(
-		msecs_to_jiffies(
-			khugepaged_alloc_sleep_millisecs));
-	remove_wait_queue(&khugepaged_wait, &wait);
+	wait_event_freezable_timeout(khugepaged_wait, false,
+			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
 }
 
 #ifndef CONFIG_NUMA
@@ -2313,14 +2309,10 @@ static void khugepaged_loop(void)
 		if (unlikely(kthread_should_stop()))
 			break;
 		if (khugepaged_has_work()) {
-			DEFINE_WAIT(wait);
 			if (!khugepaged_scan_sleep_millisecs)
 				continue;
-			add_wait_queue(&khugepaged_wait, &wait);
-			schedule_timeout_interruptible(
-				msecs_to_jiffies(
-					khugepaged_scan_sleep_millisecs));
-			remove_wait_queue(&khugepaged_wait, &wait);
+			wait_event_freezable_timeout(khugepaged_wait, false,
+			    msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
 		} else if (khugepaged_enabled())
 			wait_event_freezable(khugepaged_wait,
 					     khugepaged_wait_event());
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch


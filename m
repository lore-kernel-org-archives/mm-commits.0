From: akpm@linux-foundation.org
Subject: - mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:10:48 -0700
Message-ID: <200704270810.l3R8AmYm022944@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbXD0IKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:10:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix 2
has been removed from the -mm tree.  Its filename was
     mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch

This patch was dropped because it was folded into mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch

------------------------------------------------------
Subject: mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix 2
From: Nick Piggin <nickpiggin@yahoo.com.au>

Fix typo in do_no_page vs invalidate race fix patch.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/truncate.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2 mm/truncate.c
--- a/mm/truncate.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2
+++ a/mm/truncate.c
@@ -235,7 +235,7 @@ void truncate_inode_pages_range(struct a
 			wait_on_page_writeback(page);
 			if (page_mapped(page)) {
 				unmap_mapping_range(mapping,
-				  (loff_t)page_index<<PAGE_CACHE_SHIFT,
+				  (loff_t)page->index<<PAGE_CACHE_SHIFT,
 				  PAGE_CACHE_SIZE, 0);
 			}
 			if (page->index > next)
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

ia64-race-flushing-icache-in-do_no_page-path.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch
mm-merge-nopfn-into-fault-fix.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
readahead-improve-heuristic-detecting-sequential-reads.patch
readahead-code-cleanup.patch
readahead-code-cleanup-fix.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
madv_free-lazytlb-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
as-fix-antic_expire-check.patch
kblockd-use-flush_work.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-align-rq-to-cacheline-boundary.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched2-sched-domain-sysctl.patch
revoke-core-code-break-cow-fixes.patch

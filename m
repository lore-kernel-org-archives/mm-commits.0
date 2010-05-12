From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:26 -0400
Message-ID: <201005121759.o4CHxsV8011538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0ELSAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, andi@firstfloor.org, lee.schermerhorn@hp.com, rientjes@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: kill applications that use MAP_NORESERVE with SIGBUS instead of OOM-killer
has been removed from the -mm tree.  Its filename was
     hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: kill applications that use MAP_NORESERVE with SIGBUS instead of OOM-killer
From: Mel Gorman <mel@csn.ul.ie>

Ordinarily, application using hugetlbfs will create mappings with
reserves.  For shared mappings, these pages are reserved before mmap()
returns success and for private mappings, the caller process is guaranteed
and a child process that cannot get the pages gets killed with sigbus.

An application that uses MAP_NORESERVE gets no reservations and mmap()
will always succeed at the risk the page will not be available at fault
time.  This might be used for example on very large sparse mappings where
the developer is confident the necessary huge pages exist to satisfy all
faults even though the whole mapping cannot be backed by huge pages. 
Unfortunately, if an allocation does fail, VM_FAULT_OOM is returned to the
fault handler which proceeds to trigger the OOM-killer.  This is
unhelpful.

Even without hugetlbfs mounted, a user using mmap() can trivially trigger
the OOM-killer because VM_FAULT_OOM is returned (will provide example
program if desired - it's a whopping 24 lines long).  It could be
considered a DOS available to an unprivileged user.

This patch alters hugetlbfs to kill a process that uses MAP_NORESERVE
where huge pages were not available with SIGBUS instead of triggering the
OOM killer.

This change affects hugetlb_cow() as well.  I feel there is a failure case
in there, but I didn't create one.  It would need a fairly specific target
in terms of the faulting application and the hugepage pool size.  The
hugetlb_no_page() path is much easier to hit but both might as well be
closed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer
+++ a/mm/hugetlb.c
@@ -1039,7 +1039,7 @@ static struct page *alloc_huge_page(stru
 		page = alloc_buddy_huge_page(h, vma, addr);
 		if (!page) {
 			hugetlb_put_quota(inode->i_mapping, chg);
-			return ERR_PTR(-VM_FAULT_OOM);
+			return ERR_PTR(-VM_FAULT_SIGBUS);
 		}
 	}
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mmmigration-avoid-race-between-shift_arg_pages-and-rmap_walk-during-migration-by-not-migrating-temporary-stacks.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-memory-compaction-core-do-not-schedule-work-on-other-cpus-for-compaction.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails-fix.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch
vmscan-remove-may_unmap-scan-control.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch
vmscan-remove-may_swap-scan-control.patch
ummunotify-userspace-support-for-mmu-notifications-v2.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch


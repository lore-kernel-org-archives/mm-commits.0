From: akpm@linux-foundation.org
Subject: [merged] schednuma-add-cond_resched-to-task_numa_work.patch
 removed from -mm tree
Date: Mon, 24 Feb 2014 12:39:49 -0800
Message-ID: <530bae15.6WyOwvSBMifHOKvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaBXUju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 15:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, peterz@infradead.org, gang.xing@hp.com, chegu_vinod@hp.com, aarcange@redhat.com, riel@redhat.com

Subject: [merged] schednuma-add-cond_resched-to-task_numa_work.patch removed from -mm tree
To: riel@redhat.com,aarcange@redhat.com,chegu_vinod@hp.com,gang.xing@hp.com,peterz@infradead.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 12:39:49 -0800


The patch titled
     Subject: sched,numa: add cond_resched to task_numa_work
has been removed from the -mm tree.  Its filename was
     schednuma-add-cond_resched-to-task_numa_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: sched,numa: add cond_resched to task_numa_work

Normally task_numa_work scans over a fairly small amount of memory, but it
is possible to run into a large unpopulated part of virtual memory, with
no pages mapped.  In that case, task_numa_work can run for a while, and it
may make sense to reschedule as required.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Xing Gang <gang.xing@hp.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched/fair.c~schednuma-add-cond_resched-to-task_numa_work kernel/sched/fair.c
--- a/kernel/sched/fair.c~schednuma-add-cond_resched-to-task_numa_work
+++ a/kernel/sched/fair.c
@@ -1757,6 +1757,8 @@ void task_numa_work(struct callback_head
 			start = end;
 			if (pages <= 0)
 				goto out;
+
+			cond_resched();
 		} while (end != vma->vm_end);
 	}
 
_

Patches currently in -mm which might be from riel@redhat.com are

mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch
linux-next.patch


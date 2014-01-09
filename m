From: akpm@linux-foundation.org
Subject: + x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
 added to -mm tree
Date: Thu, 09 Jan 2014 14:02:01 -0800
Message-ID: <52cf1c59.CPjaf8PlFvqvXgf0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaAIWCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jan 2014 17:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, hpa@zytor.com, alex.shi@linaro.org, mgorman@suse.de

Subject: + x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch added to -mm tree
To: mgorman@suse.de,alex.shi@linaro.org,hpa@zytor.com,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Thu, 09 Jan 2014 14:02:01 -0800


The patch titled
     Subject: x86: mm: clean up inconsistencies when flushing TLB ranges
has been added to the -mm tree.  Its filename is
     x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: mm: clean up inconsistencies when flushing TLB ranges

NR_TLB_LOCAL_FLUSH_ALL is not always accounted for correctly and the
comparison with total_vm is done before taking tlb_flushall_shift into
account.  Clean it up.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Alex Shi <alex.shi@linaro.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/tlb.c~x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges
+++ a/arch/x86/mm/tlb.c
@@ -189,6 +189,7 @@ void flush_tlb_mm_range(struct mm_struct
 {
 	unsigned long addr;
 	unsigned act_entries, tlb_entries = 0;
+	unsigned long nr_base_pages;
 
 	preempt_disable();
 	if (current->active_mm != mm)
@@ -210,18 +211,17 @@ void flush_tlb_mm_range(struct mm_struct
 		tlb_entries = tlb_lli_4k[ENTRIES];
 	else
 		tlb_entries = tlb_lld_4k[ENTRIES];
+
 	/* Assume all of TLB entries was occupied by this task */
-	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
+	act_entries = tlb_entries >> tlb_flushall_shift;
+	act_entries = mm->total_vm > act_entries ? act_entries : mm->total_vm;
+	nr_base_pages = (end - start) >> PAGE_SHIFT;
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
-	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift) {
+	if (nr_base_pages > act_entries || has_large_page(mm, start, end)) {
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
-		if (has_large_page(mm, start, end)) {
-			local_flush_tlb();
-			goto flush_all;
-		}
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
 			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
mm-thp-__get_page_tail_foll-can-use-get_huge_page_tail.patch
mm-thp-turn-compound_head-into-bug_onpagetail-in-get_huge_page_tail.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
numa-add-a-sysctl-for-numa_balancing.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch


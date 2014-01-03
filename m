From: akpm@linux-foundation.org
Subject: [merged] mm-remove-bogus-warning-in-copy_huge_pmd.patch removed
 from -mm tree
Date: Fri, 03 Jan 2014 12:38:02 -0800
Message-ID: <52c71faa.8RrRRO+Dze2fOPTr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaACUiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 15:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-remove-bogus-warning-in-copy_huge_pmd.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 12:38:02 -0800


The patch titled
     Subject: mm: remove bogus warning in copy_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-remove-bogus-warning-in-copy_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: remove bogus warning in copy_huge_pmd()

Sasha Levin reported the following warning being triggered

[ 1704.594807] WARNING: CPU: 28 PID: 35287 at mm/huge_memory.c:887 copy_huge_pmd+0x145/ 0x3a0()
[ 1704.597258] Modules linked in:
[ 1704.597844] CPU: 28 PID: 35287 Comm: trinity-main Tainted: G        W    3.13.0-rc4-next-20131217-sasha-00013-ga878504-dirty #4149
[ 1704.599924]  0000000000000377e delta! pid slot 27 [36258]: old:2 now:537927697 diff: 537927695 ffff8803593ddb90 ffffffff8439501c ffffffff854722c1
[ 1704.604846]  0000000000000000 ffff8803593ddbd0 ffffffff8112f8ac ffff8803593ddbe0
[ 1704.606391]  ffff88034bc137f0 ffff880e41677000 8000000b47c009e4 ffff88034a638000
[ 1704.608008] Call Trace:
[ 1704.608511]  [<ffffffff8439501c>] dump_stack+0x52/0x7f
[ 1704.609699]  [<ffffffff8112f8ac>] warn_slowpath_common+0x8c/0xc0
[ 1704.612617]  [<ffffffff8112f8fa>] warn_slowpath_null+0x1a/0x20
[ 1704.614043]  [<ffffffff812b91c5>] copy_huge_pmd+0x145/0x3a0
[ 1704.615587]  [<ffffffff8127e032>] copy_page_range+0x3f2/0x560
[ 1704.616869]  [<ffffffff81199ef1>] ? rwsem_wake+0x51/0x70
[ 1704.617942]  [<ffffffff8112cf59>] dup_mmap+0x2c9/0x3d0
[ 1704.619146]  [<ffffffff8112d54d>] dup_mm+0xad/0x150
[ 1704.620051]  [<ffffffff8112e178>] copy_process+0xa68/0x12e0
[ 1704.622976]  [<ffffffff81194eda>] ? __lock_release+0x1da/0x1f0
[ 1704.624234]  [<ffffffff8112eee6>] do_fork+0x96/0x270
[ 1704.624975]  [<ffffffff81249465>] ? context_tracking_user_exit+0x195/0x1d0
[ 1704.626427]  [<ffffffff811930ed>] ? trace_hardirqs_on+0xd/0x10
[ 1704.627681]  [<ffffffff8112f0d6>] SyS_clone+0x16/0x20
[ 1704.628833]  [<ffffffff843a6309>] stub_clone+0x69/0x90
[ 1704.629672]  [<ffffffff843a6150>] ? tracesys+0xdd/0xe2

This warning was introduced by "mm: numa: Avoid unnecessary disruption of
NUMA hinting during migration" for paranoia reasons but the warning is
bogus.  I was thinking of parallel races between NUMA hinting faults and
forks but this warning would also be triggered by a parallel reclaim
splitting a THP during a fork.  Remote the bogus warning.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/huge_memory.c~mm-remove-bogus-warning-in-copy_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-remove-bogus-warning-in-copy_huge_pmd
+++ a/mm/huge_memory.c
@@ -883,9 +883,6 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
 
-	/* mmap_sem prevents this happening but warn if that changes */
-	WARN_ON(pmd_trans_migrating(pmd));
-
 	if (unlikely(pmd_trans_splitting(pmd))) {
 		/* split huge page running from under us */
 		spin_unlock(src_ptl);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
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
x86-get-pg_data_ts-memory-from-other-node.patch
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
mm-remove-bug_on-from-mlock_vma_page.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch


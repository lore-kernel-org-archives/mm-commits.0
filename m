From: akpm@linux-foundation.org
Subject: + mm-memcg-group-swapped-out-statistics-counter-logically.patch added to -mm tree
Date: Tue, 15 May 2012 14:54:46 -0700
Message-ID: <20120515215446.D4804A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63942 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab2EOVyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:54:49 -0400
Received: by eaao13 with SMTP id o13so2454eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:54:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com


The patch titled
     Subject: mm: memcg: group swapped-out statistics counter logically
has been added to the -mm tree.  Its filename is
     mm-memcg-group-swapped-out-statistics-counter-logically.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: group swapped-out statistics counter logically

The counter of currently swapped out pages in a memcg (hierarchy) is
sitting amidst ever-increasing event counters.  Move this item to the
other counters that reflect current state rather than history.

This technically breaks the kernel ABI, but hopefully nobody relies on the
order of items in memory.stat.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-group-swapped-out-statistics-counter-logically mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-group-swapped-out-statistics-counter-logically
+++ a/mm/memcontrol.c
@@ -4265,9 +4265,9 @@ enum {
 	MCS_RSS,
 	MCS_FILE_MAPPED,
 	MCS_MLOCK,
+	MCS_SWAP,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
-	MCS_SWAP,
 	MCS_PGFAULT,
 	MCS_PGMAJFAULT,
 	MCS_INACTIVE_ANON,
@@ -4287,9 +4287,9 @@ static const char *memcg_stat_strings[NR
 	"rss",
 	"mapped_file",
 	"mlock",
+	"swap",
 	"pgpgin",
 	"pgpgout",
-	"swap",
 	"pgfault",
 	"pgmajfault",
 	"inactive_anon",
@@ -4314,14 +4314,14 @@ mem_cgroup_get_local_stat(struct mem_cgr
 	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_MLOCK);
 	s->stat[MCS_MLOCK] += val * PAGE_SIZE;
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGIN);
-	s->stat[MCS_PGPGIN] += val;
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGOUT);
-	s->stat[MCS_PGPGOUT] += val;
 	if (do_swap_account) {
 		val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
+	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGIN);
+	s->stat[MCS_PGPGIN] += val;
+	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGOUT);
+	s->stat[MCS_PGPGOUT] += val;
 	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGFAULT);
 	s->stat[MCS_PGFAULT] += val;
 	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGMAJFAULT);
_
Subject: Subject: mm: memcg: group swapped-out statistics counter logically

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
mm-slab-remove-duplicate-check.patch
mm-remove-swap-token-code.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-remove-redundant-offset-check-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
mm-memcg-remove-obsolete-statistics-array-boundary-enum-item.patch
mm-memcg-convert-numa-stat-to-read_seq_string-interface.patch
mm-memcg-print-statistics-directly-to-seq_file.patch
mm-memcg-keep-ratelimit-counter-separate-from-event-counters.patch
mm-memcg-group-swapped-out-statistics-counter-logically.patch
mm-memcg-print-statistics-from-live-counters.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch


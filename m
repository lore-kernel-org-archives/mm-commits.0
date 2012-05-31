From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-keep-ratelimit-counter-separate-from-event-counters.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:00 -0700
Message-ID: <20120531191800.6B0EDA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2EaTSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:02 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: keep ratelimit counter separate from event counters
has been removed from the -mm tree.  Its filename was
     mm-memcg-keep-ratelimit-counter-separate-from-event-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: keep ratelimit counter separate from event counters

All events except the ratelimit counter are statistics exported to
userspace.  Keep this internal value out of the event count array.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-keep-ratelimit-counter-separate-from-event-counters mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-keep-ratelimit-counter-separate-from-event-counters
+++ a/mm/memcontrol.c
@@ -94,7 +94,6 @@ enum mem_cgroup_stat_index {
 enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
 	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
-	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
 	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
 	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
 	MEM_CGROUP_EVENTS_NSTATS,
@@ -118,6 +117,7 @@ enum mem_cgroup_events_target {
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
+	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
 
@@ -716,7 +716,7 @@ static void mem_cgroup_charge_statistics
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
+	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
 
 	preempt_enable();
 }
@@ -777,7 +777,7 @@ static bool mem_cgroup_event_ratelimit(s
 {
 	unsigned long val, next;
 
-	val = __this_cpu_read(memcg->stat->events[MEM_CGROUP_EVENTS_COUNT]);
+	val = __this_cpu_read(memcg->stat->nr_page_events);
 	next = __this_cpu_read(memcg->stat->targets[target]);
 	/* from time_after() in jiffies.h */
 	if ((long)next - (long)val < 0) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-slab-remove-duplicate-check.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
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
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch


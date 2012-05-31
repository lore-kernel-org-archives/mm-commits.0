From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-obsolete-statistics-array-boundary-enum-item.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:53 -0700
Message-ID: <20120531191753.6967CA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35579 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2EaTRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:54 -0400
Received: by mail-gg0-f202.google.com with SMTP id h3so135653gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove obsolete statistics array boundary enum item
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-obsolete-statistics-array-boundary-enum-item.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: remove obsolete statistics array boundary enum item

MEM_CGROUP_STAT_DATA is a leftover from when item counters were living in
the same array as ever-increasing event counters.  It's no longer needed,
use MEM_CGROUP_STAT_NSTATS to iterate over the stat array.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-obsolete-statistics-array-boundary-enum-item mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-obsolete-statistics-array-boundary-enum-item
+++ a/mm/memcontrol.c
@@ -88,7 +88,6 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -2135,7 +2134,7 @@ static void mem_cgroup_drain_pcp_counter
 	int i;
 
 	spin_lock(&memcg->pcp_counter_lock);
-	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		long x = per_cpu(memcg->stat->count[i], cpu);
 
 		per_cpu(memcg->stat->count[i], cpu) = 0;
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


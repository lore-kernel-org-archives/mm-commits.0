From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-pcg_file_mapped-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:26:26 -0700
Message-ID: <20120321232626.667B4A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33970 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab2CUX03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2012 19:26:29 -0400
Received: by laai8 with SMTP id i8so82302laa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:26:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-remove-pcg_file_mapped-fix
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcg_file_mapped-fix.patch

This patch was dropped because it was folded into memcg-remove-pcg_file_mapped.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg-remove-pcg_file_mapped-fix

memcg: fix remove PCG_FILE_MAPPED

At move_acount(), accounting information nr_file_mapped per memcg is moved
from old cgroup to new one.  The patch memcg-remove-pcg_file_mapped.patch
chesk the condition by

	if (page_mapped(page))

But we want to count only FILE_MAPPED. Then, this should be

	if (!PageAnon(page) && page_mapped(page))

This handles following cases.
  - anon  + mapped   => false
  - anon  + unmapped => false (swap cache)
  - shmem + mapped   => true
  - shmem + unmapped => false (swap cache)
  - file  + mapped   => true
  - file  + unmapped => false

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-pcg_file_mapped-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_file_mapped-fix
+++ a/mm/memcontrol.c
@@ -2613,7 +2613,7 @@ static int mem_cgroup_move_account(struc
 
 	move_lock_mem_cgroup(from, &flags);
 
-	if (page_mapped(page)) {
+	if (!PageAnon(page) && page_mapped(page)) {
 		/* Update mapped_file data for mem_cgroup */
 		preempt_disable();
 		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-make-get_mm_counter-static-inline.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-oom-force-oom-kill-on-sysrqf.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch
mm-dont-set-__gfp_write-on-ramfs-sysfs-writes.patch
mm-use-global_dirty_limit-in-throttle_vm_writeout.patch
mm-memcg-pass-charge-order-to-oom-killer.patch
mm-counters-remove-task-argument-to-sync_mm_rss-and-__sync_task_rss_stat.patch
mm-counters-fold-__sync_task_rss_stat-into-sync_mm_rss.patch
mmapc-fix-comment-for-__insert_vm_struct.patch
mm-forbid-lumpy-reclaim-in-shrink_active_list.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-export_symbolmem_cgroup_update_page_stat.patch
memcg-simplify-move_account-check.patch
memcg-remove-pcg_move_lock-flag-from-page_cgroup.patch
memcg-use-new-logic-for-page-stat-accounting.patch
memcg-remove-pcg_file_mapped.patch
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
memcg-remove-pcg_file_mapped-fix-42.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
memcg-clean-up-existing-move-charge-code.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch
memcg-avoid-thp-split-in-task-migration.patch


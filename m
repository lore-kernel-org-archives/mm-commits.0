From: akpm@linux-foundation.org
Subject: + memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch added to -mm tree
Date: Fri, 17 Feb 2012 13:46:02 -0800
Message-ID: <20120217214602.790E5A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38233 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2BQVqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 16:46:03 -0500
Received: by mail-gy0-f202.google.com with SMTP id r17so480109ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 13:46:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: fix performance of mem_cgroup_begin_update_page_stat()
has been added to the -mm tree.  Its filename is
     memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: fix performance of mem_cgroup_begin_update_page_stat()

mem_cgroup_begin_update_page_stat() should be very fast because it's
called very frequently.  Now, it needs to look up page_cgroup and its
memcg....this is slow.

This patch adds a global variable to check "any memcg is moving or not". 
With this, the caller doesn't need to visit page_cgroup and memcg.

Here is a test result.  A test program makes page faults onto a file,
MAP_SHARED and makes each page's page_mapcount(page) > 1, and free the
range by madvise() and page fault again.  This program causes 26214400
times of page fault onto a file(size was 1G.) and shows shows the cost of
mem_cgroup_begin_update_page_stat().

Before this patch for mem_cgroup_begin_update_page_stat()
[kamezawa@bluextal test]$ time ./mmap 1G

real    0m21.765s
user    0m5.999s
sys     0m15.434s

    27.46%     mmap  mmap               [.] reader
    21.15%     mmap  [kernel.kallsyms]  [k] page_fault
     9.17%     mmap  [kernel.kallsyms]  [k] filemap_fault
     2.96%     mmap  [kernel.kallsyms]  [k] __do_fault
     2.83%     mmap  [kernel.kallsyms]  [k] __mem_cgroup_begin_update_page_stat

After this patch
[root@bluextal test]# time ./mmap 1G

real    0m21.373s
user    0m6.113s
sys     0m15.016s

In usual path, calls to __mem_cgroup_begin_update_page_stat() goes away.

Note: we may be able to remove this optimization in future if
      we can get pointer to memcg directly from struct page.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +++++-
 mm/memcontrol.c            |    9 ++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat
+++ a/include/linux/memcontrol.h
@@ -144,6 +144,8 @@ static inline bool mem_cgroup_disabled(v
 void __mem_cgroup_begin_update_page_stat(struct page *page, bool *locked,
 					 unsigned long *flags);
 
+extern atomic_t memcg_moving;
+
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
@@ -151,7 +153,9 @@ static inline void mem_cgroup_begin_upda
 		return;
 	rcu_read_lock();
 	*locked = false;
-	return __mem_cgroup_begin_update_page_stat(page, locked, flags);
+	if (atomic_read(&memcg_moving))
+		return __mem_cgroup_begin_update_page_stat(page, locked,
+								flags);
 }
 
 void __mem_cgroup_end_update_page_stat(struct page *page,
diff -puN mm/memcontrol.c~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat
+++ a/mm/memcontrol.c
@@ -1273,8 +1273,13 @@ int mem_cgroup_swappiness(struct mem_cgr
  *                                              rcu_read_unlock()
  *         start move here.
  */
+
+/* for quick checking without looking up memcg */
+atomic_t memcg_moving __read_mostly;
+
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
+	atomic_inc(&memcg_moving);
 	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
@@ -1285,8 +1290,10 @@ static void mem_cgroup_end_move(struct m
 	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
 	 * We check NULL in callee rather than caller.
 	 */
-	if (memcg)
+	if (memcg) {
+		atomic_dec(&memcg_moving);
 		atomic_dec(&memcg->moving_account);
+	}
 }
 
 /*
_
Subject: Subject: memcg: fix performance of mem_cgroup_begin_update_page_stat()

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-oom-introduce-independent-oom-killer-ratelimit-state.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-make-get_mm_counter-static-inline.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
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
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-remove-export_symbolmem_cgroup_update_page_stat.patch
memcg-simplify-move_account-check.patch
memcg-remove-pcg_move_lock-flag-from-page_cgroup.patch
memcg-use-new-logic-for-page-stat-accounting.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-remove-pcg_file_mapped.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
proc-speedup-proc-stat-handling.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch
procfs-speed-up-proc-pid-stat-statm.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch


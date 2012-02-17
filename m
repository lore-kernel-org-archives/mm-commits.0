From: akpm@linux-foundation.org
Subject: + memcg-use-new-logic-for-page-stat-accounting.patch added to -mm tree
Date: Fri, 17 Feb 2012 13:45:56 -0800
Message-ID: <20120217214556.3C683A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:39964 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab2BQVp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 16:45:59 -0500
Received: by eekb15 with SMTP id b15so133798eek.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 13:45:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: use new logic for page stat accounting
has been added to the -mm tree.  Its filename is
     memcg-use-new-logic-for-page-stat-accounting.patch

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
Subject: memcg: use new logic for page stat accounting

Now, page-stat-per-memcg is recorded into per page_cgroup flag by
duplicating page's status into the flag.  The reason is that memcg has a
feature to move a page from a group to another group and we have race
between "move" and "page stat accounting",

Under current logic, assume CPU-A and CPU-B.  CPU-A does "move" and CPU-B
does "page stat accounting".

When CPU-A goes 1st,

            CPU-A                           CPU-B
                                    update "struct page" info.
    move_lock_mem_cgroup(memcg)
    see pc->flags
    copy page stat to new group
    overwrite pc->mem_cgroup.
    move_unlock_mem_cgroup(memcg)
                                    move_lock_mem_cgroup(mem)
                                    set pc->flags
                                    update page stat accounting
                                    move_unlock_mem_cgroup(mem)

stat accounting is guarded by move_lock_mem_cgroup() and "move" logic
(CPU-A) doesn't see changes in "struct page" information.

But it's costly to have the same information both in 'struct page' and
'struct page_cgroup'.  And, there is a potential problem.

For example, assume we have PG_dirty accounting in memcg.
PG_..is a flag for struct page.
PCG_ is a flag for struct page_cgroup.
(This is just an example. The same problem can be found in any
 kind of page stat accounting.)

	  CPU-A                               CPU-B
      TestSet PG_dirty
      (delay)                        TestClear PG_dirty
                                     if (TestClear(PCG_dirty))
                                          memcg->nr_dirty--
      if (TestSet(PCG_dirty))
          memcg->nr_dirty++

Here, memcg->nr_dirty = +1, this is wrong.  This race was reported by Greg
Thelen <gthelen@google.com>.  Now, only FILE_MAPPED is supported but
fortunately, it's serialized by page table lock and this is not real bug,
_now_,

If this potential problem is caused by having duplicated information in
struct page and struct page_cgroup, we may be able to fix this by using
original 'struct page' information.  But we'll have a problem in "move
account"

Assume we use only PG_dirty.

         CPU-A                   CPU-B
    TestSet PG_dirty
    (delay)                    move_lock_mem_cgroup()
                               if (PageDirty(page))
                                      new_memcg->nr_dirty++
                               pc->mem_cgroup = new_memcg;
                               move_unlock_mem_cgroup()
    move_lock_mem_cgroup()
    memcg = pc->mem_cgroup
    new_memcg->nr_dirty++

accounting information may be double-counted.  This was original reason to
have PCG_xxx flags but it seems PCG_xxx has another problem.

I think we need a bigger lock as

     move_lock_mem_cgroup(page)
     TestSetPageDirty(page)
     update page stats (without any checks)
     move_unlock_mem_cgroup(page)

This fixes both of problems and we don't have to duplicate page flag into
page_cgroup.  Please note: move_lock_mem_cgroup() is held only when there
are possibility of "account move" under the system.  So, in most path,
status update will go without atomic locks.

This patch introduces mem_cgroup_begin_update_page_stat() and
mem_cgroup_end_update_page_stat() both should be called at modifying
'struct page' information if memcg takes care of it.  as

     mem_cgroup_begin_update_page_stat()
     modify page information
     mem_cgroup_update_page_stat()
     => never check any 'struct page' info, just update counters.
     mem_cgroup_end_update_page_stat().

This patch is slow because we need to call begin_update_page_stat()/
end_update_page_stat() regardless of accounted will be changed or not.  A
following patch adds an easy optimization and reduces the cost.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   35 +++++++++++++++++++
 mm/memcontrol.c            |   64 ++++++++++++++++++++++++-----------
 mm/rmap.c                  |   15 +++++++-
 3 files changed, 92 insertions(+), 22 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting
+++ a/include/linux/memcontrol.h
@@ -141,6 +141,31 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
+void __mem_cgroup_begin_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags);
+
+static inline void mem_cgroup_begin_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+	if (mem_cgroup_disabled())
+		return;
+	rcu_read_lock();
+	*lock = false;
+	return __mem_cgroup_begin_update_page_stat(page, lock, flags);
+}
+
+void __mem_cgroup_end_update_page_stat(struct page *page,
+				unsigned long *flags);
+static inline void mem_cgroup_end_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+	if (mem_cgroup_disabled())
+		return;
+	if (*lock)
+		__mem_cgroup_end_update_page_stat(page, flags);
+	rcu_read_unlock();
+}
+
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx,
 				 int val);
@@ -341,6 +366,16 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
+static inline void mem_cgroup_begin_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+}
+
+static inline void mem_cgroup_end_update_page_stat(struct page *page,
+					bool *lock, unsigned long *flags)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_page_stat_item idx)
 {
diff -puN mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting
+++ a/mm/memcontrol.c
@@ -1877,32 +1877,61 @@ bool mem_cgroup_handle_oom(struct mem_cg
  * If there is, we take a lock.
  */
 
+void __mem_cgroup_begin_update_page_stat(struct page *page,
+				bool *lock, unsigned long *flags)
+{
+	struct mem_cgroup *memcg;
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(page);
+again:
+	memcg = pc->mem_cgroup;
+	if (unlikely(!memcg || !PageCgroupUsed(pc)))
+		return;
+	/*
+	 * If this memory cgroup is not under account moving, we don't
+	 * need to take move_lock_page_cgroup(). Because we already hold
+	 * rcu_read_lock(), any calls to move_account will be delayed until
+	 * rcu_read_unlock() if mem_cgroup_stealed() == true.
+	 */
+	if (!mem_cgroup_stealed(memcg))
+		return;
+
+	move_lock_mem_cgroup(memcg, flags);
+	if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
+		move_unlock_mem_cgroup(memcg, flags);
+		goto again;
+	}
+	*lock = true;
+}
+
+void __mem_cgroup_end_update_page_stat(struct page *page,
+				unsigned long *flags)
+{
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+
+	/*
+	 * It's guaranteed that pc->mem_cgroup never changes while
+	 * lock is held because a routine modifies pc->mem_cgroup
+	 * should take move_lock_page_cgroup().
+	 */
+	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
+}
+
+
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-	bool need_unlock = false;
 	unsigned long uninitialized_var(flags);
 
 	if (mem_cgroup_disabled())
 		return;
-again:
-	rcu_read_lock();
+
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
-		goto out;
-	/* pc->mem_cgroup is unstable ? */
-	if (unlikely(mem_cgroup_stealed(memcg))) {
-		/* take a lock against to access pc->mem_cgroup */
-		move_lock_mem_cgroup(memcg, &flags);
-		if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
-			move_unlock_mem_cgroup(memcg, &flags);
-			rcu_read_unlock();
-			goto again;
-		}
-		need_unlock = true;
-	}
+		return;
 
 	switch (idx) {
 	case MEMCG_NR_FILE_MAPPED:
@@ -1917,11 +1946,6 @@ again:
 	}
 
 	this_cpu_add(memcg->stat->count[idx], val);
-
-out:
-	if (unlikely(need_unlock))
-		move_unlock_mem_cgroup(memcg, &flags);
-	rcu_read_unlock();
 }
 
 /*
diff -puN mm/rmap.c~memcg-use-new-logic-for-page-stat-accounting mm/rmap.c
--- a/mm/rmap.c~memcg-use-new-logic-for-page-stat-accounting
+++ a/mm/rmap.c
@@ -1147,10 +1147,15 @@ void page_add_new_anon_rmap(struct page 
  */
 void page_add_file_rmap(struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_MAPPED);
 	}
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /**
@@ -1161,9 +1166,13 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+	bool locked;
+	unsigned long flags;
+
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
-		return;
+		goto out;
 
 	/*
 	 * Now that the last pte has gone, s390 must transfer dirty
@@ -1180,7 +1189,7 @@ void page_remove_rmap(struct page *page)
 	 * and not charged by memcg for now.
 	 */
 	if (unlikely(PageHuge(page)))
-		return;
+		goto out;
 	if (PageAnon(page)) {
 		mem_cgroup_uncharge_page(page);
 		if (!PageTransHuge(page))
@@ -1201,6 +1210,8 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
+out:
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /*
_
Subject: Subject: memcg: use new logic for page stat accounting

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


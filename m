From: akpm@linux-foundation.org
Subject: [merged] memcg-use-new-logic-for-page-stat-accounting.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:56 -0700
Message-ID: <20120322201956.CC093A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35764 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab2CVUT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:57 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so402357vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: use new logic for page stat accounting
has been removed from the -mm tree.  Its filename was
     memcg-use-new-logic-for-page-stat-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[akpm@linux-foundation.org: s/lock/locked/]
[hughd@google.com: fix deadlock by avoiding stat lock when anon]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   35 +++++++++++++++++++
 mm/memcontrol.c            |   62 +++++++++++++++++++++++------------
 mm/rmap.c                  |   28 +++++++++++++--
 3 files changed, 101 insertions(+), 24 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting
+++ a/include/linux/memcontrol.h
@@ -141,6 +141,31 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
+void __mem_cgroup_begin_update_page_stat(struct page *page, bool *locked,
+					 unsigned long *flags);
+
+static inline void mem_cgroup_begin_update_page_stat(struct page *page,
+					bool *locked, unsigned long *flags)
+{
+	if (mem_cgroup_disabled())
+		return;
+	rcu_read_lock();
+	*locked = false;
+	return __mem_cgroup_begin_update_page_stat(page, locked, flags);
+}
+
+void __mem_cgroup_end_update_page_stat(struct page *page,
+				unsigned long *flags);
+static inline void mem_cgroup_end_update_page_stat(struct page *page,
+					bool *locked, unsigned long *flags)
+{
+	if (mem_cgroup_disabled())
+		return;
+	if (*locked)
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
+					bool *locked, unsigned long *flags)
+{
+}
+
+static inline void mem_cgroup_end_update_page_stat(struct page *page,
+					bool *locked, unsigned long *flags)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_page_stat_item idx)
 {
diff -puN mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting
+++ a/mm/memcontrol.c
@@ -1910,32 +1910,59 @@ bool mem_cgroup_handle_oom(struct mem_cg
  * If there is, we take a lock.
  */
 
+void __mem_cgroup_begin_update_page_stat(struct page *page,
+				bool *locked, unsigned long *flags)
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
+	*locked = true;
+}
+
+void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
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
@@ -1950,11 +1977,6 @@ again:
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
@@ -1148,10 +1148,15 @@ void page_add_new_anon_rmap(struct page 
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
@@ -1162,9 +1167,21 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+	bool anon = PageAnon(page);
+	bool locked;
+	unsigned long flags;
+
+	/*
+	 * The anon case has no mem_cgroup page_stat to update; but may
+	 * uncharge_page() below, where the lock ordering can deadlock if
+	 * we hold the lock against page_stat move: so avoid it on anon.
+	 */
+	if (!anon)
+		mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
-		return;
+		goto out;
 
 	/*
 	 * Now that the last pte has gone, s390 must transfer dirty
@@ -1173,7 +1190,7 @@ void page_remove_rmap(struct page *page)
 	 * not if it's in swapcache - there might be another pte slot
 	 * containing the swap entry, but page not yet written to swap.
 	 */
-	if ((!PageAnon(page) || PageSwapCache(page)) &&
+	if ((!anon || PageSwapCache(page)) &&
 	    page_test_and_clear_dirty(page_to_pfn(page), 1))
 		set_page_dirty(page);
 	/*
@@ -1181,8 +1198,8 @@ void page_remove_rmap(struct page *page)
 	 * and not charged by memcg for now.
 	 */
 	if (unlikely(PageHuge(page)))
-		return;
-	if (PageAnon(page)) {
+		goto out;
+	if (anon) {
 		mem_cgroup_uncharge_page(page);
 		if (!PageTransHuge(page))
 			__dec_zone_page_state(page, NR_ANON_PAGES);
@@ -1202,6 +1219,9 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
+out:
+	if (!anon)
+		mem_cgroup_end_update_page_stat(page, &locked, &flags);
 }
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
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


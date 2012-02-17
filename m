From: akpm@linux-foundation.org
Subject: + memcg-remove-pcg_move_lock-flag-from-page_cgroup.patch added to -mm tree
Date: Fri, 17 Feb 2012 13:45:53 -0800
Message-ID: <20120217214553.D9C73A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:34425 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2BQVp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 16:45:56 -0500
Received: by wgbds12 with SMTP id ds12so132991wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 13:45:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: remove PCG_MOVE_LOCK flag from page_cgroup
has been added to the -mm tree.  Its filename is
     memcg-remove-pcg_move_lock-flag-from-page_cgroup.patch

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
Subject: memcg: remove PCG_MOVE_LOCK flag from page_cgroup

PCG_MOVE_LOCK is used for bit spinlock to avoid race between overwriting
pc->mem_cgroup and page statistics accounting per memcg.  This lock helps
to avoid the race but the race is very rare because moving tasks between
cgroup is not a usual job.  So, it seems using 1bit per page is too
costly.

This patch changes this lock as per-memcg spinlock and removes
PCG_MOVE_LOCK.

If smaller lock is required, we'll be able to add some hashes but I'd like
to start from this.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   19 ---------------
 mm/memcontrol.c             |   42 +++++++++++++++++++++++++---------
 2 files changed, 32 insertions(+), 29 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-remove-pcg_move_lock-flag-from-page_cgroup include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-pcg_move_lock-flag-from-page_cgroup
+++ a/include/linux/page_cgroup.h
@@ -7,7 +7,6 @@ enum {
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
 	/* flags for mem_cgroup and file and I/O status */
-	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 	__NR_PCG_FLAGS,
 };
@@ -89,24 +88,6 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-static inline void move_lock_page_cgroup(struct page_cgroup *pc,
-	unsigned long *flags)
-{
-	/*
-	 * We know updates to pc->flags of page cache's stats are from both of
-	 * usual context or IRQ context. Disable IRQ to avoid deadlock.
-	 */
-	local_irq_save(*flags);
-	bit_spin_lock(PCG_MOVE_LOCK, &pc->flags);
-}
-
-static inline void move_unlock_page_cgroup(struct page_cgroup *pc,
-	unsigned long *flags)
-{
-	bit_spin_unlock(PCG_MOVE_LOCK, &pc->flags);
-	local_irq_restore(*flags);
-}
-
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct page_cgroup;
 
diff -puN mm/memcontrol.c~memcg-remove-pcg_move_lock-flag-from-page_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_move_lock-flag-from-page_cgroup
+++ a/mm/memcontrol.c
@@ -280,6 +280,8 @@ struct mem_cgroup {
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
 	atomic_t	moving_account;
+	/* taken only while moving_account > 0 */
+	spinlock_t	move_lock;
 	/*
 	 * percpu counter.
 	 */
@@ -1343,6 +1345,24 @@ static bool mem_cgroup_wait_acct_move(st
 	return false;
 }
 
+/*
+ * Take this lock when
+ * - a code tries to modify page's memcg while it's USED.
+ * - a code tries to modify page state accounting in a memcg.
+ * see mem_cgroup_stealed(), too.
+ */
+static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
+				  unsigned long *flags)
+{
+	spin_lock_irqsave(&memcg->move_lock, *flags);
+}
+
+static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
+				unsigned long *flags)
+{
+	spin_unlock_irqrestore(&memcg->move_lock, *flags);
+}
+
 /**
  * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
  * @memcg: The memory cgroup that went over limit
@@ -1867,7 +1887,7 @@ void mem_cgroup_update_page_stat(struct 
 
 	if (mem_cgroup_disabled())
 		return;
-
+again:
 	rcu_read_lock();
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
@@ -1875,11 +1895,13 @@ void mem_cgroup_update_page_stat(struct 
 	/* pc->mem_cgroup is unstable ? */
 	if (unlikely(mem_cgroup_stealed(memcg))) {
 		/* take a lock against to access pc->mem_cgroup */
-		move_lock_page_cgroup(pc, &flags);
+		move_lock_mem_cgroup(memcg, &flags);
+		if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
+			move_unlock_mem_cgroup(memcg, &flags);
+			rcu_read_unlock();
+			goto again;
+		}
 		need_unlock = true;
-		memcg = pc->mem_cgroup;
-		if (!memcg || !PageCgroupUsed(pc))
-			goto out;
 	}
 
 	switch (idx) {
@@ -1898,7 +1920,7 @@ void mem_cgroup_update_page_stat(struct 
 
 out:
 	if (unlikely(need_unlock))
-		move_unlock_page_cgroup(pc, &flags);
+		move_unlock_mem_cgroup(memcg, &flags);
 	rcu_read_unlock();
 }
 
@@ -2440,8 +2462,7 @@ static void __mem_cgroup_commit_charge(s
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_MIGRATION))
+#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2512,7 +2533,7 @@ static int mem_cgroup_move_account(struc
 	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
 		goto unlock;
 
-	move_lock_page_cgroup(pc, &flags);
+	move_lock_mem_cgroup(from, &flags);
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
@@ -2536,7 +2557,7 @@ static int mem_cgroup_move_account(struc
 	 * guaranteed that "to" is never removed. So, we don't check rmdir
 	 * status here.
 	 */
-	move_unlock_page_cgroup(pc, &flags);
+	move_unlock_mem_cgroup(from, &flags);
 	ret = 0;
 unlock:
 	unlock_page_cgroup(pc);
@@ -4928,6 +4949,7 @@ mem_cgroup_create(struct cgroup *cont)
 	atomic_set(&memcg->refcnt, 1);
 	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
+	spin_lock_init(&memcg->move_lock);
 	return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
_
Subject: Subject: memcg: remove PCG_MOVE_LOCK flag from page_cgroup

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


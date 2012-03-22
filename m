From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-pcg_move_lock-flag-from-page_cgroup.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:54 -0700
Message-ID: <20120322201954.7E7E1A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39689 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab2CVUTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:55 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so62245qab.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove PCG_MOVE_LOCK flag from page_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcg_move_lock-flag-from-page_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -300,6 +300,8 @@ struct mem_cgroup {
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
 	atomic_t	moving_account;
+	/* taken only while moving_account > 0 */
+	spinlock_t	move_lock;
 	/*
 	 * percpu counter.
 	 */
@@ -1376,6 +1378,24 @@ static bool mem_cgroup_wait_acct_move(st
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
@@ -1900,7 +1920,7 @@ void mem_cgroup_update_page_stat(struct 
 
 	if (mem_cgroup_disabled())
 		return;
-
+again:
 	rcu_read_lock();
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
@@ -1908,11 +1928,13 @@ void mem_cgroup_update_page_stat(struct 
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
@@ -1931,7 +1953,7 @@ void mem_cgroup_update_page_stat(struct 
 
 out:
 	if (unlikely(need_unlock))
-		move_unlock_page_cgroup(pc, &flags);
+		move_unlock_mem_cgroup(memcg, &flags);
 	rcu_read_unlock();
 }
 
@@ -2500,8 +2522,7 @@ static void __mem_cgroup_commit_charge(s
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_MIGRATION))
+#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2572,7 +2593,7 @@ static int mem_cgroup_move_account(struc
 	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
 		goto unlock;
 
-	move_lock_page_cgroup(pc, &flags);
+	move_lock_mem_cgroup(from, &flags);
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
@@ -2596,7 +2617,7 @@ static int mem_cgroup_move_account(struc
 	 * guaranteed that "to" is never removed. So, we don't check rmdir
 	 * status here.
 	 */
-	move_unlock_page_cgroup(pc, &flags);
+	move_unlock_mem_cgroup(from, &flags);
 	ret = 0;
 unlock:
 	unlock_page_cgroup(pc);
@@ -4971,6 +4992,7 @@ mem_cgroup_create(struct cgroup *cont)
 	atomic_set(&memcg->refcnt, 1);
 	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
+	spin_lock_init(&memcg->move_lock);
 	return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
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


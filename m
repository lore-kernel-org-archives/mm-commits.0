From: akpm@linux-foundation.org
Subject: + memcg-reduce-lock-hold-time-during-charge-moving.patch added to -mm tree
Date: Thu, 07 Oct 2010 16:15:29 -0700
Message-ID: <201010072315.o97NFT8a030304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab0JGXQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 19:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, gthelen@google.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: reduce lock hold time during charge moving
has been added to the -mm tree.  Its filename is
     memcg-reduce-lock-hold-time-during-charge-moving.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: reduce lock hold time during charge moving
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently during task migration among cgroups, memory cgroup scans page
tables and moves accounting if flags are properly set.

The core code, mem_cgroup_move_charge_pte_range() does

 	pte_offset_map_lock();
	for all ptes in a page table:
		1. look into page table, find_and_get a page
		2. remove it from LRU.
		3. move charge.
		4. putback to LRU. put_page()
	pte_offset_map_unlock();

for pte entries on a 3rd level? page table.

This pte_offset_map_lock seems a bit long. This patch modifies a rountine as

	for 32 pages: pte_offset_map_lock()
		      find_and_get a page
		      record it
		      pte_offset_map_unlock()
	for all recorded pages
		      isolate it from LRU.
		      move charge
		      putback to LRU
	for all recorded pages
		      put_page()

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   95 ++++++++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 36 deletions(-)

diff -puN mm/memcontrol.c~memcg-reduce-lock-hold-time-during-charge-moving mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reduce-lock-hold-time-during-charge-moving
+++ a/mm/memcontrol.c
@@ -276,6 +276,21 @@ enum move_type {
 	NR_MOVE_TYPE,
 };
 
+enum mc_target_type {
+	MC_TARGET_NONE, /* used as failure code(0) */
+	MC_TARGET_PAGE,
+	MC_TARGET_SWAP,
+};
+
+struct mc_target {
+	enum mc_target_type type;
+	union {
+		struct page *page;
+		swp_entry_t	ent;
+	} val;
+};
+#define MC_MOVE_ONCE	(32)
+
 /* "mc" and its members are protected by cgroup_mutex */
 static struct move_charge_struct {
 	spinlock_t	  lock; /* for from, to, moving_task */
@@ -284,6 +299,7 @@ static struct move_charge_struct {
 	unsigned long precharge;
 	unsigned long moved_charge;
 	unsigned long moved_swap;
+	struct mc_target target[MC_MOVE_ONCE];
 	struct task_struct *moving_task;	/* a task moving charges */
 	wait_queue_head_t waitq;		/* a waitq for other context */
 } mc = {
@@ -291,6 +307,7 @@ static struct move_charge_struct {
 	.waitq = __WAIT_QUEUE_HEAD_INITIALIZER(mc.waitq),
 };
 
+
 static bool move_anon(void)
 {
 	return test_bit(MOVE_CHARGE_TYPE_ANON,
@@ -4479,16 +4496,7 @@ one_by_one:
  *
  * Called with pte lock held.
  */
-union mc_target {
-	struct page	*page;
-	swp_entry_t	ent;
-};
 
-enum mc_target_type {
-	MC_TARGET_NONE,	/* not used */
-	MC_TARGET_PAGE,
-	MC_TARGET_SWAP,
-};
 
 static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 						unsigned long addr, pte_t ptent)
@@ -4565,7 +4573,7 @@ static struct page *mc_handle_file_pte(s
 }
 
 static int is_target_pte_for_mc(struct vm_area_struct *vma,
-		unsigned long addr, pte_t ptent, union mc_target *target)
+		unsigned long addr, pte_t ptent, struct mc_target *target)
 {
 	struct page *page = NULL;
 	struct page_cgroup *pc;
@@ -4591,7 +4599,7 @@ static int is_target_pte_for_mc(struct v
 		if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
 			ret = MC_TARGET_PAGE;
 			if (target)
-				target->page = page;
+				target->val.page = page;
 		}
 		if (!ret || !target)
 			put_page(page);
@@ -4601,8 +4609,10 @@ static int is_target_pte_for_mc(struct v
 			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
 		ret = MC_TARGET_SWAP;
 		if (target)
-			target->ent = ent;
+			target->val.ent = ent;
 	}
+	if (target)
+		target->type = ret;
 	return ret;
 }
 
@@ -4763,26 +4773,42 @@ static int mem_cgroup_move_charge_pte_ra
 	struct vm_area_struct *vma = walk->private;
 	pte_t *pte;
 	spinlock_t *ptl;
+	int index, num;
 
 retry:
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; addr += PAGE_SIZE) {
+	for (num = 0; num < MC_MOVE_ONCE && addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
-		union mc_target target;
-		int type;
+		ret = is_target_pte_for_mc(vma, addr, ptent, &mc.target[num]);
+		if (!ret)
+			continue;
+		mc.target[num++].type = ret;
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+
+	ret = 0;
+	index = 0;
+	do {
+		struct mc_target *mt;
 		struct page *page;
 		struct page_cgroup *pc;
 		swp_entry_t ent;
 
-		if (!mc.precharge)
-			break;
+		if (!mc.precharge) {
+			ret = mem_cgroup_do_precharge(1);
+			if (ret)
+				goto out;
+			continue;
+		}
+
+		mt = &mc.target[index++];
 
-		type = is_target_pte_for_mc(vma, addr, ptent, &target);
-		switch (type) {
+		switch (mt->type) {
 		case MC_TARGET_PAGE:
-			page = target.page;
+			page = mt->val.page;
 			if (isolate_lru_page(page))
-				goto put;
+				break;
 			pc = lookup_page_cgroup(page);
 			if (!mem_cgroup_move_account(pc,
 						mc.from, mc.to, false)) {
@@ -4791,11 +4817,9 @@ retry:
 				mc.moved_charge++;
 			}
 			putback_lru_page(page);
-put:			/* is_target_pte_for_mc() gets the page */
-			put_page(page);
 			break;
 		case MC_TARGET_SWAP:
-			ent = target.ent;
+			ent = mt->val.ent;
 			if (!mem_cgroup_move_swap_account(ent,
 						mc.from, mc.to, false)) {
 				mc.precharge--;
@@ -4806,21 +4830,20 @@ put:			/* is_target_pte_for_mc() gets th
 		default:
 			break;
 		}
+	} while (index < num);
+out:
+	for (index = 0; index < num; index++) {
+		if (mc.target[index].type == MC_TARGET_PAGE)
+			put_page(mc.target[index].val.page);
+		mc.target[index].type = MC_TARGET_NONE;
 	}
-	pte_unmap_unlock(pte - 1, ptl);
+
+	if (ret)
+		return ret;
 	cond_resched();
 
-	if (addr != end) {
-		/*
-		 * We have consumed all precharges we got in can_attach().
-		 * We try charge one by one, but don't do any additional
-		 * charges to mc.to if we have failed in charge once in attach()
-		 * phase.
-		 */
-		ret = mem_cgroup_do_precharge(1);
-		if (!ret)
-			goto retry;
-	}
+	if (addr != end)
+		goto retry;
 
 	return ret;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-thresholds-with-use_hierarchy-==-1.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
memcg-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-avoid-lock-in-updating-file_mapped-was-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-use-for_each_mem_cgroup.patch
memcg-cpu-hotplug-aware-percpu-count-updates.patch
memcg-cpu-hotplug-aware-percpu-count-updates-fix.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
memcg-generic-filestat-update-interface.patch
memcg-reduce-lock-hold-time-during-charge-moving.patch


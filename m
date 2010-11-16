From: akpm@linux-foundation.org
Subject: + memcg-avoid-deadlock-between-move-charge-and-try_charge.patch added to -mm tree
Date: Tue, 16 Nov 2010 12:41:22 -0800
Message-ID: <201011162041.oAGKfMfq006407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756987Ab0KPUlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 15:41:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, stable@kernel.org


The patch titled
     memcg: avoid deadlock between move charge and try_charge()
has been added to the -mm tree.  Its filename is
     memcg-avoid-deadlock-between-move-charge-and-try_charge.patch

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
Subject: memcg: avoid deadlock between move charge and try_charge()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

__mem_cgroup_try_charge() can be called under down_write(&mmap_sem)(e.g.
mlock does it). This means it can cause deadlock if it races with move charge:

Ex.1)
                move charge             |        try charge
  --------------------------------------+------------------------------
    mem_cgroup_can_attach()             |  down_write(&mmap_sem)
      mc.moving_task = current          |    ..
      mem_cgroup_precharge_mc()         |  __mem_cgroup_try_charge()
        mem_cgroup_count_precharge()    |    prepare_to_wait()
          down_read(&mmap_sem)          |    if (mc.moving_task)
          -> cannot aquire the lock     |    -> true
                                        |      schedule()

Ex.2)
                move charge             |        try charge
  --------------------------------------+------------------------------
    mem_cgroup_can_attach()             |
      mc.moving_task = current          |
      mem_cgroup_precharge_mc()         |
        mem_cgroup_count_precharge()    |
          down_read(&mmap_sem)          |
          ..                            |
          up_read(&mmap_sem)            |
                                        |  down_write(&mmap_sem)
    mem_cgroup_move_task()              |    ..
      mem_cgroup_move_charge()          |  __mem_cgroup_try_charge()
        down_read(&mmap_sem)            |    prepare_to_wait()
        -> cannot aquire the lock       |    if (mc.moving_task)
                                        |    -> true
                                        |      schedule()

To avoid this deadlock, we do all the move charge works (both can_attach() and
attach()) under one mmap_sem section.
And after this patch, we set/clear mc.moving_task outside mc.lock, because we
use the lock only to check mc.from/to.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-deadlock-between-move-charge-and-try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-deadlock-between-move-charge-and-try_charge
+++ a/mm/memcontrol.c
@@ -278,13 +278,14 @@ enum move_type {
 
 /* "mc" and its members are protected by cgroup_mutex */
 static struct move_charge_struct {
-	spinlock_t	  lock; /* for from, to, moving_task */
+	spinlock_t	  lock; /* for from, to */
 	struct mem_cgroup *from;
 	struct mem_cgroup *to;
 	unsigned long precharge;
 	unsigned long moved_charge;
 	unsigned long moved_swap;
 	struct task_struct *moving_task;	/* a task moving charges */
+	struct mm_struct *mm;
 	wait_queue_head_t waitq;		/* a waitq for other context */
 } mc = {
 	.lock = __SPIN_LOCK_UNLOCKED(mc.lock),
@@ -4631,7 +4632,7 @@ static unsigned long mem_cgroup_count_pr
 	unsigned long precharge;
 	struct vm_area_struct *vma;
 
-	down_read(&mm->mmap_sem);
+	/* We've already held the mmap_sem */
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		struct mm_walk mem_cgroup_count_precharge_walk = {
 			.pmd_entry = mem_cgroup_count_precharge_pte_range,
@@ -4643,7 +4644,6 @@ static unsigned long mem_cgroup_count_pr
 		walk_page_range(vma->vm_start, vma->vm_end,
 					&mem_cgroup_count_precharge_walk);
 	}
-	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
 	mc.precharge = 0;
@@ -4694,11 +4694,16 @@ static void mem_cgroup_clear_mc(void)
 
 		mc.moved_swap = 0;
 	}
+	if (mc.mm) {
+		up_read(&mc.mm->mmap_sem);
+		mmput(mc.mm);
+	}
 	spin_lock(&mc.lock);
 	mc.from = NULL;
 	mc.to = NULL;
-	mc.moving_task = NULL;
 	spin_unlock(&mc.lock);
+	mc.moving_task = NULL;
+	mc.mm = NULL;
 	mem_cgroup_end_move(from);
 	memcg_oom_recover(from);
 	memcg_oom_recover(to);
@@ -4724,12 +4729,21 @@ static int mem_cgroup_can_attach(struct 
 			return 0;
 		/* We move charges only when we move a owner of the mm */
 		if (mm->owner == p) {
+			/*
+			 * We do all the move charge works under one mmap_sem to
+			 * avoid deadlock with down_write(&mmap_sem)
+			 * -> try_charge() -> if (mc.moving_task) -> sleep.
+			 */
+			down_read(&mm->mmap_sem);
+
 			VM_BUG_ON(mc.from);
 			VM_BUG_ON(mc.to);
 			VM_BUG_ON(mc.precharge);
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
 			VM_BUG_ON(mc.moving_task);
+			VM_BUG_ON(mc.mm);
+
 			mem_cgroup_start_move(from);
 			spin_lock(&mc.lock);
 			mc.from = from;
@@ -4737,14 +4751,16 @@ static int mem_cgroup_can_attach(struct 
 			mc.precharge = 0;
 			mc.moved_charge = 0;
 			mc.moved_swap = 0;
-			mc.moving_task = current;
 			spin_unlock(&mc.lock);
+			mc.moving_task = current;
+			mc.mm = mm;
 
 			ret = mem_cgroup_precharge_mc(mm);
 			if (ret)
 				mem_cgroup_clear_mc();
-		}
-		mmput(mm);
+			/* We call up_read() and mmput() in clear_mc(). */
+		} else
+			mmput(mm);
 	}
 	return ret;
 }
@@ -4832,7 +4848,7 @@ static void mem_cgroup_move_charge(struc
 	struct vm_area_struct *vma;
 
 	lru_add_drain_all();
-	down_read(&mm->mmap_sem);
+	/* We've already held the mmap_sem */
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		int ret;
 		struct mm_walk mem_cgroup_move_charge_walk = {
@@ -4851,7 +4867,6 @@ static void mem_cgroup_move_charge(struc
 			 */
 			break;
 	}
-	up_read(&mm->mmap_sem);
 }
 
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
@@ -4860,17 +4875,11 @@ static void mem_cgroup_move_task(struct 
 				struct task_struct *p,
 				bool threadgroup)
 {
-	struct mm_struct *mm;
-
-	if (!mc.to)
+	if (!mc.mm)
 		/* no need to move charge */
 		return;
 
-	mm = get_task_mm(p);
-	if (mm) {
-		mem_cgroup_move_charge(mm);
-		mmput(mm);
-	}
+	mem_cgroup_move_charge(mc.mm);
 	mem_cgroup_clear_mc();
 }
 #else	/* !CONFIG_MMU */
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-avoid-deadlock-between-move-charge-and-try_charge.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch


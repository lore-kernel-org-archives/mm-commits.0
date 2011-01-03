From: akpm@linux-foundation.org
Subject: + memcg-fix-deadlock-between-cpuset-and-memcg.patch added to -mm tree
Date: Mon, 03 Jan 2011 13:31:29 -0800
Message-ID: <201101032131.p03LVTp8029638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919Ab1ACVcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 16:32:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, bblum@andrew.cmu.edu, kamezawa.hiroyuki@gmail.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     memcg: fix deadlock between cpuset and memcg
has been added to the -mm tree.  Its filename is
     memcg-fix-deadlock-between-cpuset-and-memcg.patch

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
Subject: memcg: fix deadlock between cpuset and memcg
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Commit b1dd693e ("memcg: avoid deadlock between move charge and
try_charge()") can cause another deadlock about mmap_sem on task migration
if cpuset and memcg are mounted onto the same mount point.

After the commit, cgroup_attach_task() has sequence like:

cgroup_attach_task()
  ss->can_attach()
    cpuset_can_attach()
    mem_cgroup_can_attach()
      down_read(&mmap_sem)        (1)
  ss->attach()
    cpuset_attach()
      mpol_rebind_mm()
        down_write(&mmap_sem)     (2)
        up_write(&mmap_sem)
      cpuset_migrate_mm()
        do_migrate_pages()
          down_read(&mmap_sem)
          up_read(&mmap_sem)
    mem_cgroup_move_task()
      mem_cgroup_clear_mc()
        up_read(&mmap_sem)

We can cause deadlock at (2) because we've already aquire the mmap_sem at (1).

But the commit itself is necessary to fix deadlocks which have existed
before the commit like:

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
                                        |      -> move charge should wake it up

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
                                        |      -> move charge should wake it up

This patch fixes all of these problems by:
1. revert the commit.
2. To fix the Ex.1, we set mc.moving_task after mem_cgroup_count_precharge()
   has released the mmap_sem.
3. To fix the Ex.2, we use down_read_trylock() instead of down_read() in
   mem_cgroup_move_charge() and, if it has failed to aquire the lock, cancel
   all extra charges, wake up all waiters, and retry trylock.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   78 +++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-deadlock-between-cpuset-and-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-deadlock-between-cpuset-and-memcg
+++ a/mm/memcontrol.c
@@ -292,7 +292,6 @@ static struct move_charge_struct {
 	unsigned long moved_charge;
 	unsigned long moved_swap;
 	struct task_struct *moving_task;	/* a task moving charges */
-	struct mm_struct *mm;
 	wait_queue_head_t waitq;		/* a waitq for other context */
 } mc = {
 	.lock = __SPIN_LOCK_UNLOCKED(mc.lock),
@@ -4681,7 +4680,7 @@ static unsigned long mem_cgroup_count_pr
 	unsigned long precharge;
 	struct vm_area_struct *vma;
 
-	/* We've already held the mmap_sem */
+	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		struct mm_walk mem_cgroup_count_precharge_walk = {
 			.pmd_entry = mem_cgroup_count_precharge_pte_range,
@@ -4693,6 +4692,7 @@ static unsigned long mem_cgroup_count_pr
 		walk_page_range(vma->vm_start, vma->vm_end,
 					&mem_cgroup_count_precharge_walk);
 	}
+	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
 	mc.precharge = 0;
@@ -4702,10 +4702,15 @@ static unsigned long mem_cgroup_count_pr
 
 static int mem_cgroup_precharge_mc(struct mm_struct *mm)
 {
-	return mem_cgroup_do_precharge(mem_cgroup_count_precharge(mm));
+	unsigned long precharge = mem_cgroup_count_precharge(mm);
+
+	VM_BUG_ON(mc.moving_task);
+	mc.moving_task = current;
+	return mem_cgroup_do_precharge(precharge);
 }
 
-static void mem_cgroup_clear_mc(void)
+/* cancels all extra charges on mc.from and mc.to, and wakes up all waiters. */
+static void __mem_cgroup_clear_mc(void)
 {
 	struct mem_cgroup *from = mc.from;
 	struct mem_cgroup *to = mc.to;
@@ -4740,23 +4745,24 @@ static void mem_cgroup_clear_mc(void)
 						PAGE_SIZE * mc.moved_swap);
 		}
 		/* we've already done mem_cgroup_get(mc.to) */
-
 		mc.moved_swap = 0;
 	}
-	if (mc.mm) {
-		up_read(&mc.mm->mmap_sem);
-		mmput(mc.mm);
-	}
+	memcg_oom_recover(from);
+	memcg_oom_recover(to);
+	wake_up_all(&mc.waitq);
+}
+
+static void mem_cgroup_clear_mc(void)
+{
+	struct mem_cgroup *from = mc.from;
+
+	__mem_cgroup_clear_mc();
 	spin_lock(&mc.lock);
 	mc.from = NULL;
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
 	mc.moving_task = NULL;
-	mc.mm = NULL;
 	mem_cgroup_end_move(from);
-	memcg_oom_recover(from);
-	memcg_oom_recover(to);
-	wake_up_all(&mc.waitq);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
@@ -4778,38 +4784,23 @@ static int mem_cgroup_can_attach(struct 
 			return 0;
 		/* We move charges only when we move a owner of the mm */
 		if (mm->owner == p) {
-			/*
-			 * We do all the move charge works under one mmap_sem to
-			 * avoid deadlock with down_write(&mmap_sem)
-			 * -> try_charge() -> if (mc.moving_task) -> sleep.
-			 */
-			down_read(&mm->mmap_sem);
-
 			VM_BUG_ON(mc.from);
 			VM_BUG_ON(mc.to);
 			VM_BUG_ON(mc.precharge);
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
-			VM_BUG_ON(mc.moving_task);
-			VM_BUG_ON(mc.mm);
-
 			mem_cgroup_start_move(from);
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = mem;
-			mc.precharge = 0;
-			mc.moved_charge = 0;
-			mc.moved_swap = 0;
 			spin_unlock(&mc.lock);
-			mc.moving_task = current;
-			mc.mm = mm;
+			/* We set mc.moving_task later */
 
 			ret = mem_cgroup_precharge_mc(mm);
 			if (ret)
 				mem_cgroup_clear_mc();
-			/* We call up_read() and mmput() in clear_mc(). */
-		} else
-			mmput(mm);
+		}
+		mmput(mm);
 	}
 	return ret;
 }
@@ -4898,7 +4889,19 @@ static void mem_cgroup_move_charge(struc
 	struct vm_area_struct *vma;
 
 	lru_add_drain_all();
-	/* We've already held the mmap_sem */
+retry:
+	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
+		/*
+		 * Someone who are holding the mmap_sem might be waiting in
+		 * waitq. So we cancel all extra charges, wake up all waiters,
+		 * and retry. Because we cancel precharges, we might not be able
+		 * to move enough charges, but moving charge is a best-effort
+		 * feature anyway, so it wouldn't be a big problem.
+		 */
+		__mem_cgroup_clear_mc();
+		cond_resched();
+		goto retry;
+	}
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		int ret;
 		struct mm_walk mem_cgroup_move_charge_walk = {
@@ -4917,6 +4920,7 @@ static void mem_cgroup_move_charge(struc
 			 */
 			break;
 	}
+	up_read(&mm->mmap_sem);
 }
 
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
@@ -4925,11 +4929,17 @@ static void mem_cgroup_move_task(struct 
 				struct task_struct *p,
 				bool threadgroup)
 {
-	if (!mc.mm)
+	struct mm_struct *mm;
+
+	if (!mc.to)
 		/* no need to move charge */
 		return;
 
-	mem_cgroup_move_charge(mc.mm);
+	mm = get_task_mm(p);
+	if (mm) {
+		mem_cgroup_move_charge(mm);
+		mmput(mm);
+	}
 	mem_cgroup_clear_mc();
 }
 #else	/* !CONFIG_MMU */
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-compound_trans_order-fix.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
memcg-fix-deadlock-between-cpuset-and-memcg.patch


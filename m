From: akpm@linux-foundation.org
Subject: [merged] memcg-move-charges-of-anonymous-page.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:44 -0400
Message-ID: <201003150659.o2F6xHmO016531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COG7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: move charges of anonymous page
has been removed from the -mm tree.  Its filename was
     memcg-move-charges-of-anonymous-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: move charges of anonymous page
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

This patch is the core part of this move-charge-at-task-migration feature.
 It implements functions to move charges of anonymous pages mapped only by
the target task.

Implementation:
- define struct move_charge_struct and a valuable of it(mc) to remember the
  count of pre-charges and other information.
- At can_attach(), get anon_rss of the target mm, call __mem_cgroup_try_charge()
  repeatedly and count up mc.precharge.
- At attach(), parse the page table, find a target page to be move, and call
  mem_cgroup_move_account() about the page.
- Cancel all precharges if mc.precharge > 0 on failure or at the end of
  task move.

[akpm@linux-foundation.org: a little simplification]
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  292 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 283 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-move-charges-of-anonymous-page mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-charges-of-anonymous-page
+++ a/mm/memcontrol.c
@@ -21,6 +21,7 @@
 #include <linux/memcontrol.h>
 #include <linux/cgroup.h>
 #include <linux/mm.h>
+#include <linux/hugetlb.h>
 #include <linux/pagemap.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
@@ -243,9 +244,17 @@ struct mem_cgroup {
  * left-shifted bitmap of these types.
  */
 enum move_type {
+	MOVE_CHARGE_TYPE_ANON,	/* private anonymous page and swap of it */
 	NR_MOVE_TYPE,
 };
 
+/* "mc" and its members are protected by cgroup_mutex */
+static struct move_charge_struct {
+	struct mem_cgroup *from;
+	struct mem_cgroup *to;
+	unsigned long precharge;
+} mc;
+
 /*
  * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
@@ -1513,7 +1522,7 @@ charged:
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
 	 * if they exceeds softlimit.
 	 */
-	if (mem_cgroup_soft_limit_check(mem))
+	if (page && mem_cgroup_soft_limit_check(mem))
 		mem_cgroup_update_tree(mem, page);
 done:
 	return 0;
@@ -1690,8 +1699,9 @@ static void __mem_cgroup_move_account(st
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
-	 * this function is just force_empty() and it's garanteed that
-	 * "to" is never removed. So, we don't check rmdir status here.
+	 * this function is just force_empty() and move charge, so it's
+	 * garanteed that "to" is never removed. So, we don't check rmdir
+	 * status here.
 	 */
 }
 
@@ -3428,11 +3438,171 @@ static int mem_cgroup_populate(struct cg
 }
 
 /* Handlers for move charge at task migration. */
-static int mem_cgroup_can_move_charge(void)
+static int mem_cgroup_do_precharge(void)
 {
+	int ret = -ENOMEM;
+	struct mem_cgroup *mem = mc.to;
+
+	ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false, NULL);
+	if (ret || !mem)
+		return -ENOMEM;
+
+	mc.precharge++;
+	return ret;
+}
+
+/**
+ * is_target_pte_for_mc - check a pte whether it is valid for move charge
+ * @vma: the vma the pte to be checked belongs
+ * @addr: the address corresponding to the pte to be checked
+ * @ptent: the pte to be checked
+ * @target: the pointer the target page will be stored(can be NULL)
+ *
+ * Returns
+ *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
+ *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
+ *     move charge. if @target is not NULL, the page is stored in target->page
+ *     with extra refcnt got(Callers should handle it).
+ *
+ * Called with pte lock held.
+ */
+/* We add a new member later. */
+union mc_target {
+	struct page	*page;
+};
+
+/* We add a new type later. */
+enum mc_target_type {
+	MC_TARGET_NONE,	/* not used */
+	MC_TARGET_PAGE,
+};
+
+static int is_target_pte_for_mc(struct vm_area_struct *vma,
+		unsigned long addr, pte_t ptent, union mc_target *target)
+{
+	struct page *page;
+	struct page_cgroup *pc;
+	int ret = 0;
+	bool move_anon = test_bit(MOVE_CHARGE_TYPE_ANON,
+					&mc.to->move_charge_at_immigrate);
+
+	if (!pte_present(ptent))
+		return 0;
+
+	page = vm_normal_page(vma, addr, ptent);
+	if (!page || !page_mapped(page))
+		return 0;
+	/*
+	 * TODO: We don't move charges of file(including shmem/tmpfs) pages for
+	 * now.
+	 */
+	if (!move_anon || !PageAnon(page))
+		return 0;
+	/*
+	 * TODO: We don't move charges of shared(used by multiple processes)
+	 * pages for now.
+	 */
+	if (page_mapcount(page) > 1)
+		return 0;
+	if (!get_page_unless_zero(page))
+		return 0;
+
+	pc = lookup_page_cgroup(page);
+	/*
+	 * Do only loose check w/o page_cgroup lock. mem_cgroup_move_account()
+	 * checks the pc is valid or not under the lock.
+	 */
+	if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
+		ret = MC_TARGET_PAGE;
+		if (target)
+			target->page = page;
+	}
+
+	if (!ret || !target)
+		put_page(page);
+
+	return ret;
+}
+
+static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
+					unsigned long addr, unsigned long end,
+					struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->private;
+	pte_t *pte;
+	spinlock_t *ptl;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE)
+		if (is_target_pte_for_mc(vma, addr, *pte, NULL))
+			mc.precharge++;	/* increment precharge temporarily */
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+
 	return 0;
 }
 
+static unsigned long mem_cgroup_count_precharge(struct mm_struct *mm)
+{
+	unsigned long precharge;
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		struct mm_walk mem_cgroup_count_precharge_walk = {
+			.pmd_entry = mem_cgroup_count_precharge_pte_range,
+			.mm = mm,
+			.private = vma,
+		};
+		if (is_vm_hugetlb_page(vma))
+			continue;
+		/* TODO: We don't move charges of shmem/tmpfs pages for now. */
+		if (vma->vm_flags & VM_SHARED)
+			continue;
+		walk_page_range(vma->vm_start, vma->vm_end,
+					&mem_cgroup_count_precharge_walk);
+	}
+	up_read(&mm->mmap_sem);
+
+	precharge = mc.precharge;
+	mc.precharge = 0;
+
+	return precharge;
+}
+
+#define PRECHARGE_AT_ONCE	256
+static int mem_cgroup_precharge_mc(struct mm_struct *mm)
+{
+	int ret = 0;
+	int count = PRECHARGE_AT_ONCE;
+	unsigned long precharge = mem_cgroup_count_precharge(mm);
+
+	while (!ret && precharge--) {
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+		if (!count--) {
+			count = PRECHARGE_AT_ONCE;
+			cond_resched();
+		}
+		ret = mem_cgroup_do_precharge();
+	}
+
+	return ret;
+}
+
+static void mem_cgroup_clear_mc(void)
+{
+	/* we must uncharge all the leftover precharges from mc.to */
+	while (mc.precharge) {
+		mem_cgroup_cancel_charge(mc.to);
+		mc.precharge--;
+	}
+	mc.from = NULL;
+	mc.to = NULL;
+}
+
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 				struct cgroup *cgroup,
 				struct task_struct *p,
@@ -3450,11 +3620,19 @@ static int mem_cgroup_can_attach(struct 
 		mm = get_task_mm(p);
 		if (!mm)
 			return 0;
-
 		/* We move charges only when we move a owner of the mm */
-		if (mm->owner == p)
-			ret = mem_cgroup_can_move_charge();
+		if (mm->owner == p) {
+			VM_BUG_ON(mc.from);
+			VM_BUG_ON(mc.to);
+			VM_BUG_ON(mc.precharge);
+			mc.from = from;
+			mc.to = mem;
+			mc.precharge = 0;
 
+			ret = mem_cgroup_precharge_mc(mm);
+			if (ret)
+				mem_cgroup_clear_mc();
+		}
 		mmput(mm);
 	}
 	return ret;
@@ -3465,10 +3643,95 @@ static void mem_cgroup_cancel_attach(str
 				struct task_struct *p,
 				bool threadgroup)
 {
+	mem_cgroup_clear_mc();
+}
+
+static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
+				unsigned long addr, unsigned long end,
+				struct mm_walk *walk)
+{
+	int ret = 0;
+	struct vm_area_struct *vma = walk->private;
+	pte_t *pte;
+	spinlock_t *ptl;
+
+retry:
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; addr += PAGE_SIZE) {
+		pte_t ptent = *(pte++);
+		union mc_target target;
+		int type;
+		struct page *page;
+		struct page_cgroup *pc;
+
+		if (!mc.precharge)
+			break;
+
+		type = is_target_pte_for_mc(vma, addr, ptent, &target);
+		switch (type) {
+		case MC_TARGET_PAGE:
+			page = target.page;
+			if (isolate_lru_page(page))
+				goto put;
+			pc = lookup_page_cgroup(page);
+			if (!mem_cgroup_move_account(pc, mc.from, mc.to)) {
+				css_put(&mc.to->css);
+				mc.precharge--;
+			}
+			putback_lru_page(page);
+put:			/* is_target_pte_for_mc() gets the page */
+			put_page(page);
+			break;
+		default:
+			break;
+		}
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+
+	if (addr != end) {
+		/*
+		 * We have consumed all precharges we got in can_attach().
+		 * We try charge one by one, but don't do any additional
+		 * charges to mc.to if we have failed in charge once in attach()
+		 * phase.
+		 */
+		ret = mem_cgroup_do_precharge();
+		if (!ret)
+			goto retry;
+	}
+
+	return ret;
 }
 
-static void mem_cgroup_move_charge(void)
+static void mem_cgroup_move_charge(struct mm_struct *mm)
 {
+	struct vm_area_struct *vma;
+
+	lru_add_drain_all();
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		int ret;
+		struct mm_walk mem_cgroup_move_charge_walk = {
+			.pmd_entry = mem_cgroup_move_charge_pte_range,
+			.mm = mm,
+			.private = vma,
+		};
+		if (is_vm_hugetlb_page(vma))
+			continue;
+		/* TODO: We don't move charges of shmem/tmpfs pages for now. */
+		if (vma->vm_flags & VM_SHARED)
+			continue;
+		ret = walk_page_range(vma->vm_start, vma->vm_end,
+						&mem_cgroup_move_charge_walk);
+		if (ret)
+			/*
+			 * means we have consumed all precharges and failed in
+			 * doing additional charge. Just abandon here.
+			 */
+			break;
+	}
+	up_read(&mm->mmap_sem);
 }
 
 static void mem_cgroup_move_task(struct cgroup_subsys *ss,
@@ -3477,7 +3740,18 @@ static void mem_cgroup_move_task(struct 
 				struct task_struct *p,
 				bool threadgroup)
 {
-	mem_cgroup_move_charge();
+	struct mm_struct *mm;
+
+	if (!mc.to)
+		/* no need to move charge */
+		return;
+
+	mm = get_task_mm(p);
+	if (mm) {
+		mem_cgroup_move_charge(mm);
+		mmput(mm);
+	}
+	mem_cgroup_clear_mc();
 }
 
 struct cgroup_subsys mem_cgroup_subsys = {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch


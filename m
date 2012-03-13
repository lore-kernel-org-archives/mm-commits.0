From: akpm@linux-foundation.org
Subject: + memcg-avoid-thp-split-in-task-migration.patch added to -mm tree
Date: Tue, 13 Mar 2012 15:31:45 -0700
Message-ID: <20120313223145.35203A1A06@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:40636 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759709Ab2CMWbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 18:31:51 -0400
Received: by ggnd2 with SMTP id d2so203884ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 15:31:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     Subject: memcg: avoid THP split in task migration
has been added to the -mm tree.  Its filename is
     memcg-avoid-thp-split-in-task-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: memcg: avoid THP split in task migration

Currently we can't do task migration among memory cgroups without THP
split, which means processes heavily using THP experience large overhead
in task migration.  This patch introduces the code for moving charge of
THP and makes THP more valuable.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   85 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 79 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-thp-split-in-task-migration mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-thp-split-in-task-migration
+++ a/mm/memcontrol.c
@@ -5256,6 +5256,41 @@ static enum mc_target_type get_mctgt_typ
 	return ret;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/*
+ * We don't consider swapping or file mapped pages because THP does not
+ * support them for now.
+ * Caller should make sure that pmd_trans_huge(pmd) is true.
+ */
+static enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t pmd, union mc_target *target)
+{
+	struct page *page = NULL;
+	struct page_cgroup *pc;
+	enum mc_target_type ret = MC_TARGET_NONE;
+
+	page = pmd_page(pmd);
+	VM_BUG_ON(!page || !PageHead(page));
+	if (!move_anon())
+		return ret;
+	pc = lookup_page_cgroup(page);
+	if (PageCgroupUsed(pc) && pc->mem_cgroup == mc.from) {
+		ret = MC_TARGET_PAGE;
+		if (target) {
+			get_page(page);
+			target->page = page;
+		}
+	}
+	return ret;
+}
+#else
+static inline enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t pmd, union mc_target *target)
+{
+	return MC_TARGET_NONE;
+}
+#endif
+
 static int mem_cgroup_count_precharge_pte_range(pmd_t *pmd,
 					unsigned long addr, unsigned long end,
 					struct mm_walk *walk)
@@ -5264,7 +5299,12 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	split_huge_page_pmd(walk->mm, pmd);
+	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
+			mc.precharge += HPAGE_PMD_NR;
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		return 0;
+	}
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
@@ -5423,16 +5463,49 @@ static int mem_cgroup_move_charge_pte_ra
 	struct vm_area_struct *vma = walk->private;
 	pte_t *pte;
 	spinlock_t *ptl;
+	enum mc_target_type target_type;
+	union mc_target target;
+	struct page *page;
+	struct page_cgroup *pc;
+
+	/*
+	 * We don't take compound_lock() here but no race with splitting thp
+	 * happens because:
+	 *  - if pmd_trans_huge_lock() returns 1, the relevant thp is not
+	 *    under splitting, which means there's no concurrent thp split,
+	 *  - if another thread runs into split_huge_page() just after we
+	 *    entered this if-block, the thread must wait for page table lock
+	 *    to be unlocked in __split_huge_page_splitting(), where the main
+	 *    part of thp split is not executed yet.
+	 */
+	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+		if (!mc.precharge) {
+			spin_unlock(&vma->vm_mm->page_table_lock);
+			return 0;
+		}
+		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
+		if (target_type == MC_TARGET_PAGE) {
+			page = target.page;
+			if (!isolate_lru_page(page)) {
+				pc = lookup_page_cgroup(page);
+				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
+							     pc, mc.from, mc.to,
+							     false)) {
+					mc.precharge -= HPAGE_PMD_NR;
+					mc.moved_charge += HPAGE_PMD_NR;
+				}
+				putback_lru_page(page);
+			}
+			put_page(page);
+		}
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		return 0;
+	}
 
-	split_huge_page_pmd(walk->mm, pmd);
 retry:
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
-		union mc_target target;
-		int type;
-		struct page *page;
-		struct page_cgroup *pc;
 		swp_entry_t ent;
 
 		if (!mc.precharge)
_
Subject: Subject: memcg: avoid THP split in task migration

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
memcg-clean-up-existing-move-charge-code.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch
memcg-avoid-thp-split-in-task-migration.patch


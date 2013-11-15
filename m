From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:07:25 -0800
Message-ID: <52867efd.HBWrgDebVBIHVBxZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3KOUH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:25 -0800


The patch titled
     Subject: mm, thp: change pmd_trans_huge_lock() to return taken lock
has been removed from the -mm tree.  Its filename was
     mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: change pmd_trans_huge_lock() to return taken lock

With split ptlock it's important to know which lock pmd_trans_huge_lock()
took.  This patch adds one more parameter to the function to return the
lock.

In most places migration to new api is trivial.  Exception is
move_huge_pmd(): we need to take two locks if pmd tables are different.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   13 ++++++------
 include/linux/huge_mm.h |   14 ++++++-------
 mm/huge_memory.c        |   40 +++++++++++++++++++++++++-------------
 mm/memcontrol.c         |   10 ++++-----
 4 files changed, 46 insertions(+), 31 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock
+++ a/fs/proc/task_mmu.c
@@ -506,9 +506,9 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
-		spin_unlock(&walk->mm->page_table_lock);
+		spin_unlock(ptl);
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
 		return 0;
 	}
@@ -999,13 +999,14 @@ static int pagemap_pte_range(pmd_t *pmd,
 {
 	struct vm_area_struct *vma;
 	struct pagemapread *pm = walk->private;
+	spinlock_t *ptl;
 	pte_t *pte;
 	int err = 0;
 	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
-	if (vma && pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (vma && pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		int pmd_flags2;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
@@ -1023,7 +1024,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 			if (err)
 				break;
 		}
-		spin_unlock(&walk->mm->page_table_lock);
+		spin_unlock(ptl);
 		return err;
 	}
 
@@ -1325,7 +1326,7 @@ static int gather_pte_stats(pmd_t *pmd,
 
 	md = walk->private;
 
-	if (pmd_trans_huge_lock(pmd, md->vma) == 1) {
+	if (pmd_trans_huge_lock(pmd, md->vma, &ptl) == 1) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
@@ -1333,7 +1334,7 @@ static int gather_pte_stats(pmd_t *pmd,
 		if (page)
 			gather_stats(page, md, pte_dirty(huge_pte),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
-		spin_unlock(&walk->mm->page_table_lock);
+		spin_unlock(ptl);
 		return 0;
 	}
 
diff -puN include/linux/huge_mm.h~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock
+++ a/include/linux/huge_mm.h
@@ -129,15 +129,15 @@ extern void __vma_adjust_trans_huge(stru
 				    unsigned long start,
 				    unsigned long end,
 				    long adjust_next);
-extern int __pmd_trans_huge_lock(pmd_t *pmd,
-				 struct vm_area_struct *vma);
+extern int __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+		spinlock_t **ptl);
 /* mmap_sem must be held on entry */
-static inline int pmd_trans_huge_lock(pmd_t *pmd,
-				      struct vm_area_struct *vma)
+static inline int pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+		spinlock_t **ptl)
 {
 	VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
 	if (pmd_trans_huge(*pmd))
-		return __pmd_trans_huge_lock(pmd, vma);
+		return __pmd_trans_huge_lock(pmd, vma, ptl);
 	else
 		return 0;
 }
@@ -215,8 +215,8 @@ static inline void vma_adjust_trans_huge
 					 long adjust_next)
 {
 }
-static inline int pmd_trans_huge_lock(pmd_t *pmd,
-				      struct vm_area_struct *vma)
+static inline int pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+		spinlock_t **ptl)
 {
 	return 0;
 }
diff -puN mm/huge_memory.c~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock
+++ a/mm/huge_memory.c
@@ -1376,9 +1376,10 @@ out:
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
+	spinlock_t *ptl;
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
 		pmd_t orig_pmd;
@@ -1393,7 +1394,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			atomic_long_dec(&tlb->mm->nr_ptes);
-			spin_unlock(&tlb->mm->page_table_lock);
+			spin_unlock(ptl);
 			put_huge_zero_page();
 		} else {
 			page = pmd_page(orig_pmd);
@@ -1402,7 +1403,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 			VM_BUG_ON(!PageHead(page));
 			atomic_long_dec(&tlb->mm->nr_ptes);
-			spin_unlock(&tlb->mm->page_table_lock);
+			spin_unlock(ptl);
 			tlb_remove_page(tlb, page);
 		}
 		pte_free(tlb->mm, pgtable);
@@ -1415,14 +1416,15 @@ int mincore_huge_pmd(struct vm_area_stru
 		unsigned long addr, unsigned long end,
 		unsigned char *vec)
 {
+	spinlock_t *ptl;
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		/*
 		 * All logical pages in the range are present
 		 * if backed by a huge page.
 		 */
-		spin_unlock(&vma->vm_mm->page_table_lock);
+		spin_unlock(ptl);
 		memset(vec, 1, (end - addr) >> PAGE_SHIFT);
 		ret = 1;
 	}
@@ -1435,6 +1437,7 @@ int move_huge_pmd(struct vm_area_struct
 		  unsigned long new_addr, unsigned long old_end,
 		  pmd_t *old_pmd, pmd_t *new_pmd)
 {
+	spinlock_t *old_ptl, *new_ptl;
 	int ret = 0;
 	pmd_t pmd;
 
@@ -1455,12 +1458,21 @@ int move_huge_pmd(struct vm_area_struct
 		goto out;
 	}
 
-	ret = __pmd_trans_huge_lock(old_pmd, vma);
+	/*
+	 * We don't have to worry about the ordering of src and dst
+	 * ptlocks because exclusive mmap_sem prevents deadlock.
+	 */
+	ret = __pmd_trans_huge_lock(old_pmd, vma, &old_ptl);
 	if (ret == 1) {
+		new_ptl = pmd_lockptr(mm, new_pmd);
+		if (new_ptl != old_ptl)
+			spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
 		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
-		spin_unlock(&mm->page_table_lock);
+		if (new_ptl != old_ptl)
+			spin_unlock(new_ptl);
+		spin_unlock(old_ptl);
 	}
 out:
 	return ret;
@@ -1476,9 +1488,10 @@ int change_huge_pmd(struct vm_area_struc
 		unsigned long addr, pgprot_t newprot, int prot_numa)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pmd_t entry;
 		ret = 1;
 		if (!prot_numa) {
@@ -1507,7 +1520,7 @@ int change_huge_pmd(struct vm_area_struc
 		if (ret == HPAGE_PMD_NR)
 			set_pmd_at(mm, addr, pmd, entry);
 
-		spin_unlock(&vma->vm_mm->page_table_lock);
+		spin_unlock(ptl);
 	}
 
 	return ret;
@@ -1520,12 +1533,13 @@ int change_huge_pmd(struct vm_area_struc
  * Note that if it returns 1, this routine returns without unlocking page
  * table locks. So callers must unlock them.
  */
-int __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
+int __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+		spinlock_t **ptl)
 {
-	spin_lock(&vma->vm_mm->page_table_lock);
+	*ptl = pmd_lock(vma->vm_mm, pmd);
 	if (likely(pmd_trans_huge(*pmd))) {
 		if (unlikely(pmd_trans_splitting(*pmd))) {
-			spin_unlock(&vma->vm_mm->page_table_lock);
+			spin_unlock(*ptl);
 			wait_split_huge_page(vma->anon_vma, pmd);
 			return -1;
 		} else {
@@ -1534,7 +1548,7 @@ int __pmd_trans_huge_lock(pmd_t *pmd, st
 			return 1;
 		}
 	}
-	spin_unlock(&vma->vm_mm->page_table_lock);
+	spin_unlock(*ptl);
 	return 0;
 }
 
diff -puN mm/memcontrol.c~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock mm/memcontrol.c
--- a/mm/memcontrol.c~mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock
+++ a/mm/memcontrol.c
@@ -6605,10 +6605,10 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
 			mc.precharge += HPAGE_PMD_NR;
-		spin_unlock(&vma->vm_mm->page_table_lock);
+		spin_unlock(ptl);
 		return 0;
 	}
 
@@ -6797,9 +6797,9 @@ static int mem_cgroup_move_charge_pte_ra
 	 *    to be unlocked in __split_huge_page_splitting(), where the main
 	 *    part of thp split is not executed yet.
 	 */
-	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		if (mc.precharge < HPAGE_PMD_NR) {
-			spin_unlock(&vma->vm_mm->page_table_lock);
+			spin_unlock(ptl);
 			return 0;
 		}
 		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
@@ -6816,7 +6816,7 @@ static int mem_cgroup_move_charge_pte_ra
 			}
 			put_page(page);
 		}
-		spin_unlock(&vma->vm_mm->page_table_lock);
+		spin_unlock(ptl);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch


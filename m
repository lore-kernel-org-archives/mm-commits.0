From: akpm@linux-foundation.org
Subject: + thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
 added to -mm tree
Date: Tue, 19 Jan 2016 14:17:46 -0800
Message-ID: <569eb60a.ZkWKegqgjQq2WUuO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbcASWRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 17:17:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: change pmd_trans_huge_lock() interface to return ptl
has been added to the -mm tree.  Its filename is
     thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: change pmd_trans_huge_lock() interface to return ptl

After THP refcounting rework we have only two possible return values from
pmd_trans_huge_lock(): success and failure.  Return-by-pointer for ptl
doesn't make much sense in this case.

Let's convert pmd_trans_huge_lock() to return ptl on success and NULL on
failure.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   12 ++++++++----
 include/linux/huge_mm.h |   16 ++++++++--------
 mm/huge_memory.c        |   24 ++++++++++++++----------
 mm/memcontrol.c         |    6 ++++--
 mm/mincore.c            |    3 ++-
 5 files changed, 36 insertions(+), 25 deletions(-)

diff -puN fs/proc/task_mmu.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl
+++ a/fs/proc/task_mmu.c
@@ -602,7 +602,8 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
 		smaps_pmd_entry(pmd, addr, walk);
 		spin_unlock(ptl);
 		return 0;
@@ -913,7 +914,8 @@ static int clear_refs_pte_range(pmd_t *p
 	spinlock_t *ptl;
 	struct page *page;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
 		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
 			clear_soft_dirty_pmd(vma, addr, pmd);
 			goto out;
@@ -1187,7 +1189,8 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	int err = 0;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge_lock(pmdp, vma, &ptl)) {
+	ptl = pmd_trans_huge_lock(pmdp, vma);
+	if (ptl) {
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 
@@ -1519,7 +1522,8 @@ static int gather_pte_stats(pmd_t *pmd, 
 	pte_t *orig_pte;
 	pte_t *pte;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
diff -puN include/linux/huge_mm.h~thp-change-pmd_trans_huge_lock-interface-to-return-ptl include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-change-pmd_trans_huge_lock-interface-to-return-ptl
+++ a/include/linux/huge_mm.h
@@ -120,15 +120,15 @@ extern void vma_adjust_trans_huge(struct
 				    unsigned long start,
 				    unsigned long end,
 				    long adjust_next);
-extern bool __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
-		spinlock_t **ptl);
+extern spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd,
+		struct vm_area_struct *vma);
 /* mmap_sem must be held on entry */
-static inline bool pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
-		spinlock_t **ptl)
+static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
+		struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_mm->mmap_sem), vma);
 	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))
-		return __pmd_trans_huge_lock(pmd, vma, ptl);
+		return __pmd_trans_huge_lock(pmd, vma);
 	else
 		return false;
 }
@@ -190,10 +190,10 @@ static inline void vma_adjust_trans_huge
 					 long adjust_next)
 {
 }
-static inline bool pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
-		spinlock_t **ptl)
+static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
+		struct vm_area_struct *vma)
 {
-	return false;
+	return NULL;
 }
 
 static inline int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
diff -puN mm/huge_memory.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl mm/huge_memory.c
--- a/mm/huge_memory.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl
+++ a/mm/huge_memory.c
@@ -1560,7 +1560,8 @@ int madvise_free_huge_pmd(struct mmu_gat
 	struct mm_struct *mm = tlb->mm;
 	int ret = 0;
 
-	if (!pmd_trans_huge_lock(pmd, vma, &ptl))
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (!ptl)
 		goto out_unlocked;
 
 	orig_pmd = *pmd;
@@ -1627,7 +1628,8 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	pmd_t orig_pmd;
 	spinlock_t *ptl;
 
-	if (!__pmd_trans_huge_lock(pmd, vma, &ptl))
+	ptl = __pmd_trans_huge_lock(pmd, vma);
+	if (!ptl)
 		return 0;
 	/*
 	 * For architectures like ppc64 we look at deposited pgtable
@@ -1690,7 +1692,8 @@ bool move_huge_pmd(struct vm_area_struct
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_sem prevents deadlock.
 	 */
-	if (__pmd_trans_huge_lock(old_pmd, vma, &old_ptl)) {
+	old_ptl = __pmd_trans_huge_lock(old_pmd, vma);
+	if (old_ptl) {
 		new_ptl = pmd_lockptr(mm, new_pmd);
 		if (new_ptl != old_ptl)
 			spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
@@ -1724,7 +1727,8 @@ int change_huge_pmd(struct vm_area_struc
 	spinlock_t *ptl;
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma, &ptl)) {
+	ptl = __pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
 		pmd_t entry;
 		bool preserve_write = prot_numa && pmd_write(*pmd);
 		ret = 1;
@@ -1760,14 +1764,14 @@ int change_huge_pmd(struct vm_area_struc
  * Note that if it returns true, this routine returns without unlocking page
  * table lock. So callers must unlock it.
  */
-bool __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
-		spinlock_t **ptl)
+spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
 {
-	*ptl = pmd_lock(vma->vm_mm, pmd);
+	spinlock_t *ptl;
+	ptl = pmd_lock(vma->vm_mm, pmd);
 	if (likely(pmd_trans_huge(*pmd) || pmd_devmap(*pmd)))
-		return true;
-	spin_unlock(*ptl);
-	return false;
+		return ptl;
+	spin_unlock(ptl);
+	return NULL;
 }
 
 #define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
diff -puN mm/memcontrol.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl mm/memcontrol.c
--- a/mm/memcontrol.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl
+++ a/mm/memcontrol.c
@@ -4673,7 +4673,8 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
 		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
 			mc.precharge += HPAGE_PMD_NR;
 		spin_unlock(ptl);
@@ -4861,7 +4862,8 @@ static int mem_cgroup_move_charge_pte_ra
 	union mc_target target;
 	struct page *page;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
 		if (mc.precharge < HPAGE_PMD_NR) {
 			spin_unlock(ptl);
 			return 0;
diff -puN mm/mincore.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl mm/mincore.c
--- a/mm/mincore.c~thp-change-pmd_trans_huge_lock-interface-to-return-ptl
+++ a/mm/mincore.c
@@ -117,7 +117,8 @@ static int mincore_pte_range(pmd_t *pmd,
 	unsigned char *vec = walk->private;
 	int nr = (end - addr) >> PAGE_SHIFT;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
 		memset(vec, 1, nr);
 		spin_unlock(ptl);
 		goto out;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


From: akpm@linux-foundation.org
Subject: + thp-optimize-away-unnecessary-page-table-locking-fix.patch added to -mm tree
Date: Tue, 21 Feb 2012 12:12:06 -0800
Message-ID: <20120221201206.64EB9A0331@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48817 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2BUUMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2012 15:12:10 -0500
Received: by werb13 with SMTP id b13so290282wer.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2012 12:12:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, jslaby@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: fix mremap bug of failing to split thp
has been added to the -mm tree.  Its filename is
     thp-optimize-away-unnecessary-page-table-locking-fix.patch

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
Subject: fix mremap bug of failing to split thp

The patch "thp: optimize away unnecessary page table locking" introduced a
bug to move_page_tables(), where we fail to split thp when move_huge_pmd()
is not called.  To fix it, this patch reverts the return value changes and
readd if (!err) block.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 +++---
 mm/huge_memory.c   |   13 ++++++-------
 mm/mremap.c        |    2 ++
 3 files changed, 11 insertions(+), 10 deletions(-)

diff -puN fs/proc/task_mmu.c~thp-optimize-away-unnecessary-page-table-locking-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~thp-optimize-away-unnecessary-page-table-locking-fix
+++ a/fs/proc/task_mmu.c
@@ -394,7 +394,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma)) {
+	if (pmd_trans_huge_lock(pmd, vma) == 1) {
 		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
 		spin_unlock(&walk->mm->page_table_lock);
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
@@ -688,7 +688,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 
-	if (pmd_trans_huge_lock(pmd, vma)) {
+	if (pmd_trans_huge_lock(pmd, vma) == 1) {
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset = (addr & ~PAGEMAP_WALK_MASK)
 				>> PAGE_SHIFT;
@@ -966,7 +966,7 @@ static int gather_pte_stats(pmd_t *pmd, 
 
 	md = walk->private;
 
-	if (pmd_trans_huge_lock(pmd, md->vma)) {
+	if (pmd_trans_huge_lock(pmd, md->vma) == 1) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
diff -puN mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking-fix
+++ a/mm/huge_memory.c
@@ -1030,7 +1030,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 {
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma)) {
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
 		pgtable = get_pmd_huge_pte(tlb->mm);
@@ -1056,7 +1056,7 @@ int mincore_huge_pmd(struct vm_area_stru
 {
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma)) {
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		/*
 		 * All logical pages in the range are present
 		 * if backed by a huge page.
@@ -1094,12 +1094,11 @@ int move_huge_pmd(struct vm_area_struct 
 		goto out;
 	}
 
-	if (__pmd_trans_huge_lock(old_pmd, vma)) {
+	if ((ret = __pmd_trans_huge_lock(old_pmd, vma)) == 1) {
 		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		spin_unlock(&mm->page_table_lock);
-		ret = 1;
 	}
 out:
 	return ret;
@@ -1111,7 +1110,7 @@ int change_huge_pmd(struct vm_area_struc
 	struct mm_struct *mm = vma->vm_mm;
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma)) {
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
 		entry = pmd_modify(entry, newprot);
@@ -1125,7 +1124,7 @@ int change_huge_pmd(struct vm_area_struc
 
 /*
  * Returns 1 if a given pmd maps a stable (not under splitting) thp.
- * Returns 0 otherwise.
+ * Returns -1 if it maps a thp under splitting. Returns 0 otherwise.
  *
  * Note that if it returns 1, this routine returns without unlocking page
  * table locks. So callers must unlock them.
@@ -1137,7 +1136,7 @@ int __pmd_trans_huge_lock(pmd_t *pmd, st
 		if (unlikely(pmd_trans_splitting(*pmd))) {
 			spin_unlock(&vma->vm_mm->page_table_lock);
 			wait_split_huge_page(vma->anon_vma, pmd);
-			return 0;
+			return -1;
 		} else {
 			/* Thp mapped by 'pmd' is stable, so we can
 			 * handle it as it is. */
diff -puN mm/mremap.c~thp-optimize-away-unnecessary-page-table-locking-fix mm/mremap.c
--- a/mm/mremap.c~thp-optimize-away-unnecessary-page-table-locking-fix
+++ a/mm/mremap.c
@@ -155,6 +155,8 @@ unsigned long move_page_tables(struct vm
 			if (err > 0) {
 				need_flush = true;
 				continue;
+			} else if (!err) {
+				split_huge_page_pmd(vma->vm_mm, old_pmd);
 			}
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
_
Subject: Subject: fix mremap bug of failing to split thp

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch


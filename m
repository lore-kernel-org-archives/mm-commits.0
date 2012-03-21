From: akpm@linux-foundation.org
Subject: [folded] thp-optimize-away-unnecessary-page-table-locking-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:18:23 -0700
Message-ID: <20120321231823.81FDDA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39875 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2CUXSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:18:24 -0400
Received: by vbnl22 with SMTP id l22so128395vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:18:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, jslaby@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix mremap bug of failing to split thp
has been removed from the -mm tree.  Its filename was
     thp-optimize-away-unnecessary-page-table-locking-fix.patch

This patch was dropped because it was folded into thp-optimize-away-unnecessary-page-table-locking.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -696,7 +696,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 	spin_lock(&walk->mm->page_table_lock);
-	if (pmd_trans_huge_lock(pmd, vma)) {
+	if (pmd_trans_huge_lock(pmd, vma) == 1) {
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
 
@@ -977,7 +977,7 @@ static int gather_pte_stats(pmd_t *pmd, 
 
 	md = walk->private;
 
-	if (pmd_trans_huge_lock(pmd, md->vma)) {
+	if (pmd_trans_huge_lock(pmd, md->vma) == 1) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
diff -puN mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking-fix
+++ a/mm/huge_memory.c
@@ -1031,7 +1031,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 {
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma)) {
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
 		pgtable = get_pmd_huge_pte(tlb->mm);
@@ -1057,7 +1057,7 @@ int mincore_huge_pmd(struct vm_area_stru
 {
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma)) {
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		/*
 		 * All logical pages in the range are present
 		 * if backed by a huge page.
@@ -1095,12 +1095,11 @@ int move_huge_pmd(struct vm_area_struct 
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
@@ -1112,7 +1111,7 @@ int change_huge_pmd(struct vm_area_struc
 	struct mm_struct *mm = vma->vm_mm;
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma)) {
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
 		entry = pmdp_get_and_clear(mm, addr, pmd);
 		entry = pmd_modify(entry, newprot);
@@ -1126,7 +1125,7 @@ int change_huge_pmd(struct vm_area_struc
 
 /*
  * Returns 1 if a given pmd maps a stable (not under splitting) thp.
- * Returns 0 otherwise.
+ * Returns -1 if it maps a thp under splitting. Returns 0 otherwise.
  *
  * Note that if it returns 1, this routine returns without unlocking page
  * table locks. So callers must unlock them.
@@ -1138,7 +1137,7 @@ int __pmd_trans_huge_lock(pmd_t *pmd, st
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

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
memcg-clean-up-existing-move-charge-code.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch
memcg-avoid-thp-split-in-task-migration.patch


From: akpm@linux-foundation.org
Subject: + mm-add-apply_to_page_range_batch.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:17:43 -0800
Message-ID: <201101280017.p0S0HhNE008223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894Ab1A1ASU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:18:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk


The patch titled
     mm: add apply_to_page_range_batch()
has been added to the -mm tree.  Its filename is
     mm-add-apply_to_page_range_batch.patch

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
Subject: mm: add apply_to_page_range_batch()
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

apply_to_page_range() calls its callback function once for each pte, which
is pretty inefficient since it will almost always be operating on a batch
of adjacent ptes.  apply_to_page_range_batch() calls its callback with
both a pte_t * and a count, so it can operate on multiple ptes at once.

The callback is expected to handle all its ptes, or return an error.  For
both apply_to_page_range and apply_to_page_range_batch, it is up to the
caller to work out how much progress was made if either fails with an
error.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++
 mm/memory.c        |   57 ++++++++++++++++++++++++++++++-------------
 2 files changed, 47 insertions(+), 16 deletions(-)

diff -puN include/linux/mm.h~mm-add-apply_to_page_range_batch include/linux/mm.h
--- a/include/linux/mm.h~mm-add-apply_to_page_range_batch
+++ a/include/linux/mm.h
@@ -1543,6 +1543,12 @@ typedef int (*pte_fn_t)(pte_t *pte, unsi
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
 
+typedef int (*pte_batch_fn_t)(pte_t *pte, unsigned count,
+			      unsigned long addr, void *data);
+extern int apply_to_page_range_batch(struct mm_struct *mm,
+				     unsigned long address, unsigned long size,
+				     pte_batch_fn_t fn, void *data);
+
 #ifdef CONFIG_PROC_FS
 void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
 #else
diff -puN mm/memory.c~mm-add-apply_to_page_range_batch mm/memory.c
--- a/mm/memory.c~mm-add-apply_to_page_range_batch
+++ a/mm/memory.c
@@ -2012,11 +2012,10 @@ EXPORT_SYMBOL(remap_pfn_range);
 
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data)
+				     pte_batch_fn_t fn, void *data)
 {
 	pte_t *pte;
 	int err;
-	pgtable_t token;
 	spinlock_t *uninitialized_var(ptl);
 
 	pte = (mm == &init_mm) ?
@@ -2028,25 +2027,17 @@ static int apply_to_pte_range(struct mm_
 	BUG_ON(pmd_huge(*pmd));
 
 	arch_enter_lazy_mmu_mode();
-
-	token = pmd_pgtable(*pmd);
-
-	do {
-		err = fn(pte++, addr, data);
-		if (err)
-			break;
-	} while (addr += PAGE_SIZE, addr != end);
-
+	err = fn(pte, (end - addr) / PAGE_SIZE, addr, data);
 	arch_leave_lazy_mmu_mode();
 
 	if (mm != &init_mm)
-		pte_unmap_unlock(pte-1, ptl);
+		pte_unmap_unlock(pte, ptl);
 	return err;
 }
 
 static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data)
+				     pte_batch_fn_t fn, void *data)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -2068,7 +2059,7 @@ static int apply_to_pmd_range(struct mm_
 
 static int apply_to_pud_range(struct mm_struct *mm, pgd_t *pgd,
 				     unsigned long addr, unsigned long end,
-				     pte_fn_t fn, void *data)
+				     pte_batch_fn_t fn, void *data)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -2090,8 +2081,9 @@ static int apply_to_pud_range(struct mm_
  * Scan a region of virtual memory, filling in page tables as necessary
  * and calling a provided function on each leaf page table.
  */
-int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
-			unsigned long size, pte_fn_t fn, void *data)
+int apply_to_page_range_batch(struct mm_struct *mm,
+			      unsigned long addr, unsigned long size,
+			      pte_batch_fn_t fn, void *data)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -2109,6 +2101,39 @@ int apply_to_page_range(struct mm_struct
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(apply_to_page_range_batch);
+
+struct pte_single_fn
+{
+	pte_fn_t fn;
+	void *data;
+};
+
+static int apply_pte_batch(pte_t *pte, unsigned count,
+			   unsigned long addr, void *data)
+{
+	struct pte_single_fn *single = data;
+	int err = 0;
+
+	while (count--) {
+		err = single->fn(pte, addr, single->data);
+		if (err)
+			break;
+
+		addr += PAGE_SIZE;
+		pte++;
+	}
+
+	return err;
+}
+
+int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
+			unsigned long size, pte_fn_t fn, void *data)
+{
+	struct pte_single_fn single = { .fn = fn, .data = data };
+	return apply_to_page_range_batch(mm, addr, size,
+					 apply_pte_batch, &single);
+}
 EXPORT_SYMBOL_GPL(apply_to_page_range);
 
 /*
_

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

linux-next.patch
mm-remove-unused-token-argument-from-apply_to_page_range-callback.patch
mm-add-apply_to_page_range_batch.patch
ioremap-use-apply_to_page_range_batch-for-ioremap_page_range.patch
vmalloc-use-plain-pte_clear-for-unmaps.patch
vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch
vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch
vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch
xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch
xen-grant-table-use-apply_to_page_range_batch.patch


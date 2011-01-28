From: akpm@linux-foundation.org
Subject: + vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:17:51 -0800
Message-ID: <201101280017.p0S0HpqV008243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894Ab1A1ASZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk


The patch titled
     vmalloc: use apply_to_page_range_batch() for vmap_page_range_noflush()
has been added to the -mm tree.  Its filename is
     vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch

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
Subject: vmalloc: use apply_to_page_range_batch() for vmap_page_range_noflush()
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

There's no need to open-code it when there's a helpful utility function.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   86 ++++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 60 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush
+++ a/mm/vmalloc.c
@@ -53,63 +53,34 @@ static void vunmap_page_range(unsigned l
 	apply_to_page_range_batch(&init_mm, addr, end - addr, vunmap_pte, NULL);
 }
 
-static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
+struct vmap_data
 {
-	pte_t *pte;
+	struct page **pages;
+	unsigned index;
+	pgprot_t prot;
+};
 
-	/*
-	 * nr is a running index into the array which helps higher level
-	 * callers keep track of where we're up to.
-	 */
+static int vmap_pte(pte_t *pte, unsigned count,
+		    unsigned long addr, void *data)
+{
+	struct vmap_data *vmap = data;
 
-	pte = pte_alloc_kernel(pmd, addr);
-	if (!pte)
-		return -ENOMEM;
-	do {
-		struct page *page = pages[*nr];
+	while (count--) {
+		struct page *page = vmap->pages[vmap->index];
 
 		if (WARN_ON(!pte_none(*pte)))
 			return -EBUSY;
+
 		if (WARN_ON(!page))
 			return -ENOMEM;
-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	return 0;
-}
 
-static int vmap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	pmd_t *pmd;
-	unsigned long next;
+		set_pte_at(&init_mm, addr, pte, mk_pte(page, vmap->prot));
 
-	pmd = pmd_alloc(&init_mm, pud, addr);
-	if (!pmd)
-		return -ENOMEM;
-	do {
-		next = pmd_addr_end(addr, end);
-		if (vmap_pte_range(pmd, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
-
-static int vmap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
-{
-	pud_t *pud;
-	unsigned long next;
+		pte++;
+		addr += PAGE_SIZE;
+		vmap->index++;
+	}
 
-	pud = pud_alloc(&init_mm, pgd, addr);
-	if (!pud)
-		return -ENOMEM;
-	do {
-		next = pud_addr_end(addr, end);
-		if (vmap_pmd_range(pud, addr, next, prot, pages, nr))
-			return -ENOMEM;
-	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
@@ -122,22 +93,17 @@ static int vmap_pud_range(pgd_t *pgd, un
 static int vmap_page_range_noflush(unsigned long start, unsigned long end,
 				   pgprot_t prot, struct page **pages)
 {
-	pgd_t *pgd;
-	unsigned long next;
-	unsigned long addr = start;
-	int err = 0;
-	int nr = 0;
+	int err;
+	struct vmap_data vmap = {
+		.pages = pages,
+		.index = 0,
+		.prot = prot
+	};
 
-	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
-		if (err)
-			return err;
-	} while (pgd++, addr = next, addr != end);
+	err = apply_to_page_range_batch(&init_mm, start, end - start,
+					vmap_pte, &vmap);
 
-	return nr;
+	return err ? err : vmap.index;
 }
 
 static int vmap_page_range(unsigned long start, unsigned long end,
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


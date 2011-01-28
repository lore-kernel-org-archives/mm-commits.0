From: akpm@linux-foundation.org
Subject: + ioremap-use-apply_to_page_range_batch-for-ioremap_page_range.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:17:45 -0800
Message-ID: <201101280017.p0S0Hj0X008227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894Ab1A1ASX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk


The patch titled
     ioremap: use apply_to_page_range_batch() for ioremap_page_range()
has been added to the -mm tree.  Its filename is
     ioremap-use-apply_to_page_range_batch-for-ioremap_page_range.patch

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
Subject: ioremap: use apply_to_page_range_batch() for ioremap_page_range()
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ioremap.c |   85 ++++++++++++------------------------------------
 1 file changed, 22 insertions(+), 63 deletions(-)

diff -puN lib/ioremap.c~ioremap-use-apply_to_page_range_batch-for-ioremap_page_range lib/ioremap.c
--- a/lib/ioremap.c~ioremap-use-apply_to_page_range_batch-for-ioremap_page_range
+++ a/lib/ioremap.c
@@ -13,81 +13,40 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+struct ioremap_data
 {
-	pte_t *pte;
+	phys_addr_t phys_addr;
+	pgprot_t prot;
+};
+
+static int ioremap_pte_range(pte_t *pte, unsigned count,
+			     unsigned long addr, void *v)
+{
+	struct ioremap_data *data = v;
 	u64 pfn;
 
-	pfn = phys_addr >> PAGE_SHIFT;
-	pte = pte_alloc_kernel(pmd, addr);
-	if (!pte)
-		return -ENOMEM;
-	do {
-		BUG_ON(!pte_none(*pte));
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	return 0;
-}
+	pfn = data->phys_addr >> PAGE_SHIFT;
+	data->phys_addr += count * PAGE_SIZE;
 
-static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
-{
-	pmd_t *pmd;
-	unsigned long next;
+	while (count--) {
+		BUG_ON(!pte_none(*pte));
 
-	phys_addr -= addr;
-	pmd = pmd_alloc(&init_mm, pud, addr);
-	if (!pmd)
-		return -ENOMEM;
-	do {
-		next = pmd_addr_end(addr, end);
-		if (ioremap_pte_range(pmd, addr, next, phys_addr + addr, prot))
-			return -ENOMEM;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
+		set_pte_at(&init_mm, addr, pte++, pfn_pte(pfn++, data->prot));
 
-static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
-{
-	pud_t *pud;
-	unsigned long next;
+		addr += PAGE_SIZE;
+	}
 
-	phys_addr -= addr;
-	pud = pud_alloc(&init_mm, pgd, addr);
-	if (!pud)
-		return -ENOMEM;
-	do {
-		next = pud_addr_end(addr, end);
-		if (ioremap_pmd_range(pud, addr, next, phys_addr + addr, prot))
-			return -ENOMEM;
-	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
-int ioremap_page_range(unsigned long addr,
-		       unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+int ioremap_page_range(unsigned long addr, unsigned long end,
+		       phys_addr_t phys_addr, pgprot_t prot)
 {
-	pgd_t *pgd;
-	unsigned long start;
-	unsigned long next;
-	int err;
-
-	BUG_ON(addr >= end);
-
-	start = addr;
-	phys_addr -= addr;
-	pgd = pgd_offset_k(addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		err = ioremap_pud_range(pgd, addr, next, phys_addr+addr, prot);
-		if (err)
-			break;
-	} while (pgd++, addr = next, addr != end);
+	struct ioremap_data data = { .phys_addr = phys_addr, .prot = prot };
+	int err = apply_to_page_range_batch(&init_mm, addr, end - addr,
+					    ioremap_pte_range, &data);
 
-	flush_cache_vmap(start, end);
+	flush_cache_vmap(addr, end);
 
 	return err;
 }
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


From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 120/128] mm/ioremap: track which page-table levels
 were modified
Date: Mon, 01 Jun 2020 21:52:26 -0700
Message-ID: <20200602045226.lWe5_oCw8%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgFBEw3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:52:29 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, jroedel@suse.de, linux-mm@kvack.org, luto@kernel.org, mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net, rostedt@goodmis.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org

From: Joerg Roedel <jroedel@suse.de>
Subject: mm/ioremap: track which page-table levels were modified

Track at which levels in the page-table entries were modified by
ioremap_page_range().  After the page-table has been modified, use that
information do decide whether the new arch_sync_kernel_mappings() needs to
be called.  The iounmap path re-uses vunmap(), which has already been
taken care of.

Link: http://lkml.kernel.org/r/20200515140023.25469-4-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ioremap.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

--- a/lib/ioremap.c~mm-ioremap-track-which-page-table-levels-were-modified
+++ a/lib/ioremap.c
@@ -61,13 +61,14 @@ static inline int ioremap_pmd_enabled(vo
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot,
+		pgtbl_mod_mask *mask)
 {
 	pte_t *pte;
 	u64 pfn;
 
 	pfn = phys_addr >> PAGE_SHIFT;
-	pte = pte_alloc_kernel(pmd, addr);
+	pte = pte_alloc_kernel_track(pmd, addr, mask);
 	if (!pte)
 		return -ENOMEM;
 	do {
@@ -75,6 +76,7 @@ static int ioremap_pte_range(pmd_t *pmd,
 		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
+	*mask |= PGTBL_PTE_MODIFIED;
 	return 0;
 }
 
@@ -101,21 +103,24 @@ static int ioremap_try_huge_pmd(pmd_t *p
 }
 
 static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot,
+		pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
 	unsigned long next;
 
-	pmd = pmd_alloc(&init_mm, pud, addr);
+	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
 
-		if (ioremap_try_huge_pmd(pmd, addr, next, phys_addr, prot))
+		if (ioremap_try_huge_pmd(pmd, addr, next, phys_addr, prot)) {
+			*mask |= PGTBL_PMD_MODIFIED;
 			continue;
+		}
 
-		if (ioremap_pte_range(pmd, addr, next, phys_addr, prot))
+		if (ioremap_pte_range(pmd, addr, next, phys_addr, prot, mask))
 			return -ENOMEM;
 	} while (pmd++, phys_addr += (next - addr), addr = next, addr != end);
 	return 0;
@@ -144,21 +149,24 @@ static int ioremap_try_huge_pud(pud_t *p
 }
 
 static inline int ioremap_pud_range(p4d_t *p4d, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot,
+		pgtbl_mod_mask *mask)
 {
 	pud_t *pud;
 	unsigned long next;
 
-	pud = pud_alloc(&init_mm, p4d, addr);
+	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
 
-		if (ioremap_try_huge_pud(pud, addr, next, phys_addr, prot))
+		if (ioremap_try_huge_pud(pud, addr, next, phys_addr, prot)) {
+			*mask |= PGTBL_PUD_MODIFIED;
 			continue;
+		}
 
-		if (ioremap_pmd_range(pud, addr, next, phys_addr, prot))
+		if (ioremap_pmd_range(pud, addr, next, phys_addr, prot, mask))
 			return -ENOMEM;
 	} while (pud++, phys_addr += (next - addr), addr = next, addr != end);
 	return 0;
@@ -187,21 +195,24 @@ static int ioremap_try_huge_p4d(p4d_t *p
 }
 
 static inline int ioremap_p4d_range(pgd_t *pgd, unsigned long addr,
-		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
+		unsigned long end, phys_addr_t phys_addr, pgprot_t prot,
+		pgtbl_mod_mask *mask)
 {
 	p4d_t *p4d;
 	unsigned long next;
 
-	p4d = p4d_alloc(&init_mm, pgd, addr);
+	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
 
-		if (ioremap_try_huge_p4d(p4d, addr, next, phys_addr, prot))
+		if (ioremap_try_huge_p4d(p4d, addr, next, phys_addr, prot)) {
+			*mask |= PGTBL_P4D_MODIFIED;
 			continue;
+		}
 
-		if (ioremap_pud_range(p4d, addr, next, phys_addr, prot))
+		if (ioremap_pud_range(p4d, addr, next, phys_addr, prot, mask))
 			return -ENOMEM;
 	} while (p4d++, phys_addr += (next - addr), addr = next, addr != end);
 	return 0;
@@ -214,6 +225,7 @@ int ioremap_page_range(unsigned long add
 	unsigned long start;
 	unsigned long next;
 	int err;
+	pgtbl_mod_mask mask = 0;
 
 	might_sleep();
 	BUG_ON(addr >= end);
@@ -222,13 +234,17 @@ int ioremap_page_range(unsigned long add
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		err = ioremap_p4d_range(pgd, addr, next, phys_addr, prot);
+		err = ioremap_p4d_range(pgd, addr, next, phys_addr, prot,
+					&mask);
 		if (err)
 			break;
 	} while (pgd++, phys_addr += (next - addr), addr = next, addr != end);
 
 	flush_cache_vmap(start, end);
 
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, end);
+
 	return err;
 }
 
_

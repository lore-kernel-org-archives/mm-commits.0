From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 56/93] m68k/mm: move {cache,nocahe}_page()
 definitions close to their user
Date: Mon, 08 Jun 2020 21:32:56 -0700
Message-ID: <20200609043256.DNudmqn_F%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEc6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:58 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.orgy

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: m68k/mm: move {cache,nocahe}_page() definitions close to their user

The cache_page() and nocache_page() functions are only used by the
motorola MMU variant for setting caching attributes for the page table
pages.

Move the definitions of these functions from
arch/m68k/include/asm/motorola_pgtable.h closer to their usage in
arch/m68k/mm/motorola.c and drop unused definition in
arch/m68k/include/asm/mcf_pgtable.h.

Link: http://lkml.kernel.org/r/20200514170327.31389-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mcf_pgtable.h      |   40 -------------------
 arch/m68k/include/asm/motorola_pgtable.h |   44 ---------------------
 arch/m68k/mm/motorola.c                  |   43 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 84 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-mm-move-cachenocahe_page-definitions-close-to-their-user
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -329,46 +329,6 @@ extern pgd_t kernel_pg_dir[PTRS_PER_PGD]
 	((pte_t *) __pmd_page(*(dir)) + __pte_offset(address))
 
 /*
- * Disable caching for page at given kernel virtual address.
- */
-static inline void nocache_page(void *vaddr)
-{
-	pgd_t *dir;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp;
-	pte_t *ptep;
-	unsigned long addr = (unsigned long) vaddr;
-
-	dir = pgd_offset_k(addr);
-	p4dp = p4d_offset(dir, addr);
-	pudp = pud_offset(p4dp, addr);
-	pmdp = pmd_offset(pudp, addr);
-	ptep = pte_offset_kernel(pmdp, addr);
-	*ptep = pte_mknocache(*ptep);
-}
-
-/*
- * Enable caching for page at given kernel virtual address.
- */
-static inline void cache_page(void *vaddr)
-{
-	pgd_t *dir;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp;
-	pte_t *ptep;
-	unsigned long addr = (unsigned long) vaddr;
-
-	dir = pgd_offset_k(addr);
-	p4dp = p4d_offset(dir, addr);
-	pudp = pud_offset(p4dp, addr);
-	pmdp = pmd_offset(pudp, addr);
-	ptep = pte_offset_kernel(pmdp, addr);
-	*ptep = pte_mkcache(*ptep);
-}
-
-/*
  * Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e))
  */
 #define __swp_type(x)		((x).val & 0xFF)
--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-mm-move-cachenocahe_page-definitions-close-to-their-user
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -227,50 +227,6 @@ static inline pte_t *pte_offset_kernel(p
 #define pte_offset_map(pmdp,address) ((pte_t *)__pmd_page(*pmdp) + (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 #define pte_unmap(pte)		((void)0)
 
-/* Prior to calling these routines, the page should have been flushed
- * from both the cache and ATC, or the CPU might not notice that the
- * cache setting for the page has been changed. -jskov
- */
-static inline void nocache_page(void *vaddr)
-{
-	unsigned long addr = (unsigned long)vaddr;
-
-	if (CPU_IS_040_OR_060) {
-		pgd_t *dir;
-		p4d_t *p4dp;
-		pud_t *pudp;
-		pmd_t *pmdp;
-		pte_t *ptep;
-
-		dir = pgd_offset_k(addr);
-		p4dp = p4d_offset(dir, addr);
-		pudp = pud_offset(p4dp, addr);
-		pmdp = pmd_offset(pudp, addr);
-		ptep = pte_offset_kernel(pmdp, addr);
-		*ptep = pte_mknocache(*ptep);
-	}
-}
-
-static inline void cache_page(void *vaddr)
-{
-	unsigned long addr = (unsigned long)vaddr;
-
-	if (CPU_IS_040_OR_060) {
-		pgd_t *dir;
-		p4d_t *p4dp;
-		pud_t *pudp;
-		pmd_t *pmdp;
-		pte_t *ptep;
-
-		dir = pgd_offset_k(addr);
-		p4dp = p4d_offset(dir, addr);
-		pudp = pud_offset(p4dp, addr);
-		pmdp = pmd_offset(pudp, addr);
-		ptep = pte_offset_kernel(pmdp, addr);
-		*ptep = pte_mkcache(*ptep);
-	}
-}
-
 /* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
 #define __swp_type(x)		(((x).val >> 4) & 0xff)
 #define __swp_offset(x)		((x).val >> 12)
--- a/arch/m68k/mm/motorola.c~m68k-mm-move-cachenocahe_page-definitions-close-to-their-user
+++ a/arch/m68k/mm/motorola.c
@@ -45,6 +45,49 @@ unsigned long mm_cachebits;
 EXPORT_SYMBOL(mm_cachebits);
 #endif
 
+/* Prior to calling these routines, the page should have been flushed
+ * from both the cache and ATC, or the CPU might not notice that the
+ * cache setting for the page has been changed. -jskov
+ */
+static inline void nocache_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (CPU_IS_040_OR_060) {
+		pgd_t *dir;
+		p4d_t *p4dp;
+		pud_t *pudp;
+		pmd_t *pmdp;
+		pte_t *ptep;
+
+		dir = pgd_offset_k(addr);
+		p4dp = p4d_offset(dir, addr);
+		pudp = pud_offset(p4dp, addr);
+		pmdp = pmd_offset(pudp, addr);
+		ptep = pte_offset_kernel(pmdp, addr);
+		*ptep = pte_mknocache(*ptep);
+	}
+}
+
+static inline void cache_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (CPU_IS_040_OR_060) {
+		pgd_t *dir;
+		p4d_t *p4dp;
+		pud_t *pudp;
+		pmd_t *pmdp;
+		pte_t *ptep;
+
+		dir = pgd_offset_k(addr);
+		p4dp = p4d_offset(dir, addr);
+		pudp = pud_offset(p4dp, addr);
+		pmdp = pmd_offset(pudp, addr);
+		ptep = pte_offset_kernel(pmdp, addr);
+		*ptep = pte_mkcache(*ptep);
+	}
+}
 
 /*
  * Motorola 680x0 user's manual recommends using uncached memory for address
_

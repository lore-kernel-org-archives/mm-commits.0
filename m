From: akpm@linux-foundation.org
Subject: [merged] um-kill-pfn_t.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:18 -0800
Message-ID: <569e98de.mLZ1mee9Zuc24zu2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbcASUNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, jdike@addtoit.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: kill pfn_t
has been removed from the -mm tree.  Its filename was
     um-kill-pfn_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: um: kill pfn_t

The core has developed a need for a "pfn_t" type [1].  Convert the usage
of pfn_t by usermode-linux to an unsigned long, and update pfn_to_phys()
to drop its expectation of a typed pfn.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-September/002199.html

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/page.h           |    7 +++----
 arch/um/include/asm/pgtable-3level.h |    4 ++--
 arch/um/include/asm/pgtable.h        |    2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/um/include/asm/page.h~um-kill-pfn_t arch/um/include/asm/page.h
--- a/arch/um/include/asm/page.h~um-kill-pfn_t
+++ a/arch/um/include/asm/page.h
@@ -18,6 +18,7 @@
 
 struct page;
 
+#include <linux/pfn.h>
 #include <linux/types.h>
 #include <asm/vm-flags.h>
 
@@ -52,7 +53,6 @@ typedef struct { unsigned long pgd; } pg
 #define pmd_val(x)	((x).pmd)
 #define __pmd(x) ((pmd_t) { (x) } )
 
-typedef unsigned long long pfn_t;
 typedef unsigned long long phys_t;
 
 #else
@@ -76,7 +76,6 @@ typedef struct { unsigned long pmd; } pm
 #define pte_is_zero(p) (!((p).pte & ~_PAGE_NEWPAGE))
 #define pte_set_val(p, phys, prot) (p).pte = (phys | pgprot_val(prot))
 
-typedef unsigned long pfn_t;
 typedef unsigned long phys_t;
 
 #endif
@@ -109,8 +108,8 @@ extern unsigned long uml_physmem;
 #define __pa(virt) to_phys((void *) (unsigned long) (virt))
 #define __va(phys) to_virt((unsigned long) (phys))
 
-#define phys_to_pfn(p) ((pfn_t) ((p) >> PAGE_SHIFT))
-#define pfn_to_phys(pfn) ((phys_t) ((pfn) << PAGE_SHIFT))
+#define phys_to_pfn(p) ((p) >> PAGE_SHIFT)
+#define pfn_to_phys(pfn) PFN_PHYS(pfn)
 
 #define pfn_valid(pfn) ((pfn) < max_mapnr)
 #define virt_addr_valid(v) pfn_valid(phys_to_pfn(__pa(v)))
diff -puN arch/um/include/asm/pgtable-3level.h~um-kill-pfn_t arch/um/include/asm/pgtable-3level.h
--- a/arch/um/include/asm/pgtable-3level.h~um-kill-pfn_t
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -98,7 +98,7 @@ static inline unsigned long pte_pfn(pte_
 	return phys_to_pfn(pte_val(pte));
 }
 
-static inline pte_t pfn_pte(pfn_t page_nr, pgprot_t pgprot)
+static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	pte_t pte;
 	phys_t phys = pfn_to_phys(page_nr);
@@ -107,7 +107,7 @@ static inline pte_t pfn_pte(pfn_t page_n
 	return pte;
 }
 
-static inline pmd_t pfn_pmd(pfn_t page_nr, pgprot_t pgprot)
+static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
 	return __pmd((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
 }
diff -puN arch/um/include/asm/pgtable.h~um-kill-pfn_t arch/um/include/asm/pgtable.h
--- a/arch/um/include/asm/pgtable.h~um-kill-pfn_t
+++ a/arch/um/include/asm/pgtable.h
@@ -271,7 +271,7 @@ static inline int pte_same(pte_t pte_a,
 
 #define phys_to_page(phys) pfn_to_page(phys_to_pfn(phys))
 #define __virt_to_page(virt) phys_to_page(__pa(virt))
-#define page_to_phys(page) pfn_to_phys((pfn_t) page_to_pfn(page))
+#define page_to_phys(page) pfn_to_phys(page_to_pfn(page))
 #define virt_to_page(addr) __virt_to_page((const unsigned long) addr)
 
 #define mk_pte(page, pgprot) \
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch


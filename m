From: akpm@linux-foundation.org
Subject: + um-kill-pfn_t.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:16:45 -0800
Message-ID: <5670ad6d.kX4xqVPswZIdLEZv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbbLPAQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, jdike@addtoit.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: kill pfn_t
has been added to the -mm tree.  Its filename is
     um-kill-pfn_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/um-kill-pfn_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/um-kill-pfn_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch


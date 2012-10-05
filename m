From: akpm@linux-foundation.org
Subject: + sparc64-halve-the-size-of-pte-tables.patch added to -mm tree
Date: Fri, 05 Oct 2012 15:00:50 -0700
Message-ID: <20121005220050.D58625C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63907 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786Ab2JEWAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 18:00:54 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so142391eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 15:00:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: sparc64: Halve the size of PTE tables
has been added to the -mm tree.  Its filename is
     sparc64-halve-the-size-of-pte-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Miller <davem@davemloft.net>
Subject: sparc64: Halve the size of PTE tables

The reason we want to do this is to facilitate transparent huge page
support.

Right now PMD's cover 8MB of address space, and our huge page size is 4MB.
 The current transparent hugepage support is not able to handle HPAGE_SIZE
!= PMD_SIZE.

So make PTE tables be sized to half of a page instead of a full page.

We can still map properly the whole supported virtual address range which
on sparc64 requires 44 bits.  Add a compile time CPP test which ensures
that this requirement is always met.

There is a minor inefficiency added by this change.  We only use half of
the page for PTE tables.  It's not trivial to use only half of the page
yet still get all of the pgtable_page_{ctor,dtor}() stuff working
properly.  It is doable, and that will come in a subsequent change.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |   24 +++++++-----------------
 arch/sparc/include/asm/tsb.h        |    4 ++--
 2 files changed, 9 insertions(+), 19 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc64-halve-the-size-of-pte-tables arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc64-halve-the-size-of-pte-tables
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -45,40 +45,30 @@
 
 #define vmemmap			((struct page *)VMEMMAP_BASE)
 
-/* XXX All of this needs to be rethought so we can take advantage
- * XXX cheetah's full 64-bit virtual address space, ie. no more hole
- * XXX in the middle like on spitfire. -DaveM
- */
-/*
- * Given a virtual address, the lowest PAGE_SHIFT bits determine offset
- * into the page; the next higher PAGE_SHIFT-3 bits determine the pte#
- * in the proper pagetable (the -3 is from the 8 byte ptes, and each page
- * table is a single page long). The next higher PMD_BITS determine pmd#
- * in the proper pmdtable (where we must have PMD_BITS <= (PAGE_SHIFT-2)
- * since the pmd entries are 4 bytes, and each pmd page is a single page
- * long). Finally, the higher few bits determine pgde#.
- */
-
 /* PMD_SHIFT determines the size of the area a second-level page
  * table can map
  */
-#define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT-3))
+#define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT-4))
 #define PMD_SIZE	(_AC(1,UL) << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
 #define PMD_BITS	(PAGE_SHIFT - 2)
 
 /* PGDIR_SHIFT determines what a third-level page table entry can map */
-#define PGDIR_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT-3) + PMD_BITS)
+#define PGDIR_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT-4) + PMD_BITS)
 #define PGDIR_SIZE	(_AC(1,UL) << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 #define PGDIR_BITS	(PAGE_SHIFT - 2)
 
+#if (PGDIR_SHIFT + PGDIR_BITS) != 44
+#error Page table parameters do not cover virtual address space properly.
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <linux/sched.h>
 
 /* Entries per page directory level. */
-#define PTRS_PER_PTE	(1UL << (PAGE_SHIFT-3))
+#define PTRS_PER_PTE	(1UL << (PAGE_SHIFT-4))
 #define PTRS_PER_PMD	(1UL << PMD_BITS)
 #define PTRS_PER_PGD	(1UL << PGDIR_BITS)
 
diff -puN arch/sparc/include/asm/tsb.h~sparc64-halve-the-size-of-pte-tables arch/sparc/include/asm/tsb.h
--- a/arch/sparc/include/asm/tsb.h~sparc64-halve-the-size-of-pte-tables
+++ a/arch/sparc/include/asm/tsb.h
@@ -152,7 +152,7 @@ extern struct tsb_phys_patch_entry __tsb
 	lduwa		[REG1 + REG2] ASI_PHYS_USE_EC, REG1; \
 	brz,pn		REG1, FAIL_LABEL; \
 	 sllx		VADDR, 64 - PMD_SHIFT, REG2; \
-	srlx		REG2, 64 - PAGE_SHIFT, REG2; \
+	srlx		REG2, 64 - (PAGE_SHIFT - 1), REG2; \
 	sllx		REG1, 11, REG1; \
 	andn		REG2, 0x7, REG2; \
 	add		REG1, REG2, REG1;
@@ -177,7 +177,7 @@ extern struct tsb_phys_patch_entry __tsb
 	lduwa		[REG1 + REG2] ASI_PHYS_USE_EC, REG1; \
 	brz,pn		REG1, FAIL_LABEL; \
 	 sllx		VADDR, 64 - PMD_SHIFT, REG2; \
-	srlx		REG2, 64 - PAGE_SHIFT, REG2; \
+	srlx		REG2, 64 - (PAGE_SHIFT - 1), REG2; \
 	sllx		REG1, 11, REG1; \
 	andn		REG2, 0x7, REG2; \
 	add		REG1, REG2, REG1;
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch
kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch
sparc64-halve-the-size-of-pte-tables.patch
sparc64-eliminate-pte-table-memory-wastage.patch
sparc64-document-pgd-and-pmd-layout.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch
sparc64-support-transparent-huge-pages.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch


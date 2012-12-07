From: akpm@linux-foundation.org
Subject: + asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch added to -mm tree
Date: Fri, 07 Dec 2012 12:43:59 -0800
Message-ID: <20121207204359.A907682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39843 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424123Ab2LGUoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 15:44:00 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so94249vcd.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 12:44:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com


The patch titled
     Subject: asm-generic, mm: pgtable: consolidate zero page helpers
has been added to the -mm tree.  Its filename is
     asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: asm-generic, mm: pgtable: consolidate zero page helpers

We have two different implementation of is_zero_pfn() and my_zero_pfn()
helpers: for architectures with and without zero page coloring.

Let's consolidate them in <asm-generic/pgtable.h>.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |   11 +----------
 arch/s390/include/asm/pgtable.h |   11 +----------
 include/asm-generic/pgtable.h   |   26 ++++++++++++++++++++++++++
 include/linux/mm.h              |    8 --------
 mm/memory.c                     |    7 -------
 5 files changed, 28 insertions(+), 35 deletions(-)

diff -puN arch/mips/include/asm/pgtable.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers
+++ a/arch/mips/include/asm/pgtable.h
@@ -77,16 +77,7 @@ extern unsigned long zero_page_mask;
 
 #define ZERO_PAGE(vaddr) \
 	(virt_to_page((void *)(empty_zero_page + (((unsigned long)(vaddr)) & zero_page_mask))))
-
-#define is_zero_pfn is_zero_pfn
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	extern unsigned long zero_pfn;
-	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
-	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
-}
-
-#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
+#define __HAVE_COLOR_ZERO_PAGE
 
 extern void paging_init(void);
 
diff -puN arch/s390/include/asm/pgtable.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers
+++ a/arch/s390/include/asm/pgtable.h
@@ -54,16 +54,7 @@ extern unsigned long zero_page_mask;
 #define ZERO_PAGE(vaddr) \
 	(virt_to_page((void *)(empty_zero_page + \
 	 (((unsigned long)(vaddr)) &zero_page_mask))))
-
-#define is_zero_pfn is_zero_pfn
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	extern unsigned long zero_pfn;
-	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
-	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
-}
-
-#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
+#define __HAVE_COLOR_ZERO_PAGE
 
 #endif /* !__ASSEMBLY__ */
 
diff -puN include/asm-generic/pgtable.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers
+++ a/include/asm-generic/pgtable.h
@@ -453,6 +453,32 @@ extern void untrack_pfn(struct vm_area_s
 			unsigned long size);
 #endif
 
+#ifdef __HAVE_COLOR_ZERO_PAGE
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	extern unsigned long zero_pfn;
+	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
+	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
+}
+
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	return page_to_pfn(ZERO_PAGE(addr));
+}
+#else
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	extern unsigned long zero_pfn;
+	return pfn == zero_pfn;
+}
+
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	extern unsigned long zero_pfn;
+	return zero_pfn;
+}
+#endif
+
 #ifdef CONFIG_MMU
 
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN include/linux/mm.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers include/linux/mm.h
--- a/include/linux/mm.h~asm-generic-mm-pgtable-consolidate-zero-page-helpers
+++ a/include/linux/mm.h
@@ -516,14 +516,6 @@ static inline pte_t maybe_mkwrite(pte_t 
 }
 #endif
 
-#ifndef my_zero_pfn
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	extern unsigned long zero_pfn;
-	return zero_pfn;
-}
-#endif
-
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
diff -puN mm/memory.c~asm-generic-mm-pgtable-consolidate-zero-page-helpers mm/memory.c
--- a/mm/memory.c~asm-generic-mm-pgtable-consolidate-zero-page-helpers
+++ a/mm/memory.c
@@ -724,13 +724,6 @@ static inline bool is_cow_mapping(vm_fla
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
-#ifndef is_zero_pfn
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	return pfn == zero_pfn;
-}
-#endif
-
 /*
  * vm_normal_page -- This function gets the "struct page" associated with a pte.
  *
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
thp-fix-update_mmu_cache_pmd-calls.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-thp-fix-anononymous-page-accounting-in-fallback-path-for-cow-of-hzp.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch


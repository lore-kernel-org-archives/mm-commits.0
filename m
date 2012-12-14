From: akpm@linux-foundation.org
Subject: [merged] asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:30:18 -0800
Message-ID: <20121214233019.94874200063@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:61237 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945937Ab2LNXaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:30:22 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so207430lag.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:30:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic, mm: pgtable: consolidate zero page helpers
has been removed from the -mm tree.  Its filename was
     asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -76,16 +76,7 @@ extern unsigned long zero_page_mask;
 
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
@@ -55,16 +55,7 @@ extern unsigned long zero_page_mask;
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
@@ -449,6 +449,32 @@ extern void untrack_pfn(struct vm_area_s
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
@@ -717,13 +717,6 @@ static inline bool is_cow_mapping(vm_fla
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
-#ifndef is_zero_pfn
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	return pfn == zero_pfn;
-}
-#endif

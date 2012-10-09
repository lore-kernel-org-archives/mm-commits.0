From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:21 -0700
Message-ID: <20121009180721.C45951E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52542 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:22 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so518249qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: add arch hook for clearing page flags before entering pool
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: mm: hugetlb: add arch hook for clearing page flags before entering pool

The core page allocator ensures that page flags are zeroed when freeing
pages via free_pages_check.  A number of architectures (ARM, PPC, MIPS)
rely on this property to treat new pages as dirty with respect to the data
cache and perform the appropriate flushing before mapping the pages into
userspace.

This can lead to cache synchronisation problems when using hugepages,
since the allocator keeps its own pool of pages above the usual page
allocator and does not reset the page flags when freeing a page into the
pool.

This patch adds a new architecture hook, arch_clear_hugepage_flags, so
that architectures which rely on the page flags being in a particular
state for fresh allocations can adjust the flags accordingly when a page
is freed into the pool.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/hugetlb.h    |    4 ++++
 arch/mips/include/asm/hugetlb.h    |    4 ++++
 arch/powerpc/include/asm/hugetlb.h |    4 ++++
 arch/s390/include/asm/hugetlb.h    |    1 +
 arch/sh/include/asm/hugetlb.h      |    6 ++++++
 arch/sparc/include/asm/hugetlb.h   |    4 ++++
 arch/tile/include/asm/hugetlb.h    |    4 ++++
 arch/x86/include/asm/hugetlb.h     |    4 ++++
 mm/hugetlb.c                       |    1 +
 9 files changed, 32 insertions(+)

diff -puN arch/ia64/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/ia64/include/asm/hugetlb.h
--- a/arch/ia64/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -77,4 +77,8 @@ static inline void arch_release_hugepage
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #endif /* _ASM_IA64_HUGETLB_H */
diff -puN arch/mips/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/mips/include/asm/hugetlb.h
--- a/arch/mips/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/mips/include/asm/hugetlb.h
@@ -112,4 +112,8 @@ static inline void arch_release_hugepage
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #endif /* __ASM_HUGETLB_H */
diff -puN arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/powerpc/include/asm/hugetlb.h
--- a/arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -151,6 +151,10 @@ static inline void arch_release_hugepage
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #else /* ! CONFIG_HUGETLB_PAGE */
 static inline void flush_hugetlb_page(struct vm_area_struct *vma,
 				      unsigned long vmaddr)
diff -puN arch/s390/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/s390/include/asm/hugetlb.h
@@ -33,6 +33,7 @@ static inline int prepare_hugepage_range
 }
 
 #define hugetlb_prefault_arch_hook(mm)		do { } while (0)
+#define arch_clear_hugepage_flags(page)		do { } while (0)
 
 int arch_prepare_hugepage(struct page *page);
 void arch_release_hugepage(struct page *page);
diff -puN arch/sh/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/sh/include/asm/hugetlb.h
--- a/arch/sh/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/sh/include/asm/hugetlb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_SH_HUGETLB_H
 #define _ASM_SH_HUGETLB_H
 
+#include <asm/cacheflush.h>
 #include <asm/page.h>
 
 
@@ -89,4 +90,9 @@ static inline void arch_release_hugepage
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+	clear_bit(PG_dcache_clean, &page->flags);
+}
+
 #endif /* _ASM_SH_HUGETLB_H */
diff -puN arch/sparc/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/sparc/include/asm/hugetlb.h
--- a/arch/sparc/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -82,4 +82,8 @@ static inline void arch_release_hugepage
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #endif /* _ASM_SPARC64_HUGETLB_H */
diff -puN arch/tile/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/tile/include/asm/hugetlb.h
--- a/arch/tile/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/tile/include/asm/hugetlb.h
@@ -106,6 +106,10 @@ static inline void arch_release_hugepage
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #ifdef CONFIG_HUGETLB_SUPER_PAGES
 static inline pte_t arch_make_huge_pte(pte_t entry, struct vm_area_struct *vma,
 				       struct page *page, int writable)
diff -puN arch/x86/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool arch/x86/include/asm/hugetlb.h
--- a/arch/x86/include/asm/hugetlb.h~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/arch/x86/include/asm/hugetlb.h
@@ -90,4 +90,8 @@ static inline void arch_release_hugepage
 {
 }
 
+static inline void arch_clear_hugepage_flags(struct page *page)
+{
+}
+
 #endif /* _ASM_X86_HUGETLB_H */
diff -puN mm/hugetlb.c~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-arch-hook-for-clearing-page-flags-before-entering-pool
+++ a/mm/hugetlb.c
@@ -637,6 +637,7 @@ static void free_huge_page(struct page *
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
 	} else {
+		arch_clear_hugepage_flags(page);
 		enqueue_huge_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch


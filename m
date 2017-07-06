From: akpm@linux-foundation.org
Subject: [patch 074/108] mm/hugetlb: clean up
 ARCH_HAS_GIGANTIC_PAGE
Date: Thu, 06 Jul 2017 15:39:17 -0700
Message-ID: <20170706223917._SCzsRa_l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdGFWjT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/hugetlb: clean up ARCH_HAS_GIGANTIC_PAGE

This moves the #ifdef in C code to a Kconfig dependency.  Also we move the
gigantic_page_supported() function to be arch specific.  This gives arch
to conditionally enable runtime allocation of gigantic huge page. 
Architectures like ppc64 supports different gigantic huge page size (16G
and 1G) based on the translation mode selected.  This provides an
opportunity for ppc64 to enable runtime allocation only w.r.t 1G hugepage.

No functional change in this patch.

Link: http://lkml.kernel.org/r/1494995292-4443-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    2 +-
 arch/arm64/include/asm/hugetlb.h |    4 ++++
 arch/s390/Kconfig                |    2 +-
 arch/s390/include/asm/hugetlb.h  |    3 +++
 arch/x86/Kconfig                 |    2 +-
 arch/x86/include/asm/hugetlb.h   |    4 ++++
 mm/hugetlb.c                     |    7 ++-----
 7 files changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/arm64/Kconfig~mm-hugetlb-cleanup-arch_has_gigantic_page arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~mm-hugetlb-cleanup-arch_has_gigantic_page
+++ a/arch/arm64/Kconfig
@@ -13,7 +13,7 @@ config ARM64
 	select ARCH_HAS_ACPI_TABLE_UPGRADE if ACPI
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
diff -puN arch/arm64/include/asm/hugetlb.h~mm-hugetlb-cleanup-arch_has_gigantic_page arch/arm64/include/asm/hugetlb.h
--- a/arch/arm64/include/asm/hugetlb.h~mm-hugetlb-cleanup-arch_has_gigantic_page
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -83,4 +83,8 @@ extern void huge_ptep_set_wrprotect(stru
 extern void huge_ptep_clear_flush(struct vm_area_struct *vma,
 				  unsigned long addr, pte_t *ptep);
 
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+static inline bool gigantic_page_supported(void) { return true; }
+#endif
+
 #endif /* __ASM_HUGETLB_H */
diff -puN arch/s390/Kconfig~mm-hugetlb-cleanup-arch_has_gigantic_page arch/s390/Kconfig
--- a/arch/s390/Kconfig~mm-hugetlb-cleanup-arch_has_gigantic_page
+++ a/arch/s390/Kconfig
@@ -68,7 +68,7 @@ config S390
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SG_CHAIN
diff -puN arch/s390/include/asm/hugetlb.h~mm-hugetlb-cleanup-arch_has_gigantic_page arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-cleanup-arch_has_gigantic_page
+++ a/arch/s390/include/asm/hugetlb.h
@@ -112,4 +112,7 @@ static inline pte_t huge_pte_modify(pte_
 	return pte_modify(pte, newprot);
 }
 
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+static inline bool gigantic_page_supported(void) { return true; }
+#endif
 #endif /* _ASM_S390_HUGETLB_H */
diff -puN arch/x86/Kconfig~mm-hugetlb-cleanup-arch_has_gigantic_page arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-hugetlb-cleanup-arch_has_gigantic_page
+++ a/arch/x86/Kconfig
@@ -22,7 +22,7 @@ config X86_64
 	def_bool y
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
-	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	select ARCH_SUPPORTS_INT128
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select HAVE_ARCH_SOFT_DIRTY
diff -puN arch/x86/include/asm/hugetlb.h~mm-hugetlb-cleanup-arch_has_gigantic_page arch/x86/include/asm/hugetlb.h
--- a/arch/x86/include/asm/hugetlb.h~mm-hugetlb-cleanup-arch_has_gigantic_page
+++ a/arch/x86/include/asm/hugetlb.h
@@ -85,4 +85,8 @@ static inline void arch_clear_hugepage_f
 {
 }
 
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+static inline bool gigantic_page_supported(void) { return true; }
+#endif
+
 #endif /* _ASM_X86_HUGETLB_H */
diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-arch_has_gigantic_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-arch_has_gigantic_page
+++ a/mm/hugetlb.c
@@ -1040,9 +1040,7 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && \
-	((defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || \
-	defined(CONFIG_CMA))
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 static void destroy_compound_gigantic_page(struct page *page,
 					unsigned int order)
 {
@@ -1174,8 +1172,7 @@ static int alloc_fresh_gigantic_page(str
 	return 0;
 }
 
-static inline bool gigantic_page_supported(void) { return true; }
-#else
+#else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
 static inline bool gigantic_page_supported(void) { return false; }
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
 static inline void destroy_compound_gigantic_page(struct page *page,
_

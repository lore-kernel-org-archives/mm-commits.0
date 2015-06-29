From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:42 -0700
Message-ID: <5591ad0e.r+1ryMddnV8OD6bC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbbF2Ujn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove arch_prepare/release_hugepage from arch headers
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: mm/hugetlb: remove arch_prepare/release_hugepage from arch headers

Nobody used these hooks so they were removed from common code, and can now
be removed from the architectures.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/hugetlb.h     |    9 ---------
 arch/arm64/include/asm/hugetlb.h   |    9 ---------
 arch/ia64/include/asm/hugetlb.h    |    9 ---------
 arch/metag/include/asm/hugetlb.h   |    9 ---------
 arch/mips/include/asm/hugetlb.h    |    9 ---------
 arch/powerpc/include/asm/hugetlb.h |    9 ---------
 arch/sh/include/asm/hugetlb.h      |    9 ---------
 arch/sparc/include/asm/hugetlb.h   |    9 ---------
 arch/tile/include/asm/hugetlb.h    |    9 ---------
 arch/x86/include/asm/hugetlb.h     |    9 ---------
 10 files changed, 90 deletions(-)

diff -puN arch/arm/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/arm/include/asm/hugetlb.h
--- a/arch/arm/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/arm/include/asm/hugetlb.h
@@ -63,15 +63,6 @@ static inline pte_t huge_pte_wrprotect(p
 	return pte_wrprotect(pte);
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 	clear_bit(PG_dcache_clean, &page->flags);
diff -puN arch/arm64/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/arm64/include/asm/hugetlb.h
--- a/arch/arm64/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -96,15 +96,6 @@ static inline pte_t huge_pte_wrprotect(p
 	return pte_wrprotect(pte);
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 	clear_bit(PG_dcache_clean, &page->flags);
diff -puN arch/ia64/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/ia64/include/asm/hugetlb.h
--- a/arch/ia64/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/ia64/include/asm/hugetlb.h
@@ -65,15 +65,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
diff -puN arch/metag/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/metag/include/asm/hugetlb.h
--- a/arch/metag/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/metag/include/asm/hugetlb.h
@@ -67,15 +67,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
diff -puN arch/mips/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/mips/include/asm/hugetlb.h
--- a/arch/mips/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/mips/include/asm/hugetlb.h
@@ -110,15 +110,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
diff -puN arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/powerpc/include/asm/hugetlb.h
--- a/arch/powerpc/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -168,15 +168,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
diff -puN arch/sh/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/sh/include/asm/hugetlb.h
--- a/arch/sh/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/sh/include/asm/hugetlb.h
@@ -79,15 +79,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 	clear_bit(PG_dcache_clean, &page->flags);
diff -puN arch/sparc/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/sparc/include/asm/hugetlb.h
--- a/arch/sparc/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -78,15 +78,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
diff -puN arch/tile/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/tile/include/asm/hugetlb.h
--- a/arch/tile/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/tile/include/asm/hugetlb.h
@@ -94,15 +94,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}
-
 static inline void arch_clear_hugepage_flags(struct page *page)
 {
 }
diff -puN arch/x86/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers arch/x86/include/asm/hugetlb.h
--- a/arch/x86/include/asm/hugetlb.h~mm-hugetlb-remove-arch_prepare-release_hugepage-from-arch-headers
+++ a/arch/x86/include/asm/hugetlb.h
@@ -80,15 +80,6 @@ static inline pte_t huge_ptep_get(pte_t
 	return *ptep;
 }
 
-static inline int arch_prepare_hugepage(struct page *page)
-{
-	return 0;
-}
-
-static inline void arch_release_hugepage(struct page *page)
-{
-}

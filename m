Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CC32AEF1
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 23:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741045659; cv=none; b=blLbX5aCww+JIBQPdADEGEWB5rdyPiSIlTOR+ZekAewHVZLKNsLxJC0HZLRf1wNy0mTYRUwCt9FV9/Y+6E1JS0q/RIz5dFigwz6CAGBnRjjrRV2sJ16ROu2teOIaXmELKa8rjXZYYveCGsHddph0Fa0wlZA1X1BTI+4/sxWhGP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741045659; c=relaxed/simple;
	bh=CnZjCtfgOCt2z8TgiqpGq3OtSsXKjaoRQRC8Fksw/Ec=;
	h=Date:To:From:Subject:Message-Id; b=otA8nZve5JpZlF6ZrIWtqAQAXSaBqajOUQoXWIsguFMOU/qXFyYDPYXT9VbUFjOFH8jZkr2D+5aPelT135KCgrEfms8hy/ikk68JVxdhM7nwn28x9K2HDewfdDyeiAPrJShqCtWd/LsWlYF1xGrndvp+SycWtUi2H0Jp3cJclSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BPVVuCtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BPVVuCtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39838C4CEE8;
	Mon,  3 Mar 2025 23:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741045658;
	bh=CnZjCtfgOCt2z8TgiqpGq3OtSsXKjaoRQRC8Fksw/Ec=;
	h=Date:To:From:Subject:From;
	b=BPVVuCtAZJLoSuCFMqEssRA2tcZUeq8uS4EHVpEj++9puaufxwwBCDZXxpSrMyyrq
	 qIh/9zlq6zHUKZ9im99vHbgOjsIN4k74e8lt5yBVAqy9cawBFNz+AVpv9DqT1UQdpx
	 JBwDoLoTATLGrdK+lEnW+hslIiClC/Azet1JtZnk=
Date: Mon, 03 Mar 2025 15:47:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,geert@linux-m68k.org,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2.patch added to mm-unstable branch
Message-Id: <20250303234738.39838C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
Date: Mon, 3 Mar 2025 15:26:03 +0800

remove the do { ... } while construct, per Geert

Link: https://lkml.kernel.org/r/20250303072603.45423-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgalloc.h      |    6 ++----
 arch/hexagon/include/asm/pgalloc.h   |    6 ++----
 arch/loongarch/include/asm/pgalloc.h |    6 ++----
 arch/m68k/include/asm/sun3_pgalloc.h |    6 ++----
 arch/mips/include/asm/pgalloc.h      |    6 ++----
 arch/nios2/include/asm/pgalloc.h     |    6 ++----
 arch/openrisc/include/asm/pgalloc.h  |    6 ++----
 arch/sh/include/asm/pgalloc.h        |    6 ++----
 arch/um/include/asm/pgalloc.h        |   18 ++++++------------
 9 files changed, 22 insertions(+), 44 deletions(-)

--- a/arch/csky/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/csky/include/asm/pgalloc.h
@@ -61,10 +61,8 @@ static inline pgd_t *pgd_alloc(struct mm
 	return ret;
 }
 
-#define __pte_free_tlb(tlb, pte, address)		\
-do {							\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 extern void pagetable_init(void);
 extern void mmu_init(unsigned long min_pfn, unsigned long max_pfn);
--- a/arch/hexagon/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -87,9 +87,7 @@ static inline void pmd_populate_kernel(s
 		max_kernel_seg = pmdindex;
 }
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
--- a/arch/loongarch/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -55,10 +55,8 @@ static inline pte_t *pte_alloc_one_kerne
 	return pte;
 }
 
-#define __pte_free_tlb(tlb, pte, address)			\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte));
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -17,10 +17,8 @@
 
 extern const char bad_pmd_string[];
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
 {
--- a/arch/mips/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/mips/include/asm/pgalloc.h
@@ -48,10 +48,8 @@ static inline void pud_populate(struct m
 extern void pgd_init(void *addr);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, address)			\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
--- a/arch/nios2/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/nios2/include/asm/pgalloc.h
@@ -28,9 +28,7 @@ static inline void pmd_populate(struct m
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif /* _ASM_NIOS2_PGALLOC_H */
--- a/arch/openrisc/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -64,9 +64,7 @@ extern inline pgd_t *pgd_alloc(struct mm
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
--- a/arch/sh/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/sh/include/asm/pgalloc.h
@@ -32,9 +32,7 @@ static inline void pmd_populate(struct m
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif /* __ASM_SH_PGALLOC_H */
--- a/arch/um/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2
+++ a/arch/um/include/asm/pgalloc.h
@@ -25,24 +25,18 @@
  */
 extern pgd_t *pgd_alloc(struct mm_struct *);
 
-#define __pte_free_tlb(tlb, pte, address)			\
-do {								\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));		\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
-#define __pmd_free_tlb(tlb, pmd, address)			\
-do {								\
-	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd));		\
-} while (0)
+#define __pmd_free_tlb(tlb, pmd, address)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
-#define __pud_free_tlb(tlb, pud, address)			\
-do {								\
-	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pud));		\
-} while (0)
+#define __pud_free_tlb(tlb, pud, address)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pud))
 
 #endif
 #endif
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

arm-pgtable-fix-null-pointer-dereference-issue.patch
mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch
mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2.patch
riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch
x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch
mm-pgtable-remove-tlb_remove_page_ptdesc.patch


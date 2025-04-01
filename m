Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1043621D3F9
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545898; cv=none; b=lzI1WQ8gJU/ezj2chmugg1zzhRGqx987oExNaroAH3ri1I78pwGTgYJ6eQnrMTRimpzoM9+WhutZPxRqjAFS8xrdBkGm2YDotGWw53vi963Gm+dSCHJeGjd57iixTk8gFyO7HX0oljw4gxtpWjj+I4fInBkzlaQ2Z+xRX2jst3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545898; c=relaxed/simple;
	bh=o5ELKiPt6UeSS4D3BEsZ5bvgE5qZZuMx205wQJ4ghtE=;
	h=Date:To:From:Subject:Message-Id; b=HIkpaAJrdiz5AFvwIymTIq3CqYtsR2RHRWUDCxpZ38ZxqYYDgLuMfyJVvVzXEXkgbEhmjdFZ0nd3XfeAkWaZL4tzKF+W/VjQc4/Dw1jvrP5mQ78InS7/Viu8G9O8Vh4H5GxPjMrLL0SG5TAVDGVPACbQSBSeKcvLGT+6MEyz2+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZboI6b7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZboI6b7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736D9C4CEEB;
	Tue,  1 Apr 2025 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545897;
	bh=o5ELKiPt6UeSS4D3BEsZ5bvgE5qZZuMx205wQJ4ghtE=;
	h=Date:To:From:Subject:From;
	b=ZboI6b7KkCOkwnJgvgUoYei7a+Vo8UtmzVFN3DTgml8rwdsic+23bM/8+2wEeZf/n
	 JQ83q1MRns2Rv9UA0XqqylytGp1OuTLEbypE/MFasIQfTFw6+8c2OAuNnScUoc8wtj
	 aV8UY3KQ7u7BKr6OToEIzcHnVU/UEj9D3RZcwMQA=
Date: Tue, 01 Apr 2025 15:18:16 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,geert@linux-m68k.org,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch removed from -mm tree
Message-Id: <20250401221817.736D9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: convert some architectures to use tlb_remove_ptdesc()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: convert some architectures to use tlb_remove_ptdesc()
Date: Tue, 25 Feb 2025 11:45:53 +0800

Now, the nine architectures of csky, hexagon, loongarch, m68k, mips,
nios2, openrisc, sh and um do not select CONFIG_MMU_GATHER_RCU_TABLE_FREE,
and just call pagetable_dtor() + tlb_remove_page_ptdesc() (the wrapper of
tlb_remove_page()).  This is the same as the implementation of
tlb_remove_{ptdesc|table}() under !CONFIG_MMU_GATHER_TABLE_FREE, so
convert these architectures to use tlb_remove_ptdesc().

The ultimate goal is to make the architecture only use tlb_remove_ptdesc()
or tlb_remove_table() for page table pages.

[zhengqi.arch@bytedance.com: v2]
  Link: https://lkml.kernel.org/r/20250303072603.45423-1-zhengqi.arch@bytedance.com
[akpm@linux-foundation.org: remove trailing semi in arch/loongarch/include/asm/pgalloc.h]
Link: https://lkml.kernel.org/r/19db3e8673b67bad2f1df1ab37f1c89d99eacfea.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
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

 arch/csky/include/asm/pgalloc.h      |    7 ++-----
 arch/hexagon/include/asm/pgalloc.h   |    7 ++-----
 arch/loongarch/include/asm/pgalloc.h |    7 ++-----
 arch/m68k/include/asm/sun3_pgalloc.h |    7 ++-----
 arch/mips/include/asm/pgalloc.h      |    7 ++-----
 arch/nios2/include/asm/pgalloc.h     |    7 ++-----
 arch/openrisc/include/asm/pgalloc.h  |    7 ++-----
 arch/sh/include/asm/pgalloc.h        |    7 ++-----
 arch/um/include/asm/pgalloc.h        |   21 ++++++---------------
 9 files changed, 22 insertions(+), 55 deletions(-)

--- a/arch/csky/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/csky/include/asm/pgalloc.h
@@ -61,11 +61,8 @@ static inline pgd_t *pgd_alloc(struct mm
 	return ret;
 }
 
-#define __pte_free_tlb(tlb, pte, address)		\
-do {							\
-	pagetable_dtor(page_ptdesc(pte));		\
-	tlb_remove_page_ptdesc(tlb, page_ptdesc(pte));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 extern void pagetable_init(void);
 extern void mmu_init(unsigned long min_pfn, unsigned long max_pfn);
--- a/arch/hexagon/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -87,10 +87,7 @@ static inline void pmd_populate_kernel(s
 		max_kernel_seg = pmdindex;
 }
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	pagetable_dtor((page_ptdesc(pte)));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
--- a/arch/loongarch/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -55,11 +55,8 @@ static inline pte_t *pte_alloc_one_kerne
 	return pte;
 }
 
-#define __pte_free_tlb(tlb, pte, address)			\
-do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -17,11 +17,8 @@
 
 extern const char bad_pmd_string[];
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
 {
--- a/arch/mips/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/mips/include/asm/pgalloc.h
@@ -48,11 +48,8 @@ static inline void pud_populate(struct m
 extern void pgd_init(void *addr);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, address)			\
-do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
--- a/arch/nios2/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/nios2/include/asm/pgalloc.h
@@ -28,10 +28,7 @@ static inline void pmd_populate(struct m
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, addr)					\
-	do {								\
-		pagetable_dtor(page_ptdesc(pte));			\
-		tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
-	} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif /* _ASM_NIOS2_PGALLOC_H */
--- a/arch/openrisc/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -64,10 +64,7 @@ extern inline pgd_t *pgd_alloc(struct mm
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
--- a/arch/sh/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/sh/include/asm/pgalloc.h
@@ -32,10 +32,7 @@ static inline void pmd_populate(struct m
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
 
-#define __pte_free_tlb(tlb, pte, addr)				\
-do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, addr)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif /* __ASM_SH_PGALLOC_H */
--- a/arch/um/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc
+++ a/arch/um/include/asm/pgalloc.h
@@ -25,27 +25,18 @@
  */
 extern pgd_t *pgd_alloc(struct mm_struct *);
 
-#define __pte_free_tlb(tlb, pte, address)			\
-do {								\
-	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
-} while (0)
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
-#define __pmd_free_tlb(tlb, pmd, address)			\
-do {								\
-	pagetable_dtor(virt_to_ptdesc(pmd));			\
-	tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pmd));	\
-} while (0)
+#define __pmd_free_tlb(tlb, pmd, address)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
-#define __pud_free_tlb(tlb, pud, address)			\
-do {								\
-	pagetable_dtor(virt_to_ptdesc(pud));		\
-	tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pud));	\
-} while (0)
+#define __pud_free_tlb(tlb, pud, address)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pud))
 
 #endif
 #endif
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are



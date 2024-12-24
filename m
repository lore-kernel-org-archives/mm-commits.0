Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A645C442C
	for <mm-commits@vger.kernel.org>; Tue, 24 Dec 2024 00:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735001141; cv=none; b=rD3GoJ22F0i+W0fbz/omxEbE8odavrMHD1IGUZ33oiesnBSvEXPKbmry8ZdQq7CfYSixxd5ws40Q1c32+xOe7b2zG/X3ltFZ9UAUx5aGCdO8tinH3hSuaM9npq6RJTmVjLjo5GsKvznnIprC/+MfHHD0edI8OEVGn6JIrKR/MtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735001141; c=relaxed/simple;
	bh=RJKuwr8deAzGbIwyJvv2MXuOt/grcAFaB+jpf7Hp0lY=;
	h=Date:To:From:Subject:Message-Id; b=XQalcBqNIzBxRIQAWEjKL1ZeupKVEcL1S5+ueuIcSEQXlMBcEvo1CM/6kgiPEI3aPhmKzwAhmBZ6Ss16736nwm5xrRmKEQ8SVAoe/o3apuRhAZyqL/YC0Xy1+F9sS6ZClLlY/iUeNPqk7ThJRpLXuW03+5kL6YATh0aB4iwx8uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PI+82ghR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PI+82ghR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AB4C4CED3;
	Tue, 24 Dec 2024 00:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735001141;
	bh=RJKuwr8deAzGbIwyJvv2MXuOt/grcAFaB+jpf7Hp0lY=;
	h=Date:To:From:Subject:From;
	b=PI+82ghRx7J7hS2CaZnFZ91XTpSajAvEDyq1rDxlw4icSMIeAYnGApdlDP8c8fcp0
	 Qf6BMIkpHDVcd6VBdYtDWwGUMM6QbHQBi9LrCbVEniM3RMS4rcQ52AiIn5oR2GiFDz
	 SigLcD2bHpGCGTJPh/URVoJNhwCfuhorE/eIWNZU=
Date: Mon, 23 Dec 2024 16:45:40 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-remove-tlb_remove_page_ptdesc.patch added to mm-unstable branch
Message-Id: <20241224004541.47AB4C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: remove tlb_remove_page_ptdesc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-remove-tlb_remove_page_ptdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-remove-tlb_remove_page_ptdesc.patch

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
Subject: mm: pgtable: remove tlb_remove_page_ptdesc()
Date: Mon, 23 Dec 2024 17:41:01 +0800

Here we are explicitly dealing with struct page, and the following logic
semms strange:

tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));

tlb_remove_page_ptdesc
--> tlb_remove_page(tlb, ptdesc_page(pt));

So remove tlb_remove_page_ptdesc() and make callers call tlb_remove_page()
directly.

Link: https://lkml.kernel.org/r/b37435768345e0fcf7ea358f69b4a71767f0f530.1734945104.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgalloc.h      |    2 +-
 arch/hexagon/include/asm/pgalloc.h   |    2 +-
 arch/loongarch/include/asm/pgalloc.h |    2 +-
 arch/m68k/include/asm/sun3_pgalloc.h |    2 +-
 arch/mips/include/asm/pgalloc.h      |    2 +-
 arch/nios2/include/asm/pgalloc.h     |    2 +-
 arch/openrisc/include/asm/pgalloc.h  |    2 +-
 arch/riscv/include/asm/pgalloc.h     |    2 +-
 arch/sh/include/asm/pgalloc.h        |    2 +-
 arch/um/include/asm/pgalloc.h        |    8 ++++----
 include/asm-generic/tlb.h            |    6 ------
 11 files changed, 13 insertions(+), 19 deletions(-)

--- a/arch/csky/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/csky/include/asm/pgalloc.h
@@ -64,7 +64,7 @@ static inline pgd_t *pgd_alloc(struct mm
 #define __pte_free_tlb(tlb, pte, address)		\
 do {							\
 	pagetable_dtor(page_ptdesc(pte));		\
-	tlb_remove_page_ptdesc(tlb, page_ptdesc(pte));	\
+	tlb_remove_page(tlb, (pte));			\
 } while (0)
 
 extern void pagetable_init(void);
--- a/arch/hexagon/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/hexagon/include/asm/pgalloc.h
@@ -90,7 +90,7 @@ static inline void pmd_populate_kernel(s
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
 	pagetable_dtor((page_ptdesc(pte)));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_page((tlb), (pte));				\
 } while (0)
 
 #endif
--- a/arch/loongarch/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -58,7 +58,7 @@ static inline pte_t *pte_alloc_one_kerne
 #define __pte_free_tlb(tlb, pte, address)			\
 do {								\
 	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
+	tlb_remove_page((tlb), (pte));				\
 } while (0)
 
 #ifndef __PAGETABLE_PMD_FOLDED
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -20,7 +20,7 @@ extern const char bad_pmd_string[];
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
 	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
+	tlb_remove_page((tlb), (pte));				\
 } while (0)
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
--- a/arch/mips/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/mips/include/asm/pgalloc.h
@@ -57,7 +57,7 @@ static inline void pgd_free(struct mm_st
 #define __pte_free_tlb(tlb, pte, address)			\
 do {								\
 	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
+	tlb_remove_page((tlb), (pte));				\
 } while (0)
 
 #ifndef __PAGETABLE_PMD_FOLDED
--- a/arch/nios2/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/nios2/include/asm/pgalloc.h
@@ -31,7 +31,7 @@ extern pgd_t *pgd_alloc(struct mm_struct
 #define __pte_free_tlb(tlb, pte, addr)					\
 	do {								\
 		pagetable_dtor(page_ptdesc(pte));			\
-		tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+		tlb_remove_page((tlb), (pte));				\
 	} while (0)
 
 #endif /* _ASM_NIOS2_PGALLOC_H */
--- a/arch/openrisc/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -69,7 +69,7 @@ extern pte_t *pte_alloc_one_kernel(struc
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
 	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_page((tlb), (pte));				\
 } while (0)
 
 #endif
--- a/arch/riscv/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -29,7 +29,7 @@ static inline void riscv_tlb_remove_ptde
 		tlb_remove_ptdesc(tlb, pt);
 	} else {
 		pagetable_dtor(pt);
-		tlb_remove_page_ptdesc(tlb, pt);
+		tlb_remove_page(tlb, ptdesc_page((struct ptdesc *)pt));
 	}
 }
 
--- a/arch/sh/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/sh/include/asm/pgalloc.h
@@ -35,7 +35,7 @@ static inline void pmd_populate(struct m
 #define __pte_free_tlb(tlb, pte, addr)				\
 do {								\
 	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_page((tlb), (pte));				\
 } while (0)
 
 #endif /* __ASM_SH_PGALLOC_H */
--- a/arch/um/include/asm/pgalloc.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/arch/um/include/asm/pgalloc.h
@@ -28,7 +28,7 @@ extern pgd_t *pgd_alloc(struct mm_struct
 #define __pte_free_tlb(tlb, pte, address)			\
 do {								\
 	pagetable_dtor(page_ptdesc(pte));			\
-	tlb_remove_page_ptdesc((tlb), (page_ptdesc(pte)));	\
+	tlb_remove_page((tlb), (pte));				\
 } while (0)
 
 #if CONFIG_PGTABLE_LEVELS > 2
@@ -36,15 +36,15 @@ do {								\
 #define __pmd_free_tlb(tlb, pmd, address)			\
 do {								\
 	pagetable_dtor(virt_to_ptdesc(pmd));			\
-	tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pmd));	\
+	tlb_remove_page((tlb), virt_to_page(pmd));		\
 } while (0)
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
 #define __pud_free_tlb(tlb, pud, address)			\
 do {								\
-	pagetable_dtor(virt_to_ptdesc(pud));		\
-	tlb_remove_page_ptdesc((tlb), virt_to_ptdesc(pud));	\
+	pagetable_dtor(virt_to_ptdesc(pud));			\
+	tlb_remove_page((tlb), virt_to_page(pud));		\
 } while (0)
 
 #endif
--- a/include/asm-generic/tlb.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/include/asm-generic/tlb.h
@@ -504,12 +504,6 @@ static inline void tlb_remove_ptdesc(str
 	tlb_remove_table(tlb, pt);
 }
 
-/* Like tlb_remove_ptdesc, but for page-like page directories. */
-static inline void tlb_remove_page_ptdesc(struct mmu_gather *tlb, struct ptdesc *pt)
-{
-	tlb_remove_page(tlb, ptdesc_page(pt));
-}
-
 static inline void tlb_change_page_size(struct mmu_gather *tlb,
 						     unsigned int page_size)
 {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
mm-pgtable-make-ptlock-be-freed-by-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch
revert-mm-pgtable-make-ptlock-be-freed-by-rcu.patch
mm-pgtable-add-statistics-for-p4d-level-page-table.patch
arm64-pgtable-use-mmu-gather-to-free-p4d-level-page-table.patch
s390-pgtable-add-statistics-for-pud-and-p4d-level-page-table.patch
mm-pgtable-introduce-pagetable_dtor.patch
arm-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
arm64-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
riscv-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
s390-pgtable-also-move-pagetable_dtor-of-pxd-to-__tlb_remove_table.patch
mm-pgtable-introduce-generic-__tlb_remove_table.patch
mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file.patch
mm-pgtable-remove-tlb_remove_page_ptdesc.patch
mm-pgtable-remove-tlb_remove_ptdesc.patch
mm-pgtable-introduce-generic-pagetable_dtor_free.patch


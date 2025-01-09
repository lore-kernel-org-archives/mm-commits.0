Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2592747F
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398844; cv=none; b=gBOq5mB7hZgxzGMwA5TIOcmFs3UPsfuflKsqbgW6YgbAE0SDKG6aXIWWDNf6Gv80lb1foMIPMSoQXX67DJ70F3n67g5II3XuMVNOdZnSxHVB1IpaXo1Y9SY1dv7qTRxdXZ4i287dG6GsmKIrD9u0eNFPZCYAX1UV9b0cGVf+SOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398844; c=relaxed/simple;
	bh=G3TWnAXHboLQY5BZB0jYznlrwcEOuxcQgpByYNkiEyw=;
	h=Date:To:From:Subject:Message-Id; b=FQDvPHjqu31vkkPSc5vwFpTrFu1Qdar0dfc1AJURHeCU211ghFdLTyE9oorMhkh4IC+BMXEgRt/g2/40eS0U4T3O93IVinX39o1WLvX9WXFxe9HYkXL5jeAsYusLGnKNAYspmWfXs7hdUauLsjC7ZcUpqLk9mVgmSHz07FjnYYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pIa4YXwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pIa4YXwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7C9C4CED2;
	Thu,  9 Jan 2025 05:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736398843;
	bh=G3TWnAXHboLQY5BZB0jYznlrwcEOuxcQgpByYNkiEyw=;
	h=Date:To:From:Subject:From;
	b=pIa4YXwMuZ5lQbVpPg3IK7dGvd7yrZ86tFx1NJX7X9ub5FDpf5Ped10hSC8sBYEch
	 cuH3GuM3I+xekGdQhD7pXRuQVAzSqcfsi2Rl/kVF+1+/IRrYx76IagHg16HPbL5wEG
	 29W//wtgjeg7MYutDpYnT1H0Eah0PjAKen6LwbdM=
Date: Wed, 08 Jan 2025 21:00:42 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-add-statistics-for-p4d-level-page-table.patch added to mm-unstable branch
Message-Id: <20250109050043.6D7C9C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: add statistics for P4D level page table
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-add-statistics-for-p4d-level-page-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-add-statistics-for-p4d-level-page-table.patch

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
Subject: mm: pgtable: add statistics for P4D level page table
Date: Wed, 8 Jan 2025 14:57:20 +0800

Like other levels of page tables, add statistics for P4D level page table.

Link: https://lkml.kernel.org/r/d55fe3c286305aae84457da9e1066df99b3de125.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgalloc.h |    6 +++++-
 arch/x86/mm/pgtable.c            |    3 +++
 include/asm-generic/pgalloc.h    |    2 ++
 include/linux/mm.h               |   16 ++++++++++++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgalloc.h~mm-pgtable-add-statistics-for-p4d-level-page-table
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -108,8 +108,12 @@ static inline void __pud_free_tlb(struct
 static inline void __p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d,
 				  unsigned long addr)
 {
-	if (pgtable_l5_enabled)
+	if (pgtable_l5_enabled) {
+		struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
+
+		pagetable_p4d_dtor(ptdesc);
 		riscv_tlb_remove_ptdesc(tlb, virt_to_ptdesc(p4d));
+	}
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
--- a/arch/x86/mm/pgtable.c~mm-pgtable-add-statistics-for-p4d-level-page-table
+++ a/arch/x86/mm/pgtable.c
@@ -94,6 +94,9 @@ void ___pud_free_tlb(struct mmu_gather *
 #if CONFIG_PGTABLE_LEVELS > 4
 void ___p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d)
 {
+	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
+
+	pagetable_p4d_dtor(ptdesc);
 	paravirt_release_p4d(__pa(p4d) >> PAGE_SHIFT);
 	paravirt_tlb_remove_table(tlb, virt_to_page(p4d));
 }
--- a/include/asm-generic/pgalloc.h~mm-pgtable-add-statistics-for-p4d-level-page-table
+++ a/include/asm-generic/pgalloc.h
@@ -230,6 +230,7 @@ static inline p4d_t *__p4d_alloc_one_nop
 	if (!ptdesc)
 		return NULL;
 
+	pagetable_p4d_ctor(ptdesc);
 	return ptdesc_address(ptdesc);
 }
 #define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
@@ -247,6 +248,7 @@ static inline void __p4d_free(struct mm_
 	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
 
 	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
+	pagetable_p4d_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
--- a/include/linux/mm.h~mm-pgtable-add-statistics-for-p4d-level-page-table
+++ a/include/linux/mm.h
@@ -3175,6 +3175,22 @@ static inline void pagetable_pud_dtor(st
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+}
+
+static inline void pagetable_p4d_dtor(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	__folio_clear_pgtable(folio);
+	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+}
+
 extern void __init pagecache_init(void);
 extern void free_initmem(void);
 
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
x86-pgtable-convert-__tlb_remove_table-to-use-struct-ptdesc.patch
x86-pgtable-move-pagetable_dtor-to-__tlb_remove_table.patch
s390-pgtable-consolidate-pxd-and-pte-tlb-free-paths.patch
mm-pgtable-introduce-generic-__tlb_remove_table.patch
mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch
mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file.patch
mm-pgtable-introduce-generic-pagetable_dtor_free.patch


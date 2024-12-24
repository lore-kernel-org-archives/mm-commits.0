Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11E74C96
	for <mm-commits@vger.kernel.org>; Tue, 24 Dec 2024 00:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735001133; cv=none; b=ujVlHnrjzlKOf1kOhemf7bathHdJ0ltu4a2gsGPetcT1aJ8YfitBtB/GNJgnjANEGBv8EcVkHKtPSJ0DwdsIPPmUGgKPSsxEC7nKaqs35D8GM/YYGuonrCFdIoZTbh6N5+aA99gCEBp+Aqf0V0vi7JvcahU8SEP9FVFlS25RKm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735001133; c=relaxed/simple;
	bh=g3x/oI/G6GzQFu7JPspvdBbDnwYJEv6JZCklyRtMRPM=;
	h=Date:To:From:Subject:Message-Id; b=EQUc+vK+15s4/U2T68RJAYgO40OenwWzOBWOGXT9pRqS+KJKk5DycgyBcrWwyhhVWLFioiZMiNQbpnQnas29a+ZRfcM5m3ykn6PWgmLs1BSQrSBye7B8Kik0LIXZYGJrh+kawevrKa4eHtWNFeuTaVUasr1H3ewqnjZjpeyAa24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQ94H5KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQ94H5KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B1C4CED3;
	Tue, 24 Dec 2024 00:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735001133;
	bh=g3x/oI/G6GzQFu7JPspvdBbDnwYJEv6JZCklyRtMRPM=;
	h=Date:To:From:Subject:From;
	b=AQ94H5KQ3owtEzItzakfELxlJyicUlLFezQhSNURNag0blTCfEywuQwBE7/IStNho
	 0O/WrOxQjMl3Tc3i1DvSJYCjmMh9GIO7jpqaveB6NQucb/o0rR8+fzI/osFTTzDNcc
	 +mePbWGVVFVYsiW5Tv8lypHPyaSOInpgY1Llr1Zw=
Date: Mon, 23 Dec 2024 16:45:32 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-introduce-generic-__tlb_remove_table.patch added to mm-unstable branch
Message-Id: <20241224004533.3F7B1C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: introduce generic __tlb_remove_table()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-introduce-generic-__tlb_remove_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-introduce-generic-__tlb_remove_table.patch

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
Subject: mm: pgtable: introduce generic __tlb_remove_table()
Date: Mon, 23 Dec 2024 17:40:59 +0800

Several architectures (arm, arm64, riscv and x86) define exactly the same
__tlb_remove_table(), just introduce generic __tlb_remove_table() to
eliminate these duplications.

The s390 __tlb_remove_table() is nearly the same, so also make s390
__tlb_remove_table() version generic.

Link: https://lkml.kernel.org/r/f7febc7719fd84673a8eae8af71b7b4278d3e110.1734945104.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
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
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h      |    9 ---------
 arch/arm64/include/asm/tlb.h    |    7 -------
 arch/powerpc/include/asm/tlb.h  |    1 +
 arch/riscv/include/asm/tlb.h    |   12 ------------
 arch/s390/include/asm/tlb.h     |    9 ++++-----
 arch/s390/mm/pgalloc.c          |    7 -------
 arch/sparc/include/asm/tlb_32.h |    1 +
 arch/sparc/include/asm/tlb_64.h |    1 +
 arch/x86/include/asm/tlb.h      |   17 -----------------
 include/asm-generic/tlb.h       |   15 +++++++++++++--
 10 files changed, 20 insertions(+), 59 deletions(-)

--- a/arch/arm64/include/asm/tlb.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/arm64/include/asm/tlb.h
@@ -10,13 +10,6 @@
 
 #include <linux/pagemap.h>
 
-static inline void __tlb_remove_table(void *_table)
-{
-	struct ptdesc *ptdesc = (struct ptdesc *)_table;
-
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
-}
 
 #define tlb_flush tlb_flush
 static void tlb_flush(struct mmu_gather *tlb);
--- a/arch/arm/include/asm/tlb.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/arm/include/asm/tlb.h
@@ -27,15 +27,6 @@
 #else /* !CONFIG_MMU */
 
 #include <asm/tlbflush.h>
-
-static inline void __tlb_remove_table(void *_table)
-{
-	struct ptdesc *ptdesc = (struct ptdesc *)_table;
-
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
-}
-
 #include <asm-generic/tlb.h>
 
 static inline void
--- a/arch/powerpc/include/asm/tlb.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/powerpc/include/asm/tlb.h
@@ -37,6 +37,7 @@ extern void tlb_flush(struct mmu_gather
  */
 #define tlb_needs_table_invalidate()	radix_enabled()
 
+#define __HAVE_ARCH_TLB_REMOVE_TABLE
 /* Get the generic bits... */
 #include <asm-generic/tlb.h>
 
--- a/arch/riscv/include/asm/tlb.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/riscv/include/asm/tlb.h
@@ -10,18 +10,6 @@ struct mmu_gather;
 
 static void tlb_flush(struct mmu_gather *tlb);
 
-#ifdef CONFIG_MMU
-
-static inline void __tlb_remove_table(void *table)
-{
-	struct ptdesc *ptdesc = (struct ptdesc *)table;
-
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
-}
-
-#endif /* CONFIG_MMU */
-
 #define tlb_flush tlb_flush
 #include <asm-generic/tlb.h>
 
--- a/arch/s390/include/asm/tlb.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/s390/include/asm/tlb.h
@@ -22,7 +22,6 @@
  * Pages used for the page tables is a different story. FIXME: more
  */
 
-void __tlb_remove_table(void *_table);
 static inline void tlb_flush(struct mmu_gather *tlb);
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
 		struct page *page, bool delay_rmap, int page_size);
@@ -87,7 +86,7 @@ static inline void pte_free_tlb(struct m
 	tlb->cleared_pmds = 1;
 	if (mm_alloc_pgste(tlb->mm))
 		gmap_unlink(tlb->mm, (unsigned long *)pte, address);
-	tlb_remove_ptdesc(tlb, pte);
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pte));
 }
 
 /*
@@ -106,7 +105,7 @@ static inline void pmd_free_tlb(struct m
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_puds = 1;
-	tlb_remove_ptdesc(tlb, pmd);
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pmd));
 }
 
 /*
@@ -124,7 +123,7 @@ static inline void pud_free_tlb(struct m
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_p4ds = 1;
-	tlb_remove_ptdesc(tlb, pud);
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pud));
 }
 
 /*
@@ -142,7 +141,7 @@ static inline void p4d_free_tlb(struct m
 	__tlb_adjust_range(tlb, address, PAGE_SIZE);
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
-	tlb_remove_ptdesc(tlb, p4d);
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(p4d));
 }
 
 #endif /* _S390_TLB_H */
--- a/arch/s390/mm/pgalloc.c~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/s390/mm/pgalloc.c
@@ -193,13 +193,6 @@ void page_table_free(struct mm_struct *m
 	pagetable_dtor_free(ptdesc);
 }
 
-void __tlb_remove_table(void *table)
-{
-	struct ptdesc *ptdesc = virt_to_ptdesc(table);
-
-	pagetable_dtor_free(ptdesc);
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void pte_free_now(struct rcu_head *head)
 {
--- a/arch/sparc/include/asm/tlb_32.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/sparc/include/asm/tlb_32.h
@@ -2,6 +2,7 @@
 #ifndef _SPARC_TLB_H
 #define _SPARC_TLB_H
 
+#define __HAVE_ARCH_TLB_REMOVE_TABLE
 #include <asm-generic/tlb.h>
 
 #endif /* _SPARC_TLB_H */
--- a/arch/sparc/include/asm/tlb_64.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/sparc/include/asm/tlb_64.h
@@ -33,6 +33,7 @@ void flush_tlb_pending(void);
 #define tlb_needs_table_invalidate()	(false)
 #endif
 
+#define __HAVE_ARCH_TLB_REMOVE_TABLE
 #include <asm-generic/tlb.h>
 
 #endif /* _SPARC64_TLB_H */
--- a/arch/x86/include/asm/tlb.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/arch/x86/include/asm/tlb.h
@@ -20,23 +20,6 @@ static inline void tlb_flush(struct mmu_
 	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
 }
 
-/*
- * While x86 architecture in general requires an IPI to perform TLB
- * shootdown, enablement code for several hypervisors overrides
- * .flush_tlb_others hook in pv_mmu_ops and implements it by issuing
- * a hypercall. To keep software pagetable walkers safe in this case we
- * switch to RCU based table free (MMU_GATHER_RCU_TABLE_FREE). See the comment
- * below 'ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE' in include/asm-generic/tlb.h
- * for more details.
- */
-static inline void __tlb_remove_table(void *table)
-{
-	struct ptdesc *ptdesc = (struct ptdesc *)table;
-
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
-}
-
 #ifdef CONFIG_PT_RECLAIM
 static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
 {
--- a/include/asm-generic/tlb.h~mm-pgtable-introduce-generic-__tlb_remove_table
+++ a/include/asm-generic/tlb.h
@@ -153,8 +153,9 @@
  *
  *  Useful if your architecture has non-page page directories.
  *
- *  When used, an architecture is expected to provide __tlb_remove_table()
- *  which does the actual freeing of these pages.
+ *  When used, an architecture is expected to provide __tlb_remove_table() or
+ *  use the generic __tlb_remove_table(), which does the actual freeing of these
+ *  pages.
  *
  *  MMU_GATHER_RCU_TABLE_FREE
  *
@@ -207,6 +208,16 @@ struct mmu_table_batch {
 #define MAX_TABLE_BATCH		\
 	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(void *))
 
+#ifndef __HAVE_ARCH_TLB_REMOVE_TABLE
+static inline void __tlb_remove_table(void *table)
+{
+	struct ptdesc *ptdesc = (struct ptdesc *)table;
+
+	pagetable_dtor(ptdesc);
+	pagetable_free(ptdesc);
+}
+#endif
+
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
 #else /* !CONFIG_MMU_GATHER_HAVE_TABLE_FREE */
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


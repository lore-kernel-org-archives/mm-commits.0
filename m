Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F46B213E82
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398885; cv=none; b=fzlpPkR1Ov8coEhAQNP3f1q08RduCeVAhYAhdeaLkMSJ1DadcWfji8U6UvjnFQ1DHpf4y2JYrNhPE2X1rFT0pvc8p7ngER032srEBhHFt4AzwY1L1CSlb/zSUO1Bq++aVdY0HXPRPcZ7JHvucBER/Mw9ynYzGi479nmaJBf5xCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398885; c=relaxed/simple;
	bh=XuOeyRPBv2kZyBz5SmOofVhTcZB3D7G2gNaalT494O8=;
	h=Date:To:From:Subject:Message-Id; b=YDoGpCytq8fPAgIkuQxaKeAzQdBJcfrLrYVnRVmJPWHiVnHzO/eOqoz9nQDpRT+UIy3Jn4pCbUcXXMdyuIMGBR1gE2d9XRG6CefdOZEmhczwiHXvB4w1wQvty6s+DSDX9l1ppf3a57Y+/X5ZbgPF8W9on++HZ8mZQXLzG0lLtD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ir+kHy81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ir+kHy81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D780C4CED2;
	Thu,  9 Jan 2025 05:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736398885;
	bh=XuOeyRPBv2kZyBz5SmOofVhTcZB3D7G2gNaalT494O8=;
	h=Date:To:From:Subject:From;
	b=Ir+kHy81ser9K+jbYP25C0fKXy3gDOAI9QQ/FSoxMqneyWjC7pUUkz9ffaD3+bMjm
	 JpslR1iwIlfA/vdfHWVko/GjPsxw4j6Ze5S+hEzVnBqmn0gq5qlmQBMcKzY3QYu0hY
	 QMYC8RtSsVBPpjwnZyILGGT22AfvIjShOO/6k3QI=
Date: Wed, 08 Jan 2025 21:01:24 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch added to mm-unstable branch
Message-Id: <20250109050125.4D780C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: completely move pagetable_dtor() to generic tlb_remove_table()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table.patch

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
Subject: mm: pgtable: completely move pagetable_dtor() to generic tlb_remove_table()
Date: Wed, 8 Jan 2025 14:57:31 +0800

For the generic tlb_remove_table(), it is implemented in the following two
forms:

1) CONFIG_MMU_GATHER_TABLE_FREE is enabled

tlb_remove_table
--> generic __tlb_remove_table()

2) CONFIG_MMU_GATHER_TABLE_FREE is disabled

tlb_remove_table
--> tlb_remove_page

For case 1), the pagetable_dtor() has already been moved to generic
__tlb_remove_table().

For case 2), now only arm will call tlb_remove_table()/tlb_remove_ptdesc()
when CONFIG_MMU_GATHER_TABLE_FREE is disabled.  Let's move
pagetable_dtor() completely to generic tlb_remove_table(), so that the
architectures can follow more easily.

Link: https://lkml.kernel.org/r/0c733ac867b287ec08190676496d1decebf49da2.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
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
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h |    4 ----
 include/asm-generic/tlb.h  |   10 ++++++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/arch/arm/include/asm/tlb.h~mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table
+++ a/arch/arm/include/asm/tlb.h
@@ -34,10 +34,6 @@ __pte_free_tlb(struct mmu_gather *tlb, p
 {
 	struct ptdesc *ptdesc = page_ptdesc(pte);
 
-#ifndef CONFIG_MMU_GATHER_TABLE_FREE
-	pagetable_dtor(ptdesc);
-#endif
-
 #ifndef CONFIG_ARM_LPAE
 	/*
 	 * With the classic ARM MMU, a pte page has two corresponding pmd
--- a/include/asm-generic/tlb.h~mm-pgtable-completely-move-pagetable_dtor-to-generic-tlb_remove_table
+++ a/include/asm-generic/tlb.h
@@ -220,14 +220,20 @@ static inline void __tlb_remove_table(vo
 
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
-#else /* !CONFIG_MMU_GATHER_HAVE_TABLE_FREE */
+#else /* !CONFIG_MMU_GATHER_TABLE_FREE */
 
+static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page);
 /*
  * Without MMU_GATHER_TABLE_FREE the architecture is assumed to have page based
  * page directories and we can use the normal page batching to free them.
  */
-#define tlb_remove_table(tlb, page) tlb_remove_page((tlb), (page))
+static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
+{
+	struct page *page = (struct page *)table;
 
+	pagetable_dtor(page_ptdesc(page));
+	tlb_remove_page(tlb, page);
+}
 #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
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


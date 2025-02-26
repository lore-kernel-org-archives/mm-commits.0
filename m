Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C389D155C83
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537407; cv=none; b=BVT/c1WBirkwnIJRT6Q/Ak7mwdlo2OWIvGPDW5aLuynGOuT9/RFyvmh56o8vG/A4GUp9vqyNVBJ5OqWHCc0bO9weKbk5EZ3we/lm4BAYiooq7VNjPcecsK9P1UE5xZl+gqS5A3OEkGPqRAwimICVzkMRgy8eFbP89bUN42m+NoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537407; c=relaxed/simple;
	bh=Z5LPiEW7KHafKL84lLBv4wySz4CKxyeDzqK2OyOxvqc=;
	h=Date:To:From:Subject:Message-Id; b=X9diyNu/c0Mm2jiMNcRvIVBYvxA8CiKBv5XoMUyoO6lIyiodhvpb4gvk6sJYth6UlEJQjTG7aMyQbSnj+POjoOveWxjVek384zDVi4kc3HvZxAaOADgS1PxU6hgMR9uDotn35AUmWRE819xJENbF1Y6sU3xSpTETozLE4Nu8GGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m3onWo5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m3onWo5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BD0C4CEDD;
	Wed, 26 Feb 2025 02:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740537407;
	bh=Z5LPiEW7KHafKL84lLBv4wySz4CKxyeDzqK2OyOxvqc=;
	h=Date:To:From:Subject:From;
	b=m3onWo5bDvlV1uqp0VUTlHC/VGY5tLDJuJ5Wh9VwVaE+8r0t/4X3uTlg9V3s3vQaj
	 CAveStNdAHwYi0TFGxjhpWLwXTEPFfxpqmQWuAkSG9FRwkbu6D0d3l6nCReVp9uNOT
	 CZx2BC+7+ZkDGLdRKGqZhsA/fPRiFwpf3N6bpgDo=
Date: Tue, 25 Feb 2025 18:36:46 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch added to mm-unstable branch
Message-Id: <20250226023647.38BD0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: pgtable: unconditionally use tlb_remove_ptdesc()
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch

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
Subject: riscv: pgtable: unconditionally use tlb_remove_ptdesc()
Date: Tue, 25 Feb 2025 11:45:54 +0800

To support fast gup, the commit 69be3fb111e7 ("riscv: enable
MMU_GATHER_RCU_TABLE_FREE for SMP && MMU") did the following:

1) use tlb_remove_page_ptdesc() for those platforms which use IPI to
   perform TLB shootdown

2) use tlb_remove_ptdesc() for those platforms which use SBI to perform
   TLB shootdown

The tlb_remove_page_ptdesc() is the wrapper of the tlb_remove_page().  By
design, the tlb_remove_page() should be used to remove a normal page from
a page table entry, and should not be used for page table pages.

The tlb_remove_ptdesc() is the wrapper of the tlb_remove_table(), which is
designed specifically for freeing page table pages.  If the
CONFIG_MMU_GATHER_TABLE_FREE is enabled, the tlb_remove_table() will use
semi RCU to free page table pages, that is:

 - batch table freeing: asynchronous free by RCU
 - single table freeing: IPI + synchronous free

If the CONFIG_MMU_GATHER_TABLE_FREE is disabled, the tlb_remove_table()
will fall back to pagetable_dtor() + tlb_remove_page().

For case 1), since we need to perform TLB shootdown before freeing the
page table page, the local_irq_save() in fast gup can block the freeing
and protect the fast gup page walker.  Therefore we can ensure safety by
just using tlb_remove_page_ptdesc().  In addition, we can also the
tlb_remove_ptdesc()/tlb_remove_table() to achieve it, and it doesn't
matter whether CONFIG_MMU_GATHER_RCU_TABLE_FREE is selected.  And in
theory, the performance of freeing pages asynchronously via RCU will not
be lower than synchronous free.

For case 2), since local_irq_save() only disable S-privilege IPI irq but
not M-privilege's, which is used by the SBI implementation to perform TLB
shootdown, so we must select CONFIG_MMU_GATHER_RCU_TABLE_FREE and use
tlb_remove_ptdesc() to ensure safety.  The riscv selects this config for
SMP && MMU, the CONFIG_RISCV_SBI is dependent on MMU.  Therefore, only the
UP system may have the situation where CONFIG_MMU_GATHER_RCU_TABLE_FREE is
disabled but CONFIG_RISCV_SBI is enabled.  But there is no freeing vs fast
gup race in the UP system.

So, in summary, we can use tlb_remove_ptdesc() to support fast gup in all
cases, and this interface is specifically designed for page table pages. 
So let's use it unconditionally.

Link: https://lkml.kernel.org/r/9025595e895515515c95e48db54b29afa489c41d.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
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

 arch/riscv/include/asm/pgalloc.h |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

--- a/arch/riscv/include/asm/pgalloc.h~riscv-pgtable-unconditionally-use-tlb_remove_ptdesc
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -15,24 +15,6 @@
 #define __HAVE_ARCH_PUD_FREE
 #include <asm-generic/pgalloc.h>
 
-/*
- * While riscv platforms with riscv_ipi_for_rfence as true require an IPI to
- * perform TLB shootdown, some platforms with riscv_ipi_for_rfence as false use
- * SBI to perform TLB shootdown. To keep software pagetable walkers safe in this
- * case we switch to RCU based table free (MMU_GATHER_RCU_TABLE_FREE). See the
- * comment below 'ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE' in include/asm-generic/tlb.h
- * for more details.
- */
-static inline void riscv_tlb_remove_ptdesc(struct mmu_gather *tlb, void *pt)
-{
-	if (riscv_use_sbi_for_rfence()) {
-		tlb_remove_ptdesc(tlb, pt);
-	} else {
-		pagetable_dtor(pt);
-		tlb_remove_page_ptdesc(tlb, pt);
-	}
-}
-
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 	pmd_t *pmd, pte_t *pte)
 {
@@ -108,14 +90,14 @@ static inline void __pud_free_tlb(struct
 				  unsigned long addr)
 {
 	if (pgtable_l4_enabled)
-		riscv_tlb_remove_ptdesc(tlb, virt_to_ptdesc(pud));
+		tlb_remove_ptdesc(tlb, virt_to_ptdesc(pud));
 }
 
 static inline void __p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4d,
 				  unsigned long addr)
 {
 	if (pgtable_l5_enabled)
-		riscv_tlb_remove_ptdesc(tlb, virt_to_ptdesc(p4d));
+		tlb_remove_ptdesc(tlb, virt_to_ptdesc(p4d));
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
@@ -143,7 +125,7 @@ static inline pgd_t *pgd_alloc(struct mm
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
 				  unsigned long addr)
 {
-	riscv_tlb_remove_ptdesc(tlb, virt_to_ptdesc(pmd));
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pmd));
 }
 
 #endif /* __PAGETABLE_PMD_FOLDED */
@@ -151,7 +133,7 @@ static inline void __pmd_free_tlb(struct
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 				  unsigned long addr)
 {
-	riscv_tlb_remove_ptdesc(tlb, page_ptdesc(pte));
+	tlb_remove_ptdesc(tlb, page_ptdesc(pte));
 }
 #endif /* CONFIG_MMU */
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

arm-pgtable-fix-null-pointer-dereference-issue.patch
mm-pgtable-make-generic-tlb_remove_table-use-struct-ptdesc.patch
mm-pgtable-change-pt-parameter-of-tlb_remove_ptdesc-to-struct-ptdesc.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch
riscv-pgtable-unconditionally-use-tlb_remove_ptdesc.patch
x86-pgtable-convert-to-use-tlb_remove_ptdesc.patch
mm-pgtable-remove-tlb_remove_page_ptdesc.patch


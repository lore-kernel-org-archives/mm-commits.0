Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39B923D3D4
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837128; cv=none; b=ib44SH5PI+Nrfq6nlSuq3Ke7x/TG6cHmo5WO0x3JPkSlgxy8benw4bb9FFxVXVxQOqGMjlGt3mVrMBlhh7X9tP1hpFco77Mf/QE/liqeHepkiqBdrtbYH552kTuqULuWNJRkmeh5u+cNaXFZkg4dzv5niM2iNtBXZwWqfE2fYew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837128; c=relaxed/simple;
	bh=kd3c9uzY5z5+bfl7UzUwR8/lTIzR1w+bz9rcpbuEI/Y=;
	h=Date:To:From:Subject:Message-Id; b=AAXoqvGa9YAzUHuYLrq09P5TqM1btAmRTRv9L1tWiehgWKcEz4TIVr3WIrz4kej2X8NiVjg6dlAZqpz/UZFF8bpioM3bToZ/g5Sc0TiHlNi3LjE7M0oK0T23vwDiwuFblrrQ4KgwEtej1ifg9XKMW8777FeoIIvGRR6VKhl/bMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nYd6h1Zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nYd6h1Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123F6C4CEDD;
	Tue, 14 Jan 2025 06:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837128;
	bh=kd3c9uzY5z5+bfl7UzUwR8/lTIzR1w+bz9rcpbuEI/Y=;
	h=Date:To:From:Subject:From;
	b=nYd6h1Zxh3oVNjc5pKLMwIkEuo2mZTazfo2AeyP63x7e6FIOnGv+AQQ/1MJAiIFcL
	 +l6bwbnUCBMsmwivWYLN/4NPnVT+nGQtm5Y5TfBUdiJXrKChhZu7W//WKb09owi4Oc
	 Pw7A104rICfiYdi1eUXKqX50zSSbpHEnr5MmIRq4=
Date: Mon, 13 Jan 2025 22:45:27 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-pgtable-consolidate-pxd-and-pte-tlb-free-paths.patch removed from -mm tree
Message-Id: <20250114064528.123F6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390: pgtable: consolidate PxD and PTE TLB free paths
has been removed from the -mm tree.  Its filename was
     s390-pgtable-consolidate-pxd-and-pte-tlb-free-paths.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: s390: pgtable: consolidate PxD and PTE TLB free paths
Date: Wed, 8 Jan 2025 14:57:29 +0800

Call pagetable_dtor() for PMD|PUD|P4D tables just before ptdesc is freed -
same as it is done for PTE tables.  That allows consolidating TLB free
paths for all table types.

Link: https://lkml.kernel.org/r/ac69360a5f3350ebb2f63cd14b7b45316a130ee4.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
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

 arch/s390/include/asm/tlb.h |    3 ---
 arch/s390/mm/pgalloc.c      |   14 ++++----------
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/arch/s390/include/asm/tlb.h~s390-pgtable-consolidate-pxd-and-pte-tlb-free-paths
+++ a/arch/s390/include/asm/tlb.h
@@ -102,7 +102,6 @@ static inline void pmd_free_tlb(struct m
 {
 	if (mm_pmd_folded(tlb->mm))
 		return;
-	pagetable_dtor(virt_to_ptdesc(pmd));
 	__tlb_adjust_range(tlb, address, PAGE_SIZE);
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
@@ -122,7 +121,6 @@ static inline void p4d_free_tlb(struct m
 {
 	if (mm_p4d_folded(tlb->mm))
 		return;
-	pagetable_dtor(virt_to_ptdesc(p4d));
 	__tlb_adjust_range(tlb, address, PAGE_SIZE);
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
@@ -141,7 +139,6 @@ static inline void pud_free_tlb(struct m
 {
 	if (mm_pud_folded(tlb->mm))
 		return;
-	pagetable_dtor(virt_to_ptdesc(pud));
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_p4ds = 1;
--- a/arch/s390/mm/pgalloc.c~s390-pgtable-consolidate-pxd-and-pte-tlb-free-paths
+++ a/arch/s390/mm/pgalloc.c
@@ -180,7 +180,7 @@ unsigned long *page_table_alloc(struct m
 	return table;
 }
 
-static void pagetable_pte_dtor_free(struct ptdesc *ptdesc)
+static void pagetable_dtor_free(struct ptdesc *ptdesc)
 {
 	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
@@ -190,20 +190,14 @@ void page_table_free(struct mm_struct *m
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(table);
 
-	pagetable_pte_dtor_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 
 void __tlb_remove_table(void *table)
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(table);
-	struct page *page = ptdesc_page(ptdesc);
 
-	if (compound_order(page) == CRST_ALLOC_ORDER) {
-		/* pmd, pud, or p4d */
-		pagetable_free(ptdesc);
-		return;
-	}
-	pagetable_pte_dtor_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -211,7 +205,7 @@ static void pte_free_now(struct rcu_head
 {
 	struct ptdesc *ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
 
-	pagetable_pte_dtor_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are



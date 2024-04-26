Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBDC78C91
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103862; cv=none; b=TF96X1qQNOrQWPipHR01OHwepRUtkgRAkOLAzz9Lo2f0S1wjH/h5OTGe6D4aX5NLQYI5S1M2u10X2PPU8TusEJJd/gayhGGBSQsRjl+KJK89F3ZqowohnMNKdroqdKqh+CbsTb1TBayQGCejlqr99aQLIlPwTprHV5z0get4vj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103862; c=relaxed/simple;
	bh=mnd/lmKHWzrQuVHhL5OSOjjMKVeiX3kWwPqEkgBOZGg=;
	h=Date:To:From:Subject:Message-Id; b=SlgkdJ51HyEbWs8TRsa+AMce8aLt/rSw8e3bcy1s4oKn/jarDfQ9TQitZcn5btQZwLhvK6dmkckEDCEOj1BqW8MLSLwAC3DsfQ0nllJR1NWx5X1Z91tK0NDjqdGxURxNOuW7rzDJCFg9ve/Gd2iUCwvaSO5oaaSasOWrs7Xoopg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wS9MqVmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wS9MqVmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726ABC113CD;
	Fri, 26 Apr 2024 03:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103861;
	bh=mnd/lmKHWzrQuVHhL5OSOjjMKVeiX3kWwPqEkgBOZGg=;
	h=Date:To:From:Subject:From;
	b=wS9MqVmOKY32M+/NJYB5HDBo8ScQLdGy6zqgKAsfs7TN9LDNkFj65G1E8l8UQcUKB
	 YfbHFlJPsj/lOz+J298LOmsK3vznrStoHIS8ve8LWGVtSWYIc89C0xy4WvVu/+XCui
	 iC3yCooit2o8TJIEE++1dpTDOEsceHhKhmXHRj5A=
Date: Thu, 25 Apr 2024 20:57:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-treewide-replace-pxd_huge-with-pxd_leaf.patch removed from -mm tree
Message-Id: <20240426035741.726ABC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/treewide: replace pXd_huge() with pXd_leaf()
has been removed from the -mm tree.  Its filename was
     mm-treewide-replace-pxd_huge-with-pxd_leaf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/treewide: replace pXd_huge() with pXd_leaf()
Date: Mon, 18 Mar 2024 16:04:01 -0400

Now after we're sure all pXd_huge() definitions are the same as pXd_leaf(),
reuse it.  Luckily, pXd_huge() isn't widely used.

Link: https://lkml.kernel.org/r/20240318200404.448346-12-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    2 +-
 arch/arm64/include/asm/pgtable.h      |    2 +-
 arch/arm64/mm/hugetlbpage.c           |    4 ++--
 arch/loongarch/mm/hugetlbpage.c       |    2 +-
 arch/mips/mm/tlb-r4k.c                |    2 +-
 arch/powerpc/mm/pgtable_64.c          |    6 +++---
 arch/x86/mm/pgtable.c                 |    4 ++--
 mm/gup.c                              |    4 ++--
 mm/hmm.c                              |    2 +-
 mm/memory.c                           |    2 +-
 10 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/arch/arm64/include/asm/pgtable.h
@@ -517,7 +517,7 @@ static inline pmd_t pmd_mkinvalid(pmd_t
 	return pmd;
 }
 
-#define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
+#define pmd_thp_or_huge(pmd)	(pmd_leaf(pmd) || pmd_trans_huge(pmd))
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
--- a/arch/arm64/mm/hugetlbpage.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -321,7 +321,7 @@ pte_t *huge_pte_offset(struct mm_struct
 	if (sz != PUD_SIZE && pud_none(pud))
 		return NULL;
 	/* hugepage or swap? */
-	if (pud_huge(pud) || !pud_present(pud))
+	if (pud_leaf(pud) || !pud_present(pud))
 		return (pte_t *)pudp;
 	/* table; check the next level */
 
@@ -333,7 +333,7 @@ pte_t *huge_pte_offset(struct mm_struct
 	if (!(sz == PMD_SIZE || sz == CONT_PMD_SIZE) &&
 	    pmd_none(pmd))
 		return NULL;
-	if (pmd_huge(pmd) || !pmd_present(pmd))
+	if (pmd_leaf(pmd) || !pmd_present(pmd))
 		return (pte_t *)pmdp;
 
 	if (sz == CONT_PTE_SIZE)
--- a/arch/arm/include/asm/pgtable-3level.h~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -190,7 +190,7 @@ static inline pte_t pte_mkspecial(pte_t
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
 
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
-#define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
+#define pmd_thp_or_huge(pmd)	(pmd_leaf(pmd) || pmd_trans_huge(pmd))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
--- a/arch/loongarch/mm/hugetlbpage.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/arch/loongarch/mm/hugetlbpage.c
@@ -64,7 +64,7 @@ uint64_t pmd_to_entrylo(unsigned long pm
 {
 	uint64_t val;
 	/* PMD as PTE. Must be huge page */
-	if (!pmd_huge(__pmd(pmd_val)))
+	if (!pmd_leaf(__pmd(pmd_val)))
 		panic("%s", __func__);
 
 	val = pmd_val ^ _PAGE_HUGE;
--- a/arch/mips/mm/tlb-r4k.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/arch/mips/mm/tlb-r4k.c
@@ -326,7 +326,7 @@ void __update_tlb(struct vm_area_struct
 	idx = read_c0_index();
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	/* this could be a huge page  */
-	if (pmd_huge(*pmdp)) {
+	if (pmd_leaf(*pmdp)) {
 		unsigned long lo;
 		write_c0_pagemask(PM_HUGE_MASK);
 		ptep = (pte_t *)pmdp;
--- a/arch/powerpc/mm/pgtable_64.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -102,7 +102,7 @@ struct page *p4d_page(p4d_t p4d)
 {
 	if (p4d_leaf(p4d)) {
 		if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
-			VM_WARN_ON(!p4d_huge(p4d));
+			VM_WARN_ON(!p4d_leaf(p4d));
 		return pte_page(p4d_pte(p4d));
 	}
 	return virt_to_page(p4d_pgtable(p4d));
@@ -113,7 +113,7 @@ struct page *pud_page(pud_t pud)
 {
 	if (pud_leaf(pud)) {
 		if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
-			VM_WARN_ON(!pud_huge(pud));
+			VM_WARN_ON(!pud_leaf(pud));
 		return pte_page(pud_pte(pud));
 	}
 	return virt_to_page(pud_pgtable(pud));
@@ -132,7 +132,7 @@ struct page *pmd_page(pmd_t pmd)
 		 * enabled so these checks can't be used.
 		 */
 		if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
-			VM_WARN_ON(!(pmd_leaf(pmd) || pmd_huge(pmd)));
+			VM_WARN_ON(!pmd_leaf(pmd));
 		return pte_page(pmd_pte(pmd));
 	}
 	return virt_to_page(pmd_page_vaddr(pmd));
--- a/arch/x86/mm/pgtable.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/arch/x86/mm/pgtable.c
@@ -731,7 +731,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t
 		return 0;
 
 	/* Bail out if we are we on a populated non-leaf entry: */
-	if (pud_present(*pud) && !pud_huge(*pud))
+	if (pud_present(*pud) && !pud_leaf(*pud))
 		return 0;
 
 	set_pte((pte_t *)pud, pfn_pte(
@@ -760,7 +760,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
 	}
 
 	/* Bail out if we are we on a populated non-leaf entry: */
-	if (pmd_present(*pmd) && !pmd_huge(*pmd))
+	if (pmd_present(*pmd) && !pmd_leaf(*pmd))
 		return 0;
 
 	set_pte((pte_t *)pmd, pfn_pte(
--- a/mm/gup.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/mm/gup.c
@@ -778,7 +778,7 @@ static struct page *follow_p4d_mask(stru
 	p4d = READ_ONCE(*p4dp);
 	if (!p4d_present(p4d))
 		return no_page_table(vma, flags);
-	BUILD_BUG_ON(p4d_huge(p4d));
+	BUILD_BUG_ON(p4d_leaf(p4d));
 	if (unlikely(p4d_bad(p4d)))
 		return no_page_table(vma, flags);
 
@@ -3082,7 +3082,7 @@ static int gup_p4d_range(pgd_t *pgdp, pg
 		next = p4d_addr_end(addr, end);
 		if (!p4d_present(p4d))
 			return 0;
-		BUILD_BUG_ON(p4d_huge(p4d));
+		BUILD_BUG_ON(p4d_leaf(p4d));
 		if (unlikely(is_hugepd(__hugepd(p4d_val(p4d))))) {
 			if (!gup_huge_pd(__hugepd(p4d_val(p4d)), addr,
 					 P4D_SHIFT, next, flags, pages, nr))
--- a/mm/hmm.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/mm/hmm.c
@@ -429,7 +429,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 		return hmm_vma_walk_hole(start, end, -1, walk);
 	}
 
-	if (pud_huge(pud) && pud_devmap(pud)) {
+	if (pud_leaf(pud) && pud_devmap(pud)) {
 		unsigned long i, npages, pfn;
 		unsigned int required_fault;
 		unsigned long *hmm_pfns;
--- a/mm/memory.c~mm-treewide-replace-pxd_huge-with-pxd_leaf
+++ a/mm/memory.c
@@ -2765,7 +2765,7 @@ static int apply_to_pmd_range(struct mm_
 	unsigned long next;
 	int err = 0;
 
-	BUG_ON(pud_huge(*pud));
+	BUG_ON(pud_leaf(*pud));
 
 	if (create) {
 		pmd = pmd_alloc_track(mm, pud, addr, mask);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch


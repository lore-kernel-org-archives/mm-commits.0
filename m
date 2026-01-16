Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65372F361F
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 00:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768523126; cv=none; b=UJkqBn8nqOMW5gGWSWgebEreF1XGaIyKkJBy9mJlnl63VD2odUyJEKlRMOLzsosDmiuzEyhPg6rqq/X03Vm33XaBRmCL/TO1uv6mFJAtXyYjoGRco4WqjgvC3TW4nThka9bF1CqG8Eu6ZyCqJL/UywlD55brDmyFR+hV/4RfeGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768523126; c=relaxed/simple;
	bh=VGFF5tio6Q1bY2PRA9OoqcfbQPhhSJt7Kem2XHS6PY8=;
	h=Date:To:From:Subject:Message-Id; b=rJb2gDuIrxuLMvYH6NCpW0iL+r3g6uPP/Q8fKxM6s1yYy7tucYrotDGqz6ENcAFz8gBJ+lJuPyGsix3axWBvVTGhH4hf88mWVvz8pC5mAyG4pMIwtoYqsNcd05MASr21I1RgyQuMyUIW6lBePBWPqOVLEkgMYtdZk3Jz9KUq2uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RkVwsYV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RkVwsYV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34454C116D0;
	Fri, 16 Jan 2026 00:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768523126;
	bh=VGFF5tio6Q1bY2PRA9OoqcfbQPhhSJt7Kem2XHS6PY8=;
	h=Date:To:From:Subject:From;
	b=RkVwsYV5p56mNR7S8NQBNbfIJCX/8hAlNrDjme9GBWOmoO41jx27nuy1FMHTDJoDe
	 jo9Pq4RGB+Om1Nw32DxUE8MFsizx5mcVjBkarG99FGP2xBjabntVe7c6Y6zAuTkCxJ
	 uOnQI2AJcCzmlPgbVyxHjunP15h/jWe0Lo6VRCNQ=
Date: Thu, 15 Jan 2026 16:25:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,rmclure@linux.ibm.com,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,ajd@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz.patch added to mm-new branch
Message-Id: <20260116002526.34454C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: add addr parameter to __ptep_get_and_clear_anysz()
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Donnellan <ajd@linux.ibm.com>
Subject: arm64/mm: add addr parameter to __ptep_get_and_clear_anysz()
Date: Fri, 19 Dec 2025 04:09:34 +1100

To provide support for page table check on powerpc, we need to
reinstate the address parameter in several functions, including
page_table_check_{pte,pmd,pud}_clear().

In preparation for this, add the addr parameter to arm64's
__ptep_get_and_clear_anysz() and change its callsites accordingly.

Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-2-755bc151a50b@linux.ibm.com
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    5 +++--
 arch/arm64/mm/hugetlbpage.c      |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1332,6 +1332,7 @@ static inline int pmdp_test_and_clear_yo
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
 static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
+					       unsigned long address,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
@@ -1359,7 +1360,7 @@ static inline pte_t __ptep_get_and_clear
 static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address, pte_t *ptep)
 {
-	return __ptep_get_and_clear_anysz(mm, ptep, PAGE_SIZE);
+	return __ptep_get_and_clear_anysz(mm, address, ptep, PAGE_SIZE);
 }
 
 static inline void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
@@ -1398,7 +1399,7 @@ static inline pte_t __get_and_clear_full
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp)
 {
-	return pte_pmd(__ptep_get_and_clear_anysz(mm, (pte_t *)pmdp, PMD_SIZE));
+	return pte_pmd(__ptep_get_and_clear_anysz(mm, address, (pte_t *)pmdp, PMD_SIZE));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -155,11 +155,12 @@ static pte_t get_clear_contig(struct mm_
 	pte_t pte, tmp_pte;
 	bool present;
 
-	pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+	pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 	present = pte_present(pte);
 	while (--ncontig) {
 		ptep++;
-		tmp_pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		addr += pgsize;
+		tmp_pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 		if (present) {
 			if (pte_dirty(tmp_pte))
 				pte = pte_mkdirty(pte);
@@ -203,7 +204,7 @@ static void clear_flush(struct mm_struct
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		__ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
 	if (mm == &init_mm)
 		flush_tlb_kernel_range(saddr, addr);
_

Patches currently in -mm which might be from ajd@linux.ibm.com are

arm64-mm-add-addr-parameter-to-__set_ptes_anysz.patch
arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz.patch


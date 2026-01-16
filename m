Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E35C2F361F
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 00:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768523125; cv=none; b=e7CRttXTaHlS0nqhgp0ElEY8dI1KgVYFoPVvvf514BVNzNzdVJq+EcLPq1lYL1ytZm7pn6IpgDPiRhiXE+zOev4GwH2/TrlhRAiU1L+CixZNhN0SGJXC206RncWS8msMeQOxrURVa1DMAl4gVh2q+2fxSXPpRKIfMdU/7csPkwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768523125; c=relaxed/simple;
	bh=o2rDLEj2Yn6ge+nL7G8iC9vuks6nGm9JAIfH0vr7x30=;
	h=Date:To:From:Subject:Message-Id; b=oLkJ8fFxEAsBSr0Ol4kyP1cPG/Kd4vuZTXVXTeL/gI3ufG1vE2+mwCkhFEAGzCzQ/E74vSMbx84M5w9M8lYv0aOkubYiYmpKEe6lQXC2biCRO6qWl/ZsAOnrPvU2aE7fsb340vPLjPsXjabqVm0z02rLb4blhDV3wBbpQKYN6wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsOYr5C7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsOYr5C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99015C116D0;
	Fri, 16 Jan 2026 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768523124;
	bh=o2rDLEj2Yn6ge+nL7G8iC9vuks6nGm9JAIfH0vr7x30=;
	h=Date:To:From:Subject:From;
	b=AsOYr5C7t4BWmkW1ZltrshIv2VMYvgc1Iocr5a5rNJjvrJ2pGkMgFQNC0qqmHaGXa
	 Zqf7b5rSu2Qalk3S3qka4gmwvMtM6NK6cZVLHgv/27Ok4LxzQlijiWb+Mu8pYKh6c+
	 1ZJN5C01wQGg3kFgmXEIq997CIBI7tOonVw0l+6Y=
Date: Thu, 15 Jan 2026 16:25:23 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,rmclure@linux.ibm.com,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,ajd@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-add-addr-parameter-to-__set_ptes_anysz.patch added to mm-new branch
Message-Id: <20260116002524.99015C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: add addr parameter to __set_ptes_anysz()
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-add-addr-parameter-to-__set_ptes_anysz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-add-addr-parameter-to-__set_ptes_anysz.patch

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
Subject: arm64/mm: add addr parameter to __set_ptes_anysz()
Date: Fri, 19 Dec 2025 04:09:33 +1100

Patch series "Support page table check on PowerPC", v18.

Support page table check on PowerPC.  Page table check tracks the usage of
of page table entries at each level to ensure that anonymous mappings have
at most one writable consumer, and likewise that file-backed mappings are
not simultaneously also anonymous mappings.

In order to support this infrastructure, a number of helpers or stubs must
be defined or updated for all powerpc platforms.  Additionally, we
separate set_pte_at() and set_pte_at_unchecked(), to allow for internal,
uninstrumented mappings.

On some PowerPC platforms, implementing
{pte,pmd,pud}_user_accessible_page() requires the address.  We revert
previous changes that removed the address parameter from various
interfaces, and add it to some other interfaces, in order to allow this.

For now, we don't allow page table check alongside HUGETLB_PAGE, due to
the arch-specific complexity of set_huge_page_at().  (I'm sure I could
figure this out, but I have to get this version on this list before I
leave my job.)

This series was initially written by Rohan McLure, who has left IBM and is
no longer working on powerpc.


This patch (of 18):

To provide support for page table check on powerpc, we need to reinstate
the address parameter in several functions, including
page_table_check_{ptes,pmds,puds}_set().

In preparation for this, add the addr parameter to arm64's
__set_ptes_anysz() and change its callsites accordingly.

Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-1-755bc151a50b@linux.ibm.com
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
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
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   19 ++++++++-----------
 arch/arm64/mm/hugetlbpage.c      |   10 +++++-----
 2 files changed, 13 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-add-addr-parameter-to-__set_ptes_anysz
+++ a/arch/arm64/include/asm/pgtable.h
@@ -673,8 +673,8 @@ static inline pgprot_t pud_pgprot(pud_t
 	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
 }
 
-static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
-				    pte_t pte, unsigned int nr,
+static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, pte_t pte, unsigned int nr,
 				    unsigned long pgsize)
 {
 	unsigned long stride = pgsize >> PAGE_SHIFT;
@@ -709,26 +709,23 @@ static inline void __set_ptes_anysz(stru
 	__set_pte_complete(pte);
 }
 
-static inline void __set_ptes(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	__set_ptes_anysz(mm, ptep, pte, nr, PAGE_SIZE);
+	__set_ptes_anysz(mm, addr, ptep, pte, nr, PAGE_SIZE);
 }
 
-static inline void __set_pmds(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_pmds(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
-	__set_ptes_anysz(mm, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
+	__set_ptes_anysz(mm, addr, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
 }
 #define set_pmd_at(mm, addr, pmdp, pmd) __set_pmds(mm, addr, pmdp, pmd, 1)
 
-static inline void __set_puds(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_puds(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud, unsigned int nr)
 {
-	__set_ptes_anysz(mm, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
+	__set_ptes_anysz(mm, addr, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
 }
 #define set_pud_at(mm, addr, pudp, pud) __set_puds(mm, addr, pudp, pud, 1)
 
--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-add-addr-parameter-to-__set_ptes_anysz
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -221,8 +221,8 @@ void set_huge_pte_at(struct mm_struct *m
 	ncontig = num_contig_ptes(sz, &pgsize);
 
 	if (!pte_present(pte)) {
-		for (i = 0; i < ncontig; i++, ptep++)
-			__set_ptes_anysz(mm, ptep, pte, 1, pgsize);
+		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
+			__set_ptes_anysz(mm, addr, ptep, pte, 1, pgsize);
 		return;
 	}
 
@@ -230,7 +230,7 @@ void set_huge_pte_at(struct mm_struct *m
 	if (pte_cont(pte) && pte_valid(__ptep_get(ptep)))
 		clear_flush(mm, addr, ptep, pgsize, ncontig);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -445,7 +445,7 @@ int huge_ptep_set_access_flags(struct vm
 	if (pte_young(orig_pte))
 		pte = pte_mkyoung(pte);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 	return 1;
 }
 
@@ -469,7 +469,7 @@ void huge_ptep_set_wrprotect(struct mm_s
 	pte = get_clear_contig_flush(mm, addr, ptep, pgsize, ncontig);
 	pte = pte_wrprotect(pte);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
 pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from ajd@linux.ibm.com are

arm64-mm-add-addr-parameter-to-__set_ptes_anysz.patch
arm64-mm-add-addr-parameter-to-__ptep_get_and_clear_anysz.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319A30149A
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755126351; cv=none; b=tREpMtBwCJiX/sdCUOSB3GY7XMpQQ+o4oHH5ymH7gj4xfh21Rj6Ugvl3FEStk65bKgq3sUHCEko17aVhitgy9Q/ND0sIeKLHgFBa83TuK4cE5UbXks1cGBMJSvF5FfhRfUqQpRwhtRRB0i7hLoy2lZRV1PqYq4EZ7619r93/+sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755126351; c=relaxed/simple;
	bh=op5FUUM1HKLr3iKDd+1EPSrCHn4xPXMxhdi3MehKy08=;
	h=Date:To:From:Subject:Message-Id; b=pT9HCr/3JM7btvX71NJ3pFYbucxrh26lpEW+oR79TT4bqeq4GsQeUQldkkvvYj2aCrb/ypvfDKJV711p0b5XtoPodBGr18DQqPhivtIaVgIIsideBRI/g2zwsjuAEX1TBokqJoDo3hdyl9TCNZwD9EQqeOalVDasMy400myF34w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ry16mKrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ry16mKrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08229C4CEEB;
	Wed, 13 Aug 2025 23:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755126351;
	bh=op5FUUM1HKLr3iKDd+1EPSrCHn4xPXMxhdi3MehKy08=;
	h=Date:To:From:Subject:From;
	b=ry16mKrRaIWdi6GP99Lkb8G3HZxrtk7F4Dda9K6MHXnviX43J5Zned/6i6/H9KQSv
	 ra1hqNInbTlcXFBQ84qmi7ElR6Q8+aSxu0ERqHiiny4gCLpl+ABnn/8b/3ZV5yWeFN
	 C3lEgcQlYASktkmztE/zkEPKtsicShTvr2EBX0iw=
Date: Wed, 13 Aug 2025 16:05:50 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,sweettea-kernel@dorminy.me,rmclure@linux.ibm.com,pasha.tatashin@soleen.com,nicholas@linux.ibm.com,mingo@kernel.org,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,ajd@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-add-addr-parameter-to-__set_ptes_anysz.patch added to mm-new branch
Message-Id: <20250813230551.08229C4CEEB@smtp.kernel.org>
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
From: Andrew Donnellan <ajd@linux.ibm.com>
Subject: arm64/mm: add addr parameter to __set_ptes_anysz()
Date: Wed, 13 Aug 2025 16:26:02 +1000

Patch series "Support page table check on PowerPC", v16.

Support page table check on all PowerPC platforms.  This works by
serialising assignments, reassignments and clears of page table entries at
each level in order to ensure that anonymous mappings have at most one
writable consumer, and likewise that file-backed mappings are not
simultaneously also anonymous mappings.

In order to support this infrastructure, a number of stubs must be defined
for all powerpc platforms.  Additionally, separate set_pte_at() and
set_pte_at_unchecked(), to allow for internal, uninstrumented mappings.

On some PowerPC platforms, implementing
{pte,pmd,pud}_user_accessible_page() requires the address.  We revert
previous changes that removed the address parameter from various
interfaces, and add it to some other interfaces, in order to allow this.

(This series was initially written by Rohan McLure, who has left IBM and
is no longer working on powerpc.)


This patch (of 13):

To provide support for page table check on powerpc, we need to reinstate
the address parameter in several functions, including
page_table_check_{ptes,pmds,puds}_set().

In preparation for this, add the addr parameter to arm64's
__set_ptes_anysz() and change its callsites accordingly.

Link: https://lkml.kernel.org/r/20250813062614.51759-1-ajd@linux.ibm.com
Link: https://lkml.kernel.org/r/20250813062614.51759-2-ajd@linux.ibm.com
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   19 ++++++++-----------
 arch/arm64/mm/hugetlbpage.c      |   10 +++++-----
 2 files changed, 13 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-add-addr-parameter-to-__set_ptes_anysz
+++ a/arch/arm64/include/asm/pgtable.h
@@ -698,8 +698,8 @@ static inline pgprot_t pud_pgprot(pud_t
 	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
 }
 
-static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
-				    pte_t pte, unsigned int nr,
+static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, pte_t pte, unsigned int nr,
 				    unsigned long pgsize)
 {
 	unsigned long stride = pgsize >> PAGE_SHIFT;
@@ -734,26 +734,23 @@ static inline void __set_ptes_anysz(stru
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
@@ -225,8 +225,8 @@ void set_huge_pte_at(struct mm_struct *m
 	ncontig = num_contig_ptes(sz, &pgsize);
 
 	if (!pte_present(pte)) {
-		for (i = 0; i < ncontig; i++, ptep++)
-			__set_ptes_anysz(mm, ptep, pte, 1, pgsize);
+		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
+			__set_ptes_anysz(mm, addr, ptep, pte, 1, pgsize);
 		return;
 	}
 
@@ -234,7 +234,7 @@ void set_huge_pte_at(struct mm_struct *m
 	if (pte_cont(pte) && pte_valid(__ptep_get(ptep)))
 		clear_flush(mm, addr, ptep, pgsize, ncontig);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -449,7 +449,7 @@ int huge_ptep_set_access_flags(struct vm
 	if (pte_young(orig_pte))
 		pte = pte_mkyoung(pte);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 	return 1;
 }
 
@@ -473,7 +473,7 @@ void huge_ptep_set_wrprotect(struct mm_s
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


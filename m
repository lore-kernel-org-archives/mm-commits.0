Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDE32EE96E
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 22:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752706765; cv=none; b=PnplnMoO+jCMpV+KEstnUo246gxGOObSvP+etmWZw1id0Bz8vetFJXKOcHVO16oxJrNMUQXLLX+Ji10Ap2eXCuXGQk4UoGsx15B+SB2GQZdNP6N7ZbipbPQedvp2lkOlYnxVKaCR/eUSDCw/p9BIXhxK2CMrkcO4CSmOVyhXTe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752706765; c=relaxed/simple;
	bh=5vbtXSXbmLAIxzvLgWZDyoiQHMG6GshmIBmRA/7vWDE=;
	h=Date:To:From:Subject:Message-Id; b=cU2/ktsnDj8e8dIDi6rc25XOS2XuQn7/XfbrNH8LvmKrwskGYc0X0kQSHPRvYXh/wtkqMDzy5NX341UofJw7dLn/ZT/RtL/1a0SHdm40BjxuDCswqWuS6V9+eMwV68/bWJ4wXSKq6uqT39U/nq6oicI55N2cjfh05QHn+lTAoU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pru4yDYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pru4yDYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCEEC4CEE7;
	Wed, 16 Jul 2025 22:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752706765;
	bh=5vbtXSXbmLAIxzvLgWZDyoiQHMG6GshmIBmRA/7vWDE=;
	h=Date:To:From:Subject:From;
	b=Pru4yDYoqCNzszrn72iUBSafTGP/lRTTRA8DXIGFwIRePB58BhFeItb+DxkwosonE
	 nhrCXchC73+sCZRNI6G4V88QAfWwd/0ke4NZNbd1dLF4vDMr7JvV0zFl7VaZ7EhtrZ
	 VAdgQt8FE4ijUn5a/8mElPXFWshY5Xcpz08luedI=
Date: Wed, 16 Jul 2025 15:59:24 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,arnd@arndb.de,anshuman.khandual@arm.com,andreas@gaisler.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc64-remove-hugetlb_free_pgd_range.patch added to mm-new branch
Message-Id: <20250716225925.4BCEEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc64: remove hugetlb_free_pgd_range()
has been added to the -mm mm-new branch.  Its filename is
     sparc64-remove-hugetlb_free_pgd_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc64-remove-hugetlb_free_pgd_range.patch

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: sparc64: remove hugetlb_free_pgd_range()
Date: Tue, 15 Jul 2025 18:26:09 -0700

Patch series "drop hugetlb_free_pgd_range()".

For all architectures that support hugetlb except for sparc,
hugetlb_free_pgd_range() just calls free_pgd_range().  It turns out the
sparc implementation is essentially identical to free_pgd_range() and can
be removed.  Remove it and update free_pgtables() to treat hugetlb VMAs
the same as others.


This patch (of 3):

The sparc implementation of hugetlb_free_pgd_range() is identical to
free_pgd_range() with the exception of checking for and skipping possible
leaf entries at the PUD and PMD levels.

These checks are unnecessary because any huge pages have been freed and
their PTEs cleared by the time page tables needed to map them are freed. 
While some huge page sizes do populate the page table with multiple PTEs,
they are correctly cleared by huge_ptep_get_and_clear().

To verify this, libhugetlbfs tests were run for 64K, 8M, and 256M page
sizes with an instrumented kernel on a qemu guest modified to support the
256M page size.  The same tests were used to verify no regressions after
applying this patch and were also run on x86 for both 2M and 1G page
sizes.

Link: https://lkml.kernel.org/r/20250716012611.10369-1-anthony.yznaga@oracle.com
Link: https://lkml.kernel.org/r/20250716012611.10369-2-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/hugetlb.h |    5 -
 arch/sparc/mm/hugetlbpage.c      |  119 -----------------------------
 2 files changed, 124 deletions(-)

--- a/arch/sparc/include/asm/hugetlb.h~sparc64-remove-hugetlb_free_pgd_range
+++ a/arch/sparc/include/asm/hugetlb.h
@@ -50,11 +50,6 @@ static inline int huge_ptep_set_access_f
 	return changed;
 }
 
-#define __HAVE_ARCH_HUGETLB_FREE_PGD_RANGE
-void hugetlb_free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
-			    unsigned long end, unsigned long floor,
-			    unsigned long ceiling);
-
 #include <asm-generic/hugetlb.h>
 
 #endif /* _ASM_SPARC64_HUGETLB_H */
--- a/arch/sparc/mm/hugetlbpage.c~sparc64-remove-hugetlb_free_pgd_range
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -295,122 +295,3 @@ pte_t huge_ptep_get_and_clear(struct mm_
 
 	return entry;
 }
-
-static void hugetlb_free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
-			   unsigned long addr)
-{
-	pgtable_t token = pmd_pgtable(*pmd);
-
-	pmd_clear(pmd);
-	pte_free_tlb(tlb, token, addr);
-	mm_dec_nr_ptes(tlb->mm);
-}
-
-static void hugetlb_free_pmd_range(struct mmu_gather *tlb, pud_t *pud,
-				   unsigned long addr, unsigned long end,
-				   unsigned long floor, unsigned long ceiling)
-{
-	pmd_t *pmd;
-	unsigned long next;
-	unsigned long start;
-
-	start = addr;
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd))
-			continue;
-		if (is_hugetlb_pmd(*pmd))
-			pmd_clear(pmd);
-		else
-			hugetlb_free_pte_range(tlb, pmd, addr);
-	} while (pmd++, addr = next, addr != end);
-
-	start &= PUD_MASK;
-	if (start < floor)
-		return;
-	if (ceiling) {
-		ceiling &= PUD_MASK;
-		if (!ceiling)
-			return;
-	}
-	if (end - 1 > ceiling - 1)
-		return;
-
-	pmd = pmd_offset(pud, start);
-	pud_clear(pud);
-	pmd_free_tlb(tlb, pmd, start);
-	mm_dec_nr_pmds(tlb->mm);
-}
-
-static void hugetlb_free_pud_range(struct mmu_gather *tlb, p4d_t *p4d,
-				   unsigned long addr, unsigned long end,
-				   unsigned long floor, unsigned long ceiling)
-{
-	pud_t *pud;
-	unsigned long next;
-	unsigned long start;
-
-	start = addr;
-	pud = pud_offset(p4d, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		if (is_hugetlb_pud(*pud))
-			pud_clear(pud);
-		else
-			hugetlb_free_pmd_range(tlb, pud, addr, next, floor,
-					       ceiling);
-	} while (pud++, addr = next, addr != end);
-
-	start &= PGDIR_MASK;
-	if (start < floor)
-		return;
-	if (ceiling) {
-		ceiling &= PGDIR_MASK;
-		if (!ceiling)
-			return;
-	}
-	if (end - 1 > ceiling - 1)
-		return;
-
-	pud = pud_offset(p4d, start);
-	p4d_clear(p4d);
-	pud_free_tlb(tlb, pud, start);
-	mm_dec_nr_puds(tlb->mm);
-}
-
-void hugetlb_free_pgd_range(struct mmu_gather *tlb,
-			    unsigned long addr, unsigned long end,
-			    unsigned long floor, unsigned long ceiling)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	unsigned long next;
-
-	addr &= PMD_MASK;
-	if (addr < floor) {
-		addr += PMD_SIZE;
-		if (!addr)
-			return;
-	}
-	if (ceiling) {
-		ceiling &= PMD_MASK;
-		if (!ceiling)
-			return;
-	}
-	if (end - 1 > ceiling - 1)
-		end -= PMD_SIZE;
-	if (addr > end - 1)
-		return;
-
-	pgd = pgd_offset(tlb->mm, addr);
-	p4d = p4d_offset(pgd, addr);
-	do {
-		next = p4d_addr_end(addr, end);
-		if (p4d_none_or_clear_bad(p4d))
-			continue;
-		hugetlb_free_pud_range(tlb, p4d, addr, next, floor, ceiling);
-	} while (p4d++, addr = next, addr != end);
-}
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

sparc64-remove-hugetlb_free_pgd_range.patch
mm-remove-call-to-hugetlb_free_pgd_range.patch
mm-drop-hugetlb_free_pgd_range.patch


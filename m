Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16CF1373
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409680; cv=none; b=ZyiXijcBIAUE3BI6C7JUX1A2wCwsURQA1rFaaqYEm+Yh/I8PNc5H/RJJvTQDsrlo3f7m35ufms6oGJ82vhHvFWJ3IUeoE/64y2JHQpZLpUgmptrloIrmKOxrxGYmYhQ/6TnEZaamikKzdaF6myX/mGck65pltfwGP0kjvdaHeJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409680; c=relaxed/simple;
	bh=Ih/nSY0tGxHzrT5F3WttXeyLfdwzGnmz72wk99guMNc=;
	h=Date:To:From:Subject:Message-Id; b=XL/agQz3zVyp/USFWuUuz86paEqtxonn3QbjCk1MYRhlwtqKYbj1y1sY8DyAWi1vdTbgvzyksjDRnEe3qfCPputL+Lbr071yDRMnhEPVd32iVVBAorLDE3v4AAQudpglTDTiJg7SX1jaRkRsQ2j3kAjtLWTs19Q3YK80lWHdJlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOjBbz91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOjBbz91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBDEC4CEED;
	Fri, 25 Jul 2025 02:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409680;
	bh=Ih/nSY0tGxHzrT5F3WttXeyLfdwzGnmz72wk99guMNc=;
	h=Date:To:From:Subject:From;
	b=qOjBbz91bg1gGdyivFHKjGvIeb5YgApw9MU2upHEd8ZZyMC9zctmmtvBmbsEtQUb5
	 PEVyJj9HYa3hAno13UNrjH1x0lU68kUJgm5pgCfmZPtQmGmHEfoNhL3Kz60ifAF1yc
	 CqjQOoAxadcl/DjO3SaKCxZwpjrW7tk6pNOnVrUE=
Date: Thu, 24 Jul 2025 19:14:40 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,arnd@arndb.de,anshuman.khandual@arm.com,andreas@gaisler.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc64-remove-hugetlb_free_pgd_range.patch removed from -mm tree
Message-Id: <20250725021440.9DBDEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc64: remove hugetlb_free_pgd_range()
has been removed from the -mm tree.  Its filename was
     sparc64-remove-hugetlb_free_pgd_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



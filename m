Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E24C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011086; cv=none; b=s3YesxiPgWTSzRfUYe00Vbl8iKcDmXVQtgIjdFWDR+tm9SGqVQE5dEKEak6QplhHC0qC3tJbB2rbJuWqA/+OqgtqU5BmpXxX1V59mw9WQZDhQyb1kEL406iEkuKZum6TOSs++G6dO2GY2Laa0cuuB4/nzmZIGnWQ4eDjTrDMfVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011086; c=relaxed/simple;
	bh=zGMXAFTAxx6uQBrDW4HU6qAdRQG4AEsPzlQ2W9oiB8g=;
	h=Date:To:From:Subject:Message-Id; b=DwSWUazXFWUkkNfqYouSaoJE+bYx2Y3q4YWRixOcwEE8fs4CxHutuXcW5ihQ1Tc1kktfII9Z9UkEb1nWBikJH++ShlRj7FmHG8gOHMtiWXg5KbOnu2rBubdrVxxO+z/q9w80FKgRJm0tuaGxLnmU7Xe/kHRW2Oaj46KMphjjN9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jHKfT6pI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jHKfT6pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93E1C4CEE4;
	Mon, 12 May 2025 00:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011085;
	bh=zGMXAFTAxx6uQBrDW4HU6qAdRQG4AEsPzlQ2W9oiB8g=;
	h=Date:To:From:Subject:From;
	b=jHKfT6pIqcRERqkoLGnudU6XBlvXAQskozub5HkechM4zj8m0MJJLbkYWEohWDX3T
	 VD0ouI+lUQaaYPBUZF7A/nKKOIZsZy4ussHDhHuugg7JmhkXs92ZDbOU4S9PIK6ByZ
	 9MpvdmT+4auiiM6xKQdxIEUVmRJFajATPpyTLe30=
Date: Sun, 11 May 2025 17:51:25 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch removed from -mm tree
Message-Id: <20250512005125.B93E1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()
has been removed from the -mm tree.  Its filename was
     arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()
Date: Tue, 8 Apr 2025 10:52:19 +0100

TL;DR: always call the PTE/PMD ctor, passing the appropriate mm to skip
ptlock_init() if unneeded.

__create_pgd_mapping() is used for creating different kinds of mappings,
and may allocate page table pages if passed an allocator callback.  There
are currently three such cases:

1. create_pgd_mapping(), which is used to create the EFI mapping
2. arch_add_memory()
3. map_entry_trampoline()

1. uses pgd_pgtable_alloc() as allocator callback, which calls the
PTE/PMD ctor, while 2.  and 3.  use __pgd_pgtable_alloc(), which does not.
The rationale is most likely that pgtables associated with init_mm do not
make use of split page table locks, and it is therefore unnecessary to
initialise them by calling the ctor.  2.  operates on swapper_pg_dir so
the allocated pgtables are clearly associated with init_mm, this is
arguably the case for 3.  too (the trampoline mapping is never modified so
ptlocks are anyway irrelevant).  1.  corresponds to efi_mm so ptlocks need
to be initialised in that case.

We are now moving towards calling the ctor for all page tables, even those
associated with init_mm.  pagetable_{pte,pmd}_ctor() have become aware of
the associated mm so that the ptlock initialisation can be skipped for
init_mm.  This patch therefore amends the allocator callbacks so that the
PTE/PMD ctor are always called, with an appropriate mm pointer to avoid
unnecessary ptlock overhead.

Modifying the prototype of the allocator callbacks to take the mm and
propagating that pointer all the way down would be pretty invasive. 
Instead:

* __pgd_pgtable_alloc() (cases 2.  and 3.  above) is replaced with
  pgd_pgtable_alloc_init_mm(), resulting in the ctors being called with
  &init_mm.  This is the main functional change in this patch; the ptlock
  still isn't initialised, but other ctor actions (e.g. 
  accounting-related) are now carried out for those allocated pgtables.

* pgd_pgtable_alloc() (case 1.  above) is replaced with
  pgd_pgtable_alloc_special_mm(), resulting in the ctors being called with
  NULL as mm.  No functional change here; NULL essentially means "not
  init_mm", and the ptlock is still initialised.

__pgd_pgtable_alloc() is now the common implementation of those two
helpers.  While at it we switch it to using pagetable_alloc() like
standard pgtable allocator functions and remove the comment regarding ctor
calls (ctors are now always expected to be called).

Link: https://lkml.kernel.org/r/20250408095222.860601-10-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <x86@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   43 ++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping
+++ a/arch/arm64/mm/mmu.c
@@ -480,31 +480,22 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdi
 			     int flags);
 #endif
 
-static phys_addr_t __pgd_pgtable_alloc(enum pgtable_type pgtable_type)
+static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
+				       enum pgtable_type pgtable_type)
 {
 	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
-	void *ptr = (void *)__get_free_page(GFP_PGTABLE_KERNEL & ~__GFP_ZERO);
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL & ~__GFP_ZERO, 0);
+	phys_addr_t pa;
 
-	BUG_ON(!ptr);
-	return __pa(ptr);
-}
-
-static phys_addr_t pgd_pgtable_alloc(enum pgtable_type pgtable_type)
-{
-	phys_addr_t pa = __pgd_pgtable_alloc(pgtable_type);
-	struct ptdesc *ptdesc = page_ptdesc(phys_to_page(pa));
+	BUG_ON(!ptdesc);
+	pa = page_to_phys(ptdesc_page(ptdesc));
 
-	/*
-	 * Call proper page table ctor in case later we need to
-	 * call core mm functions like apply_to_page_range() on
-	 * this pre-allocated page table.
-	 */
 	switch (pgtable_type) {
 	case TABLE_PTE:
-		BUG_ON(!pagetable_pte_ctor(NULL, ptdesc));
+		BUG_ON(!pagetable_pte_ctor(mm, ptdesc));
 		break;
 	case TABLE_PMD:
-		BUG_ON(!pagetable_pmd_ctor(NULL, ptdesc));
+		BUG_ON(!pagetable_pmd_ctor(mm, ptdesc));
 		break;
 	default:
 		break;
@@ -513,6 +504,18 @@ static phys_addr_t pgd_pgtable_alloc(enu
 	return pa;
 }
 
+static phys_addr_t __maybe_unused
+pgd_pgtable_alloc_init_mm(enum pgtable_type pgtable_type)
+{
+	return __pgd_pgtable_alloc(&init_mm, pgtable_type);
+}
+
+static phys_addr_t
+pgd_pgtable_alloc_special_mm(enum pgtable_type pgtable_type)
+{
+	return __pgd_pgtable_alloc(NULL, pgtable_type);
+}
+
 /*
  * This function can only be used to modify existing table entries,
  * without allocating new levels of table. Note that this permits the
@@ -542,7 +545,7 @@ void __init create_pgd_mapping(struct mm
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-			     pgd_pgtable_alloc, flags);
+			     pgd_pgtable_alloc_special_mm, flags);
 }
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
@@ -756,7 +759,7 @@ static int __init map_entry_trampoline(v
 	memset(tramp_pg_dir, 0, PGD_SIZE);
 	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
 			     entry_tramp_text_size(), prot,
-			     __pgd_pgtable_alloc, NO_BLOCK_MAPPINGS);
+			     pgd_pgtable_alloc_init_mm, NO_BLOCK_MAPPINGS);
 
 	/* Map both the text and data into the kernel page table */
 	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
@@ -1362,7 +1365,7 @@ int arch_add_memory(int nid, u64 start,
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
-			     size, params->pgprot, __pgd_pgtable_alloc,
+			     size, params->pgprot, pgd_pgtable_alloc_init_mm,
 			     flags);
 
 	memblock_clear_nomap(start, size);
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are



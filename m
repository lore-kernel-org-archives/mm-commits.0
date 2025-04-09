Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C180614A605
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160865; cv=none; b=AasMLOvA7pQ+RrlVR4hub6cE6i8hWfY3rEKI1m9L7Jm2wK6llAGaNyJxSlWJmYp0i/tR5KjDxiqJiHRbvPShGbLonIh2CdruGCX+jpT5QJnAcQvjrnbb9XiUm0lL7jTjsn5ic54i1AvfJe9tz8CB+5wAcHr92/lI+3YnoMRgduE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160865; c=relaxed/simple;
	bh=EeCfR9FHRNPBXjUV4aEsYenM1S4v2X6FGyU+mMwCLCo=;
	h=Date:To:From:Subject:Message-Id; b=RwoDlQrTDCrc6kj/1oH2RJOgRAWeEetQ/ywUXee9OADoRMe4hqZy9hSNguA6poWhYhbsZr7QzI3pAR6DEPsQPJ38W0oBoBNYTvzSjvV6IUO1SAJqANfJmXuMPL9jR4YHMhgUID/FcI++O4KdtgaJxLTyKr3YWQ3GtibEgFdyfjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hrY9LH8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hrY9LH8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6D9C4CEE5;
	Wed,  9 Apr 2025 01:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160865;
	bh=EeCfR9FHRNPBXjUV4aEsYenM1S4v2X6FGyU+mMwCLCo=;
	h=Date:To:From:Subject:From;
	b=hrY9LH8XUIKns+PHAdyNBdmyHzUkXQbR6Mr5WODaj+oA4MnJpyR9qY6qJB9AUrtxS
	 TdJ/zXaVTOt6wsysaOuOeWjm5QotcvXyaxgVwu76APx45jLHyT4TLtUOc0kzInBSNn
	 4Ww59FhrBqgX7B5feVUBEU7+2lGB5a/CvhlcINWo=
Date: Tue, 08 Apr 2025 18:07:44 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch added to mm-new branch
Message-Id: <20250409010745.2E6D9C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch

This patch will later appear in the mm-new branch at
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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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

mm-pass-mm-down-to-pagetable_ptepmd_ctor.patch
x86-pgtable-always-use-pte_free_kernel.patch
mm-call-ctor-dtor-for-kernel-ptes.patch
m68k-mm-call-ctor-dtor-for-kernel-ptes.patch
powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch
sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch
mm-skip-ptlock_init-for-kernel-pmds.patch
arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift.patch
arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch
riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch
arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch
riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch


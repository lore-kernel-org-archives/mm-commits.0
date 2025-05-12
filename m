Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974CEC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011077; cv=none; b=Mlk2nPfKbWjP5saoBEUDdI1DK9oXqHSteJA3oVMS7unZm40Xstt8noCBBb8q2a506hB40vK19cZjeacIPMOPbfRP6LyfNbA2sd8TC70GpATCr7wBwBtXAmu+E5H1vdl5KZiVWrkPwtllr+dVIqSrXNAEkYowfQGdokstAuK/3Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011077; c=relaxed/simple;
	bh=hRLhAEVLWyGou2SJDnkicMHg40xnjxLvZWf9l6uKA0w=;
	h=Date:To:From:Subject:Message-Id; b=cA+dnY85Y+RFj0n3jGVi3wu5tsL7oDIViCRiqgwADYi+x99ZSxaV45fN8oPlZP58pRL98aCPmXD8VDbsD9dSd2yYM4tB+ZMBB/BMKUF4yvZeE8EHEOdRPmCMu+vNSJNfZGglLAKWCvvBkGD3Mx4s8NDpJJMe4y7lSIQgnqddxwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVj3HiIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVj3HiIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB55C4CEE4;
	Mon, 12 May 2025 00:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011077;
	bh=hRLhAEVLWyGou2SJDnkicMHg40xnjxLvZWf9l6uKA0w=;
	h=Date:To:From:Subject:From;
	b=MVj3HiIPk6QHkmf7nsIhz0VMjS3YOaDNGCVFRjKyjsXaw72asGK4YlLaK5TeBrKIj
	 Lt/xVygvGkRdfy/+m7ygvjOxIEN9W2t4/pIxYd1zkQEnK35/0eAmjJn/Am3pTW8o1Y
	 EYeASxDhP4VrRRgQejHAqMcId/ndELKOXsdxHrzw=
Date: Sun, 11 May 2025 17:51:16 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-ctor-dtor-for-kernel-ptes.patch removed from -mm tree
Message-Id: <20250512005117.6BB55C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: call ctor/dtor for kernel PTEs
has been removed from the -mm tree.  Its filename was
     mm-call-ctor-dtor-for-kernel-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: call ctor/dtor for kernel PTEs
Date: Tue, 8 Apr 2025 10:52:13 +0100

Since [1], constructors/destructors are expected to be called for all page
table pages, at all levels and for both user and kernel pgtables.  There
is however one glaring exception: kernel PTEs are managed via separate
helpers (pte_alloc_kernel/pte_free_kernel), which do not call the [cd]tor,
at least not in the generic implementation.

The most obvious reason for this anomaly is that init_mm is special-cased
not to use split page table locks.  As a result calling ptlock_init() for
PTEs associated with init_mm would be wasteful, potentially resulting in
dynamic memory allocation.  However, pgtable [cd]tors perform other
actions - currently related to accounting/statistics, and potentially more
functionally significant in the future.

Now that pagetable_pte_ctor() is passed the associated mm, we can make it
skip the call to ptlock_init() for init_mm; this allows us to call the
ctor from pte_alloc_one_kernel() too.  This is matched by a call to the
pgtable destructor in pte_free_kernel(); no special-casing is needed on
that path, as ptlock_free() is already called unconditionally. 
(ptlock_free() is a no-op unless a ptlock was allocated for the given
PTP.)

This patch ensures that all architectures that rely on
<asm-generic/pgalloc.h> call the [cd]tor for kernel PTEs. 
pte_free_kernel() cannot be overridden so changing the generic
implementation is sufficient.  pte_alloc_one_kernel() can be overridden
using __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL, and a few architectures implement
it by calling the page allocator directly.  We amend those so that they
call the generic __pte_alloc_one_kernel() instead, if possible, ensuring
that the ctor is called.

A few architectures do not use <asm-generic/pgalloc.h>; those will be
taken care of separately.

[1] https://lore.kernel.org/linux-mm/20250103184415.2744423-1-kevin.brodsky@arm.com/

Link: https://lkml.kernel.org/r/20250408095222.860601-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com> # s390
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgalloc.h |    2 +-
 arch/microblaze/mm/pgtable.c    |    2 +-
 arch/openrisc/mm/ioremap.c      |    2 +-
 include/asm-generic/pgalloc.h   |    7 ++++++-
 include/linux/mm.h              |    2 +-
 5 files changed, 10 insertions(+), 5 deletions(-)

--- a/arch/csky/include/asm/pgalloc.h~mm-call-ctor-dtor-for-kernel-ptes
+++ a/arch/csky/include/asm/pgalloc.h
@@ -29,7 +29,7 @@ static inline pte_t *pte_alloc_one_kerne
 	pte_t *pte;
 	unsigned long i;
 
-	pte = (pte_t *) __get_free_page(GFP_KERNEL);
+	pte = __pte_alloc_one_kernel(mm);
 	if (!pte)
 		return NULL;
 
--- a/arch/microblaze/mm/pgtable.c~mm-call-ctor-dtor-for-kernel-ptes
+++ a/arch/microblaze/mm/pgtable.c
@@ -245,7 +245,7 @@ unsigned long iopa(unsigned long addr)
 __ref pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 {
 	if (mem_init_done)
-		return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		return __pte_alloc_one_kernel(mm);
 	else
 		return memblock_alloc_try_nid(PAGE_SIZE, PAGE_SIZE,
 					      MEMBLOCK_LOW_LIMIT,
--- a/arch/openrisc/mm/ioremap.c~mm-call-ctor-dtor-for-kernel-ptes
+++ a/arch/openrisc/mm/ioremap.c
@@ -36,7 +36,7 @@ pte_t __ref *pte_alloc_one_kernel(struct
 	pte_t *pte;
 
 	if (likely(mem_init_done)) {
-		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+		pte = __pte_alloc_one_kernel(mm);
 	} else {
 		pte = memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
 	}
--- a/include/asm-generic/pgalloc.h~mm-call-ctor-dtor-for-kernel-ptes
+++ a/include/asm-generic/pgalloc.h
@@ -23,6 +23,11 @@ static inline pte_t *__pte_alloc_one_ker
 
 	if (!ptdesc)
 		return NULL;
+	if (!pagetable_pte_ctor(mm, ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
+
 	return ptdesc_address(ptdesc);
 }
 #define __pte_alloc_one_kernel(...)	alloc_hooks(__pte_alloc_one_kernel_noprof(__VA_ARGS__))
@@ -48,7 +53,7 @@ static inline pte_t *pte_alloc_one_kerne
  */
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_free(virt_to_ptdesc(pte));
+	pagetable_dtor_free(virt_to_ptdesc(pte));
 }
 
 /**
--- a/include/linux/mm.h~mm-call-ctor-dtor-for-kernel-ptes
+++ a/include/linux/mm.h
@@ -3150,7 +3150,7 @@ static inline void pagetable_dtor_free(s
 static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
-	if (!ptlock_init(ptdesc))
+	if (mm != &init_mm && !ptlock_init(ptdesc))
 		return false;
 	__pagetable_ctor(ptdesc);
 	return true;
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793342060;
	b=np09+U3mv9S25fwHBrZExxTz5r9RoVTO+kGdQrC8VfCkMC3Co6egeNmHUudc3kPp0kKF
	 OkJs1o5qObpZ/5g0tig9rQzqtllxQ7bMkvoCYEwlMcB5Q5L+ynOjkDEMIhq99+3AJfYR7
	 jqd6NFRDSTYkMftftAUViySn9kL9Trg7Mzsq3felijpEFHnwdhoEklrNV0d9ozP8pbfCg
	 twSKosvg6taLxxPLphwB25dyrzhK2wGe4FSCFkreAPe83zu0xKc0v14cesNmM4AVkQwnt
	 Ki81/X1IxBWJEjeL67pxWtFG4mWRr9zTa3AXLnt3ZHZ3zGUtWgQeetTT2ecryJe0lYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793342060;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2G3xsF3oVNmpN8BIs9FURERYUVd/nro2JgUCcsoB87A=;
	b=AAW7OjJK0rLtWLmi/phNkEW5yOItLeCs5GwQePKkXBm33SV3AvnbKP5fvM2Ue9amyFpE
	 1ckK+vaN8rL2kRc/Hs/1+ejAxxV1i+a0vizfime9DiDRviUiz3btRIobfLcVq1gr5DlU+
	 zWb6j9hulxTVr2g6ZuOxFT3W/Q2x49LcUSuAuaiSk4VvGglqP/NibKK/vaN2ms8hPICBv
	 M/YjB0hAHfwQYiDeHuqoBwlnxHdImbE0I7jlbmTgxAjx3a8u4wLTPCp8v13DjuDywx/gH
	 7xUCfXXzCy/Ksl8F7vMZVtDh2jOr0/H11ZAC5UsaBBXFAD+ltXk5wLjZr8A0b861qdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ryY+bVdU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DC0606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ryY+bVdU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5ED1F0093A;
	Fri, 30 Oct 2026 06:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793342059;
	bh=2G3xsF3oVNmpN8BIs9FURERYUVd/nro2JgUCcsoB87A=;
	h=Date:To:From:Subject;
	b=ryY+bVdU08ulqiDEfD0dh//5pRU1K3jVpB6OTVoSf/D8INYwm/5lyWH9a1gqZ1zxX
	 F/hqdWUrj6RhMG3KVCnTrlyGw/vkWP5GClak1DTbAnE/DSfpMYBzXPQjQZ+VrY7jhc
	 bg7vmOE3LAtZgqna0a4fRpqx9dJebqsQ0HO5O+5s=
Date: Thu, 29 Oct 2026 23:34:19 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,rppt@kernel.org,
	kernel@xen0n.name,james.bottomley@hansenpartnership.com,deller@gmx.de,
	david@kernel.org,chenhuacai@kernel.org,arnd@arndb.de,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-generalize-kernel-pte-table-allocation.patch added to mm-new branch
Message-Id: <20261030063419.8A5ED1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: generalize kernel PTE table allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-generalize-kernel-pte-table-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-generalize-kernel-pte-table-allocation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: generalize kernel PTE table allocation
Date: Wed, 14 Oct 2026 11:59:08 +0800

Patch series "mm: Generalize page table allocation helpers".

A subsequent series will switch runtime vmemmap population to the generic
page-table allocators.  Since vmemmap tables belong to init_mm, the
allocators must select GFP_PGTABLE_KERNEL and mark the ptdesc as a kernel
page table.

Some architecture-specific allocators do not preserve both semantics. 
LoongArch and MIPS choose PMD/PUD GFP flags without checking the mm, which
can charge kernel PMD tables to a memcg and leave user PUD tables
unaccounted.  The private PMD/PUD allocators also omit kernel ptdesc
marking.

Rather than duplicate this handling in each architecture, extend the
generic PTE, PMD and PUD allocators to support architecture initialization
hooks and non-zero table orders.  LoongArch, MIPS and parisc can then drop
their private allocators and inherit the generic GFP selection and ptdesc
handling.

This series only prepares the allocation interfaces; the runtime
vmemmap conversion will be submitted separately.


This patch (of 3):

Architectures whose empty kernel PTE representation is not all zero must
initialize new kernel PTE tables.  LoongArch therefore wraps
__pte_alloc_one_kernel() solely to call kernel_pte_init().

Call the architecture initialization hook from the generic allocator so
LoongArch can use it directly. The default hook is empty, so this does not
change other architectures.

Link: https://lore.kernel.org/20261014035910.687847-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261014035910.687847-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>
---

 arch/loongarch/include/asm/pgalloc.h |   11 -----------
 include/asm-generic/pgalloc.h        |    6 +++++-
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/arch/loongarch/include/asm/pgalloc.h~mm-generalize-kernel-pte-table-allocation
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -10,7 +10,6 @@
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_ALLOC_ONE
-#define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
@@ -45,16 +44,6 @@ extern void pagetable_init(void);
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
-{
-	pte_t *pte = __pte_alloc_one_kernel(mm);
-
-	if (pte)
-		kernel_pte_init(pte);
-
-	return pte;
-}
-
 #define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
--- a/include/asm-generic/pgalloc.h~mm-generalize-kernel-pte-table-allocation
+++ a/include/asm-generic/pgalloc.h
@@ -19,6 +19,7 @@
 static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 {
 	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
+	pte_t *pte;
 
 	if (!ptdesc)
 		return NULL;
@@ -29,7 +30,10 @@ static inline pte_t *__pte_alloc_one_ker
 
 	ptdesc_set_kernel(ptdesc);
 
-	return ptdesc_address(ptdesc);
+	pte = ptdesc_address(ptdesc);
+	kernel_pte_init(pte);
+
+	return pte;
 }
 #define __pte_alloc_one_kernel(...)	alloc_hooks(__pte_alloc_one_kernel_noprof(__VA_ARGS__))
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch


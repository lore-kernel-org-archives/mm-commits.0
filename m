Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793342066;
	b=RSkJrzbE9N1HxSLRlqKK4/OJrMr5kNql8rBDtAb8VcE4pWUg07JZurjbZaGKCsY4HmVi
	 yqxAya37K+XYYol8+nsN/w/vWGeaWfLRxQFI3ukItPQWodWSrSkBjV8IQmkwDvLyihYID
	 YlZ4kdtcdBKfaZ6HiDoZgacGd2iGbeaBqSVjcAbUATVt6u88v1bIsxstELl5WmZGrrcRi
	 CdDl0chsZ9LTQHS1tFx7UDvJLJ48I54VPjBxtUzc0+4N+b375AXMp2q7A5setW+md6K+H
	 rm/gDz3R1ce38Z6JlicYrSB+cH1NmjHN6i/MgsamuHGzGJ1qqTUOShk6Bo1XKlishjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793342066;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lD1P7SCwJM7JPeIoG6ay6nkGlYPc++pmjQ7vdWv2J1I=;
	b=G5f9F2MwfnLNYccjiXN+hSz/hic5pPb6i+o7wBJYwYbuXOWq50pWVAkaT/zD/SQdjfmP
	 NYJYAeI01DacfdnztBwcirYk5Jgb1MwkXX+ejFK880URrDj7FoCHZkPEjwqOV6E9NS6WH
	 T6h113FXhpWFzdCdVa3CkcY2RZwAY9IA1NiZYkB+IFCEwmgBFUQWuW+1Vv4ypdScWFZqg
	 Kp2li68+vTHx8yHu+NorDVXBQ+EtviUz6D/RcyTJfX6RgoZLPlBX+cZjZKB703Ry+KQgA
	 ZDGq8iuyJONxiyCyDtWyzyp8HuM0DPUIGT2lPfZKgNlhNxnWrKeZSYBM4nB83NXZwjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2qVL75A6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBFC606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2qVL75A6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6911F000C1;
	Fri, 30 Oct 2026 06:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793342065;
	bh=lD1P7SCwJM7JPeIoG6ay6nkGlYPc++pmjQ7vdWv2J1I=;
	h=Date:To:From:Subject;
	b=2qVL75A6InSZ/RvzTU/PvpVNxgbPqd0CkiNL4OUOeaQwuk600hmo6RHaqP5KbbkuP
	 EIBPP2owDvFE1JZBbr1CjZWccKilamzXi9GljoljW2ON1IurVjTKBwqn9Dp41j0KEC
	 2gX7RMR8RiWXOafae5Li3la0DS9T71nC0YGpCPLY=
Date: Thu, 29 Oct 2026 23:34:24 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,rppt@kernel.org,
	kernel@xen0n.name,james.bottomley@hansenpartnership.com,deller@gmx.de,
	david@kernel.org,chenhuacai@kernel.org,arnd@arndb.de,muchun.song@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-generalize-pud-page-table-allocation.patch added to mm-new branch
Message-Id: <20261030063425.4E6911F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: generalize PUD page table allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-generalize-pud-page-table-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-generalize-pud-page-table-allocation.patch

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
Subject: mm: generalize PUD page table allocation
Date: Wed, 14 Oct 2026 11:59:10 +0800

The generic PUD allocator assumes order-0 page tables and zero-valued empty
entries. MIPS and LoongArch need pud_init() to install their invalid
entries. MIPS also uses PUD_TABLE_ORDER to describe the allocation size.

Default PUD_TABLE_ORDER to zero, honor architecture overrides, and invoke
pud_init() from the generic allocator. MIPS and LoongArch can then drop
their duplicate helpers and use the generic constructor handling and kernel
ptdesc marking.

This also switches their user PUD allocations from GFP_KERNEL to
GFP_PGTABLE_USER, so they are accounted to the active memory cgroup
context. Allocations for init_mm continue to use GFP_PGTABLE_KERNEL.

Link: https://lore.kernel.org/20261014035910.687847-4-songmuchun@bytedance.com
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

 arch/loongarch/include/asm/pgalloc.h |   16 ----------------
 arch/mips/include/asm/pgalloc.h      |   15 ---------------
 include/asm-generic/pgalloc.h        |   11 +++++++++--
 3 files changed, 9 insertions(+), 33 deletions(-)

--- a/arch/loongarch/include/asm/pgalloc.h~mm-generalize-pud-page-table-allocation
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
@@ -51,21 +50,6 @@ extern pgd_t *pgd_alloc(struct mm_struct
 #endif
 
 #ifndef __PAGETABLE_PUD_FOLDED
-
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pud_t *pud;
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-
-	if (!ptdesc)
-		return NULL;
-	pagetable_pud_ctor(ptdesc);
-	pud = ptdesc_address(ptdesc);
-
-	pud_init(pud);
-	return pud;
-}
-
 #define __pud_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
--- a/arch/mips/include/asm/pgalloc.h~mm-generalize-pud-page-table-allocation
+++ a/arch/mips/include/asm/pgalloc.h
@@ -13,7 +13,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define __HAVE_ARCH_PUD_ALLOC_ONE
 #include <asm-generic/pgalloc.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
@@ -52,20 +51,6 @@ extern pgd_t *pgd_alloc(struct mm_struct
 
 #ifndef __PAGETABLE_PUD_FOLDED
 
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	pud_t *pud;
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, PUD_TABLE_ORDER);
-
-	if (!ptdesc)
-		return NULL;
-	pagetable_pud_ctor(ptdesc);
-	pud = ptdesc_address(ptdesc);
-
-	pud_init(pud);
-	return pud;
-}
-
 static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4d, pud_t *pud)
 {
 	set_p4d(p4d, __p4d((unsigned long)pud));
--- a/include/asm-generic/pgalloc.h~mm-generalize-pud-page-table-allocation
+++ a/include/asm-generic/pgalloc.h
@@ -182,24 +182,31 @@ static inline void pmd_free(struct mm_st
 
 #if CONFIG_PGTABLE_LEVELS > 3
 
+#ifndef PUD_TABLE_ORDER
+#define PUD_TABLE_ORDER	0
+#endif
+
 static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long addr)
 {
 	gfp_t gfp = GFP_PGTABLE_USER;
 	struct ptdesc *ptdesc;
+	pud_t *pud;
 
 	if (mm == &init_mm)
 		gfp = GFP_PGTABLE_KERNEL;
 
-	ptdesc = pagetable_alloc_noprof(gfp, 0);
+	ptdesc = pagetable_alloc_noprof(gfp, PUD_TABLE_ORDER);
 	if (!ptdesc)
 		return NULL;
 
 	pagetable_pud_ctor(ptdesc);
+	pud = ptdesc_address(ptdesc);
+	pud_init(pud);
 
 	if (mm == &init_mm)
 		ptdesc_set_kernel(ptdesc);
 
-	return ptdesc_address(ptdesc);
+	return pud;
 }
 #define __pud_alloc_one(...)	alloc_hooks(__pud_alloc_one_noprof(__VA_ARGS__))
 
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


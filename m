Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793389147;
	b=1Ho5mrdoGowxrG1chqCYpeBAfpPYBf4egCCgx1cq5m3SN3c8SGIFK/0EHMjvk42Hwa0J
	 peWh2d596BjyBuPyHJZaatFYbM0qZ3um+f1kbZm0Cvc+1w4N8Rf5d46IAPEmKNOCKLdX8
	 oCGz1gbfA/O2EH2I2c3R7pzFNwe/xiHvIT9TZWjKXXnlgTLVR+yUoQpWXc5TWG7ACzBPm
	 rtKBbV1yDWE9qbtbt5aSHxzS2JX/zzFEXRSDFp84XLWP/52OQ4kphbb3g3aD1s4K2/s/4
	 OY7GyVbjJfB41u6RUV3k0tP8dD2U0UD8oy51o7Xb4HGmLteALfIU9HUc+yrQWm9gmoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793389147;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0mbaFOrz7RZEJyzk/5Piliqa2jJGLoccqliVSaXqJTo=;
	b=xH5762MD2q60tosQdQhF0p65Uwi4/UdqRHT+5lSbS7MbzB1Z0Elp0wZHmadW7VCGYjED
	 wpJoE2EP3yeYGHer3XdDkVtkcSI3z2fERzaqhB2Gm0m6Nu/AiB97L4RtgYrVLKWafOVn7
	 amFMn9pGmZM1taKfGzdzfwH/NHlMe7qZNXN1KndoKvJoPYCrENVsLfFsq7X/G3o4b/Q3l
	 QVfg5twwDzdzCNSzGD6onWHAjEb6WvZj6Xh6VIZXr/66Mq3UR04qnp5B/s3D0b2VkZPvw
	 vVo/j0L8c1xG2ZUZvNILF22+mT0oBtGbfTAujve1a9qXys6L/ylar22vWHC/feTaPXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1oEzB0zS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0000606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 19:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1oEzB0zS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586181F0093A;
	Fri, 30 Oct 2026 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793389146;
	bh=0mbaFOrz7RZEJyzk/5Piliqa2jJGLoccqliVSaXqJTo=;
	h=Date:To:From:Subject;
	b=1oEzB0zS8ldp+Yxcteh3naiT2tROlkSN99j6ISvPVyOWwG0g1hdiV+QWgF2t4ZSsP
	 T4GO5X8S/dySv/aAXWq5IdquBVmnh3nyC+/s9Oe5ig7yd3eyA0qOtnrgY5HGva1KAM
	 I/JUMxotxUHjwugu69opIN4kgxWkHOW4d8KGZoKs=
Date: Fri, 30 Oct 2026 12:39:05 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,
	vishal.moola@gmail.com,osalvador@suse.de,maddy@linux.ibm.com,
	glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,
	geert@linux-m68k.org,david@kernel.org,davem@davemloft.net,
	dave.hansen@linux.intel.com,dalias@libc.org,arnd@arndb.de,apopple@nvidia.com,
	aneesh.kumar@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,
	muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pagetable_dtor_free.patch added to mm-new branch
Message-Id: <20261030193906.586181F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove pagetable_dtor_free()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-pagetable_dtor_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pagetable_dtor_free.patch

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
Subject: mm: remove pagetable_dtor_free()
Date: Fri, 30 Oct 2026 16:37:59 +0800

Patch series "mm: Remove pagetable_dtor_free()".

This is a follow-up cleanup to the page-table teardown fixes [1].

pagetable_free() now invokes pagetable_dtor() for constructed page tables.
This makes pagetable_dtor_free() redundant and leaves explicit destructor
calls immediately before pagetable_free() duplicating lifecycle handling.

Remove pagetable_dtor_free() and convert its callers to pagetable_free(),
then remove the remaining redundant pagetable_dtor() calls.  This keeps
the destructor decision in the common free path.  No functional change is
intended.


This patch (of 2):

pagetable_free() now runs pagetable_dtor() for pages that have gone
through a page-table constructor, so pagetable_dtor_free() no longer
provides distinct behavior.

Use pagetable_free() directly at the remaining call sites and remove the
redundant helper.  This keeps the decision to run the destructor in the
common free path.

Link: https://lore.kernel.org/20261030083800.599152-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20261030083800.599152-2-songmuchun@bytedance.com
Link: https://lore.kernel.org/r/20261023063428.3658761-1-songmuchun@bytedance.com [1]
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K . V <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
---

 arch/m68k/include/asm/mcf_pgalloc.h |    4 ++--
 arch/m68k/mm/motorola.c             |    2 +-
 arch/s390/mm/pgalloc.c              |    4 ++--
 arch/sh/mm/pgtable.c                |    2 +-
 arch/x86/mm/pat/set_memory.c        |   10 +---------
 arch/x86/mm/pgtable.c               |    4 ++--
 include/asm-generic/pgalloc.h       |   12 ++++++------
 include/asm-generic/tlb.h           |    2 +-
 include/linux/mm.h                  |    6 ------
 9 files changed, 16 insertions(+), 30 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgalloc.h~mm-remove-pagetable_dtor_free
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -7,7 +7,7 @@
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_dtor_free(virt_to_ptdesc(pte));
+	pagetable_free(virt_to_ptdesc(pte));
 }
 
 extern const char bad_pmd_string[];
@@ -74,7 +74,7 @@ static inline void pte_free(struct mm_st
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pagetable_dtor_free(virt_to_ptdesc(pgd));
+	pagetable_free(virt_to_ptdesc(pgd));
 }
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
--- a/arch/m68k/mm/motorola.c~mm-remove-pagetable_dtor_free
+++ a/arch/m68k/mm/motorola.c
@@ -237,7 +237,7 @@ int free_pointer_table(void *table, int
 		spin_unlock_bh(&ptable_lock);
 
 		mmu_page_dtor((void *)pt_addr);
-		pagetable_dtor_free(virt_to_ptdesc((void *)pt_addr));
+		pagetable_free(virt_to_ptdesc((void *)pt_addr));
 		return 1;
 	} else if (ptable_list[type].next != dp) {
 		/*
--- a/arch/s390/mm/pgalloc.c~mm-remove-pagetable_dtor_free
+++ a/arch/s390/mm/pgalloc.c
@@ -125,7 +125,7 @@ void page_table_free(struct mm_struct *m
 
 	if (pagetable_is_reserved(ptdesc))
 		return free_reserved_ptdesc(ptdesc);
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -133,7 +133,7 @@ static void pte_free_now(struct rcu_head
 {
 	struct ptdesc *ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
 
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable)
--- a/arch/sh/mm/pgtable.c~mm-remove-pagetable_dtor_free
+++ a/arch/sh/mm/pgtable.c
@@ -64,7 +64,7 @@ static void __tlb_remove_table_slab(void
 
 static void __tlb_remove_table_pgtable(void *table)
 {
-	pagetable_dtor_free(table);
+	pagetable_free(table);
 }
 
 void __tlb_remove_table(void *table)
--- a/arch/x86/mm/pat/set_memory.c~mm-remove-pagetable_dtor_free
+++ a/arch/x86/mm/pat/set_memory.c
@@ -441,15 +441,7 @@ static void __cpa_collapse_large_pages(s
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		/*
-		 * Only early alloc'd direct map should not be flagged PG_table
-		 * here and those shouldn't be collapsed. However be abundantly
-		 * cautious and handle the !PG_table case too.
-		 */
-		if (PageTable((ptdesc_page(ptdesc))))
-			pagetable_dtor_free(ptdesc);
-		else
-			pagetable_free(ptdesc);
+		pagetable_free(ptdesc);
 	}
 }
 
--- a/arch/x86/mm/pgtable.c~mm-remove-pagetable_dtor_free
+++ a/arch/x86/mm/pgtable.c
@@ -732,7 +732,7 @@ int pud_free_pmd_page(pud_t *pud, unsign
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		if (!pmd_none(pmd[i])) {
 			pt = page_ptdesc(pmd_page(pmd[i]));
-			pagetable_dtor_free(pt);
+			pagetable_free(pt);
 		}
 	}
 
@@ -759,7 +759,7 @@ int pmd_free_pte_page(pmd_t *pmd, unsign
 	/* INVLPG to clear all paging-structure caches */
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
 
-	pagetable_dtor_free(pt);
+	pagetable_free(pt);
 
 	return 1;
 }
--- a/include/asm-generic/pgalloc.h~mm-remove-pagetable_dtor_free
+++ a/include/asm-generic/pgalloc.h
@@ -58,7 +58,7 @@ static inline pte_t *pte_alloc_one_kerne
  */
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_dtor_free(virt_to_ptdesc(pte));
+	pagetable_free(virt_to_ptdesc(pte));
 }
 
 /**
@@ -119,7 +119,7 @@ static inline void pte_free(struct mm_st
 {
 	struct ptdesc *ptdesc = page_ptdesc(pte_page);
 
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 
@@ -174,7 +174,7 @@ static inline void pmd_free(struct mm_st
 	struct ptdesc *ptdesc = virt_to_ptdesc(pmd);
 
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 #endif
 
@@ -232,7 +232,7 @@ static inline void __pud_free(struct mm_
 	struct ptdesc *ptdesc = virt_to_ptdesc(pud);
 
 	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_PUD_FREE
@@ -280,7 +280,7 @@ static inline void __p4d_free(struct mm_
 	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
 
 	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_P4D_FREE
@@ -319,7 +319,7 @@ static inline void __pgd_free(struct mm_
 	struct ptdesc *ptdesc = virt_to_ptdesc(pgd);
 
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_PGD_FREE
--- a/include/asm-generic/tlb.h~mm-remove-pagetable_dtor_free
+++ a/include/asm-generic/tlb.h
@@ -202,7 +202,7 @@ static inline void __tlb_remove_table(vo
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
 
-	pagetable_dtor_free(ptdesc);
+	pagetable_free(ptdesc);
 }
 #endif
 
--- a/include/linux/mm.h~mm-remove-pagetable_dtor_free
+++ a/include/linux/mm.h
@@ -4083,12 +4083,6 @@ static inline void pagetable_free(struct
 	}
 }
 
-static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
-{
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
-}
-
 static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
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
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch


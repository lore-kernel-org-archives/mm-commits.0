Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793389153;
	b=MkX7+25RL6ciIeQwfyctyfVvpb/GAWSnQJPtreRYK4WZi0xehnXa+LtCnshRWID6yosu
	 aXmGjYQRBP0Sg8IfoNi2Ej8pAHfd11ec5ELRhsC4h60yLpZEg2ZssPXRXDTSLE00dLoWb
	 CI6IEY6Lvw86QGwO820AINxiasCoOC1QNq+H8jWSQ0Uvim3w0IKZC6YmtsSeDMbU1tOe5
	 yqayfTdhoRWJ6IIEu20NZqxIKIWQUwp32Tj0cQFbcSYX2XXxczouycbQ6EMsZKlZDyQsg
	 66fWE6S2YWHUNmmH2WlWxTJEmRP33rz0NKLe9gQL7gSCy8GAJKP+btydg8mJBdMOOeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793389153;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8BJk9pc+P1NtbFXYvrTl+QgpTip90KOcBEjUGe+iYQ0=;
	b=3cyEhL4N17xkKla8Qbm4ixn2qnvF15I+PDrFBoZO31TZqtnIOnVLBbpddLviWZ0hUWLI
	 xm86qf9PcGq7PQKfhMvFwIASnVctdwkt93Og31aGvVIuA0rbv2jjOp9dk8DWicoVzTcJP
	 +arB1yre4dfD/1nV7JV9oDnNRI1necSkrEqEOo2EdkoN2t+ETV4aPrNfAYG0VSEsj1k4j
	 7gEPZj7/pOD3ELyJuMWFjZNsC9DQIHjGq4KFFaUHkxYuD9NLgV9R8yRMUO5uZQ6/Z6Ciq
	 W6UxRkc5rXiZVIN/qh8mgy74GUgDwOF3HNBZuERTN+icVXzVQ4mngcyAwZI0Ib+ce0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FMfoMl6H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBA7606A329
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 19:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FMfoMl6H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364071F00A02;
	Fri, 30 Oct 2026 19:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793389152;
	bh=8BJk9pc+P1NtbFXYvrTl+QgpTip90KOcBEjUGe+iYQ0=;
	h=Date:To:From:Subject;
	b=FMfoMl6HjA85GpQZhHTphPFvEVgp1k8Y2JX+UwY/SQLBcz/xQm2qnkUKusmVBwaSe
	 mtqhNfp1T6SwnPx3MPup6Gtm/WAQlxy4Qv9mU1iGrgSSSm2kE4Q7336UP5gXV7SOxQ
	 l5QvIV919eVAtDqVN2IG6+TrVvIKbOkzTW1PE9eE=
Date: Fri, 30 Oct 2026 12:39:11 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,
	vishal.moola@gmail.com,osalvador@suse.de,maddy@linux.ibm.com,
	glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,
	geert@linux-m68k.org,david@kernel.org,davem@davemloft.net,
	dave.hansen@linux.intel.com,dalias@libc.org,arnd@arndb.de,apopple@nvidia.com,
	aneesh.kumar@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,
	muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-redundant-pagetable_dtor-calls.patch added to mm-new branch
Message-Id: <20261030193912.364071F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove redundant pagetable_dtor() calls
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-redundant-pagetable_dtor-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-redundant-pagetable_dtor-calls.patch

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
Subject: mm: remove redundant pagetable_dtor() calls
Date: Fri, 30 Oct 2026 16:38:00 +0800

pagetable_free() now runs pagetable_dtor() for constructed page tables. 
Calling the destructor immediately before freeing the page table therefore
duplicates the lifecycle handling at each caller.

Remove the redundant calls and let pagetable_free() handle the destructor.
No functional change is intended.

Link: https://lore.kernel.org/20261030083800.599152-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
Acked-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
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

 arch/m68k/include/asm/mcf_pgalloc.h    |    1 -
 arch/powerpc/mm/book3s64/mmu_context.c |    1 -
 arch/powerpc/mm/book3s64/pgtable.c     |    1 -
 arch/powerpc/mm/pgtable-frag.c         |    2 --
 arch/s390/include/asm/pgalloc.h        |    4 ----
 arch/sparc/mm/init_64.c                |    1 -
 arch/x86/mm/pgtable.c                  |    1 -
 7 files changed, 11 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgalloc.h~mm-remove-redundant-pagetable_dtor-calls
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -62,7 +62,6 @@ static inline void pte_free(struct mm_st
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
 
-	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
--- a/arch/powerpc/mm/book3s64/mmu_context.c~mm-remove-redundant-pagetable_dtor-calls
+++ a/arch/powerpc/mm/book3s64/mmu_context.c
@@ -249,7 +249,6 @@ static void pmd_frag_destroy(void *pmd_f
 	count = ((unsigned long)pmd_frag & ~PAGE_MASK) >> PMD_FRAG_SIZE_SHIFT;
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (atomic_sub_and_test(PMD_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
-		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
 }
--- a/arch/powerpc/mm/book3s64/pgtable.c~mm-remove-redundant-pagetable_dtor-calls
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -450,7 +450,6 @@ void pmd_fragment_free(unsigned long *pm
 
 	BUG_ON(atomic_read(&ptdesc->pt_frag_refcount) <= 0);
 	if (atomic_dec_and_test(&ptdesc->pt_frag_refcount)) {
-		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
 }
--- a/arch/powerpc/mm/pgtable-frag.c~mm-remove-redundant-pagetable_dtor-calls
+++ a/arch/powerpc/mm/pgtable-frag.c
@@ -26,7 +26,6 @@ void pte_frag_destroy(void *pte_frag)
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (atomic_sub_and_test(PTE_FRAG_NR - count, &ptdesc->pt_frag_refcount)) {
 		folio_clear_active(ptdesc_folio(ptdesc));
-		pagetable_dtor(ptdesc);
 		pagetable_free(ptdesc);
 	}
 }
@@ -110,7 +109,6 @@ static void pte_free_now(struct rcu_head
 	struct ptdesc *ptdesc;
 
 	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
-	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
--- a/arch/s390/include/asm/pgalloc.h~mm-remove-redundant-pagetable_dtor-calls
+++ a/arch/s390/include/asm/pgalloc.h
@@ -66,7 +66,6 @@ static inline void p4d_free(struct mm_st
 	if (mm_p4d_folded(mm))
 		return;
 
-	pagetable_dtor(virt_to_ptdesc(p4d));
 	crst_table_free(mm, (unsigned long *) p4d);
 }
 
@@ -88,7 +87,6 @@ static inline void pud_free(struct mm_st
 	if (mm_pud_folded(mm))
 		return;
 
-	pagetable_dtor(virt_to_ptdesc(pud));
 	crst_table_free(mm, (unsigned long *) pud);
 }
 
@@ -111,7 +109,6 @@ static inline void pmd_free(struct mm_st
 {
 	if (mm_pmd_folded(mm))
 		return;
-	pagetable_dtor(virt_to_ptdesc(pmd));
 	crst_table_free(mm, (unsigned long *) pmd);
 }
 
@@ -144,7 +141,6 @@ static inline pgd_t *pgd_alloc_noprof(st
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pagetable_dtor(virt_to_ptdesc(pgd));
 	crst_table_free(mm, (unsigned long *) pgd);
 }
 
--- a/arch/sparc/mm/init_64.c~mm-remove-redundant-pagetable_dtor-calls
+++ a/arch/sparc/mm/init_64.c
@@ -2840,7 +2840,6 @@ static void __pte_free(pgtable_t pte)
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(pte);
 
-	pagetable_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 
--- a/arch/x86/mm/pgtable.c~mm-remove-redundant-pagetable_dtor-calls
+++ a/arch/x86/mm/pgtable.c
@@ -156,7 +156,6 @@ static void free_pmds(struct mm_struct *
 		if (pmds[i]) {
 			ptdesc = virt_to_ptdesc(pmds[i]);
 
-			pagetable_dtor(ptdesc);
 			pagetable_free(ptdesc);
 			mm_dec_nr_pmds(mm);
 		}
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


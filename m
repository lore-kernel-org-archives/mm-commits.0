Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3CA78C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103863; cv=none; b=te4O4ZROENhkADoG5bfkzriJtu6nmcNEgujSOdPTBmvmATfWAkPWBfZYPxw7ApxWB+oPdbTvi6SBRhKt5VxqqjKX1C4ifivGp+X5uljMjypd1YoPLS/Fr2P+NjU1OWhr4TaBBbY4DqNpNeUgA3fmK2lDZ1H8AYelbXQnr/i4h9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103863; c=relaxed/simple;
	bh=FShQ/PzFGangs6qRn/Z49kpMKHlRPjG7gvm/miEUMqI=;
	h=Date:To:From:Subject:Message-Id; b=NQVpKEf0BoNTFxEzAFGFi56HbVlrXVikXTdd4vQcNuUQGKDI+9fb51q47LZsUpJYaVQs3cCv9AyQ5AOvlK8/wtlntlkw6NekUigG/WmTp46L8b2MPsmsLgAX6yjsIBe6WBkw522Ex8lf1Aw+yhQVjwoWFfOI0CFPh11qdT8GRPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K80Yjs1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K80Yjs1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58B4C113CD;
	Fri, 26 Apr 2024 03:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103862;
	bh=FShQ/PzFGangs6qRn/Z49kpMKHlRPjG7gvm/miEUMqI=;
	h=Date:To:From:Subject:From;
	b=K80Yjs1psQxLf63SNd8T87eNOLB30FfJRXO92uwmR9YaXTlfT6/FEZoqc5BvEQFIs
	 0Rdl3mUhAEC8VeIcq/WIl+bXQgdfoFwn6//Lh77XAeU64FC6oFO/jAnnRqq/JPMaOl
	 I6uSuAS+B+oqvsxHQpsuib+sp1NMVrGsWhXFwK/8=
Date: Thu, 25 Apr 2024 20:57:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-treewide-remove-pxd_huge.patch removed from -mm tree
Message-Id: <20240426035742.C58B4C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/treewide: remove pXd_huge()
has been removed from the -mm tree.  Its filename was
     mm-treewide-remove-pxd_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/treewide: remove pXd_huge()
Date: Mon, 18 Mar 2024 16:04:02 -0400

This API is not used anymore, drop it for the whole tree.

Link: https://lkml.kernel.org/r/20240318200404.448346-13-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/Makefile                             |    1 
 arch/arm/mm/hugetlbpage.c                        |   29 -------------
 arch/arm64/mm/hugetlbpage.c                      |   10 ----
 arch/loongarch/mm/hugetlbpage.c                  |   10 ----
 arch/mips/include/asm/pgtable-32.h               |    2 
 arch/mips/include/asm/pgtable-64.h               |    2 
 arch/mips/mm/hugetlbpage.c                       |   10 ----
 arch/parisc/mm/hugetlbpage.c                     |   11 ----
 arch/powerpc/include/asm/book3s/64/pgtable-4k.h  |   10 ----
 arch/powerpc/include/asm/book3s/64/pgtable-64k.h |   25 -----------
 arch/powerpc/include/asm/nohash/pgtable.h        |   10 ----
 arch/riscv/mm/hugetlbpage.c                      |   10 ----
 arch/s390/mm/hugetlbpage.c                       |   10 ----
 arch/sh/mm/hugetlbpage.c                         |   10 ----
 arch/sparc/mm/hugetlbpage.c                      |   10 ----
 arch/x86/mm/hugetlbpage.c                        |   16 -------
 include/linux/hugetlb.h                          |   24 ----------
 17 files changed, 2 insertions(+), 198 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -79,16 +79,6 @@ bool arch_hugetlb_migration_supported(st
 }
 #endif
 
-int pmd_huge(pmd_t pmd)
-{
-	return pmd_leaf(pmd);
-}
-
-int pud_huge(pud_t pud)
-{
-	return pud_leaf(pud);
-}
-
 static int find_num_contig(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep, size_t *pgsize)
 {
--- a/arch/arm/mm/hugetlbpage.c
+++ /dev/null
@@ -1,29 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * arch/arm/mm/hugetlbpage.c
- *
- * Copyright (C) 2012 ARM Ltd.
- *
- * Based on arch/x86/include/asm/hugetlb.h and Bill Carson's patches
- */
-
-#include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/hugetlb.h>
-#include <linux/pagemap.h>
-#include <linux/err.h>
-#include <linux/sysctl.h>
-#include <asm/mman.h>
-#include <asm/tlb.h>
-#include <asm/tlbflush.h>
-
-int pud_huge(pud_t pud)
-{
-	return 0;
-}
-
-int pmd_huge(pmd_t pmd)
-{
-	return pmd_leaf(pmd);
-}
--- a/arch/arm/mm/Makefile~mm-treewide-remove-pxd_huge
+++ a/arch/arm/mm/Makefile
@@ -21,7 +21,6 @@ KASAN_SANITIZE_physaddr.o	:= n
 obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 
 obj-$(CONFIG_ALIGNMENT_TRAP)	+= alignment.o
-obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_ARM_PV_FIXUP)	+= pv-fixup-asm.o
 
 obj-$(CONFIG_CPU_ABRT_NOMMU)	+= abort-nommu.o
--- a/arch/loongarch/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/loongarch/mm/hugetlbpage.c
@@ -50,16 +50,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return (pte_t *) pmd;
 }
 
-int pmd_huge(pmd_t pmd)
-{
-	return (pmd_val(pmd) & _PAGE_HUGE) != 0;
-}
-
-int pud_huge(pud_t pud)
-{
-	return (pud_val(pud) & _PAGE_HUGE) != 0;
-}
-
 uint64_t pmd_to_entrylo(unsigned long pmd_val)
 {
 	uint64_t val;
--- a/arch/mips/include/asm/pgtable-32.h~mm-treewide-remove-pxd_huge
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -129,7 +129,7 @@ static inline int pmd_none(pmd_t pmd)
 static inline int pmd_bad(pmd_t pmd)
 {
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
-	/* pmd_huge(pmd) but inline */
+	/* pmd_leaf(pmd) but inline */
 	if (unlikely(pmd_val(pmd) & _PAGE_HUGE))
 		return 0;
 #endif
--- a/arch/mips/include/asm/pgtable-64.h~mm-treewide-remove-pxd_huge
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -245,7 +245,7 @@ static inline int pmd_none(pmd_t pmd)
 static inline int pmd_bad(pmd_t pmd)
 {
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
-	/* pmd_huge(pmd) but inline */
+	/* pmd_leaf(pmd) but inline */
 	if (unlikely(pmd_val(pmd) & _PAGE_HUGE))
 		return 0;
 #endif
--- a/arch/mips/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/mips/mm/hugetlbpage.c
@@ -57,13 +57,3 @@ pte_t *huge_pte_offset(struct mm_struct
 	}
 	return (pte_t *) pmd;
 }
-
-int pmd_huge(pmd_t pmd)
-{
-	return (pmd_val(pmd) & _PAGE_HUGE) != 0;
-}
-
-int pud_huge(pud_t pud)
-{
-	return (pud_val(pud) & _PAGE_HUGE) != 0;
-}
--- a/arch/parisc/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -180,14 +180,3 @@ int huge_ptep_set_access_flags(struct vm
 	}
 	return changed;
 }
-
-
-int pmd_huge(pmd_t pmd)
-{
-	return 0;
-}
-
-int pud_huge(pud_t pud)
-{
-	return 0;
-}
--- a/arch/powerpc/include/asm/book3s/64/pgtable-4k.h~mm-treewide-remove-pxd_huge
+++ a/arch/powerpc/include/asm/book3s/64/pgtable-4k.h
@@ -6,16 +6,6 @@
  */
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_HUGETLB_PAGE
-static inline int pmd_huge(pmd_t pmd)
-{
-	return pmd_leaf(pmd);
-}
-
-static inline int pud_huge(pud_t pud)
-{
-	return pud_leaf(pud);
-}
-
 /*
  * With radix , we have hugepage ptes in the pud and pmd entries. We don't
  * need to setup hugepage directory for them. Our pte and page directory format
--- a/arch/powerpc/include/asm/book3s/64/pgtable-64k.h~mm-treewide-remove-pxd_huge
+++ a/arch/powerpc/include/asm/book3s/64/pgtable-64k.h
@@ -4,31 +4,6 @@
 
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_HUGETLB_PAGE
-/*
- * We have PGD_INDEX_SIZ = 12 and PTE_INDEX_SIZE = 8, so that we can have
- * 16GB hugepage pte in PGD and 16MB hugepage pte at PMD;
- *
- * Defined in such a way that we can optimize away code block at build time
- * if CONFIG_HUGETLB_PAGE=n.
- *
- * returns true for pmd migration entries, THP, devmap, hugetlb
- * But compile time dependent on CONFIG_HUGETLB_PAGE
- */
-static inline int pmd_huge(pmd_t pmd)
-{
-	/*
-	 * leaf pte for huge page
-	 */
-	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
-}
-
-static inline int pud_huge(pud_t pud)
-{
-	/*
-	 * leaf pte for huge page
-	 */
-	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PTE));
-}
 
 /*
  * With 64k page size, we have hugepage ptes in the pgd and pmd entries. We don't
--- a/arch/powerpc/include/asm/nohash/pgtable.h~mm-treewide-remove-pxd_huge
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -351,16 +351,6 @@ static inline int hugepd_ok(hugepd_t hpd
 #endif
 }
 
-static inline int pmd_huge(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline int pud_huge(pud_t pud)
-{
-	return 0;
-}
-
 #define is_hugepd(hpd)		(hugepd_ok(hpd))
 #endif
 
--- a/arch/riscv/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/riscv/mm/hugetlbpage.c
@@ -399,16 +399,6 @@ static bool is_napot_size(unsigned long
 
 #endif /*CONFIG_RISCV_ISA_SVNAPOT*/
 
-int pud_huge(pud_t pud)
-{
-	return pud_leaf(pud);
-}
-
-int pmd_huge(pmd_t pmd)
-{
-	return pmd_leaf(pmd);
-}
-
 static bool __hugetlb_valid_size(unsigned long size)
 {
 	if (size == HPAGE_SIZE)
--- a/arch/s390/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/s390/mm/hugetlbpage.c
@@ -233,16 +233,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return (pte_t *) pmdp;
 }
 
-int pmd_huge(pmd_t pmd)
-{
-	return pmd_leaf(pmd);
-}
-
-int pud_huge(pud_t pud)
-{
-	return pud_leaf(pud);
-}
-
 bool __init arch_hugetlb_valid_size(unsigned long size)
 {
 	if (MACHINE_HAS_EDAT1 && size == PMD_SIZE)
--- a/arch/sh/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/sh/mm/hugetlbpage.c
@@ -70,13 +70,3 @@ pte_t *huge_pte_offset(struct mm_struct
 
 	return pte;
 }
-
-int pmd_huge(pmd_t pmd)
-{
-	return 0;
-}
-
-int pud_huge(pud_t pud)
-{
-	return 0;
-}
--- a/arch/sparc/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -407,16 +407,6 @@ pte_t huge_ptep_get_and_clear(struct mm_
 	return entry;
 }
 
-int pmd_huge(pmd_t pmd)
-{
-	return pmd_leaf(pmd);
-}
-
-int pud_huge(pud_t pud)
-{
-	return pud_leaf(pud);
-}
-
 static void hugetlb_free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
 			   unsigned long addr)
 {
--- a/arch/x86/mm/hugetlbpage.c~mm-treewide-remove-pxd_huge
+++ a/arch/x86/mm/hugetlbpage.c
@@ -19,22 +19,6 @@
 #include <asm/tlbflush.h>
 #include <asm/elf.h>
 
-/*
- * pmd_huge() returns 1 if @pmd is hugetlb related entry.
- */
-int pmd_huge(pmd_t pmd)
-{
-	return pmd_leaf(pmd);
-}
-
-/*
- * pud_huge() returns 1 if @pud is hugetlb related entry.
- */
-int pud_huge(pud_t pud)
-{
-	return pud_leaf(pud);
-}
-
 #ifdef CONFIG_HUGETLB_PAGE
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 		unsigned long addr, unsigned long len,
--- a/include/linux/hugetlb.h~mm-treewide-remove-pxd_huge
+++ a/include/linux/hugetlb.h
@@ -272,13 +272,9 @@ void hugetlb_vma_unlock_write(struct vm_
 int hugetlb_vma_trylock_write(struct vm_area_struct *vma);
 void hugetlb_vma_assert_locked(struct vm_area_struct *vma);
 void hugetlb_vma_lock_release(struct kref *kref);
-
-int pmd_huge(pmd_t pmd);
-int pud_huge(pud_t pud);
 long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot,
 		unsigned long cp_flags);
-
 bool is_hugetlb_entry_migration(pte_t pte);
 bool is_hugetlb_entry_hwpoisoned(pte_t pte);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
@@ -399,16 +395,6 @@ static inline void hugetlb_vma_assert_lo
 {
 }
 
-static inline int pmd_huge(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline int pud_huge(pud_t pud)
-{
-	return 0;
-}
-
 static inline int is_hugepage_only_range(struct mm_struct *mm,
 					unsigned long addr, unsigned long len)
 {
@@ -493,16 +479,6 @@ static inline vm_fault_t hugetlb_fault(s
 static inline void hugetlb_unshare_all_pmds(struct vm_area_struct *vma) { }
 
 #endif /* !CONFIG_HUGETLB_PAGE */
-/*
- * hugepages at page global directory. If arch support
- * hugepages at pgd level, they need to define this.
- */
-#ifndef pgd_huge
-#define pgd_huge(x)	0
-#endif
-#ifndef p4d_huge
-#define p4d_huge(x)	0
-#endif
 
 #ifndef pgd_write
 static inline int pgd_write(pgd_t pgd)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch


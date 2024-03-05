Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8897018627
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661060; cv=none; b=mam1Of+TbTdO841+ptTWWiWYTCGA2xEGSLQ55Vm7vfzUj94knVchNgqGFee1+vWLTbkFz93r9Y4ZfOl6doiT4WFDKOVdwwNiZ7VEfgycf0SW8wKIhPgcJqpf1J31G87NZGRzO/14wS26OBzj+5ZIYFiKk5I1pnu0KaQ7im0GT1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661060; c=relaxed/simple;
	bh=FroIZ+LN11PXhCNHc8rClvWvPf1jAh0xvJHlVJKxeMk=;
	h=Date:To:From:Subject:Message-Id; b=QtV0YcRZUS/eNOXNaqopSyPJ67PS/hiFUIV6qK7GZ0CAoXiHAuUGZY6YYNzJotCpFWK1/bw8gNKcjNSyWsaE3xAW6CzUCxN9lSXL2YniMeSFzYkEbqbVAYs2DW1LSy2ITLLQB4J7bHrizJTup0Z4DaaGD47lpHcRdkOLXU1LV8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vfA7rM05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vfA7rM05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8EBC433F1;
	Tue,  5 Mar 2024 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709661060;
	bh=FroIZ+LN11PXhCNHc8rClvWvPf1jAh0xvJHlVJKxeMk=;
	h=Date:To:From:Subject:From;
	b=vfA7rM05cu+RLLNUa5hwiR+Vg3rQ3nBNt2E/LKWBjsqmXsf76mzaQ8/BsjgYwPa0s
	 RubQxwtOR2i7Xz74zbQvCV4va6o0jFqLN71D5yYx4kZJTqagThtMJ0KPIfH085IyqY
	 Yq83/k3pwic24B3QDFeiRRjfJqA35NRtVHS77yPE=
Date: Tue, 05 Mar 2024 09:50:59 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-drop-pxd_large.patch added to mm-unstable branch
Message-Id: <20240305175100.0B8EBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/treewide: drop pXd_large()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-drop-pxd_large.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-drop-pxd_large.patch

This patch will later appear in the mm-unstable branch at
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
From: Peter Xu <peterx@redhat.com>
Subject: mm/treewide: drop pXd_large()
Date: Tue, 5 Mar 2024 12:37:49 +0800

They're not used anymore, drop all of them.

Link: https://lkml.kernel.org/r/20240305043750.93762-10-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-2level.h        |    1 
 arch/arm/include/asm/pgtable-3level.h        |    1 
 arch/loongarch/kvm/mmu.c                     |    2 -
 arch/powerpc/include/asm/book3s/64/pgtable.h |    4 ---
 arch/powerpc/include/asm/pgtable.h           |    4 ---
 arch/s390/include/asm/pgtable.h              |    8 +++----
 arch/sparc/include/asm/pgtable_64.h          |    8 +++----
 arch/x86/include/asm/pgtable.h               |   19 ++++++-----------
 arch/x86/kvm/mmu/mmu.c                       |    2 -
 9 files changed, 18 insertions(+), 31 deletions(-)

--- a/arch/arm/include/asm/pgtable-2level.h~mm-treewide-drop-pxd_large
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -213,7 +213,6 @@ static inline pmd_t *pmd_offset(pud_t *p
 
 #define pmd_pfn(pmd)		(__phys_to_pfn(pmd_val(pmd) & PHYS_MASK))
 
-#define pmd_large(pmd)		(pmd_val(pmd) & 2)
 #define pmd_leaf(pmd)		(pmd_val(pmd) & 2)
 #define pmd_bad(pmd)		(pmd_val(pmd) & 2)
 #define pmd_present(pmd)	(pmd_val(pmd))
--- a/arch/arm/include/asm/pgtable-3level.h~mm-treewide-drop-pxd_large
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -118,7 +118,6 @@
 						 PMD_TYPE_TABLE)
 #define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 						 PMD_TYPE_SECT)
-#define pmd_large(pmd)		pmd_sect(pmd)
 #define pmd_leaf(pmd)		pmd_sect(pmd)
 
 #define pud_clear(pudp)			\
--- a/arch/loongarch/kvm/mmu.c~mm-treewide-drop-pxd_large
+++ a/arch/loongarch/kvm/mmu.c
@@ -723,7 +723,7 @@ static int host_pfn_mapping_level(struct
 	/*
 	 * Read each entry once.  As above, a non-leaf entry can be promoted to
 	 * a huge page _during_ this walk.  Re-reading the entry could send the
-	 * walk into the weeks, e.g. p*d_large() returns false (sees the old
+	 * walk into the weeks, e.g. p*d_leaf() returns false (sees the old
 	 * value) and then p*d_offset() walks into the target huge page instead
 	 * of the old page table (sees the new value).
 	 */
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-treewide-drop-pxd_large
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1437,17 +1437,15 @@ static inline bool is_pte_rw_upgrade(uns
 }
 
 /*
- * Like pmd_huge() and pmd_large(), but works regardless of config options
+ * Like pmd_huge(), but works regardless of config options
  */
 #define pmd_leaf pmd_leaf
-#define pmd_large pmd_leaf
 static inline bool pmd_leaf(pmd_t pmd)
 {
 	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
 }
 
 #define pud_leaf pud_leaf
-#define pud_large pud_leaf
 static inline bool pud_leaf(pud_t pud)
 {
 	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PTE));
--- a/arch/powerpc/include/asm/pgtable.h~mm-treewide-drop-pxd_large
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -101,10 +101,6 @@ void poking_init(void);
 extern unsigned long ioremap_bot;
 extern const pgprot_t protection_map[16];
 
-#ifndef pmd_large
-#define pmd_large(pmd)		0
-#endif
-
 /* can we use this in kvm */
 unsigned long vmalloc_to_phys(void *vmalloc_addr);
 
--- a/arch/s390/include/asm/pgtable.h~mm-treewide-drop-pxd_large
+++ a/arch/s390/include/asm/pgtable.h
@@ -705,16 +705,16 @@ static inline int pud_none(pud_t pud)
 	return pud_val(pud) == _REGION3_ENTRY_EMPTY;
 }
 
-#define pud_leaf	pud_large
-static inline int pud_large(pud_t pud)
+#define pud_leaf pud_leaf
+static inline int pud_leaf(pud_t pud)
 {
 	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) != _REGION_ENTRY_TYPE_R3)
 		return 0;
 	return !!(pud_val(pud) & _REGION3_ENTRY_LARGE);
 }
 
-#define pmd_leaf	pmd_large
-static inline int pmd_large(pmd_t pmd)
+#define pmd_leaf pmd_leaf
+static inline int pmd_leaf(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_LARGE) != 0;
 }
--- a/arch/sparc/include/asm/pgtable_64.h~mm-treewide-drop-pxd_large
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -680,8 +680,8 @@ static inline unsigned long pte_special(
 	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
-#define pmd_leaf	pmd_large
-static inline unsigned long pmd_large(pmd_t pmd)
+#define pmd_leaf pmd_leaf
+static inline unsigned long pmd_leaf(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
 
@@ -867,8 +867,8 @@ static inline pmd_t *pud_pgtable(pud_t p
 /* only used by the stubbed out hugetlb gup code, should never be called */
 #define p4d_page(p4d)			NULL
 
-#define pud_leaf	pud_large
-static inline unsigned long pud_large(pud_t pud)
+#define pud_leaf pud_leaf
+static inline unsigned long pud_leaf(pud_t pud)
 {
 	pte_t pte = __pte(pud_val(pud));
 
--- a/arch/x86/include/asm/pgtable.h~mm-treewide-drop-pxd_large
+++ a/arch/x86/include/asm/pgtable.h
@@ -251,8 +251,8 @@ static inline unsigned long pgd_pfn(pgd_
 	return (pgd_val(pgd) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
-#define p4d_leaf	p4d_large
-static inline int p4d_large(p4d_t p4d)
+#define p4d_leaf p4d_leaf
+static inline int p4d_leaf(p4d_t p4d)
 {
 	/* No 512 GiB pages yet */
 	return 0;
@@ -260,14 +260,14 @@ static inline int p4d_large(p4d_t p4d)
 
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
-#define pmd_leaf	pmd_large
-static inline int pmd_large(pmd_t pte)
+#define pmd_leaf pmd_leaf
+static inline int pmd_leaf(pmd_t pte)
 {
 	return pmd_flags(pte) & _PAGE_PSE;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/* NOTE: when predicate huge page, consider also pmd_devmap, or use pmd_large */
+/* NOTE: when predicate huge page, consider also pmd_devmap, or use pmd_leaf */
 static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
@@ -1085,8 +1085,8 @@ static inline pmd_t *pud_pgtable(pud_t p
  */
 #define pud_page(pud)	pfn_to_page(pud_pfn(pud))
 
-#define pud_leaf	pud_large
-static inline int pud_large(pud_t pud)
+#define pud_leaf pud_leaf
+static inline int pud_leaf(pud_t pud)
 {
 	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
 		(_PAGE_PSE | _PAGE_PRESENT);
@@ -1096,11 +1096,6 @@ static inline int pud_bad(pud_t pud)
 {
 	return (pud_flags(pud) & ~(_KERNPG_TABLE | _PAGE_USER)) != 0;
 }
-#else
-static inline int pud_large(pud_t pud)
-{
-	return 0;
-}
 #endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
 #if CONFIG_PGTABLE_LEVELS > 3
--- a/arch/x86/kvm/mmu/mmu.c~mm-treewide-drop-pxd_large
+++ a/arch/x86/kvm/mmu/mmu.c
@@ -3110,7 +3110,7 @@ static int host_pfn_mapping_level(struct
 	/*
 	 * Read each entry once.  As above, a non-leaf entry can be promoted to
 	 * a huge page _during_ this walk.  Re-reading the entry could send the
-	 * walk into the weeks, e.g. p*d_large() returns false (sees the old
+	 * walk into the weeks, e.g. p*d_leaf() returns false (sees the old
 	 * value) and then p*d_offset() walks into the target huge page instead
 	 * of the old page table (sees the new value).
 	 */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-ppc-define-pxd_large-with-pxd_leaf.patch
mm-ppc-replace-pxd_is_leaf-with-pxd_leaf.patch
mm-x86-replace-p4d_large-with-p4d_leaf.patch
mm-x86-replace-pgd_large-with-pgd_leaf.patch
mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch
mm-kasan-use-pxd_leaf-in-shadow_mapped.patch
mm-treewide-replace-pmd_large-with-pmd_leaf.patch
mm-treewide-replace-pud_large-with-pud_leaf.patch
mm-treewide-drop-pxd_large.patch
mm-treewide-align-up-pxd_leaf-retval-across-archs.patch


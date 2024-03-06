Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE491862F
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759126; cv=none; b=inesMqKUYLU46Go1FDxLKBW5OjBSZJnAegs+hcpVoKHAZu1cCrYr8UJyNyRAZ/70kb2dHV/DYzPY3zYkUni3r7xJLst8GQOtvqV/kJ63V4+D2BOFMBAXPaVhwzpz3yTwrjREa6Ob0nZOYIN9uZUYoPjIfPtWqPy/gK4nABlr3Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759126; c=relaxed/simple;
	bh=abY8ZQM1xSNsDQeSKtl4tT8Si1YEipqmsjvlIMMtjVs=;
	h=Date:To:From:Subject:Message-Id; b=oilTu3ewDWtyGe7dXuBhqRMG/Fps+xoSjOGPvEQkzyXco/DnUH6eHx17+jtFF2ksGpQUdLnT6x3R9FV4EIGJYAvJWSrtUi0Hb/FOcRrSckkME204jiYGMEFrE+yRjG9zENc7QDbvIJv1ONYoJetWfnnYNZm6yhoVuUkRHAe2x2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KwCOhkbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwCOhkbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741CFC433F1;
	Wed,  6 Mar 2024 21:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759126;
	bh=abY8ZQM1xSNsDQeSKtl4tT8Si1YEipqmsjvlIMMtjVs=;
	h=Date:To:From:Subject:From;
	b=KwCOhkbJCH8U59mXFfx1D8d42aKOphZDp/RcMwhnO70MIzfjTTLhhGCks6T05AoOE
	 yJ0OqUV59j4soQNUsj6gSv8oABXuM+ahIRxO7nhuLUB1Wk/YA46N8kVEgAz8c3W4qo
	 2tgO8C3a0twtBoxrkgbbT+wFCbpFD9rkuJx66ScM=
Date: Wed, 06 Mar 2024 13:05:25 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-treewide-align-up-pxd_leaf-retval-across-archs.patch removed from -mm tree
Message-Id: <20240306210526.741CFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/treewide: align up pXd_leaf() retval across archs
has been removed from the -mm tree.  Its filename was
     mm-treewide-align-up-pxd_leaf-retval-across-archs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/treewide: align up pXd_leaf() retval across archs
Date: Tue, 5 Mar 2024 12:37:50 +0800

Even if pXd_leaf() API is defined globally, it's not clear on the retval,
and there are three types used (bool, int, unsigned log).

Always return a boolean for pXd_leaf() APIs.

Link: https://lkml.kernel.org/r/20240305043750.93762-11-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
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

 arch/riscv/include/asm/pgtable-64.h |    2 +-
 arch/riscv/include/asm/pgtable.h    |    2 +-
 arch/s390/include/asm/pgtable.h     |    4 ++--
 arch/sparc/include/asm/pgtable_64.h |    4 ++--
 arch/x86/include/asm/pgtable.h      |    8 ++++----
 include/linux/pgtable.h             |    8 ++++----
 6 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/riscv/include/asm/pgtable-64.h~mm-treewide-align-up-pxd_leaf-retval-across-archs
+++ a/arch/riscv/include/asm/pgtable-64.h
@@ -190,7 +190,7 @@ static inline int pud_bad(pud_t pud)
 }
 
 #define pud_leaf	pud_leaf
-static inline int pud_leaf(pud_t pud)
+static inline bool pud_leaf(pud_t pud)
 {
 	return pud_present(pud) && (pud_val(pud) & _PAGE_LEAF);
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-treewide-align-up-pxd_leaf-retval-across-archs
+++ a/arch/riscv/include/asm/pgtable.h
@@ -241,7 +241,7 @@ static inline int pmd_bad(pmd_t pmd)
 }
 
 #define pmd_leaf	pmd_leaf
-static inline int pmd_leaf(pmd_t pmd)
+static inline bool pmd_leaf(pmd_t pmd)
 {
 	return pmd_present(pmd) && (pmd_val(pmd) & _PAGE_LEAF);
 }
--- a/arch/s390/include/asm/pgtable.h~mm-treewide-align-up-pxd_leaf-retval-across-archs
+++ a/arch/s390/include/asm/pgtable.h
@@ -706,7 +706,7 @@ static inline int pud_none(pud_t pud)
 }
 
 #define pud_leaf pud_leaf
-static inline int pud_leaf(pud_t pud)
+static inline bool pud_leaf(pud_t pud)
 {
 	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) != _REGION_ENTRY_TYPE_R3)
 		return 0;
@@ -714,7 +714,7 @@ static inline int pud_leaf(pud_t pud)
 }
 
 #define pmd_leaf pmd_leaf
-static inline int pmd_leaf(pmd_t pmd)
+static inline bool pmd_leaf(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_LARGE) != 0;
 }
--- a/arch/sparc/include/asm/pgtable_64.h~mm-treewide-align-up-pxd_leaf-retval-across-archs
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -681,7 +681,7 @@ static inline unsigned long pte_special(
 }
 
 #define pmd_leaf pmd_leaf
-static inline unsigned long pmd_leaf(pmd_t pmd)
+static inline bool pmd_leaf(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
 
@@ -868,7 +868,7 @@ static inline pmd_t *pud_pgtable(pud_t p
 #define p4d_page(p4d)			NULL
 
 #define pud_leaf pud_leaf
-static inline unsigned long pud_leaf(pud_t pud)
+static inline bool pud_leaf(pud_t pud)
 {
 	pte_t pte = __pte(pud_val(pud));
 
--- a/arch/x86/include/asm/pgtable.h~mm-treewide-align-up-pxd_leaf-retval-across-archs
+++ a/arch/x86/include/asm/pgtable.h
@@ -252,7 +252,7 @@ static inline unsigned long pgd_pfn(pgd_
 }
 
 #define p4d_leaf p4d_leaf
-static inline int p4d_leaf(p4d_t p4d)
+static inline bool p4d_leaf(p4d_t p4d)
 {
 	/* No 512 GiB pages yet */
 	return 0;
@@ -261,7 +261,7 @@ static inline int p4d_leaf(p4d_t p4d)
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 #define pmd_leaf pmd_leaf
-static inline int pmd_leaf(pmd_t pte)
+static inline bool pmd_leaf(pmd_t pte)
 {
 	return pmd_flags(pte) & _PAGE_PSE;
 }
@@ -1086,7 +1086,7 @@ static inline pmd_t *pud_pgtable(pud_t p
 #define pud_page(pud)	pfn_to_page(pud_pfn(pud))
 
 #define pud_leaf pud_leaf
-static inline int pud_leaf(pud_t pud)
+static inline bool pud_leaf(pud_t pud)
 {
 	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
 		(_PAGE_PSE | _PAGE_PRESENT);
@@ -1413,7 +1413,7 @@ static inline bool pgdp_maps_userspace(v
 }
 
 #define pgd_leaf	pgd_leaf
-static inline int pgd_leaf(pgd_t pgd) { return 0; }
+static inline bool pgd_leaf(pgd_t pgd) { return false; }
 
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 /*
--- a/include/linux/pgtable.h~mm-treewide-align-up-pxd_leaf-retval-across-archs
+++ a/include/linux/pgtable.h
@@ -1777,16 +1777,16 @@ typedef unsigned int pgtbl_mod_mask;
  * Only meaningful when called on a valid entry.
  */
 #ifndef pgd_leaf
-#define pgd_leaf(x)	0
+#define pgd_leaf(x)	false
 #endif
 #ifndef p4d_leaf
-#define p4d_leaf(x)	0
+#define p4d_leaf(x)	false
 #endif
 #ifndef pud_leaf
-#define pud_leaf(x)	0
+#define pud_leaf(x)	false
 #endif
 #ifndef pmd_leaf
-#define pmd_leaf(x)	0
+#define pmd_leaf(x)	false
 #endif
 
 #ifndef pgd_leaf_size
_

Patches currently in -mm which might be from peterx@redhat.com are



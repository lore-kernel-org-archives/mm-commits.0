Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8E614AAD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759117; cv=none; b=NGmGVC8KXbIKseE/TQi0loMgpW6w7+JWNNscM/EmmdzeimyhuFVGz3YSO2vxc2sWzSja7ulTP5wXAeTdqyvtmAaQEp7VVnhvRbL1RFGC+IO9TNWap8y+GG9Xb5rkHASr3er3lI4i97LvVXFvBTgGZS+VhDQJy4qqFgWGnsRyynM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759117; c=relaxed/simple;
	bh=w07k+vUqouRQ74nL2L5R1yJn5sSDF1ZbsfA0ypJ4Q4Y=;
	h=Date:To:From:Subject:Message-Id; b=MseE51aM9vufUpOGO/V/0ifR2DQFaA8f3Eo8CPS5JMo8JvAIWy+5e4OC3IJSnc3Dhv5ywvI7Tof3T1Aob8xClOZQu0OdJsvBu2gKWT9INo/lRfM5VpadQQUOpDlHXyDOdaapjG+cRuR8HTX8GoR2fDfwwACfMyB8UxjYlz0gZhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rKpoE5l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rKpoE5l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31CBC433F1;
	Wed,  6 Mar 2024 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759116;
	bh=w07k+vUqouRQ74nL2L5R1yJn5sSDF1ZbsfA0ypJ4Q4Y=;
	h=Date:To:From:Subject:From;
	b=rKpoE5l2ZY03L2d1601hafmUU9uy08PQmFJwVXLZyZwvus4HlUJ6t8DAPOCihua2K
	 7sCdQk+3Nk0oEBBNN/WyrSRRCr7xdjRfue+I2tObHsznZBmPEF7kC6zEc/yxw7QiQE
	 JVv4bVTdWVcVnR4Xkr2UQCABUB/H225efuQYeFQk=
Date: Wed, 06 Mar 2024 13:05:16 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ppc-define-pxd_large-with-pxd_leaf.patch removed from -mm tree
Message-Id: <20240306210516.C31CBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/powerpc: define pXd_large() with pXd_leaf()
has been removed from the -mm tree.  Its filename was
     mm-ppc-define-pxd_large-with-pxd_leaf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/powerpc: define pXd_large() with pXd_leaf()
Date: Tue, 5 Mar 2024 12:37:41 +0800

Patch series "mm/treewide: Replace pXd_large() with pXd_leaf()", v3.

These two APIs are mostly always the same.  It's confusing to have both of
them.  Merge them into one.  Here I used pXd_leaf() only because
pXd_leaf() is a global API which is always defined, while pXd_large() is
not.

We have yet one more API that is similar which is pXd_huge(), but that's
even trickier, so let's do it step by step.

Some special cares are taken for ppc and x86, they're done as separate
cleanups first.  


This patch (of 10):

The two definitions are the same.  The only difference is that pXd_large()
is only defined with THP selected, and only on book3s 64bits.

Instead of implementing it twice, make pXd_large() a macro to pXd_leaf(). 
Define it unconditionally just like pXd_leaf().  This helps to prepare
merging the two APIs.

Link: https://lkml.kernel.org/r/20240305043750.93762-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240305043750.93762-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   16 ++--------------
 arch/powerpc/include/asm/pgtable.h           |    2 +-
 2 files changed, 3 insertions(+), 15 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-ppc-define-pxd_large-with-pxd_leaf
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1158,20 +1158,6 @@ pud_hugepage_update(struct mm_struct *mm
 }
 
 /*
- * returns true for pmd migration entries, THP, devmap, hugetlb
- * But compile time dependent on THP config
- */
-static inline int pmd_large(pmd_t pmd)
-{
-	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
-}
-
-static inline int pud_large(pud_t pud)
-{
-	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PTE));
-}
-
-/*
  * For radix we should always find H_PAGE_HASHPTE zero. Hence
  * the below will work for radix too
  */
@@ -1455,6 +1441,7 @@ static inline bool is_pte_rw_upgrade(uns
  */
 #define pmd_is_leaf pmd_is_leaf
 #define pmd_leaf pmd_is_leaf
+#define pmd_large pmd_leaf
 static inline bool pmd_is_leaf(pmd_t pmd)
 {
 	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
@@ -1462,6 +1449,7 @@ static inline bool pmd_is_leaf(pmd_t pmd
 
 #define pud_is_leaf pud_is_leaf
 #define pud_leaf pud_is_leaf
+#define pud_large pud_leaf
 static inline bool pud_is_leaf(pud_t pud)
 {
 	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PTE));
--- a/arch/powerpc/include/asm/pgtable.h~mm-ppc-define-pxd_large-with-pxd_leaf
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -101,7 +101,7 @@ void poking_init(void);
 extern unsigned long ioremap_bot;
 extern const pgprot_t protection_map[16];
 
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+#ifndef pmd_large
 #define pmd_large(pmd)		0
 #endif
 
_

Patches currently in -mm which might be from peterx@redhat.com are



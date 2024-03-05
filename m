Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CBC1773A
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 17:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661024; cv=none; b=j8VsTPvywWCciLcf/499iZEmwZEbgolBPK+duiCYwQb+pJVLDsTUOU5xtHtz+H2xzn3KLB6gWkZcgW7d84xO4SRsbZ/9l9rUOI17+034waaXNMIaonMX2LQyVDfIZtcSEugiKd45q0Tuw0QiNb6uX85BjMHUqEPZhHXwq4Zl0gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661024; c=relaxed/simple;
	bh=4isZavuSLuQ089Cl5XTBnaA0OkzCAYXSyYJ3uJmb5cI=;
	h=Date:To:From:Subject:Message-Id; b=Ivm3wHsM2urGzNAYCSRL8Oip9E/4UP84emnWUyGNL+TipeD9ooi9boqZAnudgHNnQ7dXoT0iR5EV/bM11+xS03nznw1lIIjI53Qwtj+hzSSbjbjlgHsyu9Ab4bCWEpW4zXzQd3uaftqtJ4aDTipJyIn9syiCrs/UfpKcwX7RBQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d1u0AkXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d1u0AkXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C670DC433F1;
	Tue,  5 Mar 2024 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709661023;
	bh=4isZavuSLuQ089Cl5XTBnaA0OkzCAYXSyYJ3uJmb5cI=;
	h=Date:To:From:Subject:From;
	b=d1u0AkXqBCzZvc2YHQya4ly7PNSHD3OOu/7KZBihGjxSR8QgOWFYjQMkJ7vmJ6dLK
	 SSHoKTPrEpYHt/dRJgw7lA/DeOWB7phUPHfjQr8Yh0cBdm2hqng9nFx89T4C5Rjjox
	 4q/xxV2qTRUCMg6mHV5TXZ6+kYGs8alL5b6TeZgw=
Date: Tue, 05 Mar 2024 09:50:23 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ppc-define-pxd_large-with-pxd_leaf.patch added to mm-unstable branch
Message-Id: <20240305175023.C670DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/powerpc: define pXd_large() with pXd_leaf()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ppc-define-pxd_large-with-pxd_leaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ppc-define-pxd_large-with-pxd_leaf.patch

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


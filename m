Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A29F2E40B
	for <mm-commits@vger.kernel.org>; Tue, 10 Sep 2024 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993927; cv=none; b=Wz4XJTVTQS0DG0bExbpH0wxdmE8PflQF/ehQ6aG+a7/SslQW0RWZzcKREPjQFL3cAbDgFC79fxlFVG9EuufaVIW+l/L71jCjcYr1udVyHzY7GbIS9KqGjfhFzr4YtXFWRpxqPGw70L42UEotvd07WWJXtfFmrC9snC4Ilu0g00Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993927; c=relaxed/simple;
	bh=cBUw65hkRJrcexuvv/CVuQ03xlj56ZA8YJmGCsNpJng=;
	h=Date:To:From:Subject:Message-Id; b=ZBFVm9xwY2iQcJgByBj0FYMazagmNijL+xQMV6MjIjS+tupbimt9qrTEEe8zrQrMVOBgxzcv0Ivc/wB7hLvA1tVO0YVPIgIuKdd7ii+nDU6JtIZhQZzea8U0RB94CLkbRwkSll8pSxDmBA/R4u2DGnKGVYcM1+ecHBggXrmmdLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gYJPElCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gYJPElCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E4AC4CEC3;
	Tue, 10 Sep 2024 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725993926;
	bh=cBUw65hkRJrcexuvv/CVuQ03xlj56ZA8YJmGCsNpJng=;
	h=Date:To:From:Subject:From;
	b=gYJPElCnGa0Io2yflLPXPEOi7TDFgUa7tqHPRVENdAHt3Rm+CtBp7ArfK/BCr0/c9
	 t/Bg4vZV86U311UEdBRVxNQ2TDsSPWqBse4ukuEvM3DTecTA7TvjGuwBfMnAu6y2bc
	 NfEilpTrYmDKJs3BrjKdVJH++Z2Ltyjz+kdLsD2I=
Date: Tue, 10 Sep 2024 11:45:26 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-use-pxdp_get-for-accessing-page-table-entries.patch added to mm-unstable branch
Message-Id: <20240910184526.B2E4AC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug_vm_pgtable: Use pxdp_get() for accessing page table entries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug_vm_pgtable-use-pxdp_get-for-accessing-page-table-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-use-pxdp_get-for-accessing-page-table-entries.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: Use pxdp_get() for accessing page table entries
Date: Tue, 10 Sep 2024 17:27:46 +0530

This replaces all the existing READ_ONCE() based page table accesses with
respective pxdp_get() helpers. Although these helpers might also fallback
to READ_ONCE() as default, but they do provide an opportunity for various
platforms to override when required. This change is a step in direction to
replace all page table entry accesses with respective pxdp_get() helpers.

Link: https://lkml.kernel.org/r/20240910115746.514454-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   50 ++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-pxdp_get-for-accessing-page-table-entries
+++ a/mm/debug_vm_pgtable.c
@@ -231,10 +231,10 @@ static void __init pmd_advanced_tests(st
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
 	flush_dcache_page(page);
 	pmdp_set_wrprotect(args->mm, vaddr, args->pmdp);
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(pmd_write(pmd));
 	pmdp_huge_get_and_clear(args->mm, vaddr, args->pmdp);
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(!pmd_none(pmd));
 
 	pmd = pfn_pmd(args->pmd_pfn, args->page_prot);
@@ -245,10 +245,10 @@ static void __init pmd_advanced_tests(st
 	pmd = pmd_mkwrite(pmd, args->vma);
 	pmd = pmd_mkdirty(pmd);
 	pmdp_set_access_flags(args->vma, vaddr, args->pmdp, pmd, 1);
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(!(pmd_write(pmd) && pmd_dirty(pmd)));
 	pmdp_huge_get_and_clear_full(args->vma, vaddr, args->pmdp, 1);
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(!pmd_none(pmd));
 
 	pmd = pmd_mkhuge(pfn_pmd(args->pmd_pfn, args->page_prot));
@@ -256,7 +256,7 @@ static void __init pmd_advanced_tests(st
 	set_pmd_at(args->mm, vaddr, args->pmdp, pmd);
 	flush_dcache_page(page);
 	pmdp_test_and_clear_young(args->vma, vaddr, args->pmdp);
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(pmd_young(pmd));
 
 	/*  Clear the pte entries  */
@@ -357,12 +357,12 @@ static void __init pud_advanced_tests(st
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	flush_dcache_page(page);
 	pudp_set_wrprotect(args->mm, vaddr, args->pudp);
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(pud_write(pud));
 
 #ifndef __PAGETABLE_PMD_FOLDED
 	pudp_huge_get_and_clear(args->mm, vaddr, args->pudp);
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
@@ -374,12 +374,12 @@ static void __init pud_advanced_tests(st
 	pud = pud_mkwrite(pud);
 	pud = pud_mkdirty(pud);
 	pudp_set_access_flags(args->vma, vaddr, args->pudp, pud, 1);
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(!(pud_write(pud) && pud_dirty(pud)));
 
 #ifndef __PAGETABLE_PMD_FOLDED
 	pudp_huge_get_and_clear_full(args->vma, vaddr, args->pudp, 1);
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 
@@ -389,7 +389,7 @@ static void __init pud_advanced_tests(st
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	flush_dcache_page(page);
 	pudp_test_and_clear_young(args->vma, vaddr, args->pudp);
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(pud_young(pud));
 
 	pudp_huge_get_and_clear(args->mm, vaddr, args->pudp);
@@ -441,7 +441,7 @@ static void __init pmd_huge_tests(struct
 	WRITE_ONCE(*args->pmdp, __pmd(0));
 	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
 	WARN_ON(!pmd_clear_huge(args->pmdp));
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(!pmd_none(pmd));
 }
 
@@ -461,7 +461,7 @@ static void __init pud_huge_tests(struct
 	WRITE_ONCE(*args->pudp, __pud(0));
 	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
 	WARN_ON(!pud_clear_huge(args->pudp));
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(!pud_none(pud));
 }
 #else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
@@ -490,7 +490,7 @@ static void __init pgd_basic_tests(struc
 #ifndef __PAGETABLE_PUD_FOLDED
 static void __init pud_clear_tests(struct pgtable_debug_args *args)
 {
-	pud_t pud = READ_ONCE(*args->pudp);
+	pud_t pud = pudp_get(args->pudp);
 
 	if (mm_pmd_folded(args->mm))
 		return;
@@ -498,7 +498,7 @@ static void __init pud_clear_tests(struc
 	pr_debug("Validating PUD clear\n");
 	WARN_ON(pud_none(pud));
 	pud_clear(args->pudp);
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(!pud_none(pud));
 }
 
@@ -515,7 +515,7 @@ static void __init pud_populate_tests(st
 	 * Hence this must not qualify as pud_bad().
 	 */
 	pud_populate(args->mm, args->pudp, args->start_pmdp);
-	pud = READ_ONCE(*args->pudp);
+	pud = pudp_get(args->pudp);
 	WARN_ON(pud_bad(pud));
 }
 #else  /* !__PAGETABLE_PUD_FOLDED */
@@ -526,7 +526,7 @@ static void __init pud_populate_tests(st
 #ifndef __PAGETABLE_P4D_FOLDED
 static void __init p4d_clear_tests(struct pgtable_debug_args *args)
 {
-	p4d_t p4d = READ_ONCE(*args->p4dp);
+	p4d_t p4d = p4dp_get(args->p4dp);
 
 	if (mm_pud_folded(args->mm))
 		return;
@@ -534,7 +534,7 @@ static void __init p4d_clear_tests(struc
 	pr_debug("Validating P4D clear\n");
 	WARN_ON(p4d_none(p4d));
 	p4d_clear(args->p4dp);
-	p4d = READ_ONCE(*args->p4dp);
+	p4d = p4dp_get(args->p4dp);
 	WARN_ON(!p4d_none(p4d));
 }
 
@@ -553,13 +553,13 @@ static void __init p4d_populate_tests(st
 	pud_clear(args->pudp);
 	p4d_clear(args->p4dp);
 	p4d_populate(args->mm, args->p4dp, args->start_pudp);
-	p4d = READ_ONCE(*args->p4dp);
+	p4d = p4dp_get(args->p4dp);
 	WARN_ON(p4d_bad(p4d));
 }
 
 static void __init pgd_clear_tests(struct pgtable_debug_args *args)
 {
-	pgd_t pgd = READ_ONCE(*(args->pgdp));
+	pgd_t pgd = pgdp_get(args->pgdp);
 
 	if (mm_p4d_folded(args->mm))
 		return;
@@ -567,7 +567,7 @@ static void __init pgd_clear_tests(struc
 	pr_debug("Validating PGD clear\n");
 	WARN_ON(pgd_none(pgd));
 	pgd_clear(args->pgdp);
-	pgd = READ_ONCE(*args->pgdp);
+	pgd = pgdp_get(args->pgdp);
 	WARN_ON(!pgd_none(pgd));
 }
 
@@ -586,7 +586,7 @@ static void __init pgd_populate_tests(st
 	p4d_clear(args->p4dp);
 	pgd_clear(args->pgdp);
 	pgd_populate(args->mm, args->pgdp, args->start_p4dp);
-	pgd = READ_ONCE(*args->pgdp);
+	pgd = pgdp_get(args->pgdp);
 	WARN_ON(pgd_bad(pgd));
 }
 #else  /* !__PAGETABLE_P4D_FOLDED */
@@ -627,12 +627,12 @@ static void __init pte_clear_tests(struc
 
 static void __init pmd_clear_tests(struct pgtable_debug_args *args)
 {
-	pmd_t pmd = READ_ONCE(*args->pmdp);
+	pmd_t pmd = pmdp_get(args->pmdp);
 
 	pr_debug("Validating PMD clear\n");
 	WARN_ON(pmd_none(pmd));
 	pmd_clear(args->pmdp);
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(!pmd_none(pmd));
 }
 
@@ -646,7 +646,7 @@ static void __init pmd_populate_tests(st
 	 * Hence this must not qualify as pmd_bad().
 	 */
 	pmd_populate(args->mm, args->pmdp, args->start_ptep);
-	pmd = READ_ONCE(*args->pmdp);
+	pmd = pmdp_get(args->pmdp);
 	WARN_ON(pmd_bad(pmd));
 }
 
@@ -1251,7 +1251,7 @@ static int __init init_args(struct pgtab
 		ret = -ENOMEM;
 		goto error;
 	}
-	args->start_ptep = pmd_pgtable(READ_ONCE(*args->pmdp));
+	args->start_ptep = pmd_pgtable(pmdp_get(args->pmdp));
 	WARN_ON(!args->start_ptep);
 
 	init_fixed_pfns(args);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-use-pxdp_get-for-accessing-page-table-entries.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64541A87
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 19:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716490904; cv=none; b=TbDRUE38s79/xUETh6Ki6BlM1vVt6FQ/uzTnZGrr47sKE641bX9dq3NbJEVT/S4NBEfajhnDe8vMH7MxhmZK8P0kHt3tHa3UiBS8TBjGL1aTvKMC3xGJ2cJ+N2GfDEbsIC+Y1OmHJk9QuJmDiKtNd0u0yoIqYn4FJbQEfK0Sxl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716490904; c=relaxed/simple;
	bh=usB1QIurwqDI62TzzRgW1V8aQysPkYeIZMayBE2wvqk=;
	h=Date:To:From:Subject:Message-Id; b=bOB3kSqJ/MWWLFMuwtR4UO4EozlkFUsi1flCui5G5VFv4zePYYJtQvw7I6rThnXmDSCX5YF4akVML8pG7bILh5gC113EIYrvUrKVXMLbTr0FFD1UP7BjKtPVJwbQG98+fwh40kk2ra5/SP2at6ekijUKXEGwA4/H3KzIokFxrYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zYbKDkwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zYbKDkwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC15C2BD10;
	Thu, 23 May 2024 19:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716490903;
	bh=usB1QIurwqDI62TzzRgW1V8aQysPkYeIZMayBE2wvqk=;
	h=Date:To:From:Subject:From;
	b=zYbKDkwbLApew2hPH7HT2fNnoOWV5zpfstib+vTvWySs50w/p33WcqxpRJztjOUdk
	 ziGE3MjgOUPmbgNbQMPYisf8YrZIJNoVx24e6akOJMjlIVG0JNXaPQdW77GPnOVtAc
	 YOqgljWzoi7VGY/JVP2/YMFmh6GD+XuaJ7A9JYrY=
Date: Thu, 23 May 2024 12:01:42 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,mikhail.v.gavrilov@gmail.com,gshan@redhat.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-drop-random_orvalue-trick.patch added to mm-unstable branch
Message-Id: <20240523190143.6CC15C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug_vm_pgtable: drop RANDOM_ORVALUE trick
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug_vm_pgtable-drop-random_orvalue-trick.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-drop-random_orvalue-trick.patch

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
Subject: mm/debug_vm_pgtable: drop RANDOM_ORVALUE trick
Date: Thu, 23 May 2024 09:21:39 -0400

Macro RANDOM_ORVALUE was used to make sure the pgtable entry will be
populated with !none data in clear tests.

The RANDOM_ORVALUE tried to cover mostly all the bits in a pgtable entry,
even if there's no discussion on whether all the bits will be vaild.  Both
S390 and PPC64 have their own masks to avoid touching some bits.  Now it's
the turn for x86_64.

The issue is there's a recent report from Mikhail Gavrilov showing that
this can cause a warning with the newly added pte set check in commit
8430557fc5 on writable v.s.  userfaultfd-wp bit, even though the check
itself was valid, the random pte is not.  We can choose to mask more bits
out.

However the need to have such random bits setup is questionable, as now
it's already guaranteed to be true on below:

  - For pte level, the pgtable entry will be installed with value from
    pfn_pte(), where pfn points to a valid page.  Hence the pte will be
    !none already if populated with pfn_pte().

  - For upper-than-pte level, the pgtable entry should contain a directory
    entry always, which is also !none.

All the cases look like good enough to test a pxx_clear() helper.  Instead
of extending the bitmask, drop the "set random bits" trick completely.  Add
some warning guards to make sure the entries will be !none before clear().

Link: https://lkml.kernel.org/r/20240523132139.289719-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/r/CABXGCsMB9A8-X+Np_Q+fWLURYL_0t3Y-MdoNabDM-Lzk58-DGA@mail.gmail.com
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-drop-random_orvalue-trick
+++ a/mm/debug_vm_pgtable.c
@@ -40,22 +40,7 @@
  * Please refer Documentation/mm/arch_pgtable_helpers.rst for the semantics
  * expectations that are being validated here. All future changes in here
  * or the documentation need to be in sync.
- *
- * On s390 platform, the lower 4 bits are used to identify given page table
- * entry type. But these bits might affect the ability to clear entries with
- * pxx_clear() because of how dynamic page table folding works on s390. So
- * while loading up the entries do not change the lower 4 bits. It does not
- * have affect any other platform. Also avoid the 62nd bit on ppc64 that is
- * used to mark a pte entry.
  */
-#define S390_SKIP_MASK		GENMASK(3, 0)
-#if __BITS_PER_LONG == 64
-#define PPC64_SKIP_MASK		GENMASK(62, 62)
-#else
-#define PPC64_SKIP_MASK		0x0
-#endif
-#define ARCH_SKIP_MASK (S390_SKIP_MASK | PPC64_SKIP_MASK)
-#define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
 struct pgtable_debug_args {
@@ -511,8 +496,7 @@ static void __init pud_clear_tests(struc
 		return;
 
 	pr_debug("Validating PUD clear\n");
-	pud = __pud(pud_val(pud) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->pudp, pud);
+	WARN_ON(pud_none(pud));
 	pud_clear(args->pudp);
 	pud = READ_ONCE(*args->pudp);
 	WARN_ON(!pud_none(pud));
@@ -548,8 +532,7 @@ static void __init p4d_clear_tests(struc
 		return;
 
 	pr_debug("Validating P4D clear\n");
-	p4d = __p4d(p4d_val(p4d) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->p4dp, p4d);
+	WARN_ON(p4d_none(p4d));
 	p4d_clear(args->p4dp);
 	p4d = READ_ONCE(*args->p4dp);
 	WARN_ON(!p4d_none(p4d));
@@ -582,8 +565,7 @@ static void __init pgd_clear_tests(struc
 		return;
 
 	pr_debug("Validating PGD clear\n");
-	pgd = __pgd(pgd_val(pgd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->pgdp, pgd);
+	WARN_ON(pgd_none(pgd));
 	pgd_clear(args->pgdp);
 	pgd = READ_ONCE(*args->pgdp);
 	WARN_ON(!pgd_none(pgd));
@@ -634,10 +616,8 @@ static void __init pte_clear_tests(struc
 	if (WARN_ON(!args->ptep))
 		return;
 
-#ifndef CONFIG_RISCV
-	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
-#endif
 	set_pte_at(args->mm, args->vaddr, args->ptep, pte);
+	WARN_ON(pte_none(pte));
 	flush_dcache_page(page);
 	barrier();
 	ptep_clear(args->mm, args->vaddr, args->ptep);
@@ -650,8 +630,7 @@ static void __init pmd_clear_tests(struc
 	pmd_t pmd = READ_ONCE(*args->pmdp);
 
 	pr_debug("Validating PMD clear\n");
-	pmd = __pmd(pmd_val(pmd) | RANDOM_ORVALUE);
-	WRITE_ONCE(*args->pmdp, pmd);
+	WARN_ON(pmd_none(pmd));
 	pmd_clear(args->pmdp);
 	pmd = READ_ONCE(*args->pmdp);
 	WARN_ON(!pmd_none(pmd));
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-debug_vm_pgtable-drop-random_orvalue-trick.patch


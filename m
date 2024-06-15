Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897AC4DA0F
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473445; cv=none; b=BaAS2YLCkumBYkX73I95VBMNJGHzi5G0O4Xe/YxDAZLfJKi+lNLKu+HUN/lzFUMdFGAuSDfHJa8v8n6+l5d6REfl3NrTugN60ev2nlA6vaQWkGG/fdLuUpB8N1VdLOqDc3c67nyppGZRTwQJeXHkUBelq7SrCIEKELsfoHs2uSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473445; c=relaxed/simple;
	bh=aUZtJEKBx1ng2zdFvlxwEEVWDsUg6p09gL+NX1QaodU=;
	h=Date:To:From:Subject:Message-Id; b=pKrHqcjrF/pICWtXYrRRudVI42jEjxV4r6WZz88lwuJBKngOXDvlnD7rr74RPeoITNTA6gw+r+g3bRQxLbT7Xp4NEzsUcbs5YBDPRS1ww/flH/amRNlZTERBNSf+UW79Omma+4gpTYfPBGLG8C75zXkyIo7uLepSb5oK4o5+67g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IFtTgoQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IFtTgoQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3B0C116B1;
	Sat, 15 Jun 2024 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473445;
	bh=aUZtJEKBx1ng2zdFvlxwEEVWDsUg6p09gL+NX1QaodU=;
	h=Date:To:From:Subject:From;
	b=IFtTgoQ6nkd7WyU6LV8UCfSX56EQJoaY2QojDlIP36rR4yNl/0CMPo/Z4oq+0rBvj
	 pFvI9kgQzU5vWNgHZy0HgMO9nntcMy6CvLh6A68xZHK010UEXFIjKkHspxWrRaguYn
	 rgQtl87PN/g/KrP3DUDHbnPN3bszuCe/2Ab+Ydk8=
Date: Sat, 15 Jun 2024 10:44:04 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,mikhail.v.gavrilov@gmail.com,gshan@redhat.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-debug_vm_pgtable-drop-random_orvalue-trick.patch removed from -mm tree
Message-Id: <20240615174405.5E3B0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug_vm_pgtable: drop RANDOM_ORVALUE trick
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-drop-random_orvalue-trick.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 8430557fc584 ("mm/page_table_check: support userfault wr-protect entries")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/r/CABXGCsMB9A8-X+Np_Q+fWLURYL_0t3Y-MdoNabDM-Lzk58-DGA@mail.gmail.com
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

mm-drop-leftover-comment-references-to-pxx_huge.patch


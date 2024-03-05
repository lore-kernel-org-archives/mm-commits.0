Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45B175A1
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661031; cv=none; b=frDr7q7c2XrsR4LLN4aeg83B2sm/LA+4kcGredGwnd2Lrj06zSWE1GGfJ2sfKMSiDJVg2kdWt1+REb9GjTXKSTUczB6fdTUeKwLs7NuZ+IcRG/0qYEiM+JA+043kBlmxyNz/I/Q1Gmmbb+nQko7GJi3Mm0IxwF5UBgAf8IGMmuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661031; c=relaxed/simple;
	bh=MawUAacx6IGYN+eAUXljibG5r+kKaWLkU1WVAeZKKTc=;
	h=Date:To:From:Subject:Message-Id; b=aevaj6ty09Vg9AxSdIOE8/lXBgwbd4UTi4loTXV9gIKl4LP251b0hRAON0reu3QhaOjfdn4dULiP91V0fbsk5/3jepsRoK8SSUw+PFqVI+nyUxDhHniRFSQ7MUp5tfg6r/+TgY+p2fUCdsgiDV/6EDVJ3mUfO4MmXhjkusugtYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2E3MrTaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2E3MrTaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCD8C433F1;
	Tue,  5 Mar 2024 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709661030;
	bh=MawUAacx6IGYN+eAUXljibG5r+kKaWLkU1WVAeZKKTc=;
	h=Date:To:From:Subject:From;
	b=2E3MrTawu7P1dRLBqmPM1DE4jWSN48fGszeIO1LFJQbxmZChX8qccE/Lr2BdfOT6b
	 H0dhdf+TQYy3rl+BHIXYAW+R7a1WHk6pkDklJzHtrA426SqIjcmuz+Q3GkUUmnZOT+
	 /n+B/APkdOnB/64+3Gh2oFyFZAQFpZm/mc/claAI=
Date: Tue, 05 Mar 2024 09:50:29 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-replace-p4d_large-with-p4d_leaf.patch added to mm-unstable branch
Message-Id: <20240305175030.6FCD8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/x86: replace p4d_large() with p4d_leaf()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-replace-p4d_large-with-p4d_leaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-replace-p4d_large-with-p4d_leaf.patch

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
Subject: mm/x86: replace p4d_large() with p4d_leaf()
Date: Tue, 5 Mar 2024 12:37:43 +0800

p4d_large() is always defined as p4d_leaf().  Merge their usages.  Chose
p4d_leaf() because p4d_leaf() is a global API, while p4d_large() is not.

Only x86 has p4d_leaf() defined as of now.  So it also means after this
patch we removed all p4d_large() usages.

Link: https://lkml.kernel.org/r/20240305043750.93762-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c          |    4 ++--
 arch/x86/mm/init_64.c        |    2 +-
 arch/x86/mm/pat/set_memory.c |    4 ++--
 arch/x86/mm/pti.c            |    2 +-
 arch/x86/power/hibernate.c   |    2 +-
 arch/x86/xen/mmu_pv.c        |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/fault.c~mm-x86-replace-p4d_large-with-p4d_leaf
+++ a/arch/x86/mm/fault.c
@@ -368,7 +368,7 @@ static void dump_pagetable(unsigned long
 		goto bad;
 
 	pr_cont("P4D %lx ", p4d_val(*p4d));
-	if (!p4d_present(*p4d) || p4d_large(*p4d))
+	if (!p4d_present(*p4d) || p4d_leaf(*p4d))
 		goto out;
 
 	pud = pud_offset(p4d, address);
@@ -1039,7 +1039,7 @@ spurious_kernel_fault(unsigned long erro
 	if (!p4d_present(*p4d))
 		return 0;
 
-	if (p4d_large(*p4d))
+	if (p4d_leaf(*p4d))
 		return spurious_kernel_fault_check(error_code, (pte_t *) p4d);
 
 	pud = pud_offset(p4d, address);
--- a/arch/x86/mm/init_64.c~mm-x86-replace-p4d_large-with-p4d_leaf
+++ a/arch/x86/mm/init_64.c
@@ -1197,7 +1197,7 @@ remove_p4d_table(p4d_t *p4d_start, unsig
 		if (!p4d_present(*p4d))
 			continue;
 
-		BUILD_BUG_ON(p4d_large(*p4d));
+		BUILD_BUG_ON(p4d_leaf(*p4d));
 
 		pud_base = pud_offset(p4d, 0);
 		remove_pud_table(pud_base, addr, next, altmap, direct);
--- a/arch/x86/mm/pat/set_memory.c~mm-x86-replace-p4d_large-with-p4d_leaf
+++ a/arch/x86/mm/pat/set_memory.c
@@ -676,7 +676,7 @@ pte_t *lookup_address_in_pgd(pgd_t *pgd,
 		return NULL;
 
 	*level = PG_LEVEL_512G;
-	if (p4d_large(*p4d) || !p4d_present(*p4d))
+	if (p4d_leaf(*p4d) || !p4d_present(*p4d))
 		return (pte_t *)p4d;
 
 	pud = pud_offset(p4d, address);
@@ -739,7 +739,7 @@ pmd_t *lookup_pmd_address(unsigned long
 		return NULL;
 
 	p4d = p4d_offset(pgd, address);
-	if (p4d_none(*p4d) || p4d_large(*p4d) || !p4d_present(*p4d))
+	if (p4d_none(*p4d) || p4d_leaf(*p4d) || !p4d_present(*p4d))
 		return NULL;
 
 	pud = pud_offset(p4d, address);
--- a/arch/x86/mm/pti.c~mm-x86-replace-p4d_large-with-p4d_leaf
+++ a/arch/x86/mm/pti.c
@@ -206,7 +206,7 @@ static pmd_t *pti_user_pagetable_walk_pm
 	if (!p4d)
 		return NULL;
 
-	BUILD_BUG_ON(p4d_large(*p4d) != 0);
+	BUILD_BUG_ON(p4d_leaf(*p4d) != 0);
 	if (p4d_none(*p4d)) {
 		unsigned long new_pud_page = __get_free_page(gfp);
 		if (WARN_ON_ONCE(!new_pud_page))
--- a/arch/x86/power/hibernate.c~mm-x86-replace-p4d_large-with-p4d_leaf
+++ a/arch/x86/power/hibernate.c
@@ -165,7 +165,7 @@ int relocate_restore_code(void)
 	pgd = (pgd_t *)__va(read_cr3_pa()) +
 		pgd_index(relocated_restore_code);
 	p4d = p4d_offset(pgd, relocated_restore_code);
-	if (p4d_large(*p4d)) {
+	if (p4d_leaf(*p4d)) {
 		set_p4d(p4d, __p4d(p4d_val(*p4d) & ~_PAGE_NX));
 		goto out;
 	}
--- a/arch/x86/xen/mmu_pv.c~mm-x86-replace-p4d_large-with-p4d_leaf
+++ a/arch/x86/xen/mmu_pv.c
@@ -1104,7 +1104,7 @@ static void __init xen_cleanmfnmap_p4d(p
 	pud_t *pud_tbl;
 	int i;
 
-	if (p4d_large(*p4d)) {
+	if (p4d_leaf(*p4d)) {
 		pa = p4d_val(*p4d) & PHYSICAL_PAGE_MASK;
 		xen_free_ro_pages(pa, P4D_SIZE);
 		return;
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


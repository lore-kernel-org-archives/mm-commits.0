Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E5175BD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759119; cv=none; b=E0QkWy0gh0sJi4tLWkcwbgK4afyO+xeZZYG9qn+Knryb6TP5/3TxVJ6toDvRvwTc1mK/VRmpxVzs2qwrcg3Uln4wWDu4BlLz1Zyx1c8LvWR2vXUKws6Y4K7/mejsBYOtw6eFi5Qbq2LJj3boF/ZGjtXXoSeTak975Nak0hRgTak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759119; c=relaxed/simple;
	bh=SYyvKrxwynVJyXxKio8b+evTPUSoKdQ4eqHY0LETqWU=;
	h=Date:To:From:Subject:Message-Id; b=sUXO/bGCAjSIBgf/soZd5KpeFOjMrG/5IWIB7BPCzh7Ap/rxe+INUXP902RqWAmcXcQ/poRp6sLzWwmC8nvBsacrzhetCwQgef0ysTeG9hq/nxIm9hi3FL9lH3AiUNFX2bCI7iGZLchtfzYwdRuDzbil3EzLFdIlfNm3AYo0T4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kyqJfNZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kyqJfNZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3D9C433F1;
	Wed,  6 Mar 2024 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759119;
	bh=SYyvKrxwynVJyXxKio8b+evTPUSoKdQ4eqHY0LETqWU=;
	h=Date:To:From:Subject:From;
	b=kyqJfNZg+fjfCJkJNCH8PmSD6d1dlXgXMTZloYm5NN7yBsevnhxgSDz5whtPbS53v
	 b6z2wKY+n/xzstZ0VpJ1s8XzOsTVE/IXvE7AiEgTHOhcO5px3FXMgWXGL+KRon7HXQ
	 Re0PaTQ39pMaa8IdQjcawKODM8STM1Im07MIl8uY=
Date: Wed, 06 Mar 2024 13:05:18 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-replace-p4d_large-with-p4d_leaf.patch removed from -mm tree
Message-Id: <20240306210518.DE3D9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: replace p4d_large() with p4d_leaf()
has been removed from the -mm tree.  Its filename was
     mm-x86-replace-p4d_large-with-p4d_leaf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
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



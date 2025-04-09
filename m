Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F88329A2
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160846; cv=none; b=H3JfnC/Ge2UO4sd78nrghbWG8lTYj3p8HuBEJ6EOtnk4nL/g+P2CL8yc/2Rc5DTGrkBoDDSsqocUPP9BZoiQZXSsAT08Yki6dGwV0EIHX0n4rNZdro/3kZI+lA2nox3TQmn9pBRcQzSbK/7OSnBZAyfPa75y8nmX3kbm1czgFcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160846; c=relaxed/simple;
	bh=k7QD029oiHM/1QARTpVERDhZ2B2iuLU13Ot/ueSieSU=;
	h=Date:To:From:Subject:Message-Id; b=BvjYIGmG544Sn679Sj8ryDgcE/v0gxeov+BQvalun6sT5hA2OA9K26gggLXsIeGfGi3KbpqPZl/fBEdiFny9a4gQ/3iz7SVW1Ab11XmehcgOo6adYdg6JkKDPJHWgqXzSQ2aW6iCc8F03XvgR7DJwvalDKO7nGWq08k2Ptc5vPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S/ju/onT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S/ju/onT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED77C4CEE5;
	Wed,  9 Apr 2025 01:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160845;
	bh=k7QD029oiHM/1QARTpVERDhZ2B2iuLU13Ot/ueSieSU=;
	h=Date:To:From:Subject:From;
	b=S/ju/onTK9U9J7N104auxMmvNnBx6De8ZuzwbUhR7KY8e85C+UiWq7HOEqBnrSl2K
	 E+cZvu4BndQUO7elZkoGQY80EGHqCcbrgCSvpQr65c9bWpeJzh8uMUNJeg3cQwvrrH
	 w0A6bLETNJiJRfOS/AAV1AqoLR+C+hGVL8mhyR8k=
Date: Tue, 08 Apr 2025 18:07:25 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-pgtable-always-use-pte_free_kernel.patch added to mm-new branch
Message-Id: <20250409010725.AED77C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: pgtable: always use pte_free_kernel()
has been added to the -mm mm-new branch.  Its filename is
     x86-pgtable-always-use-pte_free_kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-pgtable-always-use-pte_free_kernel.patch

This patch will later appear in the mm-new branch at
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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: x86: pgtable: always use pte_free_kernel()
Date: Tue, 8 Apr 2025 10:52:12 +0100

Page table pages are normally freed using the appropriate helper for the
given page table level.  On x86, pud_free_pmd_page() and
pmd_free_pte_page() are an exception to the rule: they call free_page()
directly.

Constructor/destructor calls are about to be introduced for kernel PTEs. 
To avoid missing dtor calls in those helpers, free the PTE pages using
pte_free_kernel() instead of free_page().

While at it also use pmd_free() instead of calling pagetable_dtor()
explicitly at the PMD level.

Link: https://lkml.kernel.org/r/20250408095222.860601-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <x86@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/pgtable.c~x86-pgtable-always-use-pte_free_kernel
+++ a/arch/x86/mm/pgtable.c
@@ -809,14 +809,13 @@ int pud_free_pmd_page(pud_t *pud, unsign
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		if (!pmd_none(pmd_sv[i])) {
 			pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
-			free_page((unsigned long)pte);
+			pte_free_kernel(&init_mm, pte);
 		}
 	}
 
 	free_page((unsigned long)pmd_sv);
 
-	pagetable_dtor(virt_to_ptdesc(pmd));
-	free_page((unsigned long)pmd);
+	pmd_free(&init_mm, pmd);
 
 	return 1;
 }
@@ -839,7 +838,7 @@ int pmd_free_pte_page(pmd_t *pmd, unsign
 	/* INVLPG to clear all paging-structure caches */
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
 
-	free_page((unsigned long)pte);
+	pte_free_kernel(&init_mm, pte);
 
 	return 1;
 }
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

mm-pass-mm-down-to-pagetable_ptepmd_ctor.patch
x86-pgtable-always-use-pte_free_kernel.patch
mm-call-ctor-dtor-for-kernel-ptes.patch
m68k-mm-call-ctor-dtor-for-kernel-ptes.patch
powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch
sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch
mm-skip-ptlock_init-for-kernel-pmds.patch
arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift.patch
arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch
riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch
arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch
riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch


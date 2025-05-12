Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FAFC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011076; cv=none; b=P8ZwOj93xw+wpkrkM58JvBJnfy11Ekaz/DBExxjTG7Jwj2kLVpugtCM8ompEExYuQUzTeDXJfNhF6A3vh0hH1KVNYdzxtvZtBtlmX8kfELSDmktwfGsshiLfFxKwuce8hZzkevfvuD3/1tXaPgTF+IEU3F00Uoy0QkQB/K0FY+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011076; c=relaxed/simple;
	bh=+W0YOmrBz68q5fji9D0C+Ko81DlYZgfQx7LvbL1HdFQ=;
	h=Date:To:From:Subject:Message-Id; b=W5jtYcgBYAQ/fxtl0vtx4CFCiu7/RnHBhCmGEvraDWKPNJ6CdRZglFHIz3r9T4z2TeFRW5LBtPhkbw+EXkrBvP4HRmzI14Vr+MoVk6xBqCBIdGa0Bsb85YoG2jsGlWARI+b3EoXWQsnCMpHqcDQKLocFmU+nSdpPk8GZZWGJyZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VLfVB+jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VLfVB+jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1B2C4CEE4;
	Mon, 12 May 2025 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011076;
	bh=+W0YOmrBz68q5fji9D0C+Ko81DlYZgfQx7LvbL1HdFQ=;
	h=Date:To:From:Subject:From;
	b=VLfVB+jtC0QyCVixtZwzQw8DujhkzzdhYnNsnNSeHW/WGHWdfhd4az8G5hQBSAirt
	 qhn0Lf0C4ma7Gs3ILhBM96XioRMpUZHHg1jFF4X/tYgH5O0n1NaU/XxjJJFPVAH3Vu
	 sxHuwZgrrFslvtJcRt/p1TfeBwLc+dO3pGtTnosI=
Date: Sun, 11 May 2025 17:51:15 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-pgtable-always-use-pte_free_kernel.patch removed from -mm tree
Message-Id: <20250512005115.ED1B2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86: pgtable: always use pte_free_kernel()
has been removed from the -mm tree.  Its filename was
     x86-pgtable-always-use-pte_free_kernel.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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



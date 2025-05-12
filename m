Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFBFC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011083; cv=none; b=YdDR9ZSdkN2IvDoAbHX5kajHO3a14giyCgx5O28SBG6VJ+9nbCkUwciEG4pTNb3Tco1uAXSrNs4tOBy236od8b0r16bZWTBz/RuSdNs448N5uHw0udHReJ8/ogU8pUL/SNrHpV/6UxTxSEHjCVBEl37aZtxHR+6Fhywd7/n2xio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011083; c=relaxed/simple;
	bh=1SXlTSf3XzK4E+Ym5G1M77wwhD1r6u9eLFaaHE4DV90=;
	h=Date:To:From:Subject:Message-Id; b=Ez6nkL+sv9Dx77TA8WeemDLlg/INM+vnbDKzgLvN6NAbF/B3Hkl1yGxRycFs5JJcaBumtqCkrXGrTz6mSP0gl8WK9vFxrZo1wvafQY557Q1CItmLgAXZJNdxxeUHjXYczx3zEgu6R6lCsqQ/VYee6CHWHkDUlAqnPjVOrJYrYLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dn7HovYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dn7HovYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DC5C4CEE4;
	Mon, 12 May 2025 00:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011083;
	bh=1SXlTSf3XzK4E+Ym5G1M77wwhD1r6u9eLFaaHE4DV90=;
	h=Date:To:From:Subject:From;
	b=Dn7HovYIUxz3lWI1VAhXfMI1OG8h39PV5zts2cdBLmciZLpwGhpjBwOoBmcTE5r3s
	 tt9qh1wUy94TPdSJtsXvII3VhVhpDTogGRXmnXEXPN5oHjsHp7jZTTl3UbPrqo/ZgM
	 UZMv/L+DxOIddG4oIMzHH6N57nuhYMURunuUBZRM=
Date: Sun, 11 May 2025 17:51:22 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-skip-ptlock_init-for-kernel-pmds.patch removed from -mm tree
Message-Id: <20250512005122.E9DC5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: skip ptlock_init() for kernel PMDs
has been removed from the -mm tree.  Its filename was
     mm-skip-ptlock_init-for-kernel-pmds.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: skip ptlock_init() for kernel PMDs
Date: Tue, 8 Apr 2025 10:52:17 +0100

Split page table locks are not used for pgtables associated to init_mm, at
any level.  pte_alloc_kernel() does not call ptlock_init() as a result. 
There is however no separate alloc/free functions for kernel PMDs, and
pmd_ptlock_init() is called unconditionally.  When ALLOC_SPLIT_PTLOCKS is
true (e.g.  32-bit architectures or if CONFIG_PREEMPT_RT is selected),
this results in unnecessary dynamic memory allocation every time a kernel
PMD is allocated.

Now that pagetable_pmd_ctor() is passed the associated mm, we can easily
remove this overhead by skipping pmd_ptlock_init() if the pgtable is
associated to init_mm.  No special-casing is needed on the dtor path, as
ptlock_free() is already called unconditionally for all levels. 
(ptlock_free() is a no-op unless a ptlock was allocated for the given
PTP.)

Link: https://lkml.kernel.org/r/20250408095222.860601-8-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-skip-ptlock_init-for-kernel-pmds
+++ a/include/linux/mm.h
@@ -3257,7 +3257,7 @@ static inline spinlock_t *pmd_lock(struc
 static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
-	if (!pmd_ptlock_init(ptdesc))
+	if (mm != &init_mm && !pmd_ptlock_init(ptdesc))
 		return false;
 	ptdesc_pmd_pts_init(ptdesc);
 	__pagetable_ctor(ptdesc);
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are



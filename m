Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B3C23D3CE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837140; cv=none; b=XXPfpjK8SEjosjz9qlMUJIHs8C/4AfqyF+WYdX1TIp6IiR0ysL8ZegBBrKteTpcDymcW5vXMoaQbA4ZNZYk2oF3/TC+FT1erxt+0xakNa1rj/as8JpBNZIl+pkmXcfk/hwrz37APqWX9lZayydLZkxkoVGvkvxuv1ZG713rEJas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837140; c=relaxed/simple;
	bh=uFRCa7V4040ETYOkgBx/zBWXuP+K44OMa+keIHVCAjg=;
	h=Date:To:From:Subject:Message-Id; b=p+LBpg3R3qYTk0NerAX3Wsdk3sIfwY79FOg/OQ1WDJrUmuXLfsvPl6xfmPZv0//hb1I9qX/26b319OSlr0W26oxmOyjgfXbal8PYuk8dAPZwem79WfUvHdRV/mGbwPYuk1ZHbexb0y8awSBJLYLLmoiAD+AubcR2u85XWHaEz7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EIQXlWLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EIQXlWLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EED5C4CEDD;
	Tue, 14 Jan 2025 06:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837140;
	bh=uFRCa7V4040ETYOkgBx/zBWXuP+K44OMa+keIHVCAjg=;
	h=Date:To:From:Subject:From;
	b=EIQXlWLfIIBNXq7Dx2j2VUtcTpbBsgJ4CaprnCEDaTLuKJ0M0pS/M9Q8/SwW66nRN
	 prEuFif8Rwv3Me0Ek4oYrz9zd2PpsciZf4jkXv7mCelJoYAwYGYYaHgePCRealG2eF
	 B4yHtl5Qbg6Vj7zA1cPj4+xUOxqoULJpDUVJDepc=
Date: Mon, 13 Jan 2025 22:45:39 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] parisc-mm-ensure-pagetable_pmd_tor-are-called.patch removed from -mm tree
Message-Id: <20250114064540.2EED5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: parisc: mm: ensure pagetable_pmd_[cd]tor are called
has been removed from the -mm tree.  Its filename was
     parisc-mm-ensure-pagetable_pmd_tor-are-called.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: parisc: mm: ensure pagetable_pmd_[cd]tor are called
Date: Fri, 3 Jan 2025 18:44:11 +0000

The implementation of pmd_{alloc_one,free} on parisc requires a non-zero
allocation order, but is completely standard aside from that.  Let's reuse
the generic implementation of pmd_alloc_one().  Explicit zeroing is not
needed as GFP_PGTABLE_KERNEL includes __GFP_ZERO.  The generic pmd_free()
can handle higher allocation orders so we don't need to define our own.

These changes ensure that pagetable_pmd_[cd]tor are called, improving the
accounting of page table pages.

Link: https://lkml.kernel.org/r/20250103184415.2744423-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgalloc.h |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/arch/parisc/include/asm/pgalloc.h~parisc-mm-ensure-pagetable_pmd_tor-are-called
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -11,7 +11,6 @@
 #include <asm/cache.h>
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
-#define __HAVE_ARCH_PMD_FREE
 #define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
@@ -46,17 +45,19 @@ static inline void pud_populate(struct m
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd;
+	struct ptdesc *ptdesc;
+	gfp_t gfp = GFP_PGTABLE_USER;
 
-	pmd = (pmd_t *)__get_free_pages(GFP_PGTABLE_KERNEL, PMD_TABLE_ORDER);
-	if (likely(pmd))
-		memset ((void *)pmd, 0, PAGE_SIZE << PMD_TABLE_ORDER);
-	return pmd;
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	free_pages((unsigned long)pmd, PMD_TABLE_ORDER);
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	ptdesc = pagetable_alloc(gfp, PMD_TABLE_ORDER);
+	if (!ptdesc)
+		return NULL;
+	if (!pagetable_pmd_ctor(ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
+	return ptdesc_address(ptdesc);
 }
 #endif
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are



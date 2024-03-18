Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F624381C8
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788004; cv=none; b=Egi609A6g0UFp7nAMRW7fXzKCXpblgTya/V6hNs187reEsfRZcNlOGlQkgViu8mzW+UUZNTqgjIjJ2ujs1dvpHn7wym9emSHsfsaYOhLiaMIFP84FKy5lulJ0lbTZTjLsNFS0fPuZncLKb2RLTGVkDqoVkpfWzgOcHyV9iRIC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788004; c=relaxed/simple;
	bh=6dnoHqTPzcBm3UKCd2+BB5bERe8/1lM0BaExtZLEPSs=;
	h=Date:To:From:Subject:Message-Id; b=nItwx/W/dKtxV/NG9jjyQ+OhgB3pEdvcmFYBKQpEw+YDP+7U6cYT/+ofxocaGfjulBrGcEAH8HvMGdKO8F/nlZVNfj72Ha1zd4qve4KSiuyfFHeOSIw3mTdBqvM4SLBXfxb14sl8zVkpqD1ekML1Wk/V9wgUlDAnDcxBy8+njqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KT9urMkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KT9urMkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B229AC433F1;
	Mon, 18 Mar 2024 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788003;
	bh=6dnoHqTPzcBm3UKCd2+BB5bERe8/1lM0BaExtZLEPSs=;
	h=Date:To:From:Subject:From;
	b=KT9urMkFwxWwv3R3q0c92QgBUGeaRHb8GP30vn3shmJtNKO7aXI0CL4D+cerfzK0L
	 zgLBz6dByKziS03aXzXlzn6W87qOeWFkfcP1KN3Q6biVpBdb01Uq3tKBwUQ+ayrGyn
	 AsX5pJppw02WV5X0AoHFzp91nsFsGobDIHcfOTEo=
Date: Mon, 18 Mar 2024 11:53:23 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-remove-memblock_find_dma_reserve.patch added to mm-unstable branch
Message-Id: <20240318185323.B229AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: remove memblock_find_dma_reserve()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-remove-memblock_find_dma_reserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-remove-memblock_find_dma_reserve.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: x86: remove memblock_find_dma_reserve()
Date: Mon, 18 Mar 2024 22:21:34 +0800

This is not needed any more.

Link: https://lkml.kernel.org/r/20240318142138.783350-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    1 
 arch/x86/kernel/setup.c        |    2 -
 arch/x86/mm/init.c             |   45 -------------------------------
 3 files changed, 48 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-remove-memblock_find_dma_reserve
+++ a/arch/x86/include/asm/pgtable.h
@@ -1200,7 +1200,6 @@ static inline int pgd_none(pgd_t pgd)
 extern int direct_gbpages;
 void init_mem_mapping(void);
 void early_alloc_pgt_buf(void);
-extern void memblock_find_dma_reserve(void);
 void __init poking_init(void);
 unsigned long init_memory_mapping(unsigned long start,
 				  unsigned long end, pgprot_t prot);
--- a/arch/x86/kernel/setup.c~x86-remove-memblock_find_dma_reserve
+++ a/arch/x86/kernel/setup.c
@@ -1106,8 +1106,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	arch_reserve_crashkernel();
 
-	memblock_find_dma_reserve();
-
 	if (!early_xdbc_setup_hardware())
 		early_xdbc_register_console();
 
--- a/arch/x86/mm/init.c~x86-remove-memblock_find_dma_reserve
+++ a/arch/x86/mm/init.c
@@ -990,51 +990,6 @@ void __init free_initrd_mem(unsigned lon
 }
 #endif
 
-/*
- * Calculate the precise size of the DMA zone (first 16 MB of RAM),
- * and pass it to the MM layer - to help it set zone watermarks more
- * accurately.
- *
- * Done on 64-bit systems only for the time being, although 32-bit systems
- * might benefit from this as well.
- */
-void __init memblock_find_dma_reserve(void)
-{
-#ifdef CONFIG_X86_64
-	u64 nr_pages = 0, nr_free_pages = 0;
-	unsigned long start_pfn, end_pfn;
-	phys_addr_t start_addr, end_addr;
-	int i;
-	u64 u;
-
-	/*
-	 * Iterate over all memory ranges (free and reserved ones alike),
-	 * to calculate the total number of pages in the first 16 MB of RAM:
-	 */
-	nr_pages = 0;
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min(start_pfn, MAX_DMA_PFN);
-		end_pfn   = min(end_pfn,   MAX_DMA_PFN);
-
-		nr_pages += end_pfn - start_pfn;
-	}
-
-	/*
-	 * Iterate over free memory ranges to calculate the number of free
-	 * pages in the DMA zone, while not counting potential partial
-	 * pages at the beginning or the end of the range:
-	 */
-	nr_free_pages = 0;
-	for_each_free_mem_range(u, NUMA_NO_NODE, MEMBLOCK_NONE, &start_addr, &end_addr, NULL) {
-		start_pfn = min_t(unsigned long, PFN_UP(start_addr), MAX_DMA_PFN);
-		end_pfn   = min_t(unsigned long, PFN_DOWN(end_addr), MAX_DMA_PFN);
-
-		if (start_pfn < end_pfn)
-			nr_free_pages += end_pfn - start_pfn;
-	}
-#endif
-}
-
 void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-mm_initc-remove-the-useless-dma_reserve.patch
x86-remove-memblock_find_dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch


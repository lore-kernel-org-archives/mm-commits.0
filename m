Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D881A1CD2C
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711390270; cv=none; b=kSJc9gORve2uODoAj+OwgtOACDRf5XDb8Qpe3kw3Q/A3YSZLck+O8rx9NeoD/jr3YwJ7YAOVWz+bfC19Gl2HaupxSfpIpuQU4uFz10h/6WKIjGDeLOTa1gQTpbkqnymi1f1Wv5ii/oLD+El6EaptbcruvxDri8VnFnqUdwBmakA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711390270; c=relaxed/simple;
	bh=UxgQn5wrd98Ews+PjAnpMMQDjOkU8MXoF1iLyjKfzBg=;
	h=Date:To:From:Subject:Message-Id; b=If+BLPXxnvkDG3JiAjUSlBXRxmexUMI1fNUC1S0OGHRH8OuT530ZCePglLQ6Wxa7k5XEELWKrzY6UlC6PaS5rcejsF6lR27I6rOXu5YFz0aBRqZY5lM0I4CzQqUDy3IO/TvY+5u8EWlcPMIdgduAAzAsPkddZizOgWYpbEQG0Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D1P1FntV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D1P1FntV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDD3C433C7;
	Mon, 25 Mar 2024 18:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711390270;
	bh=UxgQn5wrd98Ews+PjAnpMMQDjOkU8MXoF1iLyjKfzBg=;
	h=Date:To:From:Subject:From;
	b=D1P1FntVmTL4DbRfOF02N37v903PlP27VyaC2q5nujASoAcOMmriyShV+6meOJp/O
	 NNzOZ3fvX2Bg0mSjMKE4F7j60vQTFLM/o/eD9ZRSHe7HZU0sTEtYTu2oIxygRVKPKk
	 3uUVvh5NBVVwUX0+oIqwY2HPx4cxKuebPIqr5vk0=
Date: Mon, 25 Mar 2024 11:11:09 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-remove-unneeded-memblock_find_dma_reserve.patch added to mm-unstable branch
Message-Id: <20240325181110.4DDD3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86: remove unneeded memblock_find_dma_reserve()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-remove-unneeded-memblock_find_dma_reserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-remove-unneeded-memblock_find_dma_reserve.patch

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
Subject: x86: remove unneeded memblock_find_dma_reserve()
Date: Mon, 25 Mar 2024 22:56:41 +0800

Patch series "mm/mm_init.c: refactor free_area_init_core()".

In function free_area_init_core(), the code calculating
zone->managed_pages and the subtracting dma_reserve from DMA zone looks
very confusing.

From git history, the code calculating zone->managed_pages was for
zone->present_pages originally.  The early rough assignment is for
optimize zone's pcp and water mark setting.  Later, managed_pages was
introduced into zone to represent the number of managed pages by buddy. 
Now, zone->managed_pages is zeroed out and reset in mem_init() when
calling memblock_free_all().  zone's pcp and wmark setting relying on
actual zone->managed_pages are done later than mem_init() invocation.  So
we don't need rush to early calculate and set zone->managed_pages, just
set it as zone->present_pages, will adjust it in mem_init().

And also add a new function calc_nr_kernel_pages() to count up free but
not reserved pages in memblock, then assign it to nr_all_pages and
nr_kernel_pages after memmap pages are allocated.


This patch (of 6):

Variable dma_reserve and its usage was introduced in commit 0e0b864e069c
("[PATCH] Account for memmap and optionally the kernel image as holes"). 
Its original purpose was to accounting for the reserved pages in DMA zone
to make DMA zone's watermarks calculation more accurate on x86.

However, currently there's zone->managed_pages to account for all
available pages for buddy, zone->present_pages to account for all present
physical pages in zone.  What is more important, on x86, calculating and
setting the zone->managed_pages is a temporary move, all zone's
managed_pages will be zeroed out and reset to the actual value according
to how many pages are added to buddy allocator in mem_init().  Before
mem_init(), no buddy alloction is requested.  And zone's pcp and watermark
setting are all done after mem_init().  So, no need to worry about the DMA
zone's setting accuracy during free_area_init().

Hence, remove memblock_find_dma_reserve() to stop calculating and
setting dma_reserve.

Link: https://lkml.kernel.org/r/20240325145646.1044760-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20240325145646.1044760-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    1 
 arch/x86/kernel/setup.c        |    2 -
 arch/x86/mm/init.c             |   47 -------------------------------
 3 files changed, 50 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-remove-unneeded-memblock_find_dma_reserve
+++ a/arch/x86/include/asm/pgtable.h
@@ -1200,7 +1200,6 @@ static inline int pgd_none(pgd_t pgd)
 extern int direct_gbpages;
 void init_mem_mapping(void);
 void early_alloc_pgt_buf(void);
-extern void memblock_find_dma_reserve(void);
 void __init poking_init(void);
 unsigned long init_memory_mapping(unsigned long start,
 				  unsigned long end, pgprot_t prot);
--- a/arch/x86/kernel/setup.c~x86-remove-unneeded-memblock_find_dma_reserve
+++ a/arch/x86/kernel/setup.c
@@ -1106,8 +1106,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	arch_reserve_crashkernel();
 
-	memblock_find_dma_reserve();
-
 	if (!early_xdbc_setup_hardware())
 		early_xdbc_register_console();
 
--- a/arch/x86/mm/init.c~x86-remove-unneeded-memblock_find_dma_reserve
+++ a/arch/x86/mm/init.c
@@ -990,53 +990,6 @@ void __init free_initrd_mem(unsigned lon
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
-
-	set_dma_reserve(nr_pages - nr_free_pages);
-#endif
-}
-
 void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch


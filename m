Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E486F446058
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140722; cv=none; b=tOIb3tNohOrjXkA5ooaolw2FBgstVg/Oal94J+DlAlVzxQjBm15HiM4o9PqTt+aIpeLi3trlDV7BkvUnocllrE7WNuvCHT4g3YTUDSTUU/Li1c/2yk38e6UsxWjemwP++6TYF+LmC5WtMSZvlEKN27ZNkou94T8Gf1zECeiiI6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140722; c=relaxed/simple;
	bh=8rlEnM+fAMT74Apxe4xSAi6wyaQI0y6LJFRrGz8AQIw=;
	h=Date:To:From:Subject:Message-Id; b=Aur3jlGQvvCmkRCp+BR1FiET5GECnjxo/1ZsKxOMFWqlnwrZ68VXSmP2dW5vrVIH8M5bwSyB9lt4G9FGuVVrxVIr9zfmvCmbWKfDIA0YkjQ8Dx4BzMeMGPgt5p5hIXYJD57tIfRiUDfP2wo9PmvK/FgTfC+HRzVJdyZaNi/UAEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0eubRHeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0eubRHeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700E71F00AC4;
	Wed, 15 Jul 2026 18:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140703;
	bh=H5QYsARaqYB5uzSSwYg+9yTSMziGCYr9wiKbT59aYEQ=;
	h=Date:To:From:Subject;
	b=0eubRHeNlbG1ima+wqNU2ynKUubvWZRL2dAshBdGsf9Rm/URyxz43tJnSiMvOU8bb
	 fCQ0c/XhN+OA+E+bM2Qt31Kd7RVrhkXySsZ5Fq30lHi7M1rCFWBbS0IDuRo1nSObo3
	 XIyD0fwslxh9K6ef5ZiqVYt0zhNNlo0rRP49O/og=
Date: Wed, 15 Jul 2026 11:38:23 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch added to mm-unstable branch
Message-Id: <20260715183823.700E71F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: map contiguous pages in batches for vmap() if possible
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Wed, 15 Jul 2026 20:08:12 +0800

In many cases, the pages passed to vmap() may include high-order pages. 
For example, the systemheap often allocates pages in descending order:
order 8, then 4, then 0.  Currently, vmap() iterates over every page
individually—even pages inside a high-order block are handled one by
one.

This patch detects physically contiguous pages (regardless of whether they
are compound or non-compound) by scanning with num_pages_contiguous(), and
maps them as a single contiguous block whenever possible.  The mapping
order is determined by taking the minimum of the contiguous page count and
the pfn alignment, allowing graceful degradation when pfn alignment is
less than the contiguous range.

Pages with the same page_shift are coalesced and mapped via
vmap_pages_range_noflush_walk() to avoid page table rewalk.

As users typically allocate memory in descending orders (e.g.  8 → 4 →
0), once an order-0 page is encountered, we stop scanning for contiguous
pages since subsequent pages are likely order-0 as well.

Link: https://lore.kernel.org/20260715120813.3609949-7-jiangwen6@xiaomi.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible
+++ a/mm/vmalloc.c
@@ -3586,6 +3586,84 @@ static inline unsigned int vm_shift(pgpr
 	return arch_vmap_pte_supported_shift(size);
 }
 
+static inline int get_vmap_batch_order(struct page **pages,
+		pgprot_t prot, unsigned int max_steps, unsigned int idx)
+{
+	unsigned long pfn;
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return 0;
+
+	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
+	if (nr_contig < 2)
+		return 0;
+
+	order = ilog2(nr_contig);
+	pfn = page_to_pfn(pages[idx]);
+
+	/* Limit order by pfn alignment */
+	if (pfn > 0)
+		order = min_t(int, order, __ffs(pfn));
+
+	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
+		return 0;
+
+	return order;
+}
+
+static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, idx = 0;
+	unsigned long map_addr = addr, batch_end = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+					     PAGE_SHIFT, GFP_KERNEL);
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < count; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_batch_order(pages, prot, count - i, i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(map_addr, batch_end,
+					prot, pages + idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			map_addr = batch_end;
+			idx = i;
+		}
+
+		/*
+		 * Once small pages are encountered, the remaining pages
+		 * are likely small as well.
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
+
+		batch_end += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (map_addr < end)
+		err = vmap_pages_range_noflush_walk(map_addr, end,
+				prot, pages + idx, prev_shift);
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3629,8 +3707,8 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot),
+				pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch
arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch


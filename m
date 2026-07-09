Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AA9377009
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 23:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783638329; cv=none; b=URvH56PnfPqbYxoxEXM0wruLbzKHq9nlH7sZtVzpBKbunUIk+eNC/QVI8cbMQ3ihuPNWE3vwsbSpXnuXluUzutEHSm51pRt+Fv0ycx5d90x7Yc0uDko99j2Jwim8ezYqjJQn+UBGm+DKoFjueaXkDQO0kTckVxfYm5t4wi0/qGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783638329; c=relaxed/simple;
	bh=Q+KLupuB/47zpTbPUENfKoAhybyL+7V1GIm/2Fl2MXY=;
	h=Date:To:From:Subject:Message-Id; b=ihyeIqZIXGaRLrpjdTzvrk4eVvpmmVL4N4ZWDMROnvjrDcEHm3C6TvSPS+u78iW93M6xO/U54sk1WmoDx370pWxiMIq3P2V+HH2bG3T7gjbb8n3c1jrpd33qnmJy6KD+KUI4apFLttczTwyc0YJ65/lxwo8ybKc/eoIz73i6WmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQyBHD+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQyBHD+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2941F00A3A;
	Thu,  9 Jul 2026 23:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783638327;
	bh=g6UTSO6oHyZtwh5E9Y8yBZKprO7oTNp6z0WllSSGR4Y=;
	h=Date:To:From:Subject;
	b=qQyBHD+/UQ6/irXJJyoe3IkOA2rmMEI21BjbGjFwjmXzoAaiEpSt9kstiviPsEpA5
	 2bDQoG2kEZ3VllSxcQElnuX5l30O1OBVSyeOP2/4xCaIFAX5Ct5qxmr1P/1fwOmS1I
	 PrDX2mu/wuRBylKhHqU8wDlY6EkNOwaQNbwipkaI=
Date: Thu, 09 Jul 2026 16:05:27 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ajd@linux.ibm.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch added to mm-new branch
Message-Id: <20260709230527.8B2941F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: map contiguous pages in batches for vmap() if possible
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Thu, 9 Jul 2026 15:38:22 +0800

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

Link: https://lore.kernel.org/20260709073823.6643-6-jiangwen6@xiaomi.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
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

 mm/vmalloc.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible
+++ a/mm/vmalloc.c
@@ -3549,6 +3549,89 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
+static inline int get_vmap_batch_order(struct page **pages,
+		pgprot_t prot, unsigned int max_steps, unsigned int idx)
+{
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
+
+	/* Limit order by pfn alignment */
+	order = min_t(int, order, __ffs(page_to_pfn(pages[idx])));
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
+						PAGE_SHIFT, GFP_KERNEL);
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
@@ -3592,8 +3675,8 @@ void *vmap(struct page **pages, unsigned
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


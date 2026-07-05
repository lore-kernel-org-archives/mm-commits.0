Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC48A64AA4
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783283792; cv=none; b=FoiwrZRYBhoZyKVvtyWlsl9YJHAm7f662cQX603MTowhkeMuXCiryaUxJazDmFLxr5ycyX8JEoLbv6Jd8Ji5IVMQXcp5iirUBoPVAheX/+8CKB7Dm6ucVB8FM5wfM51vGdW4O8r1DydEA8qm9M5kMvdBgGHSY9bp5RL57S03XVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783283792; c=relaxed/simple;
	bh=BA+4VGoIMlygW2KtZIyN6ygpEKt398/jM3Mo5twG3cQ=;
	h=Date:To:From:Subject:Message-Id; b=IzPfji9n/f3IQ8ftxT0zftio8b0uCcBNfe5fpob/0cEWslSnE1XkWlfPgt9LqrfOPE15OUohDLkwdFwMYuBSAnYBwUo6XDlHvyLSpbnhia4Pmo2+E6ZpYAz5eOhNNpFHKBqZeRv+VSlyXfV0zhKXvyxttrKN8+AaHV4r8ZWJZU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XjJ7doAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XjJ7doAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33581F000E9;
	Sun,  5 Jul 2026 20:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783283790;
	bh=E7B7fAVP9xoilZebgukRovgf/MPPc0i+fQJ3XoC0YDU=;
	h=Date:To:From:Subject;
	b=XjJ7doAwrRQ3+/cIcwscdToviynA3pVs4+6b7Ga4BlIC478ROtqJuGy4eY0HO7Nnz
	 2yPU0QRtZmINFdXKNYxP6NYuOju14STuJCnA0KOZAJvoXFLXCDowWkYcFYZ3X2hWxg
	 yFyajZEcqNR3w6XcaWgnJ11q6cQ42/Lw8Fu7wZmA=
Date: Sun, 05 Jul 2026 13:36:30 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch removed from -mm tree
Message-Id: <20260705203630.A33581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: map contiguous pages in batches for vmap() if possible
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Thu, 18 Jun 2026 16:47:25 +0800

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

Link: https://lore.kernel.org/20260618084726.1070022-6-jiangwen6@xiaomi.com
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
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible
+++ a/mm/vmalloc.c
@@ -3550,6 +3550,89 @@ void vunmap(const void *addr)
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
+static int vmap_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	unsigned int count = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, idx = 0;
+	unsigned long start = addr, map_addr = addr;
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
+			err = vmap_pages_range_noflush_walk(map_addr, addr,
+					prot, pages + idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			map_addr = addr;
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
+		addr += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (map_addr < end)
+		err = vmap_pages_range_noflush_walk(map_addr, end,
+				prot, pages + idx, prev_shift);
+
+out:
+	flush_cache_vmap(start, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3593,8 +3676,8 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_batched(addr, addr + size, pgprot_nx(prot),
+				pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch


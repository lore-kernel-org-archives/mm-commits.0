Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207855;
	b=P5Wf4Mxjgmb6Nd9O+bScCJVtVdi0J+WCN3H8ljeM8r1W+QkOc7nXlbNpduuZWtgANCq2
	 CyGKz78IjOEvebD4dzIrZZj9rf17gnj2KTnZvipLN2LE4gs226ivg2KI1HP8uOnll49WT
	 O6mzv2m6+BvkZIxPaJxpQCj146sn4UCuAwK+abOxyviCGH4N/o/Tz4H+rYTMODNN8y5j8
	 oiktp/FcvMMGIi5ZiuFxbNiSCvjmG3PQ9jEMs0BHdK4iNRq/22mgr4e0xwWybCywc+tJk
	 nAJ+Pg8ZzRA/1n8hS3dN2lknj+6GgonCCWPg2FI7YHkpCOPOiu3mZ7Rss6QXrWcwXbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207855;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dWK1eviuhFerIW9uorJWAd1VytN25Rg3/exB4KVMiBk=;
	b=TyiepBE9UwqcShCRszBqsUnt72SPtKl2JsuxQlV+C/brmu8Rv8fWRdpr3oh9cWXDfl31
	 f8gAEapV49E5laV3OLRvtsMrAEGrz60jI8iNAd/vQqrZ9TZrt+HoNbNVw+nbFUXcLeo01
	 narpSRzjB2PvENyjkZJlvBseKyX2JhYE4mB8l8bH9a21wzeBZgfBKw3GC7UMyJXz5OkFT
	 s0VRb9/1eRatausZLJARhpphCQ0LV17b+gH5AmZewX8ExQJul+6Y6A2SjreBe77gSqWZO
	 tRhJz6vPsAh6A83kfL2RI/VXTsGRMk5PkBzMuN4Ae+8EH7CE7w2ftzSPv5E+FnxiOPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="rM/7U7uB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAEB606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rM/7U7uB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D6F1F0089F;
	Mon,  9 Nov 2026 07:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207854;
	bh=dWK1eviuhFerIW9uorJWAd1VytN25Rg3/exB4KVMiBk=;
	h=Date:To:From:Subject;
	b=rM/7U7uBBVHEQutY+J6cJDopds82+ulv7LIBX/K8NoQ/aHOjIhfV4kcvt+PDIc4Rv
	 ggmCqZEYLPVZkSOx8tLmuyzGhgx/OtC2AsNUiEiTYKK1xnQbF3Z7yuZ5m9qfV85G0e
	 bPzvsh+jtnVeOU2KDCAq+nh9meBqeluknR4v7uew=
Date: Sun, 08 Nov 2026 23:04:14 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,
	david@kernel.org,chleroy@kernel.org,catalin.marinas@arm.com,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,baohua@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch added to mm-new branch
Message-Id: <20261109070414.91D6F1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


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
Date: Sat, 07 Nov 2026 21:49:52 +0800

In many cases, the pages passed to vmap() may include high-order
pages. For example, the systemheap often allocates pages in descending
order: order 8, then 4, then 0. Currently, vmap() iterates over every
page individually—even pages inside a high-order block are handled
one by one.

This patch detects physically contiguous pages (regardless of whether
they are compound or non-compound) by scanning with
num_pages_contiguous(), and maps them as a single contiguous block
whenever possible. The mapping order is determined by taking the
minimum of the contiguous page count and the pfn alignment, allowing
graceful degradation when pfn alignment is less than the contiguous
range.

Pages with the same page_shift are coalesced and mapped via
vmap_pages_range_noflush_walk() to avoid page table rewalk.

As users typically allocate memory in descending orders (e.g.
8 → 4 → 0), once an order-0 page is encountered, we stop scanning
for contiguous pages since subsequent pages are likely order-0 as well.

With large mappings, vmap_try_huge_pmd() may free an empty PTE table
left behind by an earlier vunmap() and install a PMD while vread_iter()
walks the same range without the mmap lock. Set VM_UNINITIALIZED on the
area until the mapping is complete, as __vmalloc_node_range_noprof()
already does, so that vread_iter() skips it.

Link: https://lore.kernel.org/20261107134953.748622-10-jiangwenxiaomi@gmail.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
---

 mm/vmalloc.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible
+++ a/mm/vmalloc.c
@@ -3630,6 +3630,85 @@ static inline unsigned int vm_shift(pgpr
 	return arch_vmap_pte_supported_shift(size);
 }
 
+static inline int get_vmap_mapping_order(struct page **pages,
+		pgprot_t prot, unsigned int nr_pages)
+{
+	unsigned long pfn;
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return 0;
+
+	/* Limit nr_pages by pfn alignment */
+	pfn = page_to_pfn(*pages);
+	if (pfn > 0)
+		nr_pages = min_t(size_t, nr_pages, 1UL << __ffs(pfn));
+
+	nr_contig = num_pages_contiguous(pages, nr_pages);
+	if (nr_contig < 2)
+		return 0;
+
+	order = ilog2(nr_contig);
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
+	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, batch_idx = 0;
+	unsigned long batch_start = addr, batch_end = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+					     PAGE_SHIFT, GFP_KERNEL);
+
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < nr_pages; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_mapping_order(pages + i, prot, nr_pages - i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
+					prot, pages + batch_idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			batch_start = batch_end;
+			batch_idx = i;
+		}
+
+		/*
+		 * Once we fail to batch pages, we expect to fail batching
+		 * for all remaining pages, so just give up.
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
+
+		batch_end += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (batch_start < end)
+		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
+				pages + batch_idx, prev_shift);
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3668,13 +3747,13 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = get_vm_area_caller(size, flags | VM_UNINITIALIZED,
+				  __builtin_return_address(0));
 	if (!area)
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
@@ -3683,6 +3762,9 @@ void *vmap(struct page **pages, unsigned
 		area->pages = pages;
 		area->nr_pages = count;
 	}
+
+	clear_vm_uninitialized_flag(area);
+
 	return area->addr;
 }
 EXPORT_SYMBOL(vmap);
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch


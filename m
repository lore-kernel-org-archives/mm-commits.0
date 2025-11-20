Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED190322A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763598999; cv=none; b=t1RQUF4ikd6rDqPM2ybrbgr84SBnNSvuC4h2phhf9YkB26Ap5NqMdXOU1yTiqJfBDZkOXtxRXGaaoAC2ZMkU3UeUE8LPvF1xCeMc2ZnSe8i4+VDNS/HWJwjRbXkmmx9D6dGjvuQTxIZh9qwNBR52OR+O/IGquy3OEVaxMu3hWCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763598999; c=relaxed/simple;
	bh=A09TP4O8BQ6vDqJ7u2HmK3ZXDzyBdm7FEaLtb/hQYY4=;
	h=Date:To:From:Subject:Message-Id; b=KHNhMymdoTmBZGaPTwI29ckXnaYbY+ezieJmfN0lEdR3Au2zRE15h0BKJrS3TUVeb2dl/pBjSSuAP2BZ/ZsnWUxoV7cH/ghxouAvS30gPvO1/Ep4hI6Xi/76+oLc0sxxF/nVdVW/N4zSWV2DmeX/Jl4KmwRnpJJ6RU423Qp8BZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UqzjOhMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UqzjOhMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A182C4CEF5;
	Thu, 20 Nov 2025 00:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763598998;
	bh=A09TP4O8BQ6vDqJ7u2HmK3ZXDzyBdm7FEaLtb/hQYY4=;
	h=Date:To:From:Subject:From;
	b=UqzjOhMcdxMExDn8w+kgGxdkOTl7Yra2yqNQTHjOL3sKCKpjfC+mo2gKeE5nE8zTF
	 k+HRhjAkgPibBORDfJvt230vCAepc8qPuq8YCuVkyqqAPZnV+tuf4wuDD96ckRepRE
	 ByVv8CevuimiXin7XBIY7qj8MfxFxSd/bPn8TrBU=
Date: Wed, 19 Nov 2025 16:36:37 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch removed from -mm tree
Message-Id: <20251120003638.5A182C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: add a helper to optimize vmalloc allocation gfps
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: add a helper to optimize vmalloc allocation gfps
Date: Mon, 17 Nov 2025 09:35:28 -0800

vm_area_alloc_pages() attempts to use different gfp flags as a way to
optimize allocations.  This has been done inline which makes things harder
to read.

Add a helper function to make the code more readable.

Link: https://lkml.kernel.org/r/20251117173530.43293-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps
+++ a/mm/vmalloc.c
@@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsi
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+/*
+ * Helper for vmalloc to adjust the gfp flags for certain allocations.
+ */
+static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
+{
+	flags |= __GFP_NOWARN;
+	if (large)
+		flags &= ~__GFP_NOFAIL;
+	return flags;
+}
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct
 	 * Please note, the __vmalloc_node_range_noprof() falls-back
 	 * to order-0 pages if high-order attempt is unsuccessful.
 	 */
-	area->nr_pages = vm_area_alloc_pages((page_order ?
-		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
-		node, page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(
+			vmalloc_gfp_adjust(gfp_mask, page_order), node,
+			page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch


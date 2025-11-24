Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B4032F74B
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025860; cv=none; b=A6zrirACaA+tEcKiSheOPCqNIG2nHxXF8T4tHr7X5jCrZMHIbONI5OzH0TLfuGWvuW2/V1cEp/MwFkoe+VklfymgsUfI4zxrOeB0MJSrtnvrzLtOtmeecHUpEYJnuP+58ave/5fZ8yYEQG8Om5btK6M0wAUbdn5x6Ww05LGI+HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025860; c=relaxed/simple;
	bh=fYLGa+qXadVdn9Gvq44ldXqM1zFaVIBSd8QDJUF7TeA=;
	h=Date:To:From:Subject:Message-Id; b=pHLsWdAzVrYI8VxcsP4VL624Xwn3Tsn1lqxYNWetOrpupvlhYzrux+onr6MTyETLWQXq39E1oiaJwNXmzfLE/S5HiY1v6Pc5aMhu0yBd87SJnxEJrrAh2+H7RIoPL4fGo/gppuUPKjDQhbJaJrn8F9AStaPnno9crxjInP1ulIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jo4aT/50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jo4aT/50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D169DC4CEF1;
	Mon, 24 Nov 2025 23:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025859;
	bh=fYLGa+qXadVdn9Gvq44ldXqM1zFaVIBSd8QDJUF7TeA=;
	h=Date:To:From:Subject:From;
	b=jo4aT/5078Y4eZgvgKYtIMtV+IpBCLZIUHRdQzrT8uheCtMXQavGIAGI0bx0j16bu
	 UUIlzrHYTob2Drfnq4E5FX3UUpQJDi/jo+j8FSKzJTKA1GBCelWIXEk3iZWsYlqXJ/
	 CfnJ0SZXPn7zaa+R4u4IxbC3fxA1h37Zfr9kegU8=
Date: Mon, 24 Nov 2025 15:10:59 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch removed from -mm tree
Message-Id: <20251124231059.D169DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: add a helper to optimize vmalloc allocation gfps
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: add a helper to optimize vmalloc allocation gfps
Date: Fri, 21 Nov 2025 01:44:03 -0800

vm_area_alloc_pages() attempts to use different gfp flags as a way to
optimize allocations.  This has been done inline which makes things harder
to read.

Add a helper function to make the code more readable.

Link: https://lkml.kernel.org/r/20251121094405.40628-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
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



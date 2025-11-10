Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F022737E7
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 19:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762801910; cv=none; b=tURmIYr3V3+Oyj92KzFahcFFddX/IXy01Lwu3udSl9O5xT1cM7T4hMgBSjhEeS6mWOSKU5VSV4XN8eDR6HhHWGNYhj49dyetdp+6SLWZzDgFe0AjLrs4u9DkCxI9uTWGAdNE38CoOSZ54M9mNnlsdo0jZyH82oy2r/nWbJfZG2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762801910; c=relaxed/simple;
	bh=Iz2276A/4s9mXmP4yF8VU3g0il4jBOX0+XiX75ldoTs=;
	h=Date:To:From:Subject:Message-Id; b=T/w2pqxdEdmwGWVeWb8lacA47EqWUMZ4NOBPTUWJu7bgBbDW0FBF3yAEsUwGMa09eEEl8FOzRL4KmI9E5AIFeiWLgmVkUeXFizbLBy9FM2bG2AY0Q7x1bWzyfO3UN9Aqyw06XuKcLpsJJg6Bazc39ruKD13v09BbodBCq9iOcC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GQpkAy6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GQpkAy6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412CCC19425;
	Mon, 10 Nov 2025 19:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762801910;
	bh=Iz2276A/4s9mXmP4yF8VU3g0il4jBOX0+XiX75ldoTs=;
	h=Date:To:From:Subject:From;
	b=GQpkAy6YWUIQR228I7r68gAC3T//bwf4/iP1mKeCLnXrTrjz0v78vySvF21aUN/b8
	 ECWe30zwFIgHDYXKQaNMwtCHZXuTZKKjYr1n7QNdYYCfYF8WmlJkJG0T3SaGDj/CUE
	 23eKIph9wKBZQN0DBtw1mpcDLPRIUM+w00EcrkFY=
Date: Mon, 10 Nov 2025 11:11:49 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch added to mm-new branch
Message-Id: <20251110191150.412CCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: add a helper to optimize vmalloc allocation gfps
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: add a helper to optimize vmalloc allocation gfps
Date: Mon, 10 Nov 2025 08:04:55 -0800

vm_area_alloc_pages() attempts to use different gfp flags as a way to
optimize allocations.  This has been done inline which makes things harder
to read.

Add a helper function to make the code more readable.

Link: https://lkml.kernel.org/r/20251110160457.61791-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
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

mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch


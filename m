Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40432DA779
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743432; cv=none; b=T4jaPDsrw2IVGPGyGtY7gqupQf6/KbacN+Ly7x1/UXP/gBsbRoFPAigY1H0JNa/zyyeOnuVStPHIyLeaaN+azC2FnPFpEJA+BW4qH0JI5lrl4QZ3Ns9hoA9E1dKNE7/Ruln2caVFtN1cFyaZSEqyQ9cgTpf/vTZO6AieUYiMLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743432; c=relaxed/simple;
	bh=/5Qo3NCRHlhD5s8Xd+k0FCQ+AT92hZnsBbJ0Lh0W2oE=;
	h=Date:To:From:Subject:Message-Id; b=WUGunghxRds9YogB/eepKHRMEsQ8fTmI2N2NDuVdtcd0cER568sw+unfvTLe7tEg4Jv5Br+kn1qronaMmhCKgEYLwT+xuLFvpmq8e5vUiqQpqVgg7Fq7RUrqf9Oehe9p+uwYDdm24qEOvnqKv7IxLTja9VzidLn8jPiuKGkpT+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQAxnI5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQAxnI5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4115FC4CEF1;
	Fri, 21 Nov 2025 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763743430;
	bh=/5Qo3NCRHlhD5s8Xd+k0FCQ+AT92hZnsBbJ0Lh0W2oE=;
	h=Date:To:From:Subject:From;
	b=LQAxnI5KCstPjSoDXrIfq/Mt23UBdr7++lL+moAGSkU2dxcZABczKiuVYW3UWwuBV
	 qjg2nKq8KKXzKXCLGnbObCvYr8VoC0a8f2JeS5Z3ubDiqPVfZDS8gQRl+RkJLuRMxr
	 ob6U3Z8VqbAZtEO6pFOPCUcl5vBVcFr1GyLOiahM=
Date: Fri, 21 Nov 2025 08:43:49 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,sj@kernel.org,hch@infradead.org,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch added to mm-unstable branch
Message-Id: <20251121164350.4115FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: add a helper to optimize vmalloc allocation gfps
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch

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

mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch


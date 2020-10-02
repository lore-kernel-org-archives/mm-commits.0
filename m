Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED32FC4363D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4B12177B
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674171;
	bh=HeFTPq1h55aS36X3ZoRP+vd7chnK9hsIbYbiHtLwy+o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rmdWZJyfiNFfeqEifqyaQ7Ku5NJ7Yx4yBA1OyC/XxCaPDVzsz5oeBUU2hgHKRhdOt
	 3JHYiGDkJ3nddKp9NWXMI3OWn09eHmFvlVIExz1fDrzi0YU1rqLnA1MH3GlCHSSfRz
	 E1Sl0IcQe3JFHBYcMgmtsauGDH259F8Sc4yKAmjw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgJBV3b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgJBV3b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:31 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B528E2168B;
        Fri,  2 Oct 2020 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674170;
        bh=HeFTPq1h55aS36X3ZoRP+vd7chnK9hsIbYbiHtLwy+o=;
        h=Date:From:To:Subject:From;
        b=KzWNrQYVMoZS3ESiyt9aH6T/BrrhpIiB5XIX30lrYZx0rMKS+cD/mCPlyEnyJsSVU
         3k1bww1LabQykMKN5nt50xB53FsHokQkPCck/XnWAED99VoD9DRtNRv60c4KB1SgXG
         kxTK4E8tIMeWS679QTseG8lsfnAvHLYLcc3Wmx2k=
Date:   Fri, 02 Oct 2020 14:29:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@lst.de
Subject:  +
 mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch added to -mm
 tree
Message-ID: <20201002212930.ukEtZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup the gfp_mask handling in __vmalloc_area_node
has been added to the -mm tree.  Its filename is
     mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: cleanup the gfp_mask handling in __vmalloc_area_node

Patch series "two small vmalloc cleanups".

This patch (of 2):

__vmalloc_area_node currently has four different gfp_t variables to
just express this simple logic:

 - use the passed in mask, plus __GFP_NOWARN and __GFP_HIGHMEM (if
   suitable) for the underlying page allocation
 - use just the reclaim flags from the passed in mask plus __GFP_ZERO
   for allocating the page array

Simplify this down to just use the pre-existing nested_gfp as-is for
the page array allocation, and just the passed in gfp_mask for the
page allocation, after conditionally ORing __GFP_HIGHMEM into it.  This
also makes the allocation warning a little more correct.

Also initialize two variables at the time of declaration while touching
this area.

Link: https://lkml.kernel.org/r/20201002124035.1539300-1-hch@lst.de
Link: https://lkml.kernel.org/r/20201002124035.1539300-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/vmalloc.c~mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -2461,21 +2461,19 @@ EXPORT_SYMBOL_GPL(vmap_pfn);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node)
 {
-	struct page **pages;
-	unsigned int nr_pages, array_size, i;
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
-	const gfp_t alloc_mask = gfp_mask | __GFP_NOWARN;
-	const gfp_t highmem_mask = (gfp_mask & (GFP_DMA | GFP_DMA32)) ?
-					0 :
-					__GFP_HIGHMEM;
+	unsigned int nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
+	unsigned int array_size = nr_pages * sizeof(struct page *), i;
+	struct page **pages;
 
-	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
-	array_size = (nr_pages * sizeof(struct page *));
+	gfp_mask |= __GFP_NOWARN;
+	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
+		gfp_mask |= __GFP_HIGHMEM;
 
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, 1, nested_gfp|highmem_mask,
-				node, area->caller);
+		pages = __vmalloc_node(array_size, 1, nested_gfp, node,
+					area->caller);
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
@@ -2493,9 +2491,9 @@ static void *__vmalloc_area_node(struct
 		struct page *page;
 
 		if (node == NUMA_NO_NODE)
-			page = alloc_page(alloc_mask|highmem_mask);
+			page = alloc_page(gfp_mask);
 		else
-			page = alloc_pages_node(node, alloc_mask|highmem_mask, 0);
+			page = alloc_pages_node(node, gfp_mask, 0);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vfree() */
_

Patches currently in -mm which might be from hch@lst.de are

mm-add-a-vm_map_put_pages-flag-for-vmap.patch
mm-add-a-vmap_pfn-function.patch
mm-allow-a-null-fn-callback-in-apply_to_page_range.patch
zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-stop-using-kmap-in-i915_gem_object_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
mm-remove-alloc_vm_area.patch
mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch
mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch


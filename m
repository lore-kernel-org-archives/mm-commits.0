Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBFEC5517A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDACB24672
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408231;
	bh=XUtDah0Wp4g9Trs78Gph/IbgU0nhFaR7Ip86CYNNDh8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=We67Uqrvyw9OFB+YOoFvlJlFtCr2cmxa0rLfYMuXV3s2xfP9Pn5tB+WrYk1IVFLaa
	 6U1200T6mMgzBIp25Eeftgiq3M8B5rXydhICpoLStzDU/fEVaLqoxbSh19LYBpsQX2
	 yjrmGk/WVBR0rMvfZJTjtj1/D4qJdJcZtcnt7SjY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373267AbgJVXKa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJVXKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF6F223C7;
        Thu, 22 Oct 2020 23:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408229;
        bh=XUtDah0Wp4g9Trs78Gph/IbgU0nhFaR7Ip86CYNNDh8=;
        h=Date:From:To:Subject:From;
        b=k2FGQTgC4MPT+EcZdWl5PbiZdN5IS+wm5578vlMnSUBbh5DPDeEqf1Tgof5MJvwbY
         eL4sgfCpngcpExkP/0fKNsptV2GsSnM91fwujTmdrqzWOc4IFUI6xgUcpDjRQJUlbq
         fU9lUXsX3TRSOyS6nljOMNX4nJ5K/1zNM2ZcjhzI=
Date:   Thu, 22 Oct 2020 16:10:29 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  [merged]
 mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch removed from
 -mm tree
Message-ID: <20201022231029.iUYUwtX93%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup the gfp_mask handling in __vmalloc_area_node
has been removed from the -mm tree.  Its filename was
     mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



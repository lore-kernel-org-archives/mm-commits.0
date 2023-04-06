Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA402C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbjDFCpM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbjDFCor (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C05793C5
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F16F1642A8
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52356C433D2;
        Thu,  6 Apr 2023 02:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749078;
        bh=YrFpzKkI+W/rMft6bn1kVtiojSzfP5lmuGKtIeYx5jA=;
        h=Date:To:From:Subject:From;
        b=jgnWckX3/K6PYOKAnprIoQBmqkbBlYdryTecfPtdV7iVDqFnmicPi+wlFTpuWvKZQ
         4Dg5G+VOSzurNl0opXSHYEefk06FlFQHSl5WtbCs4CYO+8fzR3ssXYytGh6ucER0lQ
         p+otJMvcLu41m23SQrdr7ZR9iLUuk7rjlaP6OS6Q=
Date:   Wed, 05 Apr 2023 19:44:37 -0700
To:     mm-commits@vger.kernel.org, robin.murphy@arm.com, jroedel@suse.de,
        jacob.jun.pan@linux.intel.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch removed from -mm tree
Message-Id: <20230406024438.52356C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iommu: fix MAX_ORDER usage in __iommu_dma_alloc_pages()
has been removed from the -mm tree.  Its filename was
     iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: iommu: fix MAX_ORDER usage in __iommu_dma_alloc_pages()
Date: Wed, 15 Mar 2023 14:31:32 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in __iommu_dma_alloc_pages().

Also use GENMASK() instead of hard to read "(2U << order) - 1" magic.

Link: https://lkml.kernel.org/r/20230315113133.11326-10-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/dma-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/dma-iommu.c~iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages
+++ a/drivers/iommu/dma-iommu.c
@@ -736,7 +736,7 @@ static struct page **__iommu_dma_alloc_p
 	struct page **pages;
 	unsigned int i = 0, nid = dev_to_node(dev);
 
-	order_mask &= (2U << MAX_ORDER) - 1;
+	order_mask &= GENMASK(MAX_ORDER - 1, 0);
 	if (!order_mask)
 		return NULL;
 
@@ -756,7 +756,7 @@ static struct page **__iommu_dma_alloc_p
 		 * than a necessity, hence using __GFP_NORETRY until
 		 * falling back to minimum-order allocations.
 		 */
-		for (order_mask &= (2U << __fls(count)) - 1;
+		for (order_mask &= GENMASK(__fls(count), 0);
 		     order_mask; order_mask &= ~order_size) {
 			unsigned int order = __fls(order_mask);
 			gfp_t alloc_flags = gfp;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are



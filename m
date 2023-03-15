Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1530C6FD1D
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjCOTjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjCOTjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:39:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D885F53F
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3235BB81F21
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67FEC433D2;
        Wed, 15 Mar 2023 19:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678909137;
        bh=Jis+q1vEgCAl0ikQhS5YU/GoQUGnpz3hGRnHFMg3M14=;
        h=Date:To:From:Subject:From;
        b=yvLRqDvY6W1NK2KWhTON8A8/zuhHtQXNGfGo44N6a4KGiMsdax/oENj6GATOIypp0
         wqPpDMqqxGaQ8PYcTRVGARmOaL9Kf5G8y0GFbJtY9Dh0QFHSRIOTY1/cgj9Pp8pc/V
         ms6GGAX96oNNWG48ACS/Qmlo3p1LIhcP100DuDQE=
Date:   Wed, 15 Mar 2023 12:38:57 -0700
To:     mm-commits@vger.kernel.org, robin.murphy@arm.com,
        jacob.jun.pan@linux.intel.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch added to mm-unstable branch
Message-Id: <20230315193857.C67FEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iommu: fix MAX_ORDER usage in __iommu_dma_alloc_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch

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

sparc-mm-fix-max_order-usage-in-tsb_grow.patch
um-fix-max_order-usage-in-linux_main.patch
floppy-fix-max_order-usage.patch
drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch
genwqe-fix-max_order-usage.patch
perf-core-fix-max_order-usage-in-rb_alloc_aux_page.patch
mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch
mm-slub-fix-max_order-usage-in-calculate_order.patch
iommu-fix-max_order-usage-in-__iommu_dma_alloc_pages.patch
mm-treewide-redefine-max_order-sanely.patch


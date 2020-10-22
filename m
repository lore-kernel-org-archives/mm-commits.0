Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B56C388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 049B724655
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408219;
	bh=f4Tw23M64P/FfuoDW81lwW0pA+8/Dw8apth/KP6D11U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IJan34Zo/A+2FzpHQjqioMrbwBjS+mqOc12lFGAgWKKzxXT2ptDtEkmCnU9DACeb6
	 yAxJr5JfIMY8EMn2wB3nOKfw04DgxKJ5rVPur4dztpwEiGjTvas4cnaoQh+GB4cFvX
	 jhdbQ6gn8EmREYE10K5NckoKqqgW4m2H/tdVwOIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373262AbgJVXKS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJVXKS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC05208B3;
        Thu, 22 Oct 2020 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408217;
        bh=f4Tw23M64P/FfuoDW81lwW0pA+8/Dw8apth/KP6D11U=;
        h=Date:From:To:Subject:From;
        b=MYCTRulgnXCR7My8ilXD2cs4qk/v2eHWTOeVBLWYxlgUo/9tSCvBRr7PwNki2HKgv
         7wHPml8Oul9rZCFtFNq81GKZOtQD9ultg066Y1sMV57nc07oQ2yWJtiW70np4NwF3k
         xdP4wy0ziqfYQY1+WSrYEiIX2huJnBzXRyT24mew=
Date:   Thu, 22 Oct 2020 16:10:16 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com, urezki@gmail.com,
        willy@infradead.org
Subject:  [merged]
 drm-i915-stop-using-kmap-in-i915_gem_object_map.patch removed from -mm tree
Message-ID: <20201022231016.T5b7xF7zy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: stop using kmap in i915_gem_object_map
has been removed from the -mm tree.  Its filename was
     drm-i915-stop-using-kmap-in-i915_gem_object_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: drm/i915: stop using kmap in i915_gem_object_map

kmap for !PageHighmem is just a convoluted way to say page_address, and
kunmap is a no-op in that case.

Link: https://lkml.kernel.org/r/20201002122204.1534411-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_pages.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c~drm-i915-stop-using-kmap-in-i915_gem_object_map
+++ a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -162,8 +162,6 @@ static void unmap_object(struct drm_i915
 {
 	if (is_vmalloc_addr(ptr))
 		vunmap(ptr);
-	else
-		kunmap(kmap_to_page(ptr));
 }
 
 struct sg_table *
@@ -277,11 +275,10 @@ static void *i915_gem_object_map(struct
 		 * forever.
 		 *
 		 * So if the page is beyond the 32b boundary, make an explicit
-		 * vmap. On 64b, this check will be optimised away as we can
-		 * directly kmap any page on the system.
+		 * vmap.
 		 */
 		if (!PageHighMem(page))
-			return kmap(page);
+			return page_address(page);
 	}
 
 	mem = stack;
_

Patches currently in -mm which might be from hch@lst.de are



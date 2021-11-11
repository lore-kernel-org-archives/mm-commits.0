Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6383AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D8BF61208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhKKCq1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCq1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 802D560F46;
        Thu, 11 Nov 2021 02:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598618;
        bh=VRi2dPhu09ri+SkZJ86apSoQyfvf0+OhalprSVL5KuM=;
        h=Date:From:To:Subject:From;
        b=lm231us3qGtPjPlmYWtXmRKeqOcp/tHLnGQGlELGY0FA62KlquhLV9h2OXSn5mAKz
         hTcdYCNXbMRt6SP5RM4x8tCVisbBjHYRRub/ePyz39JJcoCF7KP87RpzDWdxbEoDci
         BIVls71Ad2RiUVymI3O9tVEAdRIJjsLgBSZuUKu4=
Date:   Wed, 10 Nov 2021 18:43:38 -0800
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, hch@infradead.org, idryomov@gmail.com,
        jlayton@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        neilb@suse.de, urezki@gmail.com
Subject:  [merged]
 mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch removed from
 -mm tree
Message-ID: <20211111024338.BZsbX0Sv7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: be more explicit about supported gfp flags
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/vmalloc: be more explicit about supported gfp flags

The core of the vmalloc allocator __vmalloc_area_node doesn't say anything
about gfp mask argument.  Not all gfp flags are supported though.  Be more
explicit about constraints.

Link: https://lkml.kernel.org/r/20211020082545.4830-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-be-more-explicit-about-supported-gfp-flags
+++ a/mm/vmalloc.c
@@ -2983,8 +2983,16 @@ fail:
  * @caller:		  caller's return address
  *
  * Allocate enough pages to cover @size from the page level
- * allocator with @gfp_mask flags.  Map them into contiguous
- * kernel virtual space, using a pagetable protection of @prot.
+ * allocator with @gfp_mask flags. Please note that the full set of gfp
+ * flags are not supported. GFP_KERNEL would be a preferred allocation mode
+ * but GFP_NOFS and GFP_NOIO are supported as well. Zone modifiers are not
+ * supported. From the reclaim modifiers__GFP_DIRECT_RECLAIM is required (aka
+ * GFP_NOWAIT is not supported) and only __GFP_NOFAIL is supported (aka
+ * __GFP_NORETRY and __GFP_RETRY_MAYFAIL are not supported).
+ * __GFP_NOWARN can be used to suppress error messages about failures.
+ *
+ * Map them into contiguous kernel virtual space, using a pagetable
+ * protection of @prot.
  *
  * Return: the address of the area or %NULL on failure
  */
_

Patches currently in -mm which might be from mhocko@suse.com are



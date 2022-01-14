Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1065EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiANWHH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48396 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWHG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E28FB61FF0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D9BC36AE9;
        Fri, 14 Jan 2022 22:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198025;
        bh=GgRLpPLhwdQFwmc0O1ArEwBnFOWwxwYDCaQv3EWkZcU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hxdbYPT7iJBTOOK2cELTdailGh0VL3dArnngKlH3SSVKJBdJLDEMNyD9C6THXyvhb
         bptklND5kBmucDKdxHkl5XBfYnNtC4uBmkjts/b57nA3+CZBluJcEiuWMTHHi+vSLq
         HOs14b6buWR6BJqDY20KWgAdqi8VepW3SlW52FOE=
Date:   Fri, 14 Jan 2022 14:07:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        david@fromorbit.com, hch@lst.de, idryomov@gmail.com,
        jlayton@kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org, urezki@gmail.com, vbabka@suse.cz
Subject:  [patch 075/146] mm/vmalloc: be more explicit about
 supported gfp flags.
Message-ID: <20220114220704.yBdrgAyd4%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm/vmalloc: be more explicit about supported gfp flags.

b7d90e7a5ea8 ("mm/vmalloc: be more explicit about supported gfp flags")
has been merged prematurely without the rest of the series and without
addressed review feedback from Neil.  Fix that up now.  Only wording is
changed slightly.

Link: https://lkml.kernel.org/r/20211122153233.9924-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-be-more-explicit-about-supported-gfp-flags
+++ a/mm/vmalloc.c
@@ -3031,12 +3031,14 @@ fail:
  *
  * Allocate enough pages to cover @size from the page level
  * allocator with @gfp_mask flags. Please note that the full set of gfp
- * flags are not supported. GFP_KERNEL would be a preferred allocation mode
- * but GFP_NOFS and GFP_NOIO are supported as well. Zone modifiers are not
- * supported. From the reclaim modifiers__GFP_DIRECT_RECLAIM is required (aka
- * GFP_NOWAIT is not supported) and only __GFP_NOFAIL is supported (aka
- * __GFP_NORETRY and __GFP_RETRY_MAYFAIL are not supported).
- * __GFP_NOWARN can be used to suppress error messages about failures.
+ * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
+ * supported.
+ * Zone modifiers are not supported. From the reclaim modifiers
+ * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
+ * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
+ * __GFP_RETRY_MAYFAIL are not supported).
+ *
+ * __GFP_NOWARN can be used to suppress failures messages.
  *
  * Map them into contiguous kernel virtual space, using a pagetable
  * protection of @prot.
_

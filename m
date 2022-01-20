Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E39C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377762AbiATV0I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377751AbiATV0I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE46C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD95960A3C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48B6C340E0;
        Thu, 20 Jan 2022 21:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713967;
        bh=uyel9a8E0R1/zX5ok2hTZoA1s19ITvZsQhce5RPBoPE=;
        h=Date:From:To:Subject:From;
        b=bZlLkaZxx4vSkkltFwlMp3KsxzO3oRzEJ2I4bBuebpMPvZVyQSjklkw2swa/PpktV
         h2n5ivgIKwbjxqUYAY0BThIE+81/EgFCPEhFFysPYWIDfIS4HAfF4Pe982fBj2HyEe
         l35Dm+IWIbyYDwwgnlTKF/GSFC/sDS+iHId3XZt0=
Date:   Thu, 20 Jan 2022 13:26:06 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, david@fromorbit.com, hch@lst.de,
        idryomov@gmail.com, jlayton@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, urezki@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch removed from
 -mm tree
Message-ID: <20220120212606.T0CGJWIsy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: be more explicit about supported gfp flags.
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC4EC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 221B86135F
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJTWi3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 18:38:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA966128E;
        Wed, 20 Oct 2021 22:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634769374;
        bh=anDZJhi4wc9/YVrZnU6DT860l2+bLZNYIXygOUKdU/k=;
        h=Date:From:To:Subject:From;
        b=TDoO60e0XzUiNVOgg9+BdWYed+QuzOeyq0whRuE2kkR22saUux7gM5iHKZEYEYmev
         hE2i2MO7BCEGwdBEdQ2pBkti8yDka+xZuKsWLSCznnzpUX7Ig5klJoF+dFAXG2KY8e
         napOLedSSMTn4oDQX5mf6vNIaMUH0obJxt++BLeA=
Date:   Wed, 20 Oct 2021 15:36:13 -0700
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, hch@infradead.org, idryomov@gmail.com,
        jlayton@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        neilb@suse.de, urezki@gmail.com
Subject:  +
 mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch added to -mm
 tree
Message-ID: <20211020223613.z_R-mXCPH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: be more explicit about supported gfp flags
has been added to the -mm tree.  Its filename is
     mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2990,8 +2990,16 @@ fail:
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

mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811B8C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DFC3611C4
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhKEUmb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUmb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E4160FBF;
        Fri,  5 Nov 2021 20:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144791;
        bh=WmM1WsBKgSp+vPWqSgfjQsKHetcmcNdBnXHNO7d2bGU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=F1X0ZxPoYq5FHupcSojJeRikvj6lXLZk+TLCJyHlHPfGyAcDAD1MPZW6ltn2YIrGB
         24fdE7kp84jMfDi8GF4KnuU0tBWWEiUmNuVMKqQ29RiGPem5VpgDxUlL8WXxTlm87y
         KdsU5TAE9Hicdd6FC85OlFAAdpK6I94q2Od9Q+A8=
Date:   Fri, 05 Nov 2021 13:39:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, hch@infradead.org,
        idryomov@gmail.com, jlayton@kernel.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 099/262] mm/vmalloc: be more explicit about
 supported gfp flags
Message-ID: <20211105203950.AJ1Cnteeh%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

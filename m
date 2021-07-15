Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB1DC07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 563F961377
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhGOE3q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE3p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B22D6128C;
        Thu, 15 Jul 2021 04:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323213;
        bh=Kw/vHUgu+Ux2WajcBOafYguj9RJ6plED8o+Ox6Om/tc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WRo18r8vWkZ6IGvwQFNNknzZCJlBXxe0QKCspd6v8rntiyCXGiy9hwSKaqWDJtxI6
         NRMLRDs++dNJtNQbDxlBY118JShRZNPkmPfbLAAHms3k/9TgHnUfrF2DfmKAH6O0UN
         4YqSVnqZheplnuyL54UgEdg4DMfm7JrNR4wWZl2w=
Date:   Wed, 14 Jul 2021 21:26:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brouer@redhat.com,
        chuck.lever@oracle.com, desmondcheongzx@gmail.com,
        linux-mm@kvack.org, mcroce@microsoft.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        Qiang.Zhang@windriver.com, torvalds@linux-foundation.org,
        yanfei.xu@windriver.com
Subject:  [patch 07/13] mm/page_alloc: further fix
 __alloc_pages_bulk() return value
Message-ID: <20210715042652.3466F866K%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>
Subject: mm/page_alloc: further fix __alloc_pages_bulk() return value

The author of commit b3b64ebd3822 ("mm/page_alloc: do bulk array
bounds check after checking populated elements") was possibly
confused by the mixture of return values throughout the function.

The API contract is clear that the function "Returns the number of pages
on the list or array." It does not list zero as a unique return value with
a special meaning.  Therefore zero is a plausible return value only if
@nr_pages is zero or less.

Clean up the return logic to make it clear that the returned value is
always the total number of pages in the array/list, not the number of
pages that were allocated during this call.

The only change in behavior with this patch is the value returned if
prepare_alloc_pages() fails.  To match the API contract, the number of
pages currently in the array/list is returned in this case.

The call site in __page_pool_alloc_pages_slow() also seems to be confused
on this matter.  It should be attended to by someone who is familiar with
that code.

[mel@techsingularity.net: Return nr_populated if 0 pages are requested]
Link: https://lkml.kernel.org/r/20210713152100.10381-4-mgorman@techsingularity.net
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc: Zhang Qiang <Qiang.Zhang@windriver.com>
Cc: Yanfei Xu <yanfei.xu@windriver.com>
Cc: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-further-fix-__alloc_pages_bulk-return-value
+++ a/mm/page_alloc.c
@@ -5221,9 +5221,6 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
-	if (unlikely(nr_pages <= 0))
-		return 0;
-
 	/*
 	 * Skip populated array elements to determine if any pages need
 	 * to be allocated before disabling IRQs.
@@ -5231,9 +5228,13 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	while (page_array && nr_populated < nr_pages && page_array[nr_populated])
 		nr_populated++;
 
+	/* No pages requested? */
+	if (unlikely(nr_pages <= 0))
+		goto out;
+
 	/* Already populated array? */
 	if (unlikely(page_array && nr_pages - nr_populated == 0))
-		return nr_populated;
+		goto out;
 
 	/* Use the single page allocator for one page. */
 	if (nr_pages - nr_populated == 1)
@@ -5255,7 +5256,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	gfp &= gfp_allowed_mask;
 	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
-		return nr_populated;
+		goto out;
 	gfp = alloc_gfp;
 
 	/* Find an allowed local zone that meets the low watermark. */
@@ -5323,6 +5324,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
 
+out:
 	return nr_populated;
 
 failed_irq:
@@ -5338,7 +5340,7 @@ failed:
 		nr_populated++;
 	}
 
-	return nr_populated;
+	goto out;
 }
 EXPORT_SYMBOL_GPL(__alloc_pages_bulk);
 
_

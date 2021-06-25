Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E78C49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BCD613BA
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhFYBmZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233028AbhFYBmZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:42:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A341613B9;
        Fri, 25 Jun 2021 01:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585205;
        bh=fc57rGUi4X2nQ1DLWGi2dQ1r5fKN1CBZVzhE+leYQwQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NVByqePAEyb8OnyNgG2jq0xVIkXqEpx64AmSFJP1dnQ0alFZZvwoPB/BYFGgYcLG9
         n0EhY6WP4uI0Xlr7vzgyW6++RfbDQ/qRYkqhf594HPVHV1WzCmw1aDWAQ0wW0OF+5o
         78lgmAdh2DMSQEYmjyYh7P9SQ1dR8h+RK1oDtkIs=
Date:   Thu, 24 Jun 2021 18:40:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 21/24] mm/page_alloc: __alloc_pages_bulk(): do
 bounds check before accessing array
Message-ID: <20210625014004.eP5GNGyvo%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/page_alloc: __alloc_pages_bulk(): do bounds check before accessing array

In the event that somebody would call this with an already fully populated
page_array, the last loop iteration would do an access beyond the end of
page_array.

It's of course extremely unlikely that would ever be done, but this
triggers my internal static analyzer.  Also, if it really is not supposed
to be invoked this way (i.e., with no NULL entries in page_array), the
nr_populated<nr_pages check could simply be removed instead.

Link: https://lkml.kernel.org/r/20210507064504.1712559-1-linux@rasmusvillemoes.dk
Fixes: 0f87d9d30f21 ("mm/page_alloc: add an array-based interface to the bulk page allocator")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-__alloc_pages_bulk-do-bounds-check-before-accessing-array
+++ a/mm/page_alloc.c
@@ -5053,7 +5053,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	 * Skip populated array elements to determine if any pages need
 	 * to be allocated before disabling IRQs.
 	 */
-	while (page_array && page_array[nr_populated] && nr_populated < nr_pages)
+	while (page_array && nr_populated < nr_pages && page_array[nr_populated])
 		nr_populated++;
 
 	/* Use the single page allocator for one page. */
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32258C49EBB
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BD2F61C43
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhF0V4p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C91D61C35;
        Sun, 27 Jun 2021 21:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830859;
        bh=6jV8Sl3/M8GQuZUmtSkRlutd7YtTEGM8AkyJvjW8hNI=;
        h=Date:From:To:Subject:From;
        b=aMVNbQJ2X8Ju+lkxoJ5d+6pJ7SQEDSTfMBq4reR6yo4lLR+AKUR6elhv7zTR/jsHA
         wO2vY1s3WqT86pYpJYCuD04AXnmMf8EtsCdfi/o0thu9Axiscr9kUd/ZJx6hcAqdgI
         C1247XcuSN09LFYk9h4Y0f6YVNdsAGKJPXlUz8Pc=
Date:   Sun, 27 Jun 2021 14:54:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linux@rasmusvillemoes.dk,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Falloc-=5F=5Falloc=5Fpages=5Fbulk-do-bounds-check-?=
 =?US-ASCII?Q?before-accessing-array.patch?= removed from -mm tree
Message-ID: <20210627215419.p9lAHHB2c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: __alloc_pages_bulk(): do bounds check before accessing array
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-__alloc_pages_bulk-do-bounds-check-before-accessing-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are



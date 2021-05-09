Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3430C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EFAF6141D
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEIA0I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEIA0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:26:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A958760E0B;
        Sun,  9 May 2021 00:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620519905;
        bh=g6p/hrkv98NdvktB0vFw7++N7yEG0bS0dYGKTTYXmqM=;
        h=Date:From:To:Subject:From;
        b=W37l0Gtf1oEMfcll518e9GUEMn76S4MXEXJA6aibOw4plwhyyfy3km0Lp19X/Iu8p
         ZhxlnxFl5a0c5OSKpKlMHkfQiArTbdgvx8+lXikTY8UVfQ8/szTaOJcUhOBCFH8q31
         pLxnKVDsfHErMctm8pb95Va6QH59Am2LMcZJwrdE=
Date:   Sat, 08 May 2021 17:25:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-=5F=5Falloc=5Fpages=5Fbulk-do-bounds-check-?=
 =?US-ASCII?Q?before-accessing-array.patch?= added to -mm tree
Message-ID: <20210509002505.7_Ew470A1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: __alloc_pages_bulk(): do bounds check before accessing array
has been added to the -mm tree.  Its filename is
     mm-page_alloc-__alloc_pages_bulk-do-bounds-check-before-accessing-array.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-__alloc_pages_bulk-do-bounds-check-before-accessing-array.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-__alloc_pages_bulk-do-bounds-check-before-accessing-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Fixes: 0f87d9d30f21 (mm/page_alloc: add an array-based interface to the bulk page allocator)
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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

mm-page_alloc-__alloc_pages_bulk-do-bounds-check-before-accessing-array.patch


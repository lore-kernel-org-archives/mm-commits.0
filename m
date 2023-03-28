Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F83C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjC1XVM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjC1XVJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B292707
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56919B81F59
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E71C433EF;
        Tue, 28 Mar 2023 23:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045664;
        bh=EtkFK7L/aMni/BD2riFuqr94SpIfvxHoG8qvDCjYjQM=;
        h=Date:To:From:Subject:From;
        b=PaNOvnA0LPChrY4fSZSNi2iaF20YItspecvs8WjFInVL1rrUUEI/xzaQQQxKjVQJt
         1Dvn1dLo7q85aXgO0ohkQh9kvdd5DeINfDcDuyjE2nnIBqeVf/5OlenYRtVWRX8q2R
         BSJkQplOaQT+LwuijfChxYKtbkJVEERwfEv+8vyk=
Date:   Tue, 28 Mar 2023 16:21:03 -0700
To:     mm-commits@vger.kernel.org, yjay.kim@lge.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, minchan@kernel.org, ddstreet@ieee.org,
        taejoon.song@lge.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages.patch removed from -mm tree
Message-Id: <20230328232104.08E71C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/zswap: try to avoid worst-case scenario on same element pages
has been removed from the -mm tree.  Its filename was
     mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Taejoon Song <taejoon.song@lge.com>
Subject: mm/zswap: try to avoid worst-case scenario on same element pages
Date: Mon, 6 Feb 2023 04:00:36 +0900

The worst-case scenario on finding same element pages is that almost all
elements are same at the first glance but only last few elements are
different.

Since the same element tends to be grouped from the beginning of the
pages, if we check the first element with the last element before looping
through all elements, we might have some chances to quickly detect
non-same element pages.

1. Test is done under LG webOS TV (64-bit arch)
2. Dump the swap-out pages (~819200 pages)
3. Analyze the pages with simple test script which counts the iteration
   number and measures the speed at off-line

Under 64-bit arch, the worst iteration count is PAGE_SIZE / 8 bytes = 512.
The speed is based on the time to consume page_same_filled() function
only.  The result, on average, is listed as below:

                                   Num of Iter    Speed(MB/s)
Looping-Forward (Orig)                 38            99265
Looping-Backward                       36           102725
Last-element-check (This Patch)        33           125072

The result shows that the average iteration count decreases by 13% and the
speed increases by 25% with this patch.  This patch does not increase the
overall time complexity, though.

I also ran simpler version which uses backward loop.  Just looping
backward also makes some improvement, but less than this patch.

A similar change has already been made to zram in 90f82cbfe502 ("zram: try
to avoid worst-case scenario on same element pages").

Link: https://lkml.kernel.org/r/20230205190036.1730134-1-taejoon.song@lge.com
Signed-off-by: Taejoon Song <taejoon.song@lge.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Taejoon Song <taejoon.song@lge.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <yjay.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/zswap.c~mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages
+++ a/mm/zswap.c
@@ -1073,15 +1073,23 @@ fail:
 
 static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
 {
-	unsigned int pos;
 	unsigned long *page;
+	unsigned long val;
+	unsigned int pos, last_pos = PAGE_SIZE / sizeof(*page) - 1;
 
 	page = (unsigned long *)ptr;
-	for (pos = 1; pos < PAGE_SIZE / sizeof(*page); pos++) {
-		if (page[pos] != page[0])
+	val = page[0];
+
+	if (val != page[last_pos])
+		return 0;
+
+	for (pos = 1; pos < last_pos; pos++) {
+		if (val != page[pos])
 			return 0;
 	}
-	*value = page[0];
+
+	*value = val;
+
 	return 1;
 }
 
_

Patches currently in -mm which might be from taejoon.song@lge.com are



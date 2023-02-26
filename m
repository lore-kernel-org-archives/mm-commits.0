Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1EAC7EE2D
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 21:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBZV5n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 16:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBZV5m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 16:57:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D788C166F3
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 13:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66FE260B5B
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 21:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1CAC4339B;
        Sun, 26 Feb 2023 21:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677448659;
        bh=sCyLp09F7pbqoszlaukO+j2Qwxczk0y4o12iRc69J1c=;
        h=Date:To:From:Subject:From;
        b=y6OatVwWmtF5QJuW88mn0Kx/ung6s3oNE33LwJhJYy9cj4SLHlPti9pRlJ9Vn1Lyy
         V0RZM9KW/8qEsfyHqAEmoYg+peBThJvsoIPCQ8CqcNSEnWT77z0uzRqfxz+vwCLzDs
         G8HhEtcxMXPYWfktVVCOnvRx1bGQjnZV7sQJPb0g=
Date:   Sun, 26 Feb 2023 13:57:39 -0800
To:     mm-commits@vger.kernel.org, yjay.kim@lge.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, minchan@kernel.org, ddstreet@ieee.org,
        taejoon.song@lge.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages.patch added to mm-unstable branch
Message-Id: <20230226215739.BD1CAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: try to avoid worst-case scenario on same element pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Taejoon Song <taejoon.song@lge.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <yjay.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff --git a/mm/zswap.c~mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages b/mm/zswap.c
--- a/mm/zswap.c~mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages
+++ b/mm/zswap.c
@@ -1073,15 +1073,23 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 
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

mm-zswap-try-to-avoid-worst-case-scenario-on-same-element-pages.patch


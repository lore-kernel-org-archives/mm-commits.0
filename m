Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F09C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356689AbhK1AiX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:38:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42886 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356650AbhK1AgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:36:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FDB560F55
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6001C53FBF;
        Sun, 28 Nov 2021 00:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638059586;
        bh=ohmAR0Tqn4wI4p5Wm/B3sfoLuVcrpVsQIUUQhhk0R14=;
        h=Date:From:To:Subject:From;
        b=slp6MJYyCMSp1d3V/Dfpb7xcJSWE7+jHcwjkEUo+9WEtb8i+M/3zWkRy0Izr36a4m
         pxGj23MFZcM4s4LZ3K0Dxpx8lNF3tGT/n9P0rXPoSY5NaD/U1wt0LfLXIiqahqhMO0
         ZeD9OfMkNDNNJhSZn9K8K71lR79/ZbPGRKwU3rcU=
Date:   Sat, 27 Nov 2021 16:33:06 -0800
From:   akpm@linux-foundation.org
To:     arthur.marsh@internode.on.net, mm-commits@vger.kernel.org,
        sxwjean@gmail.com
Subject:  +
 mm-page_alloc-fix-building-error-on-werror=array-compare.patch added to -mm
 tree
Message-ID: <20211128003306.fYDKGQLtj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix building error on -Werror=array-compare
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-building-error-on-werror=array-compare.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-building-error-on-werror%3Darray-compare.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-building-error-on-werror%3Darray-compare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiongwei Song <sxwjean@gmail.com>
Subject: mm: page_alloc: fix building error on -Werror=array-compare

Arthur Marsh reported we would hit the error below when building kernel
with gcc-12:
CC      mm/page_alloc.o
mm/page_alloc.c: In function `mem_init_print_info':
mm/page_alloc.c:8173:27: error: comparison between two arrays [-Werror=array-compare]
 8173 |                 if (start <= pos && pos < end && size > adj) \
      |

In C++20, the comparision between arrays should be warned.

Link: https://lkml.kernel.org/r/20211125130928.32465-1-sxwjean@me.com
Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-building-error-on-werror=array-compare
+++ a/mm/page_alloc.c
@@ -8220,7 +8220,7 @@ void __init mem_init_print_info(void)
 	 */
 #define adj_init_size(start, end, size, pos, adj) \
 	do { \
-		if (start <= pos && pos < end && size > adj) \
+		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
 			size -= adj; \
 	} while (0)
 
_

Patches currently in -mm which might be from sxwjean@gmail.com are

mm-page_alloc-fix-building-error-on-werror=array-compare.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CBFC4361A
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B3C2053B
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbgLCV5M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729579AbgLCV5L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 16:57:11 -0500
Date:   Thu, 03 Dec 2020 13:55:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607032550;
        bh=EY9m23Iha2H1ziQdH9UaHUohllcPzu2zIe1G0dXfUD8=;
        h=From:To:Subject:From;
        b=LTunJJTvxU3GA/LZBUJQzNvHo1T51bTi+MMy6l66V9+DseeQLFNIkYvwnkh8XlGEG
         nPniVj44G8jKTHG+WjNqyLCGGmsF/aIWFdP+ZpuwC1Wm/+L3yh7CmWvIBywmwR2G1h
         FiCD3Su/y1jOCgAbALCu2EIghQyqVxsK9EQmxaaY=
From:   akpm@linux-foundation.org
To:     liu.hailong6@zte.com.cn, mm-commits@vger.kernel.org,
        rppt@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-memblock-use-a-more-appropriate-order-calculation-when-f?=
 =?US-ASCII?Q?ree-memblock-pages.patch?= added to -mm tree
Message-ID: <20201203215549.M_m76UXUS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: use a more appropriate order calculation when free memblock pages
has been added to the -mm tree.  Its filename is
     mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hailong Liu <liu.hailong6@zte.com.cn>
Subject: mm/memblock: use a more appropriate order calculation when free memblock pages

When system in the booting stage, pages span from [start, end] of a
memblock are freed to buddy in a order as large as possible (less than
MAX_ORDER) at first, then decrease gradually to a proper order(less than
end) in a loop.

However, *min(MAX_ORDER - 1UL, __ffs(start))* can not get the largest
order in some cases.  Instead, *__ffs(end - start)* may be more
appropriate and meaningful.

Link: https://lkml.kernel.org/r/20201203152311.5272-1-carver4lio@163.com
Signed-off-by: Hailong Liu <liu.hailong6@zte.com.cn>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages
+++ a/mm/memblock.c
@@ -2010,7 +2010,7 @@ static void __init __free_pages_memory(u
 	int order;
 
 	while (start < end) {
-		order = min(MAX_ORDER - 1UL, __ffs(start));
+		order = min(MAX_ORDER - 1UL, __ffs(end - start));
 
 		while (start + (1UL << order) > end)
 			order--;
_

Patches currently in -mm which might be from liu.hailong6@zte.com.cn are

mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages.patch


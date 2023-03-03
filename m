Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08991C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 23:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjCCXcB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 18:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCCXcA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 18:32:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406DBCA10
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 15:31:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E45A6B819A2
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 23:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F45C433D2;
        Fri,  3 Mar 2023 23:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677886316;
        bh=7roK2oBVHaskhD0O4ky5IPwNKVnTrXFiI5s0ad0BUqc=;
        h=Date:To:From:Subject:From;
        b=GtzpdOcRTb/rD6EB9VSt9+8++eSQJ5iVyCrDB1dpEOYSisJn8hLK3C3chsQ8Axh3T
         LnDaVHYfDhQVy1RNrbpgjgI66koRr5tigieFzMu/hYtJVaVKzSZMLsb7rArLJmvTGf
         d4LPIUAQo0quOfmIWE6oEeOHvuQ8I6y0Emp0n/SM=
Date:   Fri, 03 Mar 2023 15:31:55 -0800
To:     mm-commits@vger.kernel.org, tjmercier@google.com,
        sumit.semwal@linaro.org, mhocko@kernel.org, jstultz@google.com,
        hannes@cmpxchg.org, daniel.vetter@ffwll.ch,
        jaewon31.kim@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-buf-system_heap-avoid-reclaim-for-order-4.patch added to mm-unstable branch
Message-Id: <20230303233156.84F45C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-buf: system_heap: avoid reclaim for order 4
has been added to the -mm mm-unstable branch.  Its filename is
     dma-buf-system_heap-avoid-reclaim-for-order-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-buf-system_heap-avoid-reclaim-for-order-4.patch

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
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: dma-buf: system_heap: avoid reclaim for order 4
Date: Fri, 3 Mar 2023 14:03:32 +0900

Using order 4 pages would be helpful for IOMMUs mapping, but trying to get
order 4 pages could spend quite much time in the page allocation.  From
the perspective of responsiveness, the deterministic memory allocation
speed, I think, is quite important.

The order 4 allocation with __GFP_RECLAIM may spend much time in reclaim
and compation logic.  __GFP_NORETRY also may affect.  These cause
unpredictable delay.

To get reasonable allocation speed from dma-buf system heap, use
HIGH_ORDER_GFP for order 4 to avoid reclaim.  And let me remove
meaningless __GFP_COMP for order 0.

According to my tests, order 4 with MID_ORDER_GFP could get more number
of order 4 pages but the elapsed times could be very slow.

         time	order 8	order 4	order 0
     584 usec	0	160	0
  28,428 usec	0	160	0
 100,701 usec	0	160	0
  76,645 usec	0	160	0
  25,522 usec	0	160	0
  38,798 usec	0	160	0
  89,012 usec	0	160	0
  23,015 usec	0	160	0
  73,360 usec	0	160	0
  76,953 usec	0	160	0
  31,492 usec	0	160	0
  75,889 usec	0	160	0
  84,551 usec	0	160	0
  84,352 usec	0	160	0
  57,103 usec	0	160	0
  93,452 usec	0	160	0

If HIGH_ORDER_GFP is used for order 4, the number of order 4 could be
decreased but the elapsed time results were quite stable and fast enough.

         time	order 8	order 4	order 0
   1,356 usec	0	155	80
   1,901 usec	0	11	2384
   1,912 usec	0	0	2560
   1,911 usec	0	0	2560
   1,884 usec	0	0	2560
   1,577 usec	0	0	2560
   1,366 usec	0	0	2560
   1,711 usec	0	0	2560
   1,635 usec	0	28	2112
     544 usec	10	0	0
     633 usec	2	128	0
     848 usec	0	160	0
     729 usec	0	160	0
   1,000 usec	0	160	0
   1,358 usec	0	160	0
   2,638 usec	0	31	2064

Link: https://lkml.kernel.org/r/20230303050332.10138-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reviewed-by: John Stultz <jstultz@google.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/dma-buf/heaps/system_heap.c~dma-buf-system_heap-avoid-reclaim-for-order-4
+++ a/drivers/dma-buf/heaps/system_heap.c
@@ -41,12 +41,11 @@ struct dma_heap_attachment {
 	bool mapped;
 };
 
-#define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO | __GFP_COMP)
-#define MID_ORDER_GFP (LOW_ORDER_GFP | __GFP_NOWARN)
+#define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO)
 #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
 				| __GFP_NORETRY) & ~__GFP_RECLAIM) \
 				| __GFP_COMP)
-static gfp_t order_flags[] = {HIGH_ORDER_GFP, MID_ORDER_GFP, LOW_ORDER_GFP};
+static gfp_t order_flags[] = {HIGH_ORDER_GFP, HIGH_ORDER_GFP, LOW_ORDER_GFP};
 /*
  * The selection of the orders used for allocation (1MB, 64K, 4K) is designed
  * to match with the sizes often found in IOMMUs. Using order 4 pages instead
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

dma-buf-system_heap-avoid-reclaim-for-order-4.patch


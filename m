Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F919C77B6C
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjC1XWJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjC1XVm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1512E2D43
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B481AB81F5D
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C67BC433D2;
        Tue, 28 Mar 2023 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045695;
        bh=pOeyu5ObkzILdYyWUAN/rS4blpIm8iFu8XrTdOVwRZI=;
        h=Date:To:From:Subject:From;
        b=bbqSwnLB9s/CtBCl/cclarQwBpzsWb3lRUbxwYqzKmjr7wfL/knxFzv4IQ1tWqE9F
         oQoM/9f3t+CBYvwA5hH29bXxueCnTWK5TyS08oCx3612/KwN4jqQevoRmL5/isO5BY
         sh85ZDjBDzCkCEvNL/hPY/JHEMIcLLy48viIWr/A=
Date:   Tue, 28 Mar 2023 16:21:34 -0700
To:     mm-commits@vger.kernel.org, tjmercier@google.com,
        sumit.semwal@linaro.org, mhocko@kernel.org, jstultz@google.com,
        hannes@cmpxchg.org, daniel.vetter@ffwll.ch,
        jaewon31.kim@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dma-buf-system_heap-avoid-reclaim-for-order-4.patch removed from -mm tree
Message-Id: <20230328232135.6C67BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dma-buf: system_heap: avoid reclaim for order 4
has been removed from the -mm tree.  Its filename was
     dma-buf-system_heap-avoid-reclaim-for-order-4.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 drivers/dma-buf/heaps/system_heap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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



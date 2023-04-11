Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DC3C7619A
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 04:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDKEOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjDKEOo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 00:14:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B50510E
        for <mm-commits@vger.kernel.org>; Mon, 10 Apr 2023 21:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A0E61BA3
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 04:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0CCC433D2;
        Tue, 11 Apr 2023 04:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681186482;
        bh=JQ8VLq/LHnkQXpkRKY1A97aYs3js8hrbJhHJqJBNlDA=;
        h=Date:To:From:Subject:From;
        b=TCNJQWVg0pf06MKAggD+QkQ6tmKCnwHy+3n9jrNBKxRA5yYGQXHiVOTl3nRGnn+7R
         W8ff0hHtcJCHeUY6m+4ilszqwEGu2uRVMrTuj0ZSGV8SydEel65NjX8Ee6JSW4qtYU
         +OAPWiZY/QYHX45opIodBxw6RA2+kHnW3FtuQENk=
Date:   Mon, 10 Apr 2023 21:14:41 -0700
To:     mm-commits@vger.kernel.org, tjmercier@google.com,
        sumit.semwal@linaro.org, mhocko@kernel.org, jstultz@google.com,
        hannes@cmpxchg.org, daniel.vetter@ffwll.ch,
        jaewon31.kim@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-buf-heaps-system_heap-avoid-too-much-allocation.patch added to mm-unstable branch
Message-Id: <20230411041441.DC0CCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-buf/heaps: system_heap: avoid too much allocation
has been added to the -mm mm-unstable branch.  Its filename is
     dma-buf-heaps-system_heap-avoid-too-much-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-buf-heaps-system_heap-avoid-too-much-allocation.patch

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
Subject: dma-buf/heaps: system_heap: avoid too much allocation
Date: Mon, 10 Apr 2023 16:32:28 +0900

Normal free:212600kB min:7664kB low:57100kB high:106536kB
  reserved_highatomic:4096KB active_anon:276kB inactive_anon:180kB
  active_file:1200kB inactive_file:0kB unevictable:2932kB
  writepending:0kB present:4109312kB managed:3689488kB mlocked:2932kB
  pagetables:13600kB bounce:0kB free_pcp:0kB local_pcp:0kB
  free_cma:200844kB
Out of memory and no killable processes...
Kernel panic - not syncing: System is deadlocked on memory

An OoM panic was reported.  The log shows there were only native processes
which are non-killable as OOM_SCORE_ADJ_MIN.  After looking into the dump,
I've found the dma-buf system heap was trying to allocate a huge size.  It
seems to be a signed negative value.

dma_heap_ioctl_allocate(inline)
    |  heap_allocation = 0xFFFFFFC02247BD38 -> (
    |    len = 0xFFFFFFFFE7225100,

To avoid this invalid request, check if the requested size is bigger than
system total memory.  Actually the old ion system heap had similar policy
with commit c9e8440eca61 ("staging: ion: Fix overflow and list bugs in
system heap").

Even with this sanity check, there is still risk of too much allocations
from the system_heap.  Allocating multiple big size buffers may cause oom.
Add __GFP_RETRY_MAYFAIL.  With this gfp, the allocation may fail, but we
can avoid oom panic.

Link: https://lkml.kernel.org/r/20230410073228.23043-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: John Stultz <jstultz@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/heaps/system_heap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/heaps/system_heap.c~dma-buf-heaps-system_heap-avoid-too-much-allocation
+++ a/drivers/dma-buf/heaps/system_heap.c
@@ -41,7 +41,7 @@ struct dma_heap_attachment {
 	bool mapped;
 };
 
-#define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO)
+#define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO | __GFP_RETRY_MAYFAIL)
 #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
 				| __GFP_NORETRY) & ~__GFP_RECLAIM) \
 				| __GFP_COMP)
@@ -350,6 +350,9 @@ static struct dma_buf *system_heap_alloc
 	struct page *page, *tmp_page;
 	int i, ret = -ENOMEM;
 
+	if (len / PAGE_SIZE > totalram_pages())
+		return ERR_PTR(-ENOMEM);
+
 	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
 	if (!buffer)
 		return ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

dma-buf-heaps-system_heap-avoid-too-much-allocation.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D64C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE19F610E8
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhIOXqF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhIOXqF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 19:46:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A950460F8F;
        Wed, 15 Sep 2021 23:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631749485;
        bh=ceawZX0DgIQjWpZ7fk+e7HsUKfP0k6KDTM/8dADdbWM=;
        h=Date:From:To:Subject:From;
        b=Uz7bSAT6RGYENLI9cGjVULH/1uSOqwYE5VfHT9QLHdCj/3JVwYGMU35bHtK3WuG8w
         ZMUTIcrhJIL2xrId0TFIyWzY7v9LhIIjcpmjDtrSAnKW8UypQORlrmmXVnHSHvq4JQ
         5uJE1o/1vY1EBFogNJCaQhn8Y43jl0sOWBlBqbCg=
Date:   Wed, 15 Sep 2021 16:44:45 -0700
From:   akpm@linux-foundation.org
To:     jaewon31.kim@samsung.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ytk.lee@samsung.com
Subject:  + zram_drv-allow-reclaim-on-bio_alloc.patch added to -mm
 tree
Message-ID: <20210915234445.1d-QIxlXb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram_drv: allow reclaim on bio_alloc
has been added to the -mm tree.  Its filename is
     zram_drv-allow-reclaim-on-bio_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram_drv-allow-reclaim-on-bio_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram_drv-allow-reclaim-on-bio_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: zram_drv: allow reclaim on bio_alloc

The read_from_bdev_async is not called on atomic context.  So GFP_NOIO is
available rather than GFP_ATOMIC.  If there were reclaimable pages with
GFP_NOIO, we can avoid allocation failure and page fault failure.

Link: https://lkml.kernel.org/r/20210908005241.28062-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram_drv-allow-reclaim-on-bio_alloc
+++ a/drivers/block/zram/zram_drv.c
@@ -587,7 +587,7 @@ static int read_from_bdev_async(struct z
 {
 	struct bio *bio;
 
-	bio = bio_alloc(GFP_ATOMIC, 1);
+	bio = bio_alloc(GFP_NOIO, 1);
 	if (!bio)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

zram_drv-allow-reclaim-on-bio_alloc.patch


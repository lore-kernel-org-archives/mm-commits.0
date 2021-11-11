Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD691C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985D461361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhKKCuq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhKKCuq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9401A61872;
        Thu, 11 Nov 2021 02:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598877;
        bh=eUo5qMyl+W6rUsMOlHKqxD335iP4ZzcoLAbidB/oDcI=;
        h=Date:From:To:Subject:From;
        b=BLy6lrCsmpEyDGpZckCkSPEZmiKXiS9S/4yklL0qzahAlCV8AGZTgMTzzV0Bc5x3F
         MVLOhYuFARu7+hu4F3V0oE1iOmfE+5p8Hta6y2Ctx4PnSzNDlREJLK7UAz2hgA7zKT
         aQAolwg5LqEj3ykqBxdY6PPEHdSMElxGpW1lOMeY=
Date:   Wed, 10 Nov 2021 18:47:57 -0800
From:   akpm@linux-foundation.org
To:     jaewon31.kim@samsung.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ytk.lee@samsung.com
Subject:  [merged] zram_drv-allow-reclaim-on-bio_alloc.patch
 removed from -mm tree
Message-ID: <20211111024757.bDt-BGPmr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram_drv: allow reclaim on bio_alloc
has been removed from the -mm tree.  Its filename was
     zram_drv-allow-reclaim-on-bio_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



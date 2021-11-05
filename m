Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098CAC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E91CD61357
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhKEUrv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhKEUru (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:47:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C8761362;
        Fri,  5 Nov 2021 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145110;
        bh=+cFhMeIkiQ0YyKzyFTisK6aWa7VYMwkftw6QfEjSUQ4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=InqgpbBfpBs8PKNuzjJGvGsQDI9/OiyfL3560mEyueLvQRR0BMwClekc1ACo/b8G/
         81RgOoA7cTwtzhJXpups9e5IQ6HBJ7bqnkexiYxFE7YaV95TFibZo36Dsf0a+0IJbU
         /NvMwVNJ0zR3XjOBFenVsMYdanSlzwe+F2n6RdwM=
Date:   Fri, 05 Nov 2021 13:45:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jaewon31.kim@samsung.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ytk.lee@samsung.com
Subject:  [patch 200/262] zram_drv: allow reclaim on bio_alloc
Message-ID: <20211105204509.9t6bFXpJT%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

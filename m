Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FE2EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 19:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbjFNTxZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 15:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbjFNTxX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 15:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ADFE4D
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 12:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5100D6443A
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 19:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D71C433C9;
        Wed, 14 Jun 2023 19:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686772399;
        bh=6TJ4Tssux5OcWMNOumH8bbqSB/F/PwS0NP5R5Uqj66c=;
        h=Date:To:From:Subject:From;
        b=ToTUy7m0WCxIau3UTggxnjYktBzSZx4nJkYlB2BXJyGfU1MY/ENmBHMtlEbpg+Zbx
         Ps3rEw2xWw+SvP8X6qU5kAVqQ0ICvaeC3Fy+MEhggvoVR+RK5cJrKsi1idk9FDOWx4
         P/ASu11SMQhxH58C8sMQglaiw8HmnHaoFw20Wh+0=
Date:   Wed, 14 Jun 2023 12:53:19 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org, bgeffon@google.com,
        axboe@kernel.dk, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-further-limit-recompression-threshold.patch added to mm-unstable branch
Message-Id: <20230614195319.A6D71C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: further limit recompression threshold
has been added to the -mm mm-unstable branch.  Its filename is
     zram-further-limit-recompression-threshold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-further-limit-recompression-threshold.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: further limit recompression threshold
Date: Wed, 14 Jun 2023 23:13:12 +0900

Recompression threshold should be below huge-size-class
watermark.

Link: https://lkml.kernel.org/r/20230614141338.3480029-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Brian Geffon <bgeffon@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-further-limit-recompression-threshold
+++ a/drivers/block/zram/zram_drv.c
@@ -1753,7 +1753,7 @@ static ssize_t recompress_store(struct d
 		}
 	}
 
-	if (threshold >= PAGE_SIZE)
+	if (threshold >= huge_class_size)
 		return -EINVAL;
 
 	down_read(&zram->init_lock);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-further-limit-recompression-threshold.patch


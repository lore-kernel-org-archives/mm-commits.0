Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A44EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjFSX1L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjFSXZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FE41BCA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5027F60FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED5EC433C8;
        Mon, 19 Jun 2023 23:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217000;
        bh=VMas/8s2kp6akTPmojDSpdWZuFkFo1siNWYSdA+LLWM=;
        h=Date:To:From:Subject:From;
        b=Wir42UontwH0MVFv1cXNULFnyshl1OAXvCFzDZ40ljt1I5ZIgMR4Z1NLh0dcopAUU
         4jiizsl02gUgSzNWosCfMjc5CNoQcgXsxDLC04Y1hYHGCJRPGEUwSzJdNd4oTBj0k2
         zIVKyRCp5JG2EdV/Y02VH558ncOFtPSIOCbunYeg=
Date:   Mon, 19 Jun 2023 16:23:19 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org, bgeffon@google.com,
        axboe@kernel.dk, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-further-limit-recompression-threshold.patch removed from -mm tree
Message-Id: <20230619232320.9ED5EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: further limit recompression threshold
has been removed from the -mm tree.  Its filename was
     zram-further-limit-recompression-threshold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: further limit recompression threshold
Date: Wed, 14 Jun 2023 23:13:12 +0900

Recompression threshold should be below huge-size-class watermark.  Any
object larger than huge-size-class is a "huge object" and occupies a
whole physical page on the zsmalloc side, in other words it's
incompressible, as far as zsmalloc is concerned.

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



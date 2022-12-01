Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80130C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiLAAEl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiLAADX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EF88D664
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF8661E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EF7C433B5;
        Thu,  1 Dec 2022 00:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852890;
        bh=hte7kPIH2vfSMRuPVbCQITHMyPlxAz3mjQQIBan302I=;
        h=Date:To:From:Subject:From;
        b=St6RaDEKc5QesL+nUBA3CXlys5J7LdESPtMdnaXP65q/28TRGmmTeQ3BKJYQqdH3/
         4ZnMxaX5R+FgJldD+99GNAn6pFlhUkoOdqQRS90owDoQNb6PePnFC0dEOhoFvn3Oy+
         LRu6q6As66XVFMlcRdQtBs8jDIj/FqiX2I7ZzmCM=
Date:   Wed, 30 Nov 2022 16:01:29 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-clarify-writeback_store-comment.patch removed from -mm tree
Message-Id: <20221201000130.86EF7C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: clarify writeback_store() comment
has been removed from the -mm tree.  Its filename was
     zram-clarify-writeback_store-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clarify writeback_store() comment
Date: Wed, 9 Nov 2022 20:50:40 +0900

Re-phrase writeback BIO error comment.

Link: https://lkml.kernel.org/r/20221109115047.2921851-7-senozhatsky@chromium.org
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-clarify-writeback_store-comment
+++ a/drivers/block/zram/zram_drv.c
@@ -769,8 +769,12 @@ static ssize_t writeback_store(struct de
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
 			/*
-			 * Return last IO error unless every IO were
-			 * not suceeded.
+			 * BIO errors are not fatal, we continue and simply
+			 * attempt to writeback the remaining objects (pages).
+			 * At the same time we need to signal user-space that
+			 * some writes (at least one, but also could be all of
+			 * them) were not successful and we do so by returning
+			 * the most recent BIO error.
 			 */
 			ret = err;
 			continue;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are



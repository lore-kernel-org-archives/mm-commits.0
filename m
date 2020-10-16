Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA8BC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B806721D81
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881522;
	bh=2crNiCNQ5cmIfMSNjekoUg8a63GWACa35PVZTsK951k=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fzKXOapBFDqlsJKrX6Bme4Ew6LlV5v+G0U+Si1JN8MwCfabfFjhdHUMlBAiUR7R6i
	 45SIo3lFvHa+7/WzQhvlLctjc5hgc+vF754faevqjDJWVNxDsOnRlvnJDeTeeP/Qnw
	 UoeVtl4m3glOm3EizRAy6g4WjYEnu3xXK+Q4ENP0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408118AbgJPUwC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUv5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:51:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBD24218AC;
        Fri, 16 Oct 2020 20:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881516;
        bh=2crNiCNQ5cmIfMSNjekoUg8a63GWACa35PVZTsK951k=;
        h=Date:From:To:Subject:From;
        b=Jtk1jfhAIwwBQxgd7M8q/58lNWMzsg8Q3Xxq6DILoDNHYQVZ2aBbMa3gj6ku2N6jA
         loTF9qOY0Qb0yGkTfioqovq7E85SypPpDAaGuFkwZKcu7B0La63+ihY79+H15FXYQ5
         DuhKfyIQxC7t6Vjdu/BomOFLU7fc9YuXg7QKErQo=
Date:   Fri, 16 Oct 2020 13:51:55 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dianders@chromium.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com,
        sonnyrao@chromium.org
Subject:  [merged]
 zram-failing-to-decompress-is-warn_on-worthy.patch removed from -mm tree
Message-ID: <20201016205155.Wums6nH-M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: failing to decompress is WARN_ON worthy
has been removed from the -mm tree.  Its filename was
     zram-failing-to-decompress-is-warn_on-worthy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: zram: failing to decompress is WARN_ON worthy

If we fail to decompress in zram it's a pretty serious problem.  We were
entrusted to be able to decompress the old data but we failed.  Either
we've got some crazy bug in the compression code or we've got memory
corruption.

At the moment, when this happens the log looks like this:

  ERR kernel: [ 1833.099861] zram: Decompression failed! err=-22, page=336112
  ERR kernel: [ 1833.099881] zram: Decompression failed! err=-22, page=336112
  ALERT kernel: [ 1833.099886] Read-error on swap-device (253:0:2688896)

It is true that we have an "ALERT" level log in there, but (at least to
me) it feels like even this isn't enough to impart the seriousness of this
error.  Let's convert to a WARN_ON.  Note that WARN_ON is automatically
"unlikely" so we can simply replace the old annotation with the new one.

Link: https://lkml.kernel.org/r/20200917174059.1.If09c882545dbe432268f7a67a4d4cfcb6caace4f@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-failing-to-decompress-is-warn_on-worthy
+++ a/drivers/block/zram/zram_drv.c
@@ -1270,7 +1270,7 @@ static int __zram_bvec_read(struct zram
 	zram_slot_unlock(zram, index);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret))
+	if (WARN_ON(ret))
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 
 	return ret;
_

Patches currently in -mm which might be from dianders@chromium.org are



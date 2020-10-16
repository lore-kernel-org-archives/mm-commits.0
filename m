Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D88C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4164A20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816400;
	bh=5R94fPwsyfe3asAYJMhtMYzZ5CQsrrOABiN7ISIlRa4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aNIEoQwSXWjhdozUhXq4ew3k3Y73eaVpz34NECjXPiRbL7WtYQ9vJYNNMn4Z4cuTp
	 V5lVoWKgxwA9Ud5fSG5WXy9OlKMLOuK4gWv7cXqS6FbQGCu2E0AnfrtnrvlvElbdPw
	 F5X7OxOkhFS6sgN6/mgjXp7ECn8AMJJq8uQ0DMik=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393909AbgJPCqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731896AbgJPCqj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F30020897;
        Fri, 16 Oct 2020 02:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816397;
        bh=5R94fPwsyfe3asAYJMhtMYzZ5CQsrrOABiN7ISIlRa4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yTcNR9+xGE/M3XMXA6yujEhQKsu82WuxcBM9ErQKci8o6WtSZhEhZ0sbHVetrF9cl
         vpTTLHEIfq5VvJTZqYsb5EnvX5pVKADt88ZiO7IiWCx7tVWNPuXx/WA+ZqVja6zPRm
         wlmJl1dCYudktPdFBL24/SYB5bi8L12vohtgsAC4=
Date:   Thu, 15 Oct 2020 19:46:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, dianders@chromium.org,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky.work@gmail.com, sonnyrao@chromium.org,
        torvalds@linux-foundation.org
Subject:  [patch 084/156] zram: failing to decompress is WARN_ON
 worthy
Message-ID: <20201016024636.qnz2w8The%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78DCC43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782B521D20
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474482;
	bh=+Z67N0anrud1l5hGEVah9O5xuXC9G/XqsC2vpr96ka8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=f0rRpe4NxamkBGXWtdTFRk20L4/JJ5lgVLRmrfyxcy2DxG0x28/SzJVovrr2HgH7c
	 aP2D0GE5Lp3BfXnnMeBUngE97v2UqlS4FtaefaA67H0IFCLQAmwEddsaMDgszIFNfN
	 K93vPg8VQYgzzJSMy5HsRraL/iMWSVSIxjd90GqU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgISAOm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgISAOm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:14:42 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25EBD21D20;
        Sat, 19 Sep 2020 00:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474481;
        bh=+Z67N0anrud1l5hGEVah9O5xuXC9G/XqsC2vpr96ka8=;
        h=Date:From:To:Subject:From;
        b=Jl8afkg37AgS99KLANx8tJVCDFo650zsYBh7AV6/85BAKNg4V1aegrOwc6yxjzXl1
         rhbtdX5t4kcWD3Td+LnlFtWPAKwZmNx5x6Xi6IRONqTz4zw5IoanRBBBWpkzQmQ7rs
         rS3H+bzbbdewyyqXkARQDGdzPMAYzDkiBIqCbD5I=
Date:   Fri, 18 Sep 2020 17:14:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sonnyrao@chromium.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, dianders@chromium.org
Subject:  + zram-failing-to-decompress-is-warn_on-worthy.patch added
 to -mm tree
Message-ID: <20200919001440.LKe0h%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: failing to decompress is WARN_ON worthy
has been added to the -mm tree.  Its filename is
     zram-failing-to-decompress-is-warn_on-worthy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-failing-to-decompress-is-warn_on-worthy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-failing-to-decompress-is-warn_on-worthy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1268,7 +1268,7 @@ static int __zram_bvec_read(struct zram
 	zram_slot_unlock(zram, index);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret))
+	if (WARN_ON(ret))
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 
 	return ret;
_

Patches currently in -mm which might be from dianders@chromium.org are

zram-failing-to-decompress-is-warn_on-worthy.patch


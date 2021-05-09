Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FD2C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC0EB61019
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhEIAcp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhEIAco (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4E36100A;
        Sun,  9 May 2021 00:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620520301;
        bh=QeiL/m8FGJZDBv6uhW0/5mRxj8GeOJXrxFyrtmUbenU=;
        h=Date:From:To:Subject:From;
        b=dSM65DawVyLYg5PaACDI6HoUHB4coqniYsgUT8we65rR3/MZ2aBJIYDCUPpBnMHFF
         Y7lIRk2opNg56+BK6Zw+4aOcWidauUmqFQpukqVM/G0SC/c4exGWsFaDc3r2lkKGa4
         5LyLEYUv1xQmfjqQCd1oyKyIh7so5c57v6yWGii8=
Date:   Sat, 08 May 2021 17:31:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com
Subject:  +
 lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch added to -mm tree
Message-ID: <20210509003141.sZH5gZQCC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: decompress_bunzip2: remove an unneeded semicolon
has been added to the -mm tree.  Its filename is
     lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib: decompress_bunzip2: remove an unneeded semicolon

The semicolon immediately following '}' is unneeded.

Link: https://lkml.kernel.org/r/20210508094926.2889-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_bunzip2.c~lib-decompress_bunzip2-remove-an-unneeded-semicolon
+++ a/lib/decompress_bunzip2.c
@@ -385,7 +385,7 @@ static int INIT get_next_block(struct bu
 			bd->inbufBits =
 				(bd->inbufBits << 8)|bd->inbuf[bd->inbufPos++];
 			bd->inbufBitCount += 8;
-		};
+		}
 		bd->inbufBitCount -= hufGroup->maxLen;
 		j = (bd->inbufBits >> bd->inbufBitCount)&
 			((1 << hufGroup->maxLen)-1);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch


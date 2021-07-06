Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA92C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4AB661CA8
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhGFTYl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhGFTYk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B42561C9E;
        Tue,  6 Jul 2021 19:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599320;
        bh=nbtIsRidHmVyzr8tt3G/IR1E/nBpXHfugTXJJ/TBl14=;
        h=Date:From:To:Subject:From;
        b=EdJEFXZmHkHaPGr7bgkAAdsG25iQSCWnZYCCDtL1CHNZ9CoI3HDBtxUVvtEF4L4ha
         J4DHJSZa7BM8+XM4VVQ3KLEmwc5EPByP+o6BOWNwSki85JCZJePlwgZDjVKCvMcHMp
         qcCqKnF2xRJvX5WdkKU6nnpr2eMsMP++J9x3sSXA=
Date:   Tue, 06 Jul 2021 12:22:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com
Subject:  [merged]
 lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch removed from -mm
 tree
Message-ID: <20210706192200.5gRo_FUc_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: decompress_bunzip2: remove an unneeded semicolon
has been removed from the -mm tree.  Its filename was
     lib-decompress_bunzip2-remove-an-unneeded-semicolon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-test-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes.patch
lib-fix-spelling-mistakes-in-header-files.patch
mm-fix-spelling-mistakes-in-header-files.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782F2C11F6B
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6313E61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhGAB5g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB5d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E9E61420;
        Thu,  1 Jul 2021 01:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104503;
        bh=lzWDZl7iHCfeefN6bqRDTgU1KA8F1T/4UU1KFbO4rfU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FZOS6CzwOAIQ+5gKjGLvO1z50PimgV1h+oJqEHBUJwNz1GKPfgXxV7nvqt4/cC88a
         xykWNpmIDqsVvBNMlY+/FUhtTcslTp4QeiXSVt9dygQMGiB1CeXU9cWwGJ1jT84NLF
         yoN9PGaUB9UDtm4YDOHr02EuQ8kC15Ox+tjXaGzA=
Date:   Wed, 30 Jun 2021 18:55:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 147/192] lib: decompress_bunzip2: remove an
 unneeded semicolon
Message-ID: <20210701015502.IAHucUpyV%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

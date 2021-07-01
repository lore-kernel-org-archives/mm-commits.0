Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80900C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCFC6147D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbhGAB7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237933AbhGAB7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C06726146D;
        Thu,  1 Jul 2021 01:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104626;
        bh=BOl99PpQx/wtTG7qlhr4tvHWsX3BMnAJ9IrTcNiZPSE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vq/Cl0fUx93X5xoM/Lo/mjQyTn3zviOwTlYNWQlYPW/Jd8y2fLZyLoI64/ri4oAYC
         qlIxOet04/A+i0Y0OVA0EgF2unUbPPyMAuB9RM5alb2PgnLDBu1LOB/a8SWBcpLqGR
         k2gv/djm5uVU8+HIIosWRCEmYU96Nz/E18Ayhzjg=
Date:   Wed, 30 Jun 2021 18:57:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yukuai3@huawei.com
Subject:  [patch 188/192] lib/decompressors: remove set but not
 used variabled 'level'
Message-ID: <20210701015706.U6KPx2_gJ%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>
Subject: lib/decompressors: remove set but not used variabled 'level'

Fixes gcc '-Wunused-but-set-variable' warning:

lib/decompress_unlzo.c:46:5: warning: variable `level' set but
not used [-Wunused-but-set-variable]

It is never used and so can be removed.

[akpm@linux-foundation.org: warning: value computed is not used]
Link: https://lkml.kernel.org/r/20210514062050.3532344-1-yukuai3@huawei.com
Fixes: 7dd65feb6c60 ("lib: add support for LZO-compressed kernels")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/decompress_unlzo.c~lib-decompressors-remove-set-but-not-used-variabled-level
+++ a/lib/decompress_unlzo.c
@@ -43,7 +43,6 @@ STATIC inline long INIT parse_header(u8
 	int l;
 	u8 *parse = input;
 	u8 *end = input + in_len;
-	u8 level = 0;
 	u16 version;
 
 	/*
@@ -65,7 +64,7 @@ STATIC inline long INIT parse_header(u8
 	version = get_unaligned_be16(parse);
 	parse += 7;
 	if (version >= 0x0940)
-		level = *parse++;
+		parse++;
 	if (get_unaligned_be32(parse) & HEADER_HAS_FILTER)
 		parse += 8; /* flags + filter info */
 	else
_

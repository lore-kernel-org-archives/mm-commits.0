Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972C8C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 812EE61CA9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhGFT0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhGFT0L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A2BA61CA8;
        Tue,  6 Jul 2021 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599412;
        bh=L4jrFMKPlOXEXY5UH1qQpHTGkIuw/nez4XWgJt5LRnA=;
        h=Date:From:To:Subject:From;
        b=KlqwWzHGhPIzFIwEcxCPQ0fgBxGEa9nsC2N8xR41q/ENMUOmCgMOxPKENeB6SNJuu
         5m3EVR1AYz+1OdyClHC4Qtk4uNnSf4yWaygKNL7FLdXB7gkRp3nopFwijnVhM0pEzZ
         /wxDCQQwCBqUAEwUXA7or0CuG6DL45UZQui3/GbQ=
Date:   Tue, 06 Jul 2021 12:23:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com
Subject:  [merged]
 lib-decompressors-remove-set-but-not-used-variabled-level.patch removed
 from -mm tree
Message-ID: <20210706192332.Blos2gq1B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompressors: remove set but not used variabled 'level'
has been removed from the -mm tree.  Its filename was
     lib-decompressors-remove-set-but-not-used-variabled-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yukuai3@huawei.com are



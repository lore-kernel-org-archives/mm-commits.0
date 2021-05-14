Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A436C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EEC661440
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhENWas (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 18:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhENWas (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 18:30:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A719A613DE;
        Fri, 14 May 2021 22:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621031375;
        bh=xuokI7ZlzxavyZiJLA0cwLMPGSOzVfl15JMTkqEUHIg=;
        h=Date:From:To:Subject:From;
        b=K6c/+OwE6naRG1IGb/MrTMB3m4+11OzgBw0cEDVAE9+qOj+dpWEK+jz3qOM4UOgjP
         nNGvWOJFACVvNYWWSnpIXNh80Qto0czG9PVNg7bnNHtrxFYsBLNUtsPxM73ZDukV8/
         DFRKORaAHc9Ijiufk1SsoKvn/6lc6YpV3r1Z6Z2c=
Date:   Fri, 14 May 2021 15:29:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com
Subject:  +
 lib-decompressors-remove-set-but-not-used-variabled-level.patch added to
 -mm tree
Message-ID: <20210514222935.vvs8-0QcC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompressors: remove set but not used variabled 'level'
has been added to the -mm tree.  Its filename is
     lib-decompressors-remove-set-but-not-used-variabled-level.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-decompressors-remove-set-but-not-used-variabled-level.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-decompressors-remove-set-but-not-used-variabled-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Kuai <yukuai3@huawei.com>
Subject: lib/decompressors: remove set but not used variabled 'level'

Fixes gcc '-Wunused-but-set-variable' warning:

lib/decompress_unlzo.c:46:5: warning: variable `level' set but
not used [-Wunused-but-set-variable]

It is never used and so can be removed.

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
+		*parse++;
 	if (get_unaligned_be32(parse) & HEADER_HAS_FILTER)
 		parse += 8; /* flags + filter info */
 	else
_

Patches currently in -mm which might be from yukuai3@huawei.com are

lib-decompressors-remove-set-but-not-used-variabled-level.patch


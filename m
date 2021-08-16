Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23819C432BE
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09B3460F55
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhHPUf3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231779AbhHPUf2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 16:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD7760F36;
        Mon, 16 Aug 2021 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629146096;
        bh=3VIR0lvZdvJxa/ezQJHZEDwwidM66OB5s80NIxkYNbI=;
        h=Date:From:To:Subject:From;
        b=xce4bJc1rUfMNiXYHwmhL7SxDjUBJn0YofAnj0VvD2D2I2W9lxG11oLbsmtkIOKsC
         ytYuwkYuF0P9S3uo8YZCrr76u/282lfYc2havNbW9L0q801V6hG7iGjTdcluMFN/It
         SV2O162yjNOYUJi1jNzFqWOhioQlYxfk0sskJLyU=
Date:   Mon, 16 Aug 2021 13:34:56 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, elver@google.com, glider@google.com,
        Kuan-Ying.Lee@mediatek.com, mm-commits@vger.kernel.org,
        nicholas.tang@mediatek.com, ryabinin.a.a@gmail.com
Subject:  [merged] kasan-slub-reset-tag-when-printing-address.patch
 removed from -mm tree
Message-ID: <20210816203456.wtAFFEkxm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, slub: reset tag when printing address
has been removed from the -mm tree.  Its filename was
     kasan-slub-reset-tag-when-printing-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kasan, slub: reset tag when printing address

The address still includes the tags when it is printed.  With hardware
tag-based kasan enabled, we will get a false positive KASAN issue when we
access metadata.

Reset the tag before we access the metadata.

Link: https://lkml.kernel.org/r/20210804090957.12393-3-Kuan-Ying.Lee@mediatek.com
Fixes: aa1ef4d7b3f6 ("kasan, mm: reset tags when accessing metadata")
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slub.c~kasan-slub-reset-tag-when-printing-address
+++ a/mm/slub.c
@@ -576,8 +576,8 @@ static void print_section(char *level, c
 			  unsigned int length)
 {
 	metadata_access_enable();
-	print_hex_dump(level, kasan_reset_tag(text), DUMP_PREFIX_ADDRESS,
-			16, 1, addr, length, 1);
+	print_hex_dump(level, text, DUMP_PREFIX_ADDRESS,
+			16, 1, kasan_reset_tag((void *)addr), length, 1);
 	metadata_access_disable();
 }
 
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are



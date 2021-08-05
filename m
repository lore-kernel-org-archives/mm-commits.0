Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE910C432BE
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 01:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA3B610A8
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 01:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhHEBMS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Aug 2021 21:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231143AbhHEBMS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Aug 2021 21:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 945B1610CC;
        Thu,  5 Aug 2021 01:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628125923;
        bh=5FLsqO30ZtSj3eiOiR5Z/Vn4TjVK1h0nwnTXDzvBmyQ=;
        h=Date:From:To:Subject:From;
        b=S/hVQPK4DJ+cynV8YCZoonDwrNmN4a3FN9WIzrqvigBOX8HMxfjSrGo+G0M5jXcar
         0apUxiho/Adn1u4uA3QDvhuPPSny0A/fVcrg5yvEI9btBYKPwl1ZocUuWiImzXDd0A
         ScmRt96wmzszRiCkC74JUKdCJra1cxJt8uksGOlM=
Date:   Wed, 04 Aug 2021 18:12:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        nicholas.tang@mediatek.com, glider@google.com, elver@google.com,
        chinwen.chang@mediatek.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, Kuan-Ying.Lee@mediatek.com
Subject:  + kasan-slub-reset-tag-when-printing-address.patch added to
 -mm tree
Message-ID: <20210805011203.dR44z%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, slub: reset tag when printing address
has been added to the -mm tree.  Its filename is
     kasan-slub-reset-tag-when-printing-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-slub-reset-tag-when-printing-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-slub-reset-tag-when-printing-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

kasan-kmemleak-reset-tags-when-scanning-block.patch
kasan-slub-reset-tag-when-printing-address.patch


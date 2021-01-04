Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48E1C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F274224F4
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbhADV3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 16:29:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbhADV3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 16:29:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA7C5216C4;
        Mon,  4 Jan 2021 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609795754;
        bh=9lURVQwU3/7juLSQBYgzeQVmxQNmW5VM5Gcor25EijQ=;
        h=Date:From:To:Subject:From;
        b=tOTFMeSjqWwKjRO6JGNh/62ia3VDP15tWIY/db1xY3ks1RO+lGDLAIxI5BaAZmgB1
         5ZGG0YpltAlwLFDB5GwbFnDjhTmEthwbKV2YCDYEzBbgUS3aowJBX1P/RAsOfyUbvT
         bYeT+Kk52eYAiVowAQrOp299h0lrM0rRlPUXw+sU=
Date:   Mon, 04 Jan 2021 13:29:13 -0800
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, dan.j.williams@intel.com,
        dvyukov@google.com, glider@google.com, lecopzer.chen@mediatek.com,
        lecopzer@gmail.com, mm-commits@vger.kernel.org
Subject:  +
 kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch added
 to -mm tree
Message-ID: <20210104212913.Dp2ZoxVB9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix incorrect arguments passing in kasan_add_zero_shadow
has been added to the -mm tree.  Its filename is
     kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lecopzer Chen <lecopzer@gmail.com>
Subject: kasan: fix incorrect arguments passing in kasan_add_zero_shadow

kasan_remove_zero_shadow() shall use original virtual address, start and
size, instead of shadow address.

Link: https://lkml.kernel.org/r/20210103063847.5963-1-lecopzer@gmail.com
Fixes: 0207df4fa1a86 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/kasan/init.c~kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow
+++ a/mm/kasan/init.c
@@ -485,7 +485,6 @@ int kasan_add_zero_shadow(void *start, u
 
 	ret = kasan_populate_early_shadow(shadow_start, shadow_end);
 	if (ret)
-		kasan_remove_zero_shadow(shadow_start,
-					size >> KASAN_SHADOW_SCALE_SHIFT);
+		kasan_remove_zero_shadow(start, size);
 	return ret;
 }
_

Patches currently in -mm which might be from lecopzer@gmail.com are

kasan-fix-unaligned-address-is-unhandled-in-kasan_remove_zero_shadow.patch
kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch


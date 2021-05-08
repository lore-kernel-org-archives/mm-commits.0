Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9840DC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6C26142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhEHWxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWxU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA5C610FA;
        Sat,  8 May 2021 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514338;
        bh=H6IcS1HE2H7xhoim0bgAtPmIG05tEaiMUlrcgzmwr5E=;
        h=Date:From:To:Subject:From;
        b=e/tLsofTaONMuxHHZuQ8S5Bc2ESoMpHE5IKTgrHQUWCpslnTfKZEQbceY8ngUZaeL
         41nXYOGlB0vKiVBylWsiGio5yhdGwvfBGXwQ6wfMlNiNH4EkKOBO0k/xfGPsBhAM1j
         0wWCsuCLWKmqNjtc4V+bW8lwWM578dXLc0td1XhU=
Date:   Sat, 08 May 2021 15:52:17 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, dalias@libc.org, dennis@kernel.org,
        dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        sbrivio@redhat.com, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  [merged]
 tools-sync-bitmap_last_word_mask-macro-with-the-kernel.patch removed from
 -mm tree
Message-ID: <20210508225217.bj_PjpT9l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: sync BITMAP_LAST_WORD_MASK() macro with the kernel
has been removed from the -mm tree.  Its filename was
     tools-sync-bitmap_last_word_mask-macro-with-the-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: tools: sync BITMAP_LAST_WORD_MASK() macro with the kernel

Kernel version generates better code.

Link: https://lkml.kernel.org/r/20210401003153.97325-4-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/bitmap.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/tools/include/linux/bitmap.h~tools-sync-bitmap_last_word_mask-macro-with-the-kernel
+++ a/tools/include/linux/bitmap.h
@@ -20,12 +20,7 @@ int __bitmap_equal(const unsigned long *
 void bitmap_clear(unsigned long *map, unsigned int start, int len);
 
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
-
-#define BITMAP_LAST_WORD_MASK(nbits)					\
-(									\
-	((nbits) % BITS_PER_LONG) ?					\
-		(1UL<<((nbits) % BITS_PER_LONG))-1 : ~0UL		\
-)
+#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
 
 #define small_const_nbits(nbits) \
 	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
_

Patches currently in -mm which might be from yury.norov@gmail.com are



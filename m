Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E81C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF95E61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWxa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHWx3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0B3661426;
        Sat,  8 May 2021 22:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514347;
        bh=ifl+oCoEyeWqlY6cT7M5ZAX4dSSn200goquN74j7V7U=;
        h=Date:From:To:Subject:From;
        b=aZVmi2XYSNkZoRDqqMJvuz4zUzNZwUe9Wtl4yCMDATD3B+PDbwQStqMnsukpvdpDh
         M9q7d8UBUGtcmtpDLAHJvussBJrD727hHclMAg11oDinJU3RO6+pMwwT/oxQYmXFBI
         vj38br8FlgAunCSNusitLdGkTXuxKmiixiHyo7MA=
Date:   Sat, 08 May 2021 15:52:26 -0700
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
 tools-sync-small_const_nbits-macro-with-the-kernel.patch removed from -mm
 tree
Message-ID: <20210508225226.TFTrEhu30%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: sync small_const_nbits() macro with the kernel
has been removed from the -mm tree.  Its filename was
     tools-sync-small_const_nbits-macro-with-the-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: tools: sync small_const_nbits() macro with the kernel

Sync implementation with the kernel and move the macro from
tools/include/linux/bitmap.h to tools/include/asm-generic/bitsperlong.h

Link: https://lkml.kernel.org/r/20210401003153.97325-7-yury.norov@gmail.com
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

 tools/include/asm-generic/bitsperlong.h |    3 +++
 tools/include/linux/bitmap.h            |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/include/asm-generic/bitsperlong.h~tools-sync-small_const_nbits-macro-with-the-kernel
+++ a/tools/include/asm-generic/bitsperlong.h
@@ -18,4 +18,7 @@
 #define BITS_PER_LONG_LONG 64
 #endif
 
+#define small_const_nbits(nbits) \
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG && (nbits) > 0)
+
 #endif /* __ASM_GENERIC_BITS_PER_LONG */
--- a/tools/include/linux/bitmap.h~tools-sync-small_const_nbits-macro-with-the-kernel
+++ a/tools/include/linux/bitmap.h
@@ -22,9 +22,6 @@ void bitmap_clear(unsigned long *map, un
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
 #define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
 
-#define small_const_nbits(nbits) \
-	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
-
 static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
_

Patches currently in -mm which might be from yury.norov@gmail.com are



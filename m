Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0665FC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC386142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEHWx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHWx0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD0EC61424;
        Sat,  8 May 2021 22:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514344;
        bh=5zhf9y/HIFN9clMBIELgmo3n6B3QivCeox4eJ8Dv/Qs=;
        h=Date:From:To:Subject:From;
        b=DB0Li26mEybLFDN/6DG6tGayAxz9GozUkD4vasyDPahGeSlJKclElUFqDoslDfD8V
         xbd96o2IC5PwOYO0m+hv/Ec4z2r9LnPWYNI8o31PFDFY7WqkFKSeh3+WC2dDBSZTKj
         QO+kIwbWDXUO3caBT10VMFh6iz2pvEGrRON7EHRI=
Date:   Sat, 08 May 2021 15:52:23 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andy.shevchenko@gmail.com, arnd@arndb.de,
        dalias@libc.org, dennis@kernel.org, dsterba@suse.com,
        geert@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        jianpeng.ma@intel.com, joe@perches.com, jpoimboe@redhat.com,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, sbrivio@redhat.com,
        wsa+renesas@sang-engineering.com, ysato@users.osdn.me,
        yury.norov@gmail.com
Subject:  [merged]
 lib-extend-the-scope-of-small_const_nbits-macro.patch removed from -mm tree
Message-ID: <20210508225223.FpYDXpaZ0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: extend the scope of small_const_nbits() macro
has been removed from the -mm tree.  Its filename was
     lib-extend-the-scope-of-small_const_nbits-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: extend the scope of small_const_nbits() macro

find_bit would also benefit from small_const_nbits() optimizations.  The
detailed comment is provided by Rasmus Villemoes.

Link: https://lkml.kernel.org/r/20210401003153.97325-6-yury.norov@gmail.com
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexey Klimov <aklimov@redhat.com>
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

 include/asm-generic/bitsperlong.h |   12 ++++++++++++
 include/linux/bitmap.h            |    8 --------
 2 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/asm-generic/bitsperlong.h~lib-extend-the-scope-of-small_const_nbits-macro
+++ a/include/asm-generic/bitsperlong.h
@@ -23,4 +23,16 @@
 #define BITS_PER_LONG_LONG 64
 #endif
 
+/*
+ * small_const_nbits(n) is true precisely when it is known at compile-time
+ * that BITMAP_SIZE(n) is 1, i.e. 1 <= n <= BITS_PER_LONG. This allows
+ * various bit/bitmap APIs to provide a fast inline implementation. Bitmaps
+ * of size 0 are very rare, and a compile-time-known-size 0 is most likely
+ * a sign of error. They will be handled correctly by the bit/bitmap APIs,
+ * but using the out-of-line functions, so that the inline implementations
+ * can unconditionally dereference the pointer(s).
+ */
+#define small_const_nbits(nbits) \
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG && (nbits) > 0)
+
 #endif /* __ASM_GENERIC_BITS_PER_LONG */
--- a/include/linux/bitmap.h~lib-extend-the-scope-of-small_const_nbits-macro
+++ a/include/linux/bitmap.h
@@ -223,14 +223,6 @@ extern int bitmap_print_to_pagebuf(bool
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
 #define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
 
-/*
- * The static inlines below do not handle constant nbits==0 correctly,
- * so make such users (should any ever turn up) call the out-of-line
- * versions.
- */
-#define small_const_nbits(nbits) \
-	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG && (nbits) > 0)
-
 static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
 	unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
_

Patches currently in -mm which might be from yury.norov@gmail.com are



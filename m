Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8271AC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62DEA613B5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhEGBDr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhEGBDq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EF94610F7;
        Fri,  7 May 2021 01:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349367;
        bh=qpTt3t0UE+zsql2w3MPBjk2FWVKE8lCJY7dDZOMgkPs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SiFkWUIB1mODihdWmaUeLUfQgfZq3GfDVekaxKR0W/aESz4G5hgtOP7PikuQqWjhV
         KmZTcvO15nLdiAgvbTDeCl2M9cLw9Y0dQyEZWcH7FyQ+eFdFmOQcdSHnKdHXWTppV3
         A0TAjOgDvNwjL+Fn/ACjhyTsslqQoNmUj2p8z5nA=
Date:   Thu, 06 May 2021 18:02:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, dalias@libc.org,
        dennis@kernel.org, dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, sbrivio@redhat.com,
        torvalds@linux-foundation.org, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  [patch 15/91] tools: bitmap: sync function declarations
 with the kernel
Message-ID: <20210507010246.n_fOXph42%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: tools: bitmap: sync function declarations with the kernel

Some functions in tools/include/linux/bitmap.h declare nbits as int.  In
the kernel nbits is declared as unsigned int.

Link: https://lkml.kernel.org/r/20210401003153.97325-3-yury.norov@gmail.com
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

 tools/include/linux/bitmap.h |    8 ++++----
 tools/lib/bitmap.c           |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/tools/include/linux/bitmap.h~tools-bitmap-sync-function-declarations-with-the-kernel
+++ a/tools/include/linux/bitmap.h
@@ -30,7 +30,7 @@ void bitmap_clear(unsigned long *map, un
 #define small_const_nbits(nbits) \
 	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
 
-static inline void bitmap_zero(unsigned long *dst, int nbits)
+static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = 0UL;
@@ -66,7 +66,7 @@ static inline int bitmap_full(const unsi
 	return find_first_zero_bit(src, nbits) == nbits;
 }
 
-static inline int bitmap_weight(const unsigned long *src, int nbits)
+static inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
@@ -74,7 +74,7 @@ static inline int bitmap_weight(const un
 }
 
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
-			     const unsigned long *src2, int nbits)
+			     const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
@@ -141,7 +141,7 @@ static inline void bitmap_free(unsigned
  * @buf: buffer to store output
  * @size: size of @buf
  */
-size_t bitmap_scnprintf(unsigned long *bitmap, int nbits,
+size_t bitmap_scnprintf(unsigned long *bitmap, unsigned int nbits,
 			char *buf, size_t size);
 
 /**
--- a/tools/lib/bitmap.c~tools-bitmap-sync-function-declarations-with-the-kernel
+++ a/tools/lib/bitmap.c
@@ -28,11 +28,11 @@ void __bitmap_or(unsigned long *dst, con
 		dst[k] = bitmap1[k] | bitmap2[k];
 }
 
-size_t bitmap_scnprintf(unsigned long *bitmap, int nbits,
+size_t bitmap_scnprintf(unsigned long *bitmap, unsigned int nbits,
 			char *buf, size_t size)
 {
 	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
-	int cur, rbot, rtop;
+	unsigned int cur, rbot, rtop;
 	bool first = true;
 	size_t ret = 0;
 
_

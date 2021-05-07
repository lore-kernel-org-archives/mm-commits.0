Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB235C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDE38613B5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhEGBEU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhEGBES (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD997613C2;
        Fri,  7 May 2021 01:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349399;
        bh=H1t6BBfHTd8GEhdzIYwtQwrgvalKKBVziU97NHvMV7A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y4/HP1/vYltmYhXp5/aoMy9iD3MxoDjabk1g2T7ptzyRNuU7/ZWAaa6RT/7Gc19Y5
         p3phIn6VvA023HlAxIwQRS55ofnq16MlyIHmOlGVrqKnb5vTuVEVx84fdLX7D+gVSt
         E+5uwvKOLd0/bsd2h0uYbwekxO6YLyG3iWq2xwe0=
Date:   Thu, 06 May 2021 18:03:18 -0700
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
Subject:  [patch 24/91] tools: sync lib/find_bit implementation
Message-ID: <20210507010318.Dt6rbBUrj%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: tools: sync lib/find_bit implementation

Add fast paths to find_*_bit() functions as per kernel implementation.

Link: https://lkml.kernel.org/r/20210401003153.97325-12-yury.norov@gmail.com
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

 tools/include/asm-generic/bitops/find.h |   58 ++++++++++++++++++++--
 tools/lib/find_bit.c                    |    4 -
 2 files changed, 57 insertions(+), 5 deletions(-)

--- a/tools/include/asm-generic/bitops/find.h~tools-sync-lib-find_bit-implementation
+++ a/tools/include/asm-generic/bitops/find.h
@@ -5,6 +5,9 @@
 extern unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
 		unsigned long start, unsigned long invert, unsigned long le);
+extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
 
 #ifndef find_next_bit
 /**
@@ -20,6 +23,16 @@ static inline
 unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 			    unsigned long offset)
 {
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
 	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
 }
 #endif
@@ -40,6 +53,16 @@ unsigned long find_next_and_bit(const un
 		const unsigned long *addr2, unsigned long size,
 		unsigned long offset)
 {
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr1 & *addr2 & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
 	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
 }
 #endif
@@ -58,6 +81,16 @@ static inline
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset)
 {
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr | ~GENMASK(size - 1, offset);
+		return val == ~0UL ? size : ffz(val);
+	}
+
 	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
 }
 #endif
@@ -72,8 +105,17 @@ unsigned long find_next_zero_bit(const u
  * Returns the bit number of the first set bit.
  * If no bits are set, returns @size.
  */
-extern unsigned long find_first_bit(const unsigned long *addr,
-				    unsigned long size);
+static inline
+unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr & GENMASK(size - 1, 0);
+
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_first_bit(addr, size);
+}
 
 #endif /* find_first_bit */
 
@@ -87,7 +129,17 @@ extern unsigned long find_first_bit(cons
  * Returns the bit number of the first cleared bit.
  * If no bits are zero, returns @size.
  */
-unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size);
+static inline
+unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr | ~GENMASK(size - 1, 0);
+
+		return val == ~0UL ? size : ffz(val);
+	}
+
+	return _find_first_zero_bit(addr, size);
+}
 #endif
 
 #endif /*_TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_ */
--- a/tools/lib/find_bit.c~tools-sync-lib-find_bit-implementation
+++ a/tools/lib/find_bit.c
@@ -83,7 +83,7 @@ unsigned long _find_next_bit(const unsig
 /*
  * Find the first set bit in a memory region.
  */
-unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+unsigned long _find_first_bit(const unsigned long *addr, unsigned long size)
 {
 	unsigned long idx;
 
@@ -100,7 +100,7 @@ unsigned long find_first_bit(const unsig
 /*
  * Find the first cleared bit in a memory region.
  */
-unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
+unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size)
 {
 	unsigned long idx;
 
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B11AC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E1F61432
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhEHWxm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C7760233;
        Sat,  8 May 2021 22:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514359;
        bh=xFpvAi55ErC+guvp82Qi8NeN0IcRmA4kE/qHea/bNoo=;
        h=Date:From:To:Subject:From;
        b=hnVFm0qQOnhyN2A5tOPgMxUgfFNgGsbR4hIlIgyscJClXvig0FdM4OYsEuyg/4yN9
         8oIUqCeGH52xr6aV/h1GG/ck9/gYyD0TtRpEY2euSPwM165jzVth9RcMYv0VYZD8jb
         6Bv6fZn+i0qaAZwm1jXnScXkQP80iVNbpnkuJ+KI=
Date:   Sat, 08 May 2021 15:52:38 -0700
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
 lib-add-fast-path-for-find_first__bit-and-find_last_bit.patch removed from
 -mm tree
Message-ID: <20210508225238.42W84VJiA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add fast path for find_first_*_bit() and find_last_bit()
has been removed from the -mm tree.  Its filename was
     lib-add-fast-path-for-find_first__bit-and-find_last_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: add fast path for find_first_*_bit() and find_last_bit()

Similarly to bitmap functions, users would benefit if we'll handle a case
of small-size bitmaps that fit into a single word.

While here, move the find_last_bit() declaration to bitops/find.h where
other find_*_bit() functions sit.

Link: https://lkml.kernel.org/r/20210401003153.97325-11-yury.norov@gmail.com
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

 include/asm-generic/bitops/find.h |   50 +++++++++++++++++++++++++---
 include/linux/bitops.h            |   12 ------
 lib/find_bit.c                    |   12 +++---
 3 files changed, 52 insertions(+), 22 deletions(-)

--- a/include/asm-generic/bitops/find.h~lib-add-fast-path-for-find_first__bit-and-find_last_bit
+++ a/include/asm-generic/bitops/find.h
@@ -5,6 +5,9 @@
 extern unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
 		unsigned long start, unsigned long invert, unsigned long le);
+extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
 
 #ifndef find_next_bit
 /**
@@ -102,8 +105,17 @@ unsigned long find_next_zero_bit(const u
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
 
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
@@ -113,8 +125,17 @@ extern unsigned long find_first_bit(cons
  * Returns the bit number of the first cleared bit.
  * If no bits are zero, returns @size.
  */
-extern unsigned long find_first_zero_bit(const unsigned long *addr,
-					 unsigned long size);
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
 #else /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifndef find_first_bit
@@ -126,6 +147,27 @@ extern unsigned long find_first_zero_bit
 
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
+#ifndef find_last_bit
+/**
+ * find_last_bit - find the last set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The number of bits to search
+ *
+ * Returns the bit number of the last set bit, or size.
+ */
+static inline
+unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr & GENMASK(size - 1, 0);
+
+		return val ? __fls(val) : size;
+	}
+
+	return _find_last_bit(addr, size);
+}
+#endif
+
 /**
  * find_next_clump8 - find next 8-bit clump with set bits in a memory region
  * @clump: location to store copy of found clump
--- a/include/linux/bitops.h~lib-add-fast-path-for-find_first__bit-and-find_last_bit
+++ a/include/linux/bitops.h
@@ -286,17 +286,5 @@ static __always_inline void __assign_bit
 })
 #endif
 
-#ifndef find_last_bit
-/**
- * find_last_bit - find the last set bit in a memory region
- * @addr: The address to start the search at
- * @size: The number of bits to search
- *
- * Returns the bit number of the last set bit, or size.
- */
-extern unsigned long find_last_bit(const unsigned long *addr,
-				   unsigned long size);
-#endif
-
 #endif /* __KERNEL__ */
 #endif
--- a/lib/find_bit.c~lib-add-fast-path-for-find_first__bit-and-find_last_bit
+++ a/lib/find_bit.c
@@ -75,7 +75,7 @@ EXPORT_SYMBOL(_find_next_bit);
 /*
  * Find the first set bit in a memory region.
  */
-unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+unsigned long _find_first_bit(const unsigned long *addr, unsigned long size)
 {
 	unsigned long idx;
 
@@ -86,14 +86,14 @@ unsigned long find_first_bit(const unsig
 
 	return size;
 }
-EXPORT_SYMBOL(find_first_bit);
+EXPORT_SYMBOL(_find_first_bit);
 #endif
 
 #ifndef find_first_zero_bit
 /*
  * Find the first cleared bit in a memory region.
  */
-unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
+unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size)
 {
 	unsigned long idx;
 
@@ -104,11 +104,11 @@ unsigned long find_first_zero_bit(const
 
 	return size;
 }
-EXPORT_SYMBOL(find_first_zero_bit);
+EXPORT_SYMBOL(_find_first_zero_bit);
 #endif
 
 #ifndef find_last_bit
-unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+unsigned long _find_last_bit(const unsigned long *addr, unsigned long size)
 {
 	if (size) {
 		unsigned long val = BITMAP_LAST_WORD_MASK(size);
@@ -124,7 +124,7 @@ unsigned long find_last_bit(const unsign
 	}
 	return size;
 }
-EXPORT_SYMBOL(find_last_bit);
+EXPORT_SYMBOL(_find_last_bit);
 #endif
 
 unsigned long find_next_clump8(unsigned long *clump, const unsigned long *addr,
_

Patches currently in -mm which might be from yury.norov@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8769AC43462
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AEC8610CC
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhDAAyT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232623AbhDAAyC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03FEA6109E;
        Thu,  1 Apr 2021 00:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617238441;
        bh=da8LnY7VpCy++uDYIUUonPAfQsL9t3nYdGKa7mlEHuA=;
        h=Date:From:To:Subject:From;
        b=rVsrzNsZ8hMUf7H+g3+GGNbRHuZLwJkN+vJLHfkvFYYcsERfA6U1x+4bvMay/QMf9
         kEpmH3a08xmJNd1d9X/IwDkBJ4kfB1O05CQDT8XvVIrV1uaKiLel3VtSwRNNTrd9XR
         5NFHm7HO3NY003zkNZlV8E+eHCBhCngzi/DNaD2c=
Date:   Wed, 31 Mar 2021 17:54:00 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, dalias@libc.org, dennis@kernel.org,
        dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        sbrivio@redhat.com, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  + tools-sync-find_next_bit-implementation.patch added to
 -mm tree
Message-ID: <20210401005400.JFpjABjMe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: sync find_next_bit implementation
has been added to the -mm tree.  Its filename is
     tools-sync-find_next_bit-implementation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-sync-find_next_bit-implementation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-sync-find_next_bit-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: tools: sync find_next_bit implementation

Sync the implementation with recent kernel changes.

Link: https://lkml.kernel.org/r/20210401003153.97325-9-yury.norov@gmail.com
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

 tools/include/asm-generic/bitops/find.h |   27 ++++++++---
 tools/lib/find_bit.c                    |   52 ++++++++--------------
 2 files changed, 42 insertions(+), 37 deletions(-)

--- a/tools/include/asm-generic/bitops/find.h~tools-sync-find_next_bit-implementation
+++ a/tools/include/asm-generic/bitops/find.h
@@ -2,6 +2,10 @@
 #ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
 #define _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
 
+extern unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert, unsigned long le);
+
 #ifndef find_next_bit
 /**
  * find_next_bit - find the next set bit in a memory region
@@ -12,8 +16,12 @@
  * Returns the bit number for the next set bit
  * If no bits are set, returns @size.
  */
-extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
-		size, unsigned long offset);
+static inline
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
+}
 #endif
 
 #ifndef find_next_and_bit
@@ -27,13 +35,16 @@ extern unsigned long find_next_bit(const
  * Returns the bit number for the next set bit
  * If no bits are set, returns @size.
  */
-extern unsigned long find_next_and_bit(const unsigned long *addr1,
+static inline
+unsigned long find_next_and_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long size,
-		unsigned long offset);
+		unsigned long offset)
+{
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
+}
 #endif
 
 #ifndef find_next_zero_bit
-
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
  * @addr: The address to base the search on
@@ -43,8 +54,12 @@ extern unsigned long find_next_and_bit(c
  * Returns the bit number of the next zero bit
  * If no bits are zero, returns @size.
  */
+static inline
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-				 unsigned long offset);
+				 unsigned long offset)
+{
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
+}
 #endif
 
 #ifndef find_first_bit
--- a/tools/lib/find_bit.c~tools-sync-find_next_bit-implementation
+++ a/tools/lib/find_bit.c
@@ -28,11 +28,12 @@
  *    searching it for one bits.
  *  - The optional "addr2", which is anded with "addr1" if present.
  */
-static inline unsigned long _find_next_bit(const unsigned long *addr1,
+unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert)
+		unsigned long start, unsigned long invert, unsigned long le)
 {
-	unsigned long tmp;
+	unsigned long tmp, mask;
+	(void) le;
 
 	if (unlikely(start >= nbits))
 		return nbits;
@@ -43,7 +44,19 @@ static inline unsigned long _find_next_b
 	tmp ^= invert;
 
 	/* Handle 1st word. */
-	tmp &= BITMAP_FIRST_WORD_MASK(start);
+	mask = BITMAP_FIRST_WORD_MASK(start);
+
+	/*
+	 * Due to the lack of swab() in tools, and the fact that it doesn't
+	 * need little-endian support, just comment it out
+	 */
+#if (0)
+	if (le)
+		mask = swab(mask);
+#endif
+
+	tmp &= mask;
+
 	start = round_down(start, BITS_PER_LONG);
 
 	while (!tmp) {
@@ -57,18 +70,12 @@ static inline unsigned long _find_next_b
 		tmp ^= invert;
 	}
 
-	return min(start + __ffs(tmp), nbits);
-}
+#if (0)
+	if (le)
+		tmp = swab(tmp);
 #endif
 
-#ifndef find_next_bit
-/*
- * Find the next set bit in a memory region.
- */
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-			    unsigned long offset)
-{
-	return _find_next_bit(addr, NULL, size, offset, 0UL);
+	return min(start + __ffs(tmp), nbits);
 }
 #endif
 
@@ -105,20 +112,3 @@ unsigned long find_first_zero_bit(const
 	return size;
 }
 #endif
-
-#ifndef find_next_zero_bit
-unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-				 unsigned long offset)
-{
-	return _find_next_bit(addr, NULL, size, offset, ~0UL);
-}
-#endif
-
-#ifndef find_next_and_bit
-unsigned long find_next_and_bit(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long size,
-		unsigned long offset)
-{
-	return _find_next_bit(addr1, addr2, size, offset, 0UL);
-}
-#endif
_

Patches currently in -mm which might be from yury.norov@gmail.com are

tools-disable-wno-type-limits.patch
tools-bitmap-sync-function-declarations-with-the-kernel.patch
tools-sync-bitmap_last_word_mask-macro-with-the-kernel.patch
arch-rearrange-headers-inclusion-order-in-asm-bitops-for-m68k-and-sh.patch
lib-extend-the-scope-of-small_const_nbits-macro.patch
tools-sync-small_const_nbits-macro-with-the-kernel.patch
lib-inline-_find_next_bit-wrappers.patch
tools-sync-find_next_bit-implementation.patch
lib-add-fast-path-for-find_next__bit.patch
lib-add-fast-path-for-find_first__bit-and-find_last_bit.patch
tools-sync-lib-find_bit-implementation.patch
maintainers-add-entry-for-the-bitmap-api.patch


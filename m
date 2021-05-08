Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E14CC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28DE60E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWxg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhEHWxf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:53:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9D4D61430;
        Sat,  8 May 2021 22:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514353;
        bh=LTA8fD2jz0H5GciA64pENqyxlxbgRMoJBRV+dqB3SvQ=;
        h=Date:From:To:Subject:From;
        b=cG6p5EY7ZP+2f1kMfGiXb98dmcTYGXPwkQjMscwYtOm9TM7ebRFyfB+EOtRurRtFd
         FHiqgfCzRvx5mTDaqL/72quCNLox3PJtZvWWjQy7ejChAZLCT4iVsuNSvsR16O5xDq
         xTPopbBuUSWpofvd1b8kkWV8kEHhKsKnv2BsRo1E=
Date:   Sat, 08 May 2021 15:52:32 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, dalias@libc.org, dennis@kernel.org,
        dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        sbrivio@redhat.com, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  [merged] tools-sync-find_next_bit-implementation.patch
 removed from -mm tree
Message-ID: <20210508225232.28FgtuSsY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: sync find_next_bit implementation
has been removed from the -mm tree.  Its filename was
     tools-sync-find_next_bit-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



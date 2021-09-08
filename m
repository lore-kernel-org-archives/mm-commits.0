Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB55C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0666F6113C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbhIHC7v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347361AbhIHC7r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D72A860E52;
        Wed,  8 Sep 2021 02:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069920;
        bh=kNxpBPDcKMmizmcZThWhokQSIQf1i7c5I5NtSAbULmU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yqesWTZyLHMOENTJPYaczQGjjfrPeoUKlt5y7hhxReYIAXAS/oK8DOJa0N3BvvLVP
         CYU+sSLUFciDttX3fQcpb1ZonIHXmWbY4FKThr2tXKu+lfUMN47RF7r3J0fsLpMETu
         sqUFUaU/ZnMP8zBL/nYY59kPpFC2nM53oEpfJCsI=
Date:   Tue, 07 Sep 2021 19:58:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, David.Laight@aculab.com,
        drew@beagleboard.org, guoren@kernel.org, hch@infradead.org,
        kernel@esmil.dk, linux-mm@kvack.org, mcroce@microsoft.com,
        mick@ics.forth.gr, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com,
        torvalds@linux-foundation.org
Subject:  [patch 101/147] lib/string: optimized memcpy
Message-ID: <20210908025839.81TnA0vU3%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>
Subject: lib/string: optimized memcpy

Patch series "lib/string: optimized mem* functions", v2.

Rewrite the generic mem{cpy,move,set} so that memory is accessed with the
widest size possible, but without doing unaligned accesses.

This was originally posted as C string functions for RISC-V[1], but as
there was no specific RISC-V code, it was proposed for the generic
lib/string.c implementation.

Tested on RISC-V and on x86_64 by undefining __HAVE_ARCH_MEM{CPY,SET,MOVE}
and HAVE_EFFICIENT_UNALIGNED_ACCESS.

These are the performances of memcpy() and memset() of a RISC-V machine on
a 32 mbyte buffer:

memcpy:
original aligned:	 75 Mb/s
original unaligned:	 75 Mb/s
new aligned:		114 Mb/s
new unaligned:		107 Mb/s

memset:
original aligned:	140 Mb/s
original unaligned:	140 Mb/s
new aligned:		241 Mb/s
new unaligned:		241 Mb/s

The size increase is negligible:

$ scripts/bloat-o-meter vmlinux.orig vmlinux
add/remove: 0/0 grow/shrink: 4/1 up/down: 427/-6 (421)
Function                                     old     new   delta
memcpy                                        29     351    +322
memset                                        29     117     +88
strlcat                                       68      78     +10
strlcpy                                       50      57      +7
memmove                                       56      50      -6
Total: Before=8556964, After=8557385, chg +0.00%

These functions will be used for RISC-V initially.

[1] https://lore.kernel.org/linux-riscv/20210617152754.17960-1-mcroce@linux.microsoft.com/

The only architecture which will use all the three function will be riscv,
while memmove() will be used by arc, h8300, hexagon, ia64, openrisc and
parisc.

Keep in mind that memmove() isn't anything special, it just calls memcpy()
when possible (e.g.  buffers not overlapping), and fallbacks to the byte
by byte copy otherwise.

In future we can write two functions, one which copies forward and another
one which copies backward, and call the right one depending on the buffers
position.  Then, we could alias memcpy() and memmove(), as proposed by
Linus: https://bugzilla.redhat.com/show_bug.cgi?id=638477#c132



This patch (of 3):

Rewrite the generic memcpy() to copy a word at time, without generating
unaligned accesses.

The procedure is made of three steps: First copy data one byte at time
until the destination buffer is aligned to a long boundary.  Then copy the
data one long at time shifting the current and the next long to compose a
long at every cycle.  Finally, copy the remainder one byte at time.

This is the improvement on RISC-V:

original aligned:	 75 Mb/s
original unaligned:	 75 Mb/s
new aligned:		114 Mb/s
new unaligned:		107 Mb/s

and this the binary size increase according to bloat-o-meter:

Function     old     new   delta
memcpy        36     324    +288

Link: https://lkml.kernel.org/r/20210702123153.14093-1-mcroce@linux.microsoft.com
Link: https://lkml.kernel.org/r/20210702123153.14093-2-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Nick Kossifidis <mick@ics.forth.gr>
Cc: Guo Ren <guoren@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Drew Fustini <drew@beagleboard.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 3 deletions(-)

--- a/lib/string.c~lib-string-optimized-memcpy
+++ a/lib/string.c
@@ -33,6 +33,23 @@
 #include <asm/word-at-a-time.h>
 #include <asm/page.h>
 
+#define BYTES_LONG	sizeof(long)
+#define WORD_MASK	(BYTES_LONG - 1)
+#define MIN_THRESHOLD	(BYTES_LONG * 2)
+
+/* convenience union to avoid cast between different pointer types */
+union types {
+	u8 *as_u8;
+	unsigned long *as_ulong;
+	uintptr_t as_uptr;
+};
+
+union const_types {
+	const u8 *as_u8;
+	const unsigned long *as_ulong;
+	uintptr_t as_uptr;
+};
+
 #ifndef __HAVE_ARCH_STRNCASECMP
 /**
  * strncasecmp - Case insensitive, length-limited string comparison
@@ -869,6 +886,13 @@ EXPORT_SYMBOL(memset64);
 #endif
 
 #ifndef __HAVE_ARCH_MEMCPY
+
+#ifdef __BIG_ENDIAN
+#define MERGE_UL(h, l, d) ((h) << ((d) * 8) | (l) >> ((BYTES_LONG - (d)) * 8))
+#else
+#define MERGE_UL(h, l, d) ((h) >> ((d) * 8) | (l) << ((BYTES_LONG - (d)) * 8))
+#endif
+
 /**
  * memcpy - Copy one area of memory to another
  * @dest: Where to copy to
@@ -880,14 +904,64 @@ EXPORT_SYMBOL(memset64);
  */
 void *memcpy(void *dest, const void *src, size_t count)
 {
-	char *tmp = dest;
-	const char *s = src;
+	union const_types s = { .as_u8 = src };
+	union types d = { .as_u8 = dest };
+	int distance = 0;
+
+	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+		if (count < MIN_THRESHOLD)
+			goto copy_remainder;
+
+		/* Copy a byte at time until destination is aligned. */
+		for (; d.as_uptr & WORD_MASK; count--)
+			*d.as_u8++ = *s.as_u8++;
+
+		distance = s.as_uptr & WORD_MASK;
+	}
+
+	if (distance) {
+		unsigned long last, next;
 
+		/*
+		 * s is distance bytes ahead of d, and d just reached
+		 * the alignment boundary. Move s backward to word align it
+		 * and shift data to compensate for distance, in order to do
+		 * word-by-word copy.
+		 */
+		s.as_u8 -= distance;
+
+		next = s.as_ulong[0];
+		for (; count >= BYTES_LONG; count -= BYTES_LONG) {
+			last = next;
+			next = s.as_ulong[1];
+
+			d.as_ulong[0] = MERGE_UL(last, next, distance);
+
+			d.as_ulong++;
+			s.as_ulong++;
+		}
+
+		/* Restore s with the original offset. */
+		s.as_u8 += distance;
+	} else {
+		/*
+		 * If the source and dest lower bits are the same, do a simple
+		 * 32/64 bit wide copy.
+		 */
+		for (; count >= BYTES_LONG; count -= BYTES_LONG)
+			*d.as_ulong++ = *s.as_ulong++;
+	}
+
+copy_remainder:
 	while (count--)
-		*tmp++ = *s++;
+		*d.as_u8++ = *s.as_u8++;
+
 	return dest;
 }
 EXPORT_SYMBOL(memcpy);
+
+#undef MERGE_UL
+
 #endif
 
 #ifndef __HAVE_ARCH_MEMMOVE
_

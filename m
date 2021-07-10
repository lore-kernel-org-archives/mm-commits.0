Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CDCC07E95
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A116135D
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 21:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhGJVeT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 17:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhGJVeS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 17:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CB3061353;
        Sat, 10 Jul 2021 21:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625952693;
        bh=picFxzJUoGjoBA7YVdbtcznLqOgP6wU2p0FLwS5U0EM=;
        h=Date:From:To:Subject:From;
        b=cKJqopW9lYqX6K7UgCgdfZFTN6PhxzCd3yraV4FWobMYbRbEunAVjm0w3qQ8TQHFb
         5HMSg5Y7QDPW1Z75m2oXt+efX7zSv57vsYV0TexYGAKXd0NIsBoCzod9XPdmQWxoDw
         rXx3FDlLPzDAI50z9gu9hh6FvftEAOzQu27qalaw=
Date:   Sat, 10 Jul 2021 14:31:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, palmer@dabbelt.com,
        ndesaulniers@google.com, mick@ics.forth.gr, kernel@esmil.dk,
        hch@infradead.org, guoren@kernel.org, drew@beagleboard.org,
        David.Laight@aculab.com, mcroce@microsoft.com
Subject:  + lib-string-optimized-memcpy.patch added to -mm tree
Message-ID: <20210710213132.Am5PY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: optimized memcpy
has been added to the -mm tree.  Its filename is
     lib-string-optimized-memcpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-string-optimized-memcpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-string-optimized-memcpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mcroce@microsoft.com are

revert-mm-page_alloc-make-should_fail_alloc_page-static.patch
lib-string-optimized-memcpy.patch
lib-string-optimized-memmove.patch
lib-string-optimized-memset.patch


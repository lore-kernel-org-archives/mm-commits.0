From: akpm@linux-foundation.org
Subject: +
 bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit.patch added to
 -mm tree
Date: Thu, 29 Jun 2017 15:21:17 -0700
Message-ID: <59557d5d./lVyAKsYuk0TP7Ri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbdF2WVS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 18:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, linux@rasmusvillemoes.dk, schwidefsky@de.ibm.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: optimise bitmap_set and bitmap_clear of a single bit
has been added to the -mm tree.  Its filename is
     bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: bitmap: optimise bitmap_set and bitmap_clear of a single bit

We have eight users calling bitmap_clear for a single bit and seventeen
calling bitmap_set for a single bit.  Rather than fix all of them to call
__clear_bit or __set_bit, turn bitmap_clear and bitmap_set into inline
functions and make this special case efficient.

Link: http://lkml.kernel.org/r/20170628153221.11322-3-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   23 ++++++++++++++++++++---
 lib/bitmap.c           |    8 ++++----
 lib/test_bitmap.c      |    3 ---
 3 files changed, 24 insertions(+), 10 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit
+++ a/include/linux/bitmap.h
@@ -112,9 +112,8 @@ extern int __bitmap_intersects(const uns
 extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
-
-extern void bitmap_set(unsigned long *map, unsigned int start, int len);
-extern void bitmap_clear(unsigned long *map, unsigned int start, int len);
+extern void __bitmap_set(unsigned long *map, unsigned int start, int len);
+extern void __bitmap_clear(unsigned long *map, unsigned int start, int len);
 
 extern unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
 						    unsigned long size,
@@ -315,6 +314,24 @@ static __always_inline int bitmap_weight
 	return __bitmap_weight(src, nbits);
 }
 
+static __always_inline void bitmap_set(unsigned long *map, unsigned int start,
+		unsigned int nbits)
+{
+	if (__builtin_constant_p(nbits) && nbits == 1)
+		__set_bit(start, map);
+	else
+		__bitmap_set(map, start, nbits);
+}
+
+static __always_inline void bitmap_clear(unsigned long *map, unsigned int start,
+		unsigned int nbits)
+{
+	if (__builtin_constant_p(nbits) && nbits == 1)
+		__clear_bit(start, map);
+	else
+		__bitmap_clear(map, start, nbits);
+}
+
 static inline void bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 				unsigned int shift, int nbits)
 {
diff -puN lib/bitmap.c~bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit lib/bitmap.c
--- a/lib/bitmap.c~bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit
+++ a/lib/bitmap.c
@@ -251,7 +251,7 @@ int __bitmap_weight(const unsigned long
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
-void bitmap_set(unsigned long *map, unsigned int start, int len)
+void __bitmap_set(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
 	const unsigned int size = start + len;
@@ -270,9 +270,9 @@ void bitmap_set(unsigned long *map, unsi
 		*p |= mask_to_set;
 	}
 }
-EXPORT_SYMBOL(bitmap_set);
+EXPORT_SYMBOL(__bitmap_set);
 
-void bitmap_clear(unsigned long *map, unsigned int start, int len)
+void __bitmap_clear(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
 	const unsigned int size = start + len;
@@ -291,7 +291,7 @@ void bitmap_clear(unsigned long *map, un
 		*p &= ~mask_to_clear;
 	}
 }
-EXPORT_SYMBOL(bitmap_clear);
+EXPORT_SYMBOL(__bitmap_clear);
 
 /**
  * bitmap_find_next_zero_area_off - find a contiguous aligned zero area
diff -puN lib/test_bitmap.c~bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit lib/test_bitmap.c
--- a/lib/test_bitmap.c~bitmap-optimise-bitmap_set-and-bitmap_clear-of-a-single-bit
+++ a/lib/test_bitmap.c
@@ -333,9 +333,6 @@ static void __init test_bitmap_u32_array
 	}
 }
 
-#define __bitmap_set(a, b, c)	bitmap_set(a, b, c)
-#define __bitmap_clear(a, b, c)	bitmap_clear(a, b, c)

From: akpm@linux-foundation.org
Subject: [merged]
 turn-bitmap_set-and-bitmap_clear-into-memset-when-possible.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:26:24 -0700
Message-ID: <20170711192624.gcQlnul7a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbdGKT0Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, willy@infradead.org


The patch titled
     Subject: include/linux/bitmap.h: turn bitmap_set and bitmap_clear into memset when possible
has been removed from the -mm tree.  Its filename was
     turn-bitmap_set-and-bitmap_clear-into-memset-when-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: include/linux/bitmap.h: turn bitmap_set and bitmap_clear into memset when possible

Several callers have constant 'start' and an 'nbits' that is a multiple of
8, so we can turn them into calls to memset.  We don't need the entirety
of 'start' and 'nbits' to be constant, we just need to know whether
they're divisible by 8.

Link: http://lkml.kernel.org/r/20170628153221.11322-4-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/bitmap.h~turn-bitmap_set-and-bitmap_clear-into-memset-when-possible include/linux/bitmap.h
--- a/include/linux/bitmap.h~turn-bitmap_set-and-bitmap_clear-into-memset-when-possible
+++ a/include/linux/bitmap.h
@@ -319,6 +319,9 @@ static __always_inline void bitmap_set(u
 {
 	if (__builtin_constant_p(nbits) && nbits == 1)
 		__set_bit(start, map);
+	else if (__builtin_constant_p(start & 7) && IS_ALIGNED(start, 8) &&
+		 __builtin_constant_p(nbits & 7) && IS_ALIGNED(nbits, 8))
+		memset((char *)map + start / 8, 0xff, nbits / 8);
 	else
 		__bitmap_set(map, start, nbits);
 }
@@ -328,6 +331,9 @@ static __always_inline void bitmap_clear
 {
 	if (__builtin_constant_p(nbits) && nbits == 1)
 		__clear_bit(start, map);
+	else if (__builtin_constant_p(start & 7) && IS_ALIGNED(start, 8) &&
+		 __builtin_constant_p(nbits & 7) && IS_ALIGNED(nbits, 8))
+		memset((char *)map + start / 8, 0, nbits / 8);
 	else
 		__bitmap_clear(map, start, nbits);
 }
_

Patches currently in -mm which might be from mawilcox@microsoft.com are



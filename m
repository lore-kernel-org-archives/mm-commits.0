From: akpm@linux-foundation.org
Subject: [merged] lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:17 -0800
Message-ID: <54e24fd5.YiDG0UYc0giIANV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbbBPUPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:15:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: elide bitmap_copy_le on little-endian
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/bitmap.c: elide bitmap_copy_le on little-endian

On little-endian, there's no reason to have an extra, presumably less
efficient, way of copying a bitmap.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++++
 lib/bitmap.c           |    2 ++
 2 files changed, 6 insertions(+)

diff -puN include/linux/bitmap.h~lib-bitmapc-elide-bitmap_copy_le-on-little-endian include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmapc-elide-bitmap_copy_le-on-little-endian
+++ a/include/linux/bitmap.h
@@ -170,7 +170,11 @@ extern void bitmap_fold(unsigned long *d
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
+#ifdef __BIG_ENDIAN
 extern void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits);
+#else
+#define bitmap_copy_le bitmap_copy
+#endif
 extern unsigned int bitmap_ord_to_pos(const unsigned long *bitmap, unsigned int ord, unsigned int nbits);
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
diff -puN lib/bitmap.c~lib-bitmapc-elide-bitmap_copy_le-on-little-endian lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-elide-bitmap_copy_le-on-little-endian
+++ a/lib/bitmap.c
@@ -1191,6 +1191,7 @@ EXPORT_SYMBOL(bitmap_allocate_region);
  *
  * Require nbits % BITS_PER_LONG == 0.
  */
+#ifdef __BIG_ENDIAN
 void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits)
 {
 	unsigned int i;
@@ -1203,3 +1204,4 @@ void bitmap_copy_le(unsigned long *dst,
 	}
 }
 EXPORT_SYMBOL(bitmap_copy_le);
+#endif
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: [merged] lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:14 -0800
Message-ID: <54e24fd2.dLGwAAoFGN0M3K20%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbbBPUPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:15:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: change prototype of bitmap_copy_le
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-change-prototype-of-bitmap_copy_le.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/bitmap.c: change prototype of bitmap_copy_le

Make the prototype of bitmap_copy_le the same as bitmap_copy's.  All other
bitmap_* functions take unsigned long* parameters; there's no reason this
should be special.

The only current user is the static inline uwb_mas_bm_copy_le, which
already does the void* laundering, so the end users can pass their u8 or
__le32 buffers without a cast.

Furthermore, this allows us to simply let bitmap_copy_le be an alias for
bitmap_copy on little-endian; see next patch.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmapc-change-prototype-of-bitmap_copy_le include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmapc-change-prototype-of-bitmap_copy_le
+++ a/include/linux/bitmap.h
@@ -170,7 +170,7 @@ extern void bitmap_fold(unsigned long *d
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
-extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
+extern void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits);
 extern unsigned int bitmap_ord_to_pos(const unsigned long *bitmap, unsigned int ord, unsigned int nbits);
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
diff -puN lib/bitmap.c~lib-bitmapc-change-prototype-of-bitmap_copy_le lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-change-prototype-of-bitmap_copy_le
+++ a/lib/bitmap.c
@@ -1191,16 +1191,15 @@ EXPORT_SYMBOL(bitmap_allocate_region);
  *
  * Require nbits % BITS_PER_LONG == 0.
  */
-void bitmap_copy_le(void *dst, const unsigned long *src, int nbits)
+void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits)
 {
-	unsigned long *d = dst;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < nbits/BITS_PER_LONG; i++) {
 		if (BITS_PER_LONG == 64)
-			d[i] = cpu_to_le64(src[i]);
+			dst[i] = cpu_to_le64(src[i]);
 		else
-			d[i] = cpu_to_le32(src[i]);
+			dst[i] = cpu_to_le32(src[i]);
 	}
 }
 EXPORT_SYMBOL(bitmap_copy_le);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


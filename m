From: akpm@linux-foundation.org
Subject: - hash-add-explicit-u32-and-u64-versions-of-hash.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:39 -0800
Message-ID: <200802070020.m170KKqp006115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933856AbYBGAU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, willy@linux.intel.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hash: add explicit u32 and u64 versions of hash
has been removed from the -mm tree.  Its filename was
     hash-add-explicit-u32-and-u64-versions-of-hash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hash: add explicit u32 and u64 versions of hash
From: Matthew Wilcox <matthew@wil.cx>

The 32-bit version is more efficient (and apparently gives better hash
results than the 64-bit version), so users who are only hashing a 32-bit
quantity can now opt to use the 32-bit version explicitly, rather than
promoting to a long.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hash.h |   42 ++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff -puN include/linux/hash.h~hash-add-explicit-u32-and-u64-versions-of-hash include/linux/hash.h
--- a/include/linux/hash.h~hash-add-explicit-u32-and-u64-versions-of-hash
+++ a/include/linux/hash.h
@@ -1,6 +1,6 @@
 #ifndef _LINUX_HASH_H
 #define _LINUX_HASH_H
-/* Fast hashing routine for a long.
+/* Fast hashing routine for ints,  longs and pointers.
    (C) 2002 William Lee Irwin III, IBM */
 
 /*
@@ -13,23 +13,30 @@
  * them can use shifts and additions instead of multiplications for
  * machines where multiplications are slow.
  */
-#if BITS_PER_LONG == 32
+
+#include <asm/types.h>
+
 /* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
-#define GOLDEN_RATIO_PRIME 0x9e370001UL
-#elif BITS_PER_LONG == 64
+#define GOLDEN_RATIO_PRIME_32 0x9e370001UL
 /*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
-#define GOLDEN_RATIO_PRIME 0x9e37fffffffc0001UL
+#define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001UL
+
+#if BITS_PER_LONG == 32
+#define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_32
+#define hash_long(val, bits) hash_32(val, bits)
+#elif BITS_PER_LONG == 64
+#define hash_long(val, bits) hash_64(val, bits)
+#define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_64
 #else
-#error Define GOLDEN_RATIO_PRIME for your wordsize.
+#error Wordsize not 32 or 64
 #endif
 
-static inline unsigned long hash_long(unsigned long val, unsigned int bits)
+static inline u64 hash_64(u64 val, unsigned int bits)
 {
-	unsigned long hash = val;
+	u64 hash = val;
 
-#if BITS_PER_LONG == 64
 	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
-	unsigned long n = hash;
+	u64 n = hash;
 	n <<= 18;
 	hash -= n;
 	n <<= 33;
@@ -42,15 +49,20 @@ static inline unsigned long hash_long(un
 	hash += n;
 	n <<= 2;
 	hash += n;
-#else
+
+	/* High bits are more random, so use them. */
+	return hash >> (64 - bits);
+}
+
+static inline u32 hash_32(u32 val, unsigned int bits)
+{
 	/* On some cpus multiply is faster, on others gcc will do shifts */
-	hash *= GOLDEN_RATIO_PRIME;
-#endif
+	u32 hash = val * GOLDEN_RATIO_PRIME_32;
 
 	/* High bits are more random, so use them. */
-	return hash >> (BITS_PER_LONG - bits);
+	return hash >> (32 - bits);
 }
-	
+
 static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
 {
 	return hash_long((unsigned long)ptr, bits);
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
git-scsi-misc.patch
make-sure-nobodys-leaking-resources.patch

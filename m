From: akpm@linux-foundation.org
Subject: [failures] lib-bitmapc-speed-up-bitmap_find_free_region.patch
 removed from -mm tree
Date: Fri, 31 May 2013 12:04:13 -0700
Message-ID: <51a8f42d.JngL33fPGDVIFQTy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3EaTEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 15:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nyc@holomorphy.com, joe@perches.com, jkosina@suse.cz, anish198519851985@gmail.com, chanho.min@lge.com

Subject: [failures] lib-bitmapc-speed-up-bitmap_find_free_region.patch removed from -mm tree
To: chanho.min@lge.com,anish198519851985@gmail.com,jkosina@suse.cz,joe@perches.com,nyc@holomorphy.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 12:04:13 -0700


The patch titled
     Subject: lib/bitmap.c: speed up bitmap_find_free_region
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-speed-up-bitmap_find_free_region.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: lib/bitmap.c: speed up bitmap_find_free_region

In bitmap_find_free_region(), if we skip the all-ones words and find bits
in a not-all-ones word, we can improve performance of it.

For example, If bitmap_find_free_region() is called with order=0, First,
It scans bitmap array by the increment of long type, then find 1 free bit
within 1 long type value.  In 32 bits system and 1024 bits size, in the
worst case, We need 1024 for-loops to find 1 free bit.  But, If this is
applied, it takes 64 for-loops.  Instead, It will be needed additional
if-comparison of every word and It can take time slightly as 'Test case
3'.  But, In many cases, It will speed up significantly.

Test cases bellows show the time taken to execute bitmap_find_free_region()
before and after patch.

Test condition : ARMv7 1GHZ 32 bits system, 1024 bits size, gcc 4.6.2

Test case 1: order is 0. all bits are one except that last one bit is zero.
 before patch: 29727 ns
 after patch: 2349 ns

Test case 2: order is 1. all bits are one except that last 2 contiguous bits
are zero.
 before patch: 15475 ns
 after patch: 2225 ns

Test case 3: order is 1. all words are not-all-ones and don't have 2 contiguous
bits except that last 2 contiguous are zero.
 before patch: 15475 ns
 after patch: 16131 ns

[akpm@linux-foundation.org: reduce scope of locals, remove barely comprehensible comment]
Signed-off-by: Chanho Min <chanho.min@lge.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region
+++ a/lib/bitmap.c
@@ -1114,14 +1114,23 @@ done:
  */
 int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
 {
-	int pos, end;		/* scans bitmap by regions of size order */
+	int nlongs = BITS_TO_LONGS(bits);
+	int i;
 
-	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
-		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
-			continue;
-		__reg_op(bitmap, pos, order, REG_OP_ALLOC);
-		return pos;
-	}
+	for (i = 0; i < nlongs; i++)
+		if (bitmap[i] != ~0UL) {
+			int pos = i * BITS_PER_LONG;
+			int nbit = min(bits, pos + BITS_PER_LONG);
+			int end;
+
+			for (; (end = pos + (1 << order)) <= nbit; pos = end) {
+				if (!__reg_op(bitmap, pos, order,
+					REG_OP_ISFREE))
+					continue;
+				__reg_op(bitmap, pos, order, REG_OP_ALLOC);
+				return pos;
+			}
+		}
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(bitmap_find_free_region);
_

Patches currently in -mm which might be from chanho.min@lge.com are

lib-add-weak-clz-ctz-functions.patch
lib-add-support-for-lz4-compressed-kernel-kbuild-fix-for-updated-lz4-tool-with-the-new-streaming-format.patch
lib-add-lz4-compressor-module.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch


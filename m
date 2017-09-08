From: akpm@linux-foundation.org
Subject: [folded-merged]
 bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch removed from -mm
 tree
Date: Fri, 08 Sep 2017 16:04:28 -0700
Message-ID: <59b321fc.rVoYtypo0rTHd7mm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757210AbdIHXE3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch

This patch was dropped because it was folded into bitmap-introduce-bitmap_from_u64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes

tweak code comment

Cc: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes
+++ a/include/linux/bitmap.h
@@ -363,27 +363,27 @@ static inline int bitmap_parse(const cha
 /*
  * BITMAP_FROM_U64() - Represent u64 value in the format suitable for bitmap.
  *
- * Linux bitmaps are internally the arrays on unsigned longs, i.e. 32-bit
+ * Linux bitmaps are internally arrays of unsigned longs, i.e. 32-bit
  * integers in 32-bit environment, and 64-bit integers in 64-bit one.
  *
- * There are four combinations of endianess and length of the word in linux ABIs:
- * LE64, BE64, LE32 and BE32.
+ * There are four combinations of endianess and length of the word in linux
+ * ABIs: LE64, BE64, LE32 and BE32.
  *
  * On 64-bit kernels 64-bit LE and BE numbers are naturally ordered in
  * bitmaps and therefore don't require any special handling.
  *
- * On 32-bit kernels 32-bit LE ABI orders lo word of 64-bit number in the memory
- * prior to hi, and 32-bit BE orders hi word prior to lo. The bitmap in other
- * hand is represented as the array of 32-bit words, and the position of the
+ * On 32-bit kernels 32-bit LE ABI orders lo word of 64-bit number in memory
+ * prior to hi, and 32-bit BE orders hi word prior to lo. The bitmap on the
+ * other hand is represented as an array of 32-bit words and the position of
  * bit N may therefore be calculated as: word #(N/32) and bit #(N%32) in that
- * word. For example, bit #42 is located at 10th position of 2nd word.
+ * word.  For example, bit #42 is located at 10th position of 2nd word.
  * It matches 32-bit LE ABI, and we can simply let the compiler store 64-bit
- * value on the memory as it usually does. But for BE we therefore need to swap
- * hi and lo words manually.
+ * values in memory as it usually does. But for BE we need to swap hi and lo
+ * words manually.
  *
- * With all that, the macro BITMAP_FROM_U64() does explicit reorder of hi and lo
- * parts of u64. For LE32 it does nothing in fact, and for BE environment it
- * swaps hi and lo words, as it expected by bitmap.
+ * With all that, the macro BITMAP_FROM_U64() does explicit reordering of hi and
+ * lo parts of u64.  For LE32 it does nothing, and for BE environment it swaps
+ * hi and lo words, as is expected by bitmap.
  */
 #if __BITS_PER_LONG == 64
 #define BITMAP_FROM_U64(n) (n)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bitmap-introduce-bitmap_from_u64.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch


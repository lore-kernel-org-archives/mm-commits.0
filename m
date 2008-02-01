From: akpm@linux-foundation.org
Subject: + ia64-slim-down-__clear_bit_unlock.patch added to -mm tree
Date: Thu, 31 Jan 2008 16:02:55 -0800
Message-ID: <200802010002.m1102uD2018079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964809AbYBAADs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 19:03:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Zoltan.Menyhart@bull.net, npiggin@suse.de, tony.luck@intel.com


The patch titled
     IA64: slim down __clear_bit_unlock()
has been added to the -mm tree.  Its filename is
     ia64-slim-down-__clear_bit_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IA64: slim down __clear_bit_unlock()
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>

- I removed the unnecessary barrier() from __clear_bit_unlock().
  ia64_st4_rel_nta() makes sure all the modifications are globally
  seen before the bit is seen to be off.
- I made __clear_bit() modeled after __set_bit() and __change_bit().
- I corrected some comments sating that a memory barrier is provided,
  yet in reality, it is the acquisition side of the memory barrier only.
- I corrected some comments, e.g. test_and_clear_bit() was peaking
  about "bit to set".

Here is the code generated from my and the old versions.
(Though I do not know why "and" is moved in the 2nd bundle.):

test_new()
{
        __clear_bit_unlock(3, &data);
}

test_old()
{
        old__clear_bit_unlock(3, &data);
}

0000000000000000 <test_new>:
   0:   02 00 00 00 01 00       [MII]       nop.m 0x0
   6:   e0 00 04 00 48 00                   addl r14=0,r1;;
   c:   00 00 04 00                         nop.i 0x0
  10:   0b 10 00 1c 10 10       [MMI]       ld4 r2=[r14];;
  16:   f0 b8 0b 58 44 00                   and r15=-9,r2
  1c:   00 00 04 00                         nop.i 0x0;;
  20:   0a 00 3c 1c b6 11       [MMI]       st4.rel.nta [r14]=r15;;
  26:   00 00 00 02 00 00                   nop.m 0x0
  2c:   01 70 00 84                         mov r8=r14
  30:   1d 00 00 00 01 00       [MFB]       nop.m 0x0
  36:   00 00 00 02 00 80                   nop.f 0x0
  3c:   08 00 84 00                         br.ret.sptk.many b0;;

0000000000000040 <test_old>:
  40:   02 00 00 00 01 00       [MII]       nop.m 0x0
  46:   e0 00 04 00 48 00                   addl r14=0,r1;;
  4c:   00 00 04 00                         nop.i 0x0
  50:   03 10 00 1c b0 10       [MII]       ld4.acq r2=[r14]
  56:   00 00 00 02 00 e0                   nop.i 0x0;;
  5c:   71 17 b0 88                         and r15=-9,r2;;
  60:   0a 00 3c 1c b6 11       [MMI]       st4.rel.nta [r14]=r15;;
  66:   00 00 00 02 00 00                   nop.m 0x0
  6c:   01 70 00 84                         mov r8=r14
  70:   1d 00 00 00 01 00       [MFB]       nop.m 0x0
  76:   00 00 00 02 00 80                   nop.f 0x0
  7c:   08 00 84 00                         br.ret.sptk.many b0;;

Signed-off-by: Zoltan Menyhart, <Zoltan.Menyhart@bull.net>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/bitops.h |   50 ++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff -puN include/asm-ia64/bitops.h~ia64-slim-down-__clear_bit_unlock include/asm-ia64/bitops.h
--- a/include/asm-ia64/bitops.h~ia64-slim-down-__clear_bit_unlock
+++ a/include/asm-ia64/bitops.h
@@ -122,38 +122,40 @@ clear_bit_unlock (int nr, volatile void 
 }
 
 /**
- * __clear_bit_unlock - Non-atomically clear a bit with release
+ * __clear_bit_unlock - Non-atomically clears a bit in memory with release
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
  *
- * This is like clear_bit_unlock, but the implementation uses a store
+ * Similarly to clear_bit_unlock, the implementation uses a store
  * with release semantics. See also __raw_spin_unlock().
  */
 static __inline__ void
-__clear_bit_unlock(int nr, volatile void *addr)
+__clear_bit_unlock(int nr, void *addr)
 {
-	__u32 mask, new;
-	volatile __u32 *m;
+	__u32 * const m = (__u32 *) addr + (nr >> 5);
+	__u32 const new = *m & ~(1 << (nr & 31));
 
-	m = (volatile __u32 *)addr + (nr >> 5);
-	mask = ~(1 << (nr & 31));
-	new = *m & mask;
-	barrier();
 	ia64_st4_rel_nta(m, new);
 }
 
 /**
  * __clear_bit - Clears a bit in memory (non-atomic version)
+ * @nr: the bit to clear
+ * @addr: the address to start counting from
+ *
+ * Unlike clear_bit(), this function is non-atomic and may be reordered.
+ * If it's called on the same region of memory simultaneously, the effect
+ * may be that only one operation succeeds.
  */
 static __inline__ void
 __clear_bit (int nr, volatile void *addr)
 {
-	volatile __u32 *p = (__u32 *) addr + (nr >> 5);
-	__u32 m = 1 << (nr & 31);
-	*p &= ~m;
+	*((__u32 *) addr + (nr >> 5)) &= ~(1 << (nr & 31));
 }
 
 /**
  * change_bit - Toggle a bit in memory
- * @nr: Bit to clear
+ * @nr: Bit to toggle
  * @addr: Address to start counting from
  *
  * change_bit() is atomic and may not be reordered.
@@ -178,7 +180,7 @@ change_bit (int nr, volatile void *addr)
 
 /**
  * __change_bit - Toggle a bit in memory
- * @nr: the bit to set
+ * @nr: the bit to toggle
  * @addr: the address to start counting from
  *
  * Unlike change_bit(), this function is non-atomic and may be reordered.
@@ -197,7 +199,7 @@ __change_bit (int nr, volatile void *add
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.  
- * It also implies a memory barrier.
+ * It also implies the acquisition side of the memory barrier.
  */
 static __inline__ int
 test_and_set_bit (int nr, volatile void *addr)
@@ -247,11 +249,11 @@ __test_and_set_bit (int nr, volatile voi
 
 /**
  * test_and_clear_bit - Clear a bit and return its old value
- * @nr: Bit to set
+ * @nr: Bit to clear
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.  
- * It also implies a memory barrier.
+ * It also implies the acquisition side of the memory barrier.
  */
 static __inline__ int
 test_and_clear_bit (int nr, volatile void *addr)
@@ -272,7 +274,7 @@ test_and_clear_bit (int nr, volatile voi
 
 /**
  * __test_and_clear_bit - Clear a bit and return its old value
- * @nr: Bit to set
+ * @nr: Bit to clear
  * @addr: Address to count from
  *
  * This operation is non-atomic and can be reordered.  
@@ -292,11 +294,11 @@ __test_and_clear_bit(int nr, volatile vo
 
 /**
  * test_and_change_bit - Change a bit and return its old value
- * @nr: Bit to set
+ * @nr: Bit to change
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.  
- * It also implies a memory barrier.
+ * It also implies the acquisition side of the memory barrier.
  */
 static __inline__ int
 test_and_change_bit (int nr, volatile void *addr)
@@ -315,8 +317,12 @@ test_and_change_bit (int nr, volatile vo
 	return (old & bit) != 0;
 }
 
-/*
- * WARNING: non atomic version.
+/**
+ * __test_and_change_bit - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is non-atomic and can be reordered.
  */
 static __inline__ int
 __test_and_change_bit (int nr, void *addr)
_

Patches currently in -mm which might be from Zoltan.Menyhart@bull.net are

ia64-slim-down-__clear_bit_unlock.patch

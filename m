From: akpm@linux-foundation.org
Subject: [to-be-updated] bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:34 -0800
Message-ID: <201101131947.p0DJlFV8028847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072Ab1AMTrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:47:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     bitops: use find_first_zero_bit() instead of find_next_zero_bit(addr, size, 0)
has been removed from the -mm tree.  Its filename was
     bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: use find_first_zero_bit() instead of find_next_zero_bit(addr, size, 0)
From: Akinobu Mita <akinobu.mita@gmail.com>

The little-endian bitops patch series introduced inefficiency to some
little-endian architectures.

include/asm-generic/bitops/le.h defines find_first_zero_le_bit() like this:

	#define find_first_zero_le_bit(addr, size) \
		find_next_zero_le_bit((addr), (size), 0)

All little-endian architectures include le.h and little-endian bitops
are just aliases for their native endian bitops. So above macro definision
is converted to:

	#define find_first_zero_le_bit(addr, size) \
		find_next_zero_bit(addr, size, 0)

This is inefficient for some architectures which have faster
find_first_zero_bit() than find_next_zero_bit(addr, size, 0).

Fix it by aliasing find_first_zero_bit() to find_first_zero_le_bit()
on little-endian architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/le.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/bitops/le.h~bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0 include/asm-generic/bitops/le.h
--- a/include/asm-generic/bitops/le.h~bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0
+++ a/include/asm-generic/bitops/le.h
@@ -12,6 +12,8 @@
 	find_next_zero_bit(addr, size, offset)
 #define find_next_le_bit(addr, size, offset) \
 	find_next_bit(addr, size, offset)
+#define find_first_zero_le_bit(addr, size) \
+	find_first_zero_bit(addr, size)
 
 #elif defined(__BIG_ENDIAN)
 
@@ -22,6 +24,9 @@ extern unsigned long find_next_zero_le_b
 extern unsigned long find_next_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
 
+#define find_first_zero_le_bit(addr, size) \
+	find_next_zero_le_bit((addr), (size), 0)
+
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
@@ -43,7 +48,4 @@ extern unsigned long find_next_le_bit(co
 #define __test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-#define find_first_zero_le_bit(addr, size) \
-	find_next_zero_le_bit((addr), (size), 0)

From: akpm@linux-foundation.org
Subject: [merged] bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:32 -0700
Message-ID: <201103250723.p2P7NQCO025727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1CYHXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     bitops: merge little and big endian definisions in asm-generic/bitops/le.h
has been removed from the -mm tree.  Its filename was
     bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: merge little and big endian definisions in asm-generic/bitops/le.h
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch series introduces little-endian bit operations in asm/bitops.h
for all architectures and converts all ext2 non-atomic and minix bit
operations to use little-endian bit operations.  It enables us to remove
ext2 non-atomic and minix bit operations from asm/bitops.h.  The reason
they should be removed from asm/bitops.h is as follows:

For ext2 non-atomic bit operations, they are used for little-endian byte
order bitmap access by some filesystems and modules.  But using ext2_*()
functions on a module other than ext2 filesystem makes some feel strange.

For minix bit operations, they are only used by minix filesystem and are
useless by other modules.  Because byte order of inode and block bitmap is

This patch:

In order to make the forthcoming changes smaller, this merges macro
definisions in asm-generic/bitops/le.h for big-endian and little-endian as
much as possible.

This also removes unused BITOP_WORD macro.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/le.h |   46 +++++++++++++-----------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff -puN include/asm-generic/bitops/le.h~bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh include/asm-generic/bitops/le.h
--- a/include/asm-generic/bitops/le.h~bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh
+++ a/include/asm-generic/bitops/le.h
@@ -4,27 +4,33 @@
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
-
 #if defined(__LITTLE_ENDIAN)
 
-#define generic_test_le_bit(nr, addr) test_bit(nr, addr)
-#define generic___set_le_bit(nr, addr) __set_bit(nr, addr)
-#define generic___clear_le_bit(nr, addr) __clear_bit(nr, addr)
-
-#define generic_test_and_set_le_bit(nr, addr) test_and_set_bit(nr, addr)
-#define generic_test_and_clear_le_bit(nr, addr) test_and_clear_bit(nr, addr)
-
-#define generic___test_and_set_le_bit(nr, addr) __test_and_set_bit(nr, addr)
-#define generic___test_and_clear_le_bit(nr, addr) __test_and_clear_bit(nr, addr)
+#define BITOP_LE_SWIZZLE	0
 
-#define generic_find_next_zero_le_bit(addr, size, offset) find_next_zero_bit(addr, size, offset)
+#define generic_find_next_zero_le_bit(addr, size, offset) \
+	find_next_zero_bit(addr, size, offset)
 #define generic_find_next_le_bit(addr, size, offset) \
-			find_next_bit(addr, size, offset)
+	find_next_bit(addr, size, offset)
+#define generic_find_first_zero_le_bit(addr, size) \
+	find_first_zero_bit(addr, size)
 
 #elif defined(__BIG_ENDIAN)
 
+#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
+
+extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+#define generic_find_first_zero_le_bit(addr, size) \
+	generic_find_next_zero_le_bit((addr), (size), 0)
+
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+
 #define generic_test_le_bit(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 #define generic___set_le_bit(nr, addr) \
@@ -42,16 +48,4 @@
 #define generic___test_and_clear_le_bit(nr, addr) \
 	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 
-extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#define generic_find_first_zero_le_bit(addr, size) \
-        generic_find_next_zero_le_bit((addr), (size), 0)

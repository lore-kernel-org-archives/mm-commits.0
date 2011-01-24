From: akpm@linux-foundation.org
Subject: + bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:05:49 -0800
Message-ID: <201101242205.p0OM5nbL013326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab1AXWF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, akpm@linux-foundation.org, arnd@arndb.de


The patch titled
     bitops: merge little and big endian definisions in asm-generic/bitops/le.h
has been added to the -mm tree.  Its filename is
     bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
-
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

smp-move-smp-setup-functions-to-kernel-smpc.patch
kvm-stop-including-asm-generic-bitops-leh-directly.patch
rds-stop-including-asm-generic-bitops-leh-directly.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
asm-generic-rename-generic-little-endian-bitops-functions.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
powerpc-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
bitops-introduce-config_generic_find_bit_le.patch
m68knommu-introduce-little-endian-bitops.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
asm-generic-use-little-endian-bitops.patch
kvm-use-little-endian-bitops.patch
rds-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bitops.patch
dm-use-little-endian-bitops.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch


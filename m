From: akpm@linux-foundation.org
Subject: + bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch added to -mm tree
Date: Mon, 29 Nov 2010 13:41:06 -0800
Message-ID: <201011292141.oATLf6Gn012683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab0K2Vln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 16:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de


The patch titled
     bitops: use find_first_zero_bit() instead of find_next_zero_bit(addr, size, 0)
has been added to the -mm tree.  Its filename is
     bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch

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
-
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
rds-stop-including-asm-generic-bitops-leh.patch
kvm-stop-including-asm-generic-bitops-leh.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch
bitops-introduce-config_generic_find_le_bit.patch


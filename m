From: akpm@linux-foundation.org
Subject: + arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch added to -mm tree
Date: Thu, 27 Jan 2011 14:39:53 -0800
Message-ID: <201101272239.p0RMdrZS003892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab1A0WkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 17:40:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, rmk+kernel@arm.linux.org.uk


The patch titled
     arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions
has been added to the -mm tree.  Its filename is
     arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch

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
Subject: arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions
From: Akinobu Mita <akinobu.mita@gmail.com>

(This patch is intended to be folded into the patch in -mm:
arm-introduce-little-endian-bitops.patch)

The little-endian bitops on arm are written as preprocessor
macros with the cast to "unsigned long *".
This means that even non-pointers will be accepted without an error, and
that is a Very Bad Thing.

This converts the little-endian bitops macros to static inline functions
with proper prototypes.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bitops.h |   70 ++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 20 deletions(-)

diff -puN arch/arm/include/asm/bitops.h~arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions
+++ a/arch/arm/include/asm/bitops.h
@@ -287,26 +287,56 @@ static inline int fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-#define __set_bit_le(nr, p)			\
-	__set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define __clear_bit_le(nr, p)			\
-	__clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define __test_and_set_bit_le(nr, p)			\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define test_and_set_bit_le(nr, p)          \
-		test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define __test_and_clear_bit_le(nr, p)			\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define test_and_clear_bit_le(nr, p)	\
-		test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define test_bit_le(nr, p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define find_first_zero_bit_le(p, sz)		\
-		_find_first_zero_bit_le(p, sz)
-#define find_next_zero_bit_le(p, sz, off)	\
-		_find_next_zero_bit_le(p, sz, off)
-#define find_next_bit_le(p, sz, off) \
-		_find_next_bit_le((unsigned long *)(p), sz, off)
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, void *addr)
+{
+	return __test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int test_and_set_bit_le(int nr, void *addr)
+{
+	return test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int __test_and_clear_bit_le(int nr, void *addr)
+{
+	return __test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int test_and_clear_bit_le(int nr, void *addr)
+{
+	return test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int test_bit_le(int nr, const void *addr)
+{
+	return test_bit(WORD_BITOFF_TO_LE(nr), addr);
+}
+
+static inline int find_first_zero_bit_le(const void *p, unsigned size)
+{
+	return _find_first_zero_bit_le(p, size);
+}
+
+static inline int find_next_zero_bit_le(const void *p, int size, int offset)
+{
+	return _find_next_zero_bit_le(p, size, offset);
+}
+
+static inline int find_next_bit_le(const void *p, int size, int offset)
+{
+	return _find_next_bit_le(p, size, offset);
+}
+
 /*
  * Ext2 is defined to use little-endian byte ordering.
  * These do not need to be atomic.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch
kvm-stop-including-asm-generic-bitops-leh-directly.patch
rds-stop-including-asm-generic-bitops-leh-directly.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
asm-generic-rename-generic-little-endian-bitops-functions.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types-convert-little-endian-bitops-macros-to-static-inline-functions.patch
powerpc-introduce-little-endian-bitops.patch
powerpc-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
s390-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
arm-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
m68k-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-introduce-config_generic_find_bit_le.patch
m68knommu-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
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


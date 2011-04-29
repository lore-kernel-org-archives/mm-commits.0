From: akpm@linux-foundation.org
Subject: + arm-use-asm-generic-bitops-leh.patch added to -mm tree
Date: Fri, 29 Apr 2011 14:16:53 -0700
Message-ID: <201104292116.p3TLGrx9017546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab1D2VRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 17:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, heiko.carstens@de.ibm.com, rmk+kernel@arm.linux.org.uk, schwidefsky@de.ibm.com


The patch titled
     arm: use asm-generic/bitops/le.h
has been added to the -mm tree.  Its filename is
     arm-use-asm-generic-bitops-leh.patch

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
Subject: arm: use asm-generic/bitops/le.h
From: Akinobu Mita <akinobu.mita@gmail.com>

The previous style change enables to use asm-generic/bitops/le.h on arm.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bitops.h |   43 +++-----------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff -puN arch/arm/include/asm/bitops.h~arm-use-asm-generic-bitops-leh arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h~arm-use-asm-generic-bitops-leh
+++ a/arch/arm/include/asm/bitops.h
@@ -203,8 +203,6 @@ extern int _find_next_bit_be(const unsig
 #define find_first_bit(p,sz)		_find_first_bit_le(p,sz)
 #define find_next_bit(p,sz,off)		_find_next_bit_le(p,sz,off)
 
-#define WORD_BITOFF_TO_LE(x)		((x))
-
 #else
 /*
  * These are the big endian, atomic definitions.
@@ -214,8 +212,6 @@ extern int _find_next_bit_be(const unsig
 #define find_first_bit(p,sz)		_find_first_bit_be(p,sz)
 #define find_next_bit(p,sz,off)		_find_next_bit_be(p,sz,off)
 
-#define WORD_BITOFF_TO_LE(x)		((x) ^ 0x18)
-
 #endif
 
 #if __LINUX_ARM_ARCH__ < 5
@@ -287,40 +283,7 @@ static inline int fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-static inline void __set_bit_le(int nr, void *addr)
-{
-	__set_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline void __clear_bit_le(int nr, void *addr)
-{
-	__clear_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int __test_and_set_bit_le(int nr, void *addr)
-{
-	return __test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int test_and_set_bit_le(int nr, void *addr)
-{
-	return test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int __test_and_clear_bit_le(int nr, void *addr)
-{
-	return __test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int test_and_clear_bit_le(int nr, void *addr)
-{
-	return test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
-
-static inline int test_bit_le(int nr, const void *addr)
-{
-	return test_bit(WORD_BITOFF_TO_LE(nr), addr);
-}
+#ifdef __ARMEB__
 
 static inline int find_first_zero_bit_le(const void *p, unsigned size)
 {
@@ -340,6 +303,10 @@ static inline int find_next_bit_le(const
 }
 #define find_next_bit_le find_next_bit_le
 
+#endif
+
+#include <asm-generic/bitops/le.h>
+
 /*
  * Ext2 is defined to use little-endian byte ordering.
  */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch
arch-add-define-for-each-of-optimized-find-bitops.patch
bitops-add-ifndef-for-each-of-find-bitops.patch
arch-remove-config_generic_find_next_bitbit_lelast_bit.patch
arm-use-asm-generic-bitops-leh.patch
s390-use-asm-generic-bitops-leh.patch
m68knommu-use-generic-find_next_bit_le.patch


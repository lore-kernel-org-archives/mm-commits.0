From: akpm@linux-foundation.org
Subject: [to-be-updated] s390-use-asm-generic-bitops-leh.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:58:57 -0700
Message-ID: <201104291958.p3TJwvim012437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755515Ab1D2T7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:59:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, heiko.carstens@de.ibm.com, linux@arm.linux.org.uk, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use asm-generic/bitops/le.h
has been removed from the -mm tree.  Its filename was
     s390-use-asm-generic-bitops-leh.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: use asm-generic/bitops/le.h
From: Akinobu Mita <akinobu.mita@gmail.com>

The previous style change enables to use asm-generic/bitops/le.h on s390.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/bitops.h |   37 +------------------------------
 1 file changed, 2 insertions(+), 35 deletions(-)

diff -puN arch/s390/include/asm/bitops.h~s390-use-asm-generic-bitops-leh arch/s390/include/asm/bitops.h
--- a/arch/s390/include/asm/bitops.h~s390-use-asm-generic-bitops-leh
+++ a/arch/s390/include/asm/bitops.h
@@ -746,41 +746,6 @@ static inline int sched_find_first_bit(u
  *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
  */
 
-static inline void __set_bit_le(unsigned long nr, void *addr)
-{
-	__set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline void __clear_bit_le(unsigned long nr, void *addr)
-{
-	__clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int __test_and_set_bit_le(unsigned long nr, void *addr)
-{
-	return __test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int test_and_set_bit_le(unsigned long nr, void *addr)
-{
-	return test_and_set_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int __test_and_clear_bit_le(unsigned long nr, void *addr)
-{
-	return __test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int test_and_clear_bit_le(unsigned long nr, void *addr)
-{
-	return test_and_clear_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}
-
-static inline int test_bit_le(unsigned long nr, const void *addr)
-{
-	return test_bit(nr ^ (__BITOPS_WORDSIZE - 8), addr);
-}

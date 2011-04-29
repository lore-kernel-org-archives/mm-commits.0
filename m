From: akpm@linux-foundation.org
Subject: + bitops-add-ifndef-for-each-of-find-bitops.patch added to -mm tree
Date: Fri, 29 Apr 2011 14:16:47 -0700
Message-ID: <201104292116.p3TLGm1g017536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760892Ab1D2VRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 17:17:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, heiko.carstens@de.ibm.com, rmk+kernel@arm.linux.org.uk, schwidefsky@de.ibm.com


The patch titled
     bitops: add #ifndef for each of find bitops
has been added to the -mm tree.  Its filename is
     bitops-add-ifndef-for-each-of-find-bitops.patch

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
Subject: bitops: add #ifndef for each of find bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

The style that we normally use in asm-generic is to test the macro itself
for existence, so in asm-generic, do:

	#ifndef find_next_zero_bit_le
	extern unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset);
	#endif

and in the architectures, write

	static inline unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset)
	#define find_next_zero_bit_le find_next_zero_bit_le

This adds the #ifndef for each of the find bitops in the generic header
and source files.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/find.h |    4 ++++
 include/asm-generic/bitops/le.h   |    7 +++++++
 include/linux/bitops.h            |    2 ++
 lib/find_last_bit.c               |    4 ++++
 lib/find_next_bit.c               |   12 ++++++++++++
 5 files changed, 29 insertions(+)

diff -puN include/asm-generic/bitops/find.h~bitops-add-ifndef-for-each-of-find-bitops include/asm-generic/bitops/find.h
--- a/include/asm-generic/bitops/find.h~bitops-add-ifndef-for-each-of-find-bitops
+++ a/include/asm-generic/bitops/find.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_GENERIC_BITOPS_FIND_H_
 #define _ASM_GENERIC_BITOPS_FIND_H_
 
+#ifndef find_next_bit
 /**
  * find_next_bit - find the next set bit in a memory region
  * @addr: The address to base the search on
@@ -9,7 +10,9 @@
  */
 extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
 		size, unsigned long offset);
+#endif
 
+#ifndef find_next_zero_bit
 /**
  * find_next_zero_bit - find the next cleared bit in a memory region
  * @addr: The address to base the search on
@@ -18,6 +21,7 @@ extern unsigned long find_next_bit(const
  */
 extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset);
+#endif
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
diff -puN include/asm-generic/bitops/le.h~bitops-add-ifndef-for-each-of-find-bitops include/asm-generic/bitops/le.h
--- a/include/asm-generic/bitops/le.h~bitops-add-ifndef-for-each-of-find-bitops
+++ a/include/asm-generic/bitops/le.h
@@ -30,13 +30,20 @@ static inline unsigned long find_first_z
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
+#ifndef find_next_zero_bit_le
 extern unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
+#endif
+
+#ifndef find_next_bit_le
 extern unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
+#endif
 
+#ifndef find_first_zero_bit_le
 #define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
+#endif
 
 #else
 #error "Please fix <asm/byteorder.h>"
diff -puN include/linux/bitops.h~bitops-add-ifndef-for-each-of-find-bitops include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-add-ifndef-for-each-of-find-bitops
+++ a/include/linux/bitops.h
@@ -149,6 +149,7 @@ static inline unsigned long __ffs64(u64 
 #ifdef __KERNEL__
 
 #ifdef CONFIG_GENERIC_FIND_LAST_BIT
+#ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region
  * @addr: The address to start the search at
@@ -158,6 +159,7 @@ static inline unsigned long __ffs64(u64 
  */
 extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
+#endif
 #endif /* CONFIG_GENERIC_FIND_LAST_BIT */
 
 #endif /* __KERNEL__ */
diff -puN lib/find_last_bit.c~bitops-add-ifndef-for-each-of-find-bitops lib/find_last_bit.c
--- a/lib/find_last_bit.c~bitops-add-ifndef-for-each-of-find-bitops
+++ a/lib/find_last_bit.c
@@ -15,6 +15,8 @@
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
+#ifndef find_last_bit
+
 unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
 {
 	unsigned long words;
@@ -43,3 +45,5 @@ found:
 	return size;
 }
 EXPORT_SYMBOL(find_last_bit);
+
+#endif
diff -puN lib/find_next_bit.c~bitops-add-ifndef-for-each-of-find-bitops lib/find_next_bit.c
--- a/lib/find_next_bit.c~bitops-add-ifndef-for-each-of-find-bitops
+++ a/lib/find_next_bit.c
@@ -17,6 +17,7 @@
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
 #ifdef CONFIG_GENERIC_FIND_NEXT_BIT
+#ifndef find_next_bit
 /*
  * Find the next set bit in a memory region.
  */
@@ -59,7 +60,9 @@ found_middle:
 	return result + __ffs(tmp);
 }
 EXPORT_SYMBOL(find_next_bit);
+#endif
 
+#ifndef find_next_zero_bit
 /*
  * This implementation of find_{first,next}_zero_bit was stolen from
  * Linus' asm-alpha/bitops.h.
@@ -103,9 +106,11 @@ found_middle:
 	return result + ffz(tmp);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
+#endif
 #endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+#ifndef find_first_bit
 /*
  * Find the first set bit in a memory region.
  */
@@ -131,7 +136,9 @@ found:
 	return result + __ffs(tmp);
 }
 EXPORT_SYMBOL(find_first_bit);
+#endif
 
+#ifndef find_first_zero_bit
 /*
  * Find the first cleared bit in a memory region.
  */
@@ -157,6 +164,7 @@ found:
 	return result + ffz(tmp);
 }
 EXPORT_SYMBOL(find_first_zero_bit);
+#endif
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
@@ -186,6 +194,7 @@ static inline unsigned long ext2_swab(co
 #endif
 }
 
+#ifndef find_next_zero_bit_le
 unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
@@ -229,7 +238,9 @@ found_middle_swap:
 	return result + ffz(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
+#endif
 
+#ifndef find_next_bit_le
 unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
@@ -274,6 +285,7 @@ found_middle_swap:
 	return result + __ffs(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_bit_le);
+#endif
 
 #endif /* CONFIG_GENERIC_FIND_BIT_LE */
 #endif /* __BIG_ENDIAN */
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


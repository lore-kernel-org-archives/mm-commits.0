From: akpm@linux-foundation.org
Subject: [merged] asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:37 -0700
Message-ID: <201103250723.p2P7NVeq025738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933874Ab1CYHZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, grundler@parisc-linux.org, hans-christian.egtvedt@atmel.com


The patch titled
     asm-generic: change little-endian bitops to take any pointer types
has been removed from the -mm tree.  Its filename was
     asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic: change little-endian bitops to take any pointer types
From: Akinobu Mita <akinobu.mita@gmail.com>

This makes the little-endian bitops take any pointer types by changing the
prototypes and adding casts in the preprocessor macros.

That would seem to at least make all the filesystem code happier, and they
can continue to do just something like

  #define ext2_set_bit __test_and_set_bit_le

(or whatever the exact sequence ends up being).

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kazumoto Kojima <kkojima@rr.iij4u.or.jp>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/bitops.h |    4 -
 include/asm-generic/bitops/le.h   |   77 +++++++++++++++++++---------
 lib/find_next_bit.c               |   10 ++-
 3 files changed, 61 insertions(+), 30 deletions(-)

diff -puN arch/powerpc/include/asm/bitops.h~asm-generic-change-little-endian-bitops-to-take-any-pointer-types arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~asm-generic-change-little-endian-bitops-to-take-any-pointer-types
+++ a/arch/powerpc/include/asm/bitops.h
@@ -305,10 +305,10 @@ static __inline__ int test_le_bit(unsign
 
 #define find_first_zero_bit_le(addr, size) \
 	find_next_zero_bit_le((addr), (size), 0)
-unsigned long find_next_zero_bit_le(const unsigned long *addr,
+unsigned long find_next_zero_bit_le(const void *addr,
 				    unsigned long size, unsigned long offset);
 
-unsigned long find_next_bit_le(const unsigned long *addr,
+unsigned long find_next_bit_le(const void *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
diff -puN include/asm-generic/bitops/le.h~asm-generic-change-little-endian-bitops-to-take-any-pointer-types include/asm-generic/bitops/le.h
--- a/include/asm-generic/bitops/le.h~asm-generic-change-little-endian-bitops-to-take-any-pointer-types
+++ a/include/asm-generic/bitops/le.h
@@ -8,20 +8,31 @@
 
 #define BITOP_LE_SWIZZLE	0
 
-#define find_next_zero_bit_le(addr, size, offset) \
-	find_next_zero_bit(addr, size, offset)
-#define find_next_bit_le(addr, size, offset) \
-	find_next_bit(addr, size, offset)
-#define find_first_zero_bit_le(addr, size) \
-	find_first_zero_bit(addr, size)
+static inline unsigned long find_next_zero_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	return find_next_zero_bit(addr, size, offset);
+}
+
+static inline unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	return find_next_bit(addr, size, offset);
+}
+
+static inline unsigned long find_first_zero_bit_le(const void *addr,
+		unsigned long size)
+{
+	return find_first_zero_bit(addr, size);
+}
 
 #elif defined(__BIG_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-extern unsigned long find_next_zero_bit_le(const unsigned long *addr,
+extern unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
-extern unsigned long find_next_bit_le(const unsigned long *addr,
+extern unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
 
 #define find_first_zero_bit_le(addr, size) \
@@ -31,21 +42,39 @@ extern unsigned long find_next_bit_le(co
 #error "Please fix <asm/byteorder.h>"
 #endif
 
-#define test_bit_le(nr, addr) \
-	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __set_bit_le(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __clear_bit_le(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define test_and_set_bit_le(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define test_and_clear_bit_le(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define __test_and_set_bit_le(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __test_and_clear_bit_le(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+static inline int test_bit_le(int nr, const void *addr)
+{
+	return test_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int test_and_set_bit_le(int nr, void *addr)
+{
+	return test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int test_and_clear_bit_le(int nr, void *addr)
+{
+	return test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int __test_and_set_bit_le(int nr, void *addr)
+{
+	return __test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline int __test_and_clear_bit_le(int nr, void *addr)
+{
+	return __test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
 
 #endif /* _ASM_GENERIC_BITOPS_LE_H_ */
diff -puN lib/find_next_bit.c~asm-generic-change-little-endian-bitops-to-take-any-pointer-types lib/find_next_bit.c
--- a/lib/find_next_bit.c~asm-generic-change-little-endian-bitops-to-take-any-pointer-types
+++ a/lib/find_next_bit.c
@@ -185,15 +185,16 @@ static inline unsigned long ext2_swab(co
 #endif
 }
 
-unsigned long find_next_zero_bit_le(const unsigned long *addr, unsigned
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
+	const unsigned long *p = addr;
 	unsigned long result = offset & ~(BITS_PER_LONG - 1);
 	unsigned long tmp;
 
 	if (offset >= size)
 		return size;
+	p += BITOP_WORD(offset);
 	size -= result;
 	offset &= (BITS_PER_LONG - 1UL);
 	if (offset) {
@@ -228,15 +229,16 @@ found_middle_swap:
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
 
-unsigned long find_next_bit_le(const unsigned long *addr, unsigned
+unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
+	const unsigned long *p = addr;
 	unsigned long result = offset & ~(BITS_PER_LONG - 1);
 	unsigned long tmp;
 
 	if (offset >= size)
 		return size;
+	p += BITOP_WORD(offset);
 	size -= result;
 	offset &= (BITS_PER_LONG - 1UL);
 	if (offset) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch


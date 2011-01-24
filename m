From: akpm@linux-foundation.org
Subject: + asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:05:55 -0800
Message-ID: <201101242205.p0OM5tcR013335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab1AXWIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:08:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, grundler@parisc-linux.org, hans-christian.egtvedt@atmel.com, hpa@zytor.com, ink@jurassic.park.msu.ru, kkojima@rr.iij4u.or.jp, kyle@mcmartin.ca, lethal@linux-sh.org, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net, starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com, torvalds@linux-foundation.org, willy@debian.org, ysato@users.sourceforge.jp


The patch titled
     asm-generic: change little-endian bitops to take any pointer types
has been added to the -mm tree.  Its filename is
     asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch

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

 arch/powerpc/include/asm/bitops.h |    4 ++--
 include/asm-generic/bitops/le.h   |   24 ++++++++++++------------
 lib/find_next_bit.c               |   10 ++++++----
 3 files changed, 20 insertions(+), 18 deletions(-)

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
@@ -9,19 +9,19 @@
 #define BITOP_LE_SWIZZLE	0
 
 #define find_next_zero_bit_le(addr, size, offset) \
-	find_next_zero_bit(addr, size, offset)
+	find_next_zero_bit((unsigned long *)(addr), size, offset)
 #define find_next_bit_le(addr, size, offset) \
-	find_next_bit(addr, size, offset)
+	find_next_bit((unsigned long *)(addr), size, offset)
 #define find_first_zero_bit_le(addr, size) \
-	find_first_zero_bit(addr, size)
+	find_first_zero_bit((unsigned long *)(addr), size)
 
 #elif defined(__BIG_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-extern unsigned long find_next_zero_bit_le(const unsigned long *addr,
+extern unsigned long find_next_zero_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
-extern unsigned long find_next_bit_le(const unsigned long *addr,
+extern unsigned long find_next_bit_le(const void *addr,
 		unsigned long size, unsigned long offset);
 
 #define find_first_zero_bit_le(addr, size) \
@@ -32,20 +32,20 @@ extern unsigned long find_next_bit_le(co
 #endif
 
 #define test_bit_le(nr, addr) \
-	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define __set_bit_le(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define __clear_bit_le(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
 #define test_and_set_bit_le(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define test_and_clear_bit_le(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
 #define __test_and_set_bit_le(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 #define __test_and_clear_bit_le(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
+	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
 
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


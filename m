From: akpm@linux-foundation.org
Subject: [merged] bitops-introduce-config_generic_find_bit_le.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:52 -0700
Message-ID: <201103250723.p2P7NkoH025755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933644Ab1CYHXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     bitops: introduce CONFIG_GENERIC_FIND_BIT_LE
has been removed from the -mm tree.  Its filename was
     bitops-introduce-config_generic_find_bit_le.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: introduce CONFIG_GENERIC_FIND_BIT_LE
From: Akinobu Mita <akinobu.mita@gmail.com>

This introduces CONFIG_GENERIC_FIND_BIT_LE to tell whether to use generic
implementation of find_*_bit_le() in lib/find_next_bit.c or not.

For now we select CONFIG_GENERIC_FIND_BIT_LE for all architectures which
enable CONFIG_GENERIC_FIND_NEXT_BIT.

But m68knommu wants to define own faster find_next_zero_bit_le() and
continues using generic find_next_{,zero_}bit(). 
(CONFIG_GENERIC_FIND_NEXT_BIT and !CONFIG_GENERIC_FIND_BIT_LE)

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig        |    4 ++++
 arch/h8300/Kconfig      |    4 ++++
 arch/m32r/Kconfig       |    4 ++++
 arch/m68knommu/Kconfig  |    4 ++++
 arch/microblaze/Kconfig |    3 +++
 arch/mips/Kconfig       |    4 ++++
 arch/parisc/Kconfig     |    4 ++++
 arch/powerpc/Kconfig    |    4 ++++
 arch/sh/Kconfig         |    3 +++
 arch/sparc/Kconfig      |    4 ++++
 arch/xtensa/Kconfig     |    3 +++
 lib/Kconfig             |    3 +++
 lib/Makefile            |    1 +
 lib/find_next_bit.c     |    3 +++
 14 files changed, 48 insertions(+)

diff -puN arch/frv/Kconfig~bitops-introduce-config_generic_find_bit_le arch/frv/Kconfig
--- a/arch/frv/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/frv/Kconfig
@@ -22,6 +22,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/h8300/Kconfig~bitops-introduce-config_generic_find_bit_le arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/h8300/Kconfig
@@ -45,6 +45,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/m32r/Kconfig~bitops-introduce-config_generic_find_bit_le arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/m32r/Kconfig
@@ -260,6 +260,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/m68knommu/Kconfig~bitops-introduce-config_generic_find_bit_le arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/m68knommu/Kconfig
@@ -42,6 +42,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_GPIO
 	bool
 	default n
diff -puN arch/microblaze/Kconfig~bitops-introduce-config_generic_find_bit_le arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/microblaze/Kconfig
@@ -37,6 +37,9 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_BIT_LE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/mips/Kconfig~bitops-introduce-config_generic_find_bit_le arch/mips/Kconfig
--- a/arch/mips/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/mips/Kconfig
@@ -777,6 +777,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/parisc/Kconfig~bitops-introduce-config_generic_find_bit_le arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/parisc/Kconfig
@@ -52,6 +52,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_BUG
 	bool
 	default y
diff -puN arch/powerpc/Kconfig~bitops-introduce-config_generic_find_bit_le arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/powerpc/Kconfig
@@ -95,6 +95,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_GPIO
 	bool
 	help
diff -puN arch/sh/Kconfig~bitops-introduce-config_generic_find_bit_le arch/sh/Kconfig
--- a/arch/sh/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/sh/Kconfig
@@ -75,6 +75,9 @@ config GENERIC_CSUM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_BIT_LE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/sparc/Kconfig~bitops-introduce-config_generic_find_bit_le arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/sparc/Kconfig
@@ -192,6 +192,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_BIT_LE
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y if !ULTRA_HAS_POPULATION_COUNT
diff -puN arch/xtensa/Kconfig~bitops-introduce-config_generic_find_bit_le arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/arch/xtensa/Kconfig
@@ -21,6 +21,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_BIT_LE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN lib/Kconfig~bitops-introduce-config_generic_find_bit_le lib/Kconfig
--- a/lib/Kconfig~bitops-introduce-config_generic_find_bit_le
+++ a/lib/Kconfig
@@ -22,6 +22,9 @@ config GENERIC_FIND_FIRST_BIT
 config GENERIC_FIND_NEXT_BIT
 	bool
 
+config GENERIC_FIND_BIT_LE
+	bool
+
 config GENERIC_FIND_LAST_BIT
 	bool
 	default y
diff -puN lib/Makefile~bitops-introduce-config_generic_find_bit_le lib/Makefile
--- a/lib/Makefile~bitops-introduce-config_generic_find_bit_le
+++ a/lib/Makefile
@@ -40,6 +40,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += 
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
+lib-$(CONFIG_GENERIC_FIND_BIT_LE) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
diff -puN lib/find_next_bit.c~bitops-introduce-config_generic_find_bit_le lib/find_next_bit.c
--- a/lib/find_next_bit.c~bitops-introduce-config_generic_find_bit_le
+++ a/lib/find_next_bit.c
@@ -160,6 +160,7 @@ EXPORT_SYMBOL(find_first_zero_bit);
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
+#ifdef CONFIG_GENERIC_FIND_BIT_LE
 
 /* include/linux/byteorder does not support "unsigned long" type */
 static inline unsigned long ext2_swabp(const unsigned long * x)
@@ -273,4 +274,6 @@ found_middle_swap:
 	return result + __ffs(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_bit_le);
+
+#endif /* CONFIG_GENERIC_FIND_BIT_LE */
 #endif /* __BIG_ENDIAN */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch


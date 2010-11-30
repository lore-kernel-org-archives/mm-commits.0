From: akpm@linux-foundation.org
Subject: [to-be-updated] bitops-introduce-config_generic_find_le_bit.patch removed from -mm tree
Date: Tue, 30 Nov 2010 12:59:53 -0800
Message-ID: <201011302059.oAUKxrHE009963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab0K3VAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Nov 2010 16:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     bitops: introduce CONFIG_GENERIC_FIND_LE_BIT
has been removed from the -mm tree.  Its filename was
     bitops-introduce-config_generic_find_le_bit.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: introduce CONFIG_GENERIC_FIND_LE_BIT
From: Akinobu Mita <akinobu.mita@gmail.com>

The little-endian bitops patch series broke the build on m68knommu.

lib/find_next_bit.c:190: error: conflicting types for 'find_next_zero_le_bit'
/home/mita/scm/linux-2.6/arch/m68k/include/asm/bitops_no.h:286: error: previous
definition of 'find_next_zero_le_bit' was here

Because m68knommu selects CONFIG_GENERIC_FIND_NEXT_BIT, it redefines
find_next_zero_le_bit() in lib/find_next_bit.c.

This introduces CONFIG_GENERIC_FIND_NEXT_BIT to tell whether to use generic
implementation of find_*_le_bit() in lib/find_next_bit.c or not.  It will not
be selected by m68knommu to fix build failure.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig        |    4 ++++
 arch/h8300/Kconfig      |    4 ++++
 arch/m32r/Kconfig       |    4 ++++
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
 13 files changed, 44 insertions(+)

diff -puN arch/frv/Kconfig~bitops-introduce-config_generic_find_le_bit arch/frv/Kconfig
--- a/arch/frv/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/frv/Kconfig
@@ -21,6 +21,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/h8300/Kconfig~bitops-introduce-config_generic_find_le_bit arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/h8300/Kconfig
@@ -43,6 +43,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/m32r/Kconfig~bitops-introduce-config_generic_find_le_bit arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/m32r/Kconfig
@@ -265,6 +265,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/microblaze/Kconfig~bitops-introduce-config_generic_find_le_bit arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/microblaze/Kconfig
@@ -34,6 +34,9 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_LE_BIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/mips/Kconfig~bitops-introduce-config_generic_find_le_bit arch/mips/Kconfig
--- a/arch/mips/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/mips/Kconfig
@@ -753,6 +753,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN arch/parisc/Kconfig~bitops-introduce-config_generic_find_le_bit arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/parisc/Kconfig
@@ -48,6 +48,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_BUG
 	bool
 	default y
diff -puN arch/powerpc/Kconfig~bitops-introduce-config_generic_find_le_bit arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/powerpc/Kconfig
@@ -107,6 +107,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_GPIO
 	bool
 	help
diff -puN arch/sh/Kconfig~bitops-introduce-config_generic_find_le_bit arch/sh/Kconfig
--- a/arch/sh/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/sh/Kconfig
@@ -72,6 +72,9 @@ config GENERIC_CSUM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_LE_BIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN arch/sparc/Kconfig~bitops-introduce-config_generic_find_le_bit arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/sparc/Kconfig
@@ -194,6 +194,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_FIND_LE_BIT
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y if !ULTRA_HAS_POPULATION_COUNT
diff -puN arch/xtensa/Kconfig~bitops-introduce-config_generic_find_le_bit arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/arch/xtensa/Kconfig
@@ -21,6 +21,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
+config GENERIC_FIND_LE_BIT
+	def_bool y
+
 config GENERIC_HWEIGHT
 	def_bool y
 
diff -puN lib/Kconfig~bitops-introduce-config_generic_find_le_bit lib/Kconfig
--- a/lib/Kconfig~bitops-introduce-config_generic_find_le_bit
+++ a/lib/Kconfig
@@ -22,6 +22,9 @@ config GENERIC_FIND_FIRST_BIT
 config GENERIC_FIND_NEXT_BIT
 	bool
 
+config GENERIC_FIND_LE_BIT
+	bool
+
 config GENERIC_FIND_LAST_BIT
 	bool
 	default y
diff -puN lib/Makefile~bitops-introduce-config_generic_find_le_bit lib/Makefile
--- a/lib/Makefile~bitops-introduce-config_generic_find_le_bit
+++ a/lib/Makefile
@@ -38,6 +38,7 @@ lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += 
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
+lib-$(CONFIG_GENERIC_FIND_LE_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
diff -puN lib/find_next_bit.c~bitops-introduce-config_generic_find_le_bit lib/find_next_bit.c
--- a/lib/find_next_bit.c~bitops-introduce-config_generic_find_le_bit
+++ a/lib/find_next_bit.c
@@ -160,6 +160,7 @@ EXPORT_SYMBOL(find_first_zero_bit);
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
+#ifdef CONFIG_GENERIC_FIND_LE_BIT
 
 /* include/linux/byteorder does not support "unsigned long" type */
 static inline unsigned long ext2_swabp(const unsigned long * x)
@@ -271,4 +272,6 @@ found_middle_swap:
 	return result + __ffs(ext2_swab(tmp));
 }
 EXPORT_SYMBOL(find_next_le_bit);
+
+#endif /* CONFIG_GENERIC_FIND_LE_BIT */
 #endif /* __BIG_ENDIAN */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
bitops-rename-generic-little-endian-bitops-functions.patch
s390-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops.patch
0006-bitops-introduce-CONFIG_GENERIC_FIND_LE_BIT.patch
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


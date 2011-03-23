From: akpm@linux-foundation.org
Subject: [folded] m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:18:09 -0700
Message-ID: <201103232318.p2NNI9JG004202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933114Ab1CWXSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, geert@linux-m68k.org, gerg@uclinux.org, hpa@zytor.com, schwab@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions
has been removed from the -mm tree.  Its filename was
     m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch

This patch was dropped because it was folded into m68knommu-introduce-little-endian-bitops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions
From: Akinobu Mita <akinobu.mita@gmail.com>

(This patch is intended to be folded into the patch in -mm:
m68knommu-introduce-little-endian-bitops.patch)

A few little-endian bitops on m68knommu are written as preprocessor
macros with the cast to "unsigned long *".
This means that even non-pointers will be accepted without an error, and
that is a Very Bad Thing.

This converts the little-endian bitops macros to static inline functions
with proper prototypes.

Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops_no.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/m68k/include/asm/bitops_no.h~m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -198,11 +198,15 @@ static __inline__ int __test_bit(int nr,
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-#define __set_bit_le(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
+static inline void __set_bit_le(int nr, void *addr)
+{
+	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
 
-#define __clear_bit_le(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (unsigned long *)(addr))
+static inline void __clear_bit_le(int nr, void *addr)
+{
+	__clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
 
 static inline int __test_and_set_bit_le(int nr, volatile void *addr)
 {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
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


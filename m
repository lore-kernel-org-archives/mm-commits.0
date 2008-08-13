From: akpm@linux-foundation.org
Subject: - byteorder-avr32-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 12 Aug 2008 22:43:37 -0700
Message-ID: <200808130556.m7D5ugNv001307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbYHMF4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 01:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, haavard.skinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: avr32: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     byteorder-avr32-use-the-new-byteorder-headers.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: avr32: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/byteorder.h |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN arch/avr32/include/asm/byteorder.h~byteorder-avr32-use-the-new-byteorder-headers arch/avr32/include/asm/byteorder.h
--- a/arch/avr32/include/asm/byteorder.h~byteorder-avr32-use-the-new-byteorder-headers
+++ a/arch/avr32/include/asm/byteorder.h
@@ -7,6 +7,9 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
+
 #ifdef __CHECKER__
 extern unsigned long __builtin_bswap_32(unsigned long x);
 extern unsigned short __builtin_bswap_16(unsigned short x);
@@ -17,15 +20,18 @@ extern unsigned short __builtin_bswap_16
  * the result.
  */
 #if !(__GNUC__ == 4 && __GNUC_MINOR__ < 2)
-#define __arch__swab32(x) __builtin_bswap_32(x)
-#define __arch__swab16(x) __builtin_bswap_16(x)
-#endif
+static inline __attribute_const__ __u16 __arch_swab16(__u16 val)
+{
+	return __builtin_bswap_16(val);
+}
+#define __arch_swab16 __arch_swab16
 
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-# define __BYTEORDER_HAS_U64__
-# define __SWAB_64_THRU_32__
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
+{
+	return __builtin_bswap_32(val);
+}
+#define __arch_swab32 __arch_swab32
 #endif
 
-#include <linux/byteorder/big_endian.h>
-
+#include <linux/byteorder.h>
 #endif /* __ASM_AVR32_BYTEORDER_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
net-tipc-subscrc-dont-use-___constant_swab32.patch
byteorder-avr32-use-the-new-byteorder-headers.patch
byteorder-blackfin-use-the-new-byteorder-headers.patch
byteorder-cris-use-the-new-byteorder-headers.patch
byteorder-frv-use-the-new-byteorder-headers.patch
byteorder-h8300-use-the-new-byteorder-headers.patch
byteorder-ia64-use-the-new-byteorder-headers.patch
byteorder-m32r-use-the-new-byteorder-headers.patch
byteorder-m68k-use-the-new-byteorder-headers.patch
byteorder-m68knommu-use-the-new-byteorder-headers.patch
byteorder-mips-use-the-new-byteorder-headers.patch
byteorder-mn10300-use-the-new-byteorder-headers.patch
byteorder-parisc-use-the-new-byteorder-headers.patch
byteorder-powerpc-use-the-new-byteorder-headers.patch
byteorder-s390-use-the-new-byteorder-headers.patch
byteorder-sh-use-the-new-byteorder-headers.patch
byteorder-sparc-use-the-new-byteorder-headers.patch
byteorder-x86-use-the-new-byteorder-headers.patch
byteorder-xtensa-use-the-new-byteorder-headers.patch
byteorder-fix-direct-byteswap-includes.patch
byteorder-remove-the-old-byteorder-implementation.patch


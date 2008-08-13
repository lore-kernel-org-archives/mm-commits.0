From: akpm@linux-foundation.org
Subject: - byteorder-xtensa-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 12 Aug 2008 22:44:14 -0700
Message-ID: <200808130557.m7D5vJTD001373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbYHMF5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 01:57:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     byteorder: xtensa: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     byteorder-xtensa-use-the-new-byteorder-headers.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: xtensa: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-xtensa/byteorder.h |   32 ++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN include/asm-xtensa/byteorder.h~byteorder-xtensa-use-the-new-byteorder-headers include/asm-xtensa/byteorder.h
--- a/include/asm-xtensa/byteorder.h~byteorder-xtensa-use-the-new-byteorder-headers
+++ a/include/asm-xtensa/byteorder.h
@@ -14,7 +14,17 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __XTENSA_EL__
+# define __LITTLE_ENDIAN
+#elif defined(__XTENSA_EB__)
+# define __BIG_ENDIAN
+#else
+# error processor byte order undefined!
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
     __u32 res;
     /* instruction sequence from Xtensa ISA release 2/2000 */
@@ -28,8 +38,9 @@ static __inline__ __attribute_const__ __
 	    );
     return res;
 }
+#define __arch_swab32 __arch_swab32
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
     /* Given that 'short' values are signed (i.e., can be negative),
      * we cannot assume that the upper 16-bits of the register are
@@ -62,21 +73,8 @@ static __inline__ __attribute_const__ __
 
     return res;
 }
+#define __arch_swab16 __arch_swab16
 
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __XTENSA_EL__
-# include <linux/byteorder/little_endian.h>
-#elif defined(__XTENSA_EB__)
-# include <linux/byteorder/big_endian.h>
-#else
-# error processor byte order undefined!
-#endif
+#include <linux/byteorder.h>
 
 #endif /* _XTENSA_BYTEORDER_H */
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
byteorder-xtensa-use-the-new-byteorder-headers.patch
byteorder-fix-direct-byteswap-includes.patch
byteorder-remove-the-old-byteorder-implementation.patch


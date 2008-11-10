From: akpm@linux-foundation.org
Subject: - xtensa-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:25 -0800
Message-ID: <200811102034.mAAKYPoB025037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbYKJUey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     xtensa-use-the-new-byteorder-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/byteorder.h |   32 ++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN arch/xtensa/include/asm/byteorder.h~xtensa-use-the-new-byteorder-headers arch/xtensa/include/asm/byteorder.h
--- a/arch/xtensa/include/asm/byteorder.h~xtensa-use-the-new-byteorder-headers
+++ a/arch/xtensa/include/asm/byteorder.h
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

linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
memstick-annotate-endianness-of-attribute-structs.patch


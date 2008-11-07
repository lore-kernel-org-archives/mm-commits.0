From: akpm@linux-foundation.org
Subject: + blackfin-use-the-new-byteorder-headers.patch added to -mm tree
Date: Thu, 06 Nov 2008 16:40:58 -0800
Message-ID: <200811070040.mA70ewei020734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbYKGAlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 19:41:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, bryan.wu@analog.com


The patch titled
     blackfin: use the new byteorder headers
has been added to the -mm tree.  Its filename is
     blackfin-use-the-new-byteorder-headers.patch

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
Subject: blackfin: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/byteorder.h |   33 ++++++++++--------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff -puN arch/blackfin/include/asm/byteorder.h~blackfin-use-the-new-byteorder-headers arch/blackfin/include/asm/byteorder.h
--- a/arch/blackfin/include/asm/byteorder.h~blackfin-use-the-new-byteorder-headers
+++ a/arch/blackfin/include/asm/byteorder.h
@@ -4,9 +4,10 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahb32(__u32 xx)
 {
 	__u32 tmp;
 	__asm__("%1 = %0 >> 8 (V);\n\t"
@@ -15,34 +16,30 @@ static __inline__ __attribute_const__ __
 		: "+d"(xx), "=&d"(tmp));
 	return xx;
 }
+#define __arch_swahb32 __arch_swahb32
 
-static __inline__ __attribute_const__ __u32 ___arch__swahw32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahw32(__u32 xx)
 {
 	__u32 rv;
 	__asm__("%0 = PACK(%1.L, %1.H);\n\t": "=d"(rv): "d"(xx));
 	return rv;
 }
+#define __arch_swahw32 __arch_swahw32
 
-#define __arch__swahb32(x) ___arch__swahb32(x)
-#define __arch__swahw32(x) ___arch__swahw32(x)
-#define __arch__swab32(x) ___arch__swahb32(___arch__swahw32(x))
+static inline __attribute_const__ __u32 __arch_swab32(__u32 xx)
+{
+	return __arch_swahb32(__arch_swahw32(xx));
+}
+#define __arch_swab32 __arch_swab32
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 xx)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 xx)
 {
 	__u32 xw = xx;
 	__asm__("%0 <<= 8;\n	%0.L = %0.L + %0.H (NS);\n": "+d"(xw));
 	return (__u16)xw;
 }
+#define __arch_swab16 __arch_swab16
 
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
-#endif				/* _BLACKFIN_BYTEORDER_H */
+#endif /* _BLACKFIN_BYTEORDER_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
blackfin-remove-__function__-in-new-serial-driver.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
m68knommu-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
memstick-annotate-endianness-of-attribute-structs.patch
alpha-use-the-new-byteorder-headers.patch
arm-use-the-new-byteorder-headers.patch
blackfin-use-the-new-byteorder-headers.patch
frv-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
ia64-use-the-new-byteorder-headers.patch
m32r-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
xtensa-use-the-new-byteorder-headers.patch


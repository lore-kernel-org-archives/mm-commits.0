From: akpm@linux-foundation.org
Subject: + s390-use-the-new-byteorder-headers.patch added to -mm tree
Date: Thu, 06 Nov 2008 16:41:15 -0800
Message-ID: <200811070041.mA70fFEa020898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802AbYKGAlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 19:41:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, schwidefsky@de.ibm.com


The patch titled
     s390: use the new byteorder headers
has been added to the -mm tree.  Its filename is
     s390-use-the-new-byteorder-headers.patch

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
Subject: s390: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/byteorder.h |   72 ++++++++--------------------
 1 file changed, 21 insertions(+), 51 deletions(-)

diff -puN arch/s390/include/asm/byteorder.h~s390-use-the-new-byteorder-headers arch/s390/include/asm/byteorder.h
--- a/arch/s390/include/asm/byteorder.h~s390-use-the-new-byteorder-headers
+++ a/arch/s390/include/asm/byteorder.h
@@ -11,32 +11,39 @@
 
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
+
+#ifndef __s390x__
+# define __SWAB_64_THRU_32__
+#endif
 
 #ifdef __s390x__
-static inline __u64 ___arch__swab64p(const __u64 *x)
+static inline __u64 __arch_swab64p(const __u64 *x)
 {
 	__u64 result;
 
 	asm volatile("lrvg %0,%1" : "=d" (result) : "m" (*x));
 	return result;
 }
+#define __arch_swab64p __arch_swab64p
 
-static inline __u64 ___arch__swab64(__u64 x)
+static inline __u64 __arch_swab64(__u64 x)
 {
 	__u64 result;
 
 	asm volatile("lrvgr %0,%1" : "=d" (result) : "d" (x));
 	return result;
 }
+#define __arch_swab64 __arch_swab64
 
-static inline void ___arch__swab64s(__u64 *x)
+static inline void __arch_swab64s(__u64 *x)
 {
-	*x = ___arch__swab64p(x);
+	*x = __arch_swab64p(x);
 }
+#define __arch_swab64s __arch_swab64s
 #endif /* __s390x__ */
 
-static inline __u32 ___arch__swab32p(const __u32 *x)
+static inline __u32 __arch_swab32p(const __u32 *x)
 {
 	__u32 result;
 	
@@ -53,25 +60,20 @@ static inline __u32 ___arch__swab32p(con
 #endif /* __s390x__ */
 	return result;
 }
+#define __arch_swab32p __arch_swab32p
 
-static inline __u32 ___arch__swab32(__u32 x)
+#ifdef __s390x__
+static inline __u32 __arch_swab32(__u32 x)
 {
-#ifndef __s390x__
-	return ___arch__swab32p(&x);
-#else /* __s390x__ */
 	__u32 result;
 	
 	asm volatile("lrvr  %0,%1" : "=d" (result) : "d" (x));
 	return result;
-#endif /* __s390x__ */
-}
-
-static __inline__ void ___arch__swab32s(__u32 *x)
-{
-	*x = ___arch__swab32p(x);
 }
+#define __arch_swab32 __arch_swab32
+#endif /* __s390x__ */
 
-static __inline__ __u16 ___arch__swab16p(const __u16 *x)
+static inline __u16 __arch_swab16p(const __u16 *x)
 {
 	__u16 result;
 	
@@ -86,40 +88,8 @@ static __inline__ __u16 ___arch__swab16p
 #endif /* __s390x__ */
 	return result;
 }
+#define __arch_swab16p __arch_swab16p
 
-static __inline__ __u16 ___arch__swab16(__u16 x)
-{
-	return ___arch__swab16p(&x);
-}
-
-static __inline__ void ___arch__swab16s(__u16 *x)
-{
-	*x = ___arch__swab16p(x);
-}
-
-#ifdef __s390x__
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab64p(x) ___arch__swab64p(x)
-#define __arch__swab64s(x) ___arch__swab64s(x)
-#endif /* __s390x__ */
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab32p(x) ___arch__swab32p(x)
-#define __arch__swab16p(x) ___arch__swab16p(x)
-#define __arch__swab32s(x) ___arch__swab32s(x)
-#define __arch__swab16s(x) ___arch__swab16s(x)
-
-#ifndef __s390x__
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-#else /* __s390x__ */
-#define __BYTEORDER_HAS_U64__
-#endif /* __s390x__ */
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _S390_BYTEORDER_H */
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


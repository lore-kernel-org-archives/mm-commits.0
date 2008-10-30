From: akpm@linux-foundation.org
Subject: - cris-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Thu, 30 Oct 2008 12:01:59 -0700
Message-ID: <200810301902.m9UJ1x7A023791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbYJ3TCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 15:02:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     cris-use-the-new-byteorder-headers.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/arch-v10/byteorder.h |    6 ++++--
 include/asm-cris/arch-v32/byteorder.h |    6 ++++--
 include/asm-cris/byteorder.h          |   18 +++---------------
 3 files changed, 11 insertions(+), 19 deletions(-)

diff -puN include/asm-cris/arch-v10/byteorder.h~cris-use-the-new-byteorder-headers include/asm-cris/arch-v10/byteorder.h
--- a/include/asm-cris/arch-v10/byteorder.h~cris-use-the-new-byteorder-headers
+++ a/include/asm-cris/arch-v10/byteorder.h
@@ -9,18 +9,20 @@
  * them together into ntohl etc.
  */
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__ ("swapwb %0" : "=r" (x) : "0" (x));
   
 	return(x);
 }
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__ ("swapb %0" : "=r" (x) : "0" (x));
 	
 	return(x);
 }
+#define __arch_swab16 __arch_swab16
 
 #endif
diff -puN include/asm-cris/arch-v32/byteorder.h~cris-use-the-new-byteorder-headers include/asm-cris/arch-v32/byteorder.h
--- a/include/asm-cris/arch-v32/byteorder.h~cris-use-the-new-byteorder-headers
+++ a/include/asm-cris/arch-v32/byteorder.h
@@ -4,17 +4,19 @@
 #include <asm/types.h>
 
 static inline __const__ __u32
-___arch__swab32(__u32 x)
+__arch_swab32(__u32 x)
 {
 	__asm__ __volatile__ ("swapwb %0" : "=r" (x) : "0" (x));
 	return (x);
 }
+#define __arch_swab32 __arch_swab32
 
 static inline __const__ __u16
-___arch__swab16(__u16 x)
+__arch_swab16(__u16 x)
 {
 	__asm__ __volatile__ ("swapb %0" : "=r" (x) : "0" (x));
 	return (x);
 }
+#define __arch_swab16 __arch_swab16
 
 #endif /* _ASM_CRIS_ARCH_BYTEORDER_H */
diff -puN include/asm-cris/byteorder.h~cris-use-the-new-byteorder-headers include/asm-cris/byteorder.h
--- a/include/asm-cris/byteorder.h~cris-use-the-new-byteorder-headers
+++ a/include/asm-cris/byteorder.h
@@ -1,26 +1,14 @@
 #ifndef _CRIS_BYTEORDER_H
 #define _CRIS_BYTEORDER_H
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
 #ifdef __KERNEL__
 #include <asm/arch/byteorder.h>
-
-/* defines are necessary because the other files detect the presence
- * of a defined __arch_swab32, not an inline
- */
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-#endif /* __KERNEL__ */
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
 #endif
 
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
mips-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
sh-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
sparc-use-the-new-byteorder-headers.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
m68knommu-use-the-new-byteorder-headers.patch
cris-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
memstick-annotate-endianness-of-attribute-structs.patch


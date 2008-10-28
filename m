From: akpm@linux-foundation.org
Subject: + sh-use-the-new-byteorder-headers.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:29:09 -0700
Message-ID: <200810280629.m9S6T94G024639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbYJ1G3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, lethal@linux-sh.org


The patch titled
     sh: use the new byteorder headers
has been added to the -mm tree.  Its filename is
     sh-use-the-new-byteorder-headers.patch

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
Subject: sh: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/byteorder.h |   36 ++++++++++++++----------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff -puN arch/sh/include/asm/byteorder.h~sh-use-the-new-byteorder-headers arch/sh/include/asm/byteorder.h
--- a/arch/sh/include/asm/byteorder.h~sh-use-the-new-byteorder-headers
+++ a/arch/sh/include/asm/byteorder.h
@@ -8,7 +8,15 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __LITTLE_ENDIAN__
+# define __LITTLE_ENDIAN
+#else
+# define __BIG_ENDIAN
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__(
 #ifdef __SH5__
@@ -24,8 +32,9 @@ static inline __attribute_const__ __u32 
 
 	return x;
 }
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__(
 #ifdef __SH5__
@@ -39,32 +48,21 @@ static inline __attribute_const__ __u16 
 
 	return x;
 }
+#define __arch_swab16 __arch_swab16
 
-static inline __u64 ___arch__swab64(__u64 val)
+static inline __u64 __arch_swab64(__u64 val)
 {
 	union {
 		struct { __u32 a,b; } s;
 		__u64 u;
 	} v, w;
 	v.u = val;
-	w.s.b = ___arch__swab32(v.s.a);
-	w.s.a = ___arch__swab32(v.s.b);
+	w.s.b = __arch_swab32(v.s.a);
+	w.s.a = __arch_swab32(v.s.b);
 	return w.u;
 }
+#define __arch_swab64 __arch_swab64
 
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __LITTLE_ENDIAN__
-#include <linux/byteorder/little_endian.h>
-#else
-#include <linux/byteorder/big_endian.h>
-#endif
+#include <linux/byteorder.h>
 
 #endif /* __ASM_SH_BYTEORDER_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
gfs2-sparse-annotation-of-gl-gl_spin.patch
input-ads7846c-sparse-lock-annotation.patch
mips-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
sh-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
sparc-use-the-new-byteorder-headers.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
m68knommu-use-the-new-byteorder-headers.patch
cris-use-the-new-byteorder-headers.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
memstick-annotate-endianness-of-attribute-structs.patch


From: akpm@linux-foundation.org
Subject: - byteorder-sh-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 12 Aug 2008 22:44:08 -0700
Message-ID: <200808130557.m7D5vDNi001364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbYHMF5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 01:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     byteorder: sh: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     byteorder-sh-use-the-new-byteorder-headers.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: sh: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/byteorder.h |   32 ++++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN arch/sh/include/asm/byteorder.h~byteorder-sh-use-the-new-byteorder-headers arch/sh/include/asm/byteorder.h
--- a/arch/sh/include/asm/byteorder.h~byteorder-sh-use-the-new-byteorder-headers
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
@@ -39,8 +48,9 @@ static inline __attribute_const__ __u16 
 
 	return x;
 }
+#define __arch_swab16 __arch_swab16
 
-static inline __u64 ___arch__swab64(__u64 val)
+static inline __u64 __arch_swab64(__u64 val)
 {
 	union {
 		struct { __u32 a,b; } s;
@@ -51,20 +61,8 @@ static inline __u64 ___arch__swab64(__u6
 	w.s.a = ___arch__swab32(v.s.b);
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
byteorder-sh-use-the-new-byteorder-headers.patch
byteorder-sparc-use-the-new-byteorder-headers.patch
byteorder-x86-use-the-new-byteorder-headers.patch
byteorder-xtensa-use-the-new-byteorder-headers.patch
byteorder-fix-direct-byteswap-includes.patch
byteorder-remove-the-old-byteorder-implementation.patch


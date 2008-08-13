From: akpm@linux-foundation.org
Subject: - byteorder-mips-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 12 Aug 2008 22:43:56 -0700
Message-ID: <200808130557.m7D5v1pG001343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbYHMF5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 01:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     byteorder: mips: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     byteorder-mips-use-the-new-byteorder-headers.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: mips: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/byteorder.h |   40 +++++++++++++--------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff -puN include/asm-mips/byteorder.h~byteorder-mips-use-the-new-byteorder-headers include/asm-mips/byteorder.h
--- a/include/asm-mips/byteorder.h~byteorder-mips-use-the-new-byteorder-headers
+++ a/include/asm-mips/byteorder.h
@@ -11,11 +11,19 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#if defined(__MIPSEB__)
+# define __BIG_ENDIAN
+#elif defined(__MIPSEL__)
+# define __LITTLE_ENDIAN
+#else
+# error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
+#endif
+
+#define __SWAB_64_THRU_32__
 
 #ifdef CONFIG_CPU_MIPSR2
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__(
 	"	wsbh	%0, %1			\n"
@@ -24,9 +32,9 @@ static __inline__ __attribute_const__ __
 
 	return x;
 }
-#define __arch__swab16(x)	___arch__swab16(x)
+#define __arch_swab16 __arch_swab16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__(
 	"	wsbh	%0, %1			\n"
@@ -36,11 +44,10 @@ static __inline__ __attribute_const__ __
 
 	return x;
 }
-#define __arch__swab32(x)	___arch__swab32(x)
+#define __arch_swab32 __arch_swab32
 
 #ifdef CONFIG_CPU_MIPS64_R2
-
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
 {
 	__asm__(
 	"	dsbh	%0, %1			\n"
@@ -51,26 +58,11 @@ static __inline__ __attribute_const__ __
 
 	return x;
 }
-
-#define __arch__swab64(x)	___arch__swab64(x)
-
+#define __arch_swab64 __arch_swab64
 #endif /* CONFIG_CPU_MIPS64_R2 */
 
 #endif /* CONFIG_CPU_MIPSR2 */
 
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#endif /* __GNUC__ */
-
-#if defined(__MIPSEB__)
-#  include <linux/byteorder/big_endian.h>
-#elif defined(__MIPSEL__)
-#  include <linux/byteorder/little_endian.h>
-#else
-#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
-#endif
+#include <linux/byteorder.h>
 
 #endif /* _ASM_BYTEORDER_H */
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


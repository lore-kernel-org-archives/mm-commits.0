From: akpm@linux-foundation.org
Subject: - byteorder-powerpc-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 12 Aug 2008 22:44:04 -0700
Message-ID: <200808130557.m7D5v91n001358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbYHMF5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 01:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     byteorder: powerpc: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     byteorder-powerpc-use-the-new-byteorder-headers.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: powerpc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/byteorder.h |   49 +++++++++----------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff -puN arch/powerpc/include/asm/byteorder.h~byteorder-powerpc-use-the-new-byteorder-headers arch/powerpc/include/asm/byteorder.h
--- a/arch/powerpc/include/asm/byteorder.h~byteorder-powerpc-use-the-new-byteorder-headers
+++ a/arch/powerpc/include/asm/byteorder.h
@@ -11,36 +11,43 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
-#ifdef __KERNEL__
+#define __BIG_ENDIAN
 
-static __inline__ __u16 ld_le16(const volatile __u16 *addr)
+#ifndef __powerpc64__
+# define __SWAB_64_THRU_32__
+#endif
+
+static inline __u16 __arch_swab16p(const volatile __u16 *addr)
 {
 	__u16 val;
 
 	__asm__ __volatile__ ("lhbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define __arch_swab16p __arch_swab16p
 
-static __inline__ void st_le16(volatile __u16 *addr, const __u16 val)
+static inline void __arch_swab16s(volatile __u16 *addr, const __u16 val)
 {
 	__asm__ __volatile__ ("sthbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
+#define __arch_swab16s __arch_swab16s
 
-static __inline__ __u32 ld_le32(const volatile __u32 *addr)
+static inline __u32 __arch_swab32p(const volatile __u32 *addr)
 {
 	__u32 val;
 
 	__asm__ __volatile__ ("lwbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define __arch_swab32p __arch_swab32p
 
-static __inline__ void st_le32(volatile __u32 *addr, const __u32 val)
+static inline void __arch_swab32s(volatile __u32 *addr, const __u32 val)
 {
 	__asm__ __volatile__ ("stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
+#define __arch_swab32s __arch_swab32s
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 value)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 value)
 {
 	__u16 result;
 
@@ -49,8 +56,9 @@ static __inline__ __attribute_const__ __
 	    : "r" (value), "0" (value >> 8));
 	return result;
 }
+#define __arch_swab16 __arch_swab16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 value)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 value)
 {
 	__u32 result;
 
@@ -61,29 +69,8 @@ static __inline__ __attribute_const__ __
 	    : "r" (value), "0" (value >> 24));
 	return result;
 }
+#define __arch_swab32 __arch_swab32
 
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-/* The same, but returns converted value from the location pointer by addr. */
-#define __arch__swab16p(addr) ld_le16(addr)
-#define __arch__swab32p(addr) ld_le32(addr)
-
-/* The same, but do the conversion in situ, ie. put the value back to addr. */
-#define __arch__swab16s(addr) st_le16(addr,*addr)
-#define __arch__swab32s(addr) st_le32(addr,*addr)
-
-#endif /* __KERNEL__ */
-
-#ifndef __STRICT_ANSI__
-#define __BYTEORDER_HAS_U64__
-#ifndef __powerpc64__
-#define __SWAB_64_THRU_32__
-#endif /* __powerpc64__ */
-#endif /* __STRICT_ANSI__ */
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_POWERPC_BYTEORDER_H */
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
byteorder-powerpc-use-the-new-byteorder-headers.patch
byteorder-s390-use-the-new-byteorder-headers.patch
byteorder-sh-use-the-new-byteorder-headers.patch
byteorder-sparc-use-the-new-byteorder-headers.patch
byteorder-x86-use-the-new-byteorder-headers.patch
byteorder-xtensa-use-the-new-byteorder-headers.patch
byteorder-fix-direct-byteswap-includes.patch
byteorder-remove-the-old-byteorder-implementation.patch


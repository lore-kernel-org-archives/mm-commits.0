From: akpm@linux-foundation.org
Subject: + byteorder-x86-use-the-new-byteorder-headers.patch added to -mm tree
Date: Tue, 12 Aug 2008 19:59:19 -0700
Message-ID: <200808130259.m7D2xJKH027484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbYHMC7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 22:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     byteorder: x86: use the new byteorder headers
has been added to the -mm tree.  Its filename is
     byteorder-x86-use-the-new-byteorder-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: x86: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/byteorder.h |   69 +++++++++++++---------------------
 1 file changed, 27 insertions(+), 42 deletions(-)

diff -puN include/asm-x86/byteorder.h~byteorder-x86-use-the-new-byteorder-headers include/asm-x86/byteorder.h
--- a/include/asm-x86/byteorder.h~byteorder-x86-use-the-new-byteorder-headers
+++ a/include/asm-x86/byteorder.h
@@ -4,26 +4,33 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
 
-#ifdef __i386__
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
-#ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (x) : "0" (x));
-#else
+#ifdef __i386__
+# ifdef CONFIG_X86_BSWAP
+	asm("bswap %0" : "=r" (val) : "0" (val));
+# else
 	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
 	    "rorl $16,%0\n\t"	/* swap words		*/
 	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (x)
-	    : "0" (x));
+	    : "=q" (val)
+	    : "0" (val));
+# endif
+
+#else /* __i386__ */
+	asm("bswapl %0"
+	    : "=r" (val)
+	    : "0" (val));
 #endif
-	return x;
+	return val;
 }
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
+static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 {
+#ifdef __i386__
 	union {
 		struct {
 			__u32 a;
@@ -32,50 +39,28 @@ static inline __attribute_const__ __u64 
 		__u64 u;
 	} v;
 	v.u = val;
-#ifdef CONFIG_X86_BSWAP
+# ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#else
+# else
 	v.s.a = ___arch__swab32(v.s.a);
 	v.s.b = ___arch__swab32(v.s.b);
 	asm("xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#endif
+# endif
 	return v.u;
-}
 
 #else /* __i386__ */
-
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 x)
-{
 	asm("bswapq %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
-{
-	asm("bswapl %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
+	    : "=r" (val)
+	    : "0" (val));
+	return val;
 #endif
+}
+#define __arch_swab64 __arch_swab64
 
-/* Do not define swab16.  Gcc is smart enough to recognize "C" version and
-   convert it into rotation or exhange.  */
-
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#define __BYTEORDER_HAS_U64__
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_X86_BYTEORDER_H */
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
byteorder-alpha-use-the-new-byteorder-headers.patch
byteorder-arm-use-the-new-byteorder-headers.patch
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


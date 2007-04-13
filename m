From: akpm@linux-foundation.org
Subject: + alpha-build-fixes-force-architecture.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:05:09 -0700
Message-ID: <200704131905.l3DJ5Ef3007139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbXDMTFS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     ALPHA: build fixes - force architecture
has been added to the -mm tree.  Its filename is
     alpha-build-fixes-force-architecture.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALPHA: build fixes - force architecture
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Override compiler .arch directive for generic kernel build.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/sys_titan.c |    3 --
 include/asm-alpha/compiler.h  |   47 +++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 14 deletions(-)

diff -puN arch/alpha/kernel/sys_titan.c~alpha-build-fixes-force-architecture arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c~alpha-build-fixes-force-architecture
+++ a/arch/alpha/kernel/sys_titan.c
@@ -257,8 +257,7 @@ titan_dispatch_irqs(u64 mask)
 	 */
 	while (mask) {
 		/* convert to SRM vector... priority is <63> -> <0> */
-		__asm__("ctlz %1, %0" : "=r"(vector) : "r"(mask));
-		vector = 63 - vector;
+		vector = 63 - __kernel_ctlz(mask);
 		mask &= ~(1UL << vector);	/* clear it out 	 */
 		vector = 0x900 + (vector << 4);	/* convert to SRM vector */
 		
diff -puN include/asm-alpha/compiler.h~alpha-build-fixes-force-architecture include/asm-alpha/compiler.h
--- a/include/asm-alpha/compiler.h~alpha-build-fixes-force-architecture
+++ a/include/asm-alpha/compiler.h
@@ -17,9 +17,6 @@
 # define __kernel_extbl(val, shift)	__builtin_alpha_extbl(val, shift)
 # define __kernel_extwl(val, shift)	__builtin_alpha_extwl(val, shift)
 # define __kernel_cmpbge(a, b)		__builtin_alpha_cmpbge(a, b)
-# define __kernel_cttz(x)		__builtin_ctzl(x)
-# define __kernel_ctlz(x)		__builtin_clzl(x)
-# define __kernel_ctpop(x)		__builtin_popcountl(x)
 #else
 # define __kernel_insbl(val, shift)					\
   ({ unsigned long __kir;						\
@@ -49,17 +46,39 @@
   ({ unsigned long __kir;						\
      __asm__("cmpbge %r2,%1,%0" : "=r"(__kir) : "rI"(b), "rJ"(a));	\
      __kir; })
+#endif
+
+#ifdef __alpha_cix__
+# if __GNUC__ == 3 && __GNUC_MINOR__ >= 4 || __GNUC__ > 3
+#  define __kernel_cttz(x)		__builtin_ctzl(x)
+#  define __kernel_ctlz(x)		__builtin_clzl(x)
+#  define __kernel_ctpop(x)		__builtin_popcountl(x)
+# else
+#  define __kernel_cttz(x)						\
+   ({ unsigned long __kir;						\
+      __asm__("cttz %1,%0" : "=r"(__kir) : "r"(x));			\
+      __kir; })
+#  define __kernel_ctlz(x)						\
+   ({ unsigned long __kir;						\
+      __asm__("ctlz %1,%0" : "=r"(__kir) : "r"(x));			\
+      __kir; })
+#  define __kernel_ctpop(x)						\
+   ({ unsigned long __kir;						\
+      __asm__("ctpop %1,%0" : "=r"(__kir) : "r"(x));			\
+      __kir; })
+# endif
+#else
 # define __kernel_cttz(x)						\
   ({ unsigned long __kir;						\
-     __asm__("cttz %1,%0" : "=r"(__kir) : "r"(x));			\
+     __asm__(".arch ev67; cttz %1,%0" : "=r"(__kir) : "r"(x));		\
      __kir; })
 # define __kernel_ctlz(x)						\
   ({ unsigned long __kir;						\
-     __asm__("ctlz %1,%0" : "=r"(__kir) : "r"(x));			\
+     __asm__(".arch ev67; ctlz %1,%0" : "=r"(__kir) : "r"(x));		\
      __kir; })
 # define __kernel_ctpop(x)						\
   ({ unsigned long __kir;						\
-     __asm__("ctpop %1,%0" : "=r"(__kir) : "r"(x));			\
+     __asm__(".arch ev67; ctpop %1,%0" : "=r"(__kir) : "r"(x));		\
      __kir; })
 #endif
 
@@ -78,16 +97,20 @@
 #else
 #define __kernel_ldbu(mem)				\
   ({ unsigned char __kir;				\
-     __asm__("ldbu %0,%1" : "=r"(__kir) : "m"(mem));	\
+     __asm__(".arch ev56;				\
+	      ldbu %0,%1" : "=r"(__kir) : "m"(mem));	\
      __kir; })
 #define __kernel_ldwu(mem)				\
   ({ unsigned short __kir;				\
-     __asm__("ldwu %0,%1" : "=r"(__kir) : "m"(mem));	\
+     __asm__(".arch ev56;				\
+	      ldwu %0,%1" : "=r"(__kir) : "m"(mem));	\
      __kir; })
-#define __kernel_stb(val,mem) \
-  __asm__("stb %1,%0" : "=m"(mem) : "r"(val))
-#define __kernel_stw(val,mem) \
-  __asm__("stw %1,%0" : "=m"(mem) : "r"(val))
+#define __kernel_stb(val,mem)				\
+  __asm__(".arch ev56;					\
+	   stb %1,%0" : "=m"(mem) : "r"(val))
+#define __kernel_stw(val,mem)				\
+  __asm__(".arch ev56;					\
+	   stw %1,%0" : "=m"(mem) : "r"(val))
 #endif
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

account-for-module-percpu-space-separately-from-kernel.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
alpha-fix-bootp-image-creation.patch
alpha-prctl-macros.patch
alpha-fixes-for-specific-machine-types.patch
alpha-more-fixes-for-specific-machine-types.patch
alpha-build-fixes-force-architecture.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
lutimesat-extend-do_utimes-with-flags.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
local_t-alpha-extension.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
make-sure-nobodys-leaking-resources.patch

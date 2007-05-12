From: akpm@linux-foundation.org
Subject: - m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:03 -0700
Message-ID: <200705120533.l4C5X3xB002079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138AbXELFeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takata.hirokazu@renesas.com, alan@linuxcare.com.au, hitoshiy@linux-m32r.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: fix switch_to macro to push/pop frame pointer if needed
has been removed from the -mm tree.  Its filename was
     m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: fix switch_to macro to push/pop frame pointer if needed
From: Hirokazu Takata <takata.hirokazu@renesas.com>

This patch fixes a rarely-happened but severe scheduling problem of
the recent m32r kernel of 2.6.17-rc3 or later.

In the following previous m32r patch, the switch_to macro was
modified not to do unnecessary push/pop operations for tuning.
> [PATCH] m32r: update switch_to macro for tuning
> 4127272c38619c56f0c1aa01d01c7bd757db70a1

In this modification, only 'lr' and 'sp' registers are push/pop'ed,
assuming that the m32r kernel is always compiled with
-fomit-frame-pointer option.

However, in 2.6 kernel, kernel/sched.c is irregularly compiled
with -fno-omit-frame-pointer if CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER
is not defined.

 -- kernel/Makefile --
   :
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
 # needed for x86 only.  Why this used to be enabled for all architectures is beyond
 # me.  I suspect most platforms don't need this, but until we know that for sure
 # I turn this off for IA-64 only.  Andreas Schwab says it's also needed on m68k
 # to get a correct value for the wait-channel (WCHAN in ps). --davidm
 CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
 endif
   :
 ---

Therefore, for the recent m32r kernel, we have to push/pop 'fp'
(frame pointer) if CONFIG_FRAME_POINTER is defined or
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not defined.

Signed-off-by: Hitoshi Yamamoto <hitoshiy@linux-m32r.org>
Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig         |    4 ++++
 include/asm-m32r/system.h |   11 +++++++++++
 2 files changed, 15 insertions(+)

diff -puN arch/m32r/Kconfig~m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if
+++ a/arch/m32r/Kconfig
@@ -241,6 +241,10 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config SCHED_NO_NO_OMIT_FRAME_POINTER
+        bool
+        default y
+
 config PREEMPT
 	bool "Preemptible Kernel"
 	help
diff -puN include/asm-m32r/system.h~m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if include/asm-m32r/system.h
--- a/include/asm-m32r/system.h~m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if
+++ a/include/asm-m32r/system.h
@@ -21,12 +21,22 @@
  * `next' and `prev' should be struct task_struct, but it isn't always defined
  */
 
+#if defined(CONFIG_FRAME_POINTER) || \
+	!defined(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER)
+#define M32R_PUSH_FP "	push fp\n"
+#define M32R_POP_FP  "	pop  fp\n"
+#else
+#define M32R_PUSH_FP ""
+#define M32R_POP_FP  ""
+#endif
+
 #define switch_to(prev, next, last)  do { \
 	__asm__ __volatile__ ( \
 		"	seth	lr, #high(1f)				\n" \
 		"	or3	lr, lr, #low(1f)			\n" \
 		"	st	lr, @%4  ; store old LR			\n" \
 		"	ld	lr, @%5  ; load new LR			\n" \
+			M32R_PUSH_FP \
 		"	st	sp, @%2  ; store old SP			\n" \
 		"	ld	sp, @%3  ; load new SP			\n" \
 		"	push	%1  ; store `prev' on new stack		\n" \
@@ -34,6 +44,7 @@
 		"	.fillinsn					\n" \
 		"1:							\n" \
 		"	pop	%0  ; restore `__last' from new stack	\n" \
+			M32R_POP_FP \
 		: "=r" (last) \
 		: "0" (prev), \
 		  "r" (&(prev->thread.sp)), "r" (&(next->thread.sp)), \
_

Patches currently in -mm which might be from takata.hirokazu@renesas.com are

origin.patch

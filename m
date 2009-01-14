From: akpm@linux-foundation.org
Subject: + alpha-fix-rtc-on-marvel.patch added to -mm tree
Date: Wed, 14 Jan 2009 09:47:42 -0800
Message-ID: <200901141747.n0EHlgEZ020832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403AbZANRsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 12:48:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: fix RTC on marvel
has been added to the -mm tree.  Its filename is
     alpha-fix-rtc-on-marvel.patch

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
Subject: alpha: fix RTC on marvel
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Unlike other alphas, marvel doesn't have real PC-style CMOS clock hardware
- RTC accesses are emulated via PAL calls.  Unfortunately, for unknown
reason these calls work only on CPU #0.  So current implementation for
arbitrary CPU makes CMOS_READ/WRITE to be executed on CPU #0 via IPI. 
However, for obvious reason this doesn't work with standard
get/set_rtc_time() functions, where a bunch of CMOS accesses is done with
disabled interrupts.

Solved by making the IPI calls for entire get/set_rtc_time() functions,
not for individual CMOS accesses.  Which is also a lot more effective
performance-wise.

The patch is largely based on the code from Jay Estabrook.
My changes:
- tweak asm-generic/rtc.h by adding a couple of #defines to
  avoid a massive code duplication in arch/alpha/include/asm/rtc.h;
- sys_marvel.c: fix get/set_rtc_time() return values (Jay's FIXMEs).

NOTE: this fixes *only* LIB_RTC drivers.  Legacy (CONFIG_RTC) driver
wont't work on marvel.  Actually I think that we should just disable
CONFIG_RTC on alpha (maybe in 2.6.30?), like most other arches - AFAIK,
all modern distributions use LIB_RTC anyway.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/machvec.h |    4 ++
 arch/alpha/include/asm/rtc.h     |   12 ++++--
 arch/alpha/kernel/core_marvel.c  |   10 -----
 arch/alpha/kernel/machvec_impl.h |    5 ++
 arch/alpha/kernel/proto.h        |    2 +
 arch/alpha/kernel/sys_jensen.c   |    2 +
 arch/alpha/kernel/sys_marvel.c   |   56 ++++++++++++++++++++++++++++-
 arch/alpha/kernel/time.c         |   10 +++++
 include/asm-generic/rtc.h        |   14 +++++--
 9 files changed, 98 insertions(+), 17 deletions(-)

diff -puN arch/alpha/include/asm/machvec.h~alpha-fix-rtc-on-marvel arch/alpha/include/asm/machvec.h
--- a/arch/alpha/include/asm/machvec.h~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/include/asm/machvec.h
@@ -21,6 +21,7 @@ struct pci_dev;
 struct pci_ops;
 struct pci_controller;
 struct _alpha_agp_info;
+struct rtc_time;
 
 struct alpha_machine_vector
 {
@@ -94,6 +95,9 @@ struct alpha_machine_vector
 
 	struct _alpha_agp_info *(*agp_info)(void);
 
+	unsigned int (*rtc_get_time)(struct rtc_time *);
+	int (*rtc_set_time)(struct rtc_time *);
+
 	const char *vector_name;
 
 	/* NUMA information */
diff -puN arch/alpha/include/asm/rtc.h~alpha-fix-rtc-on-marvel arch/alpha/include/asm/rtc.h
--- a/arch/alpha/include/asm/rtc.h~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/include/asm/rtc.h
@@ -1,9 +1,15 @@
 #ifndef _ALPHA_RTC_H
 #define _ALPHA_RTC_H
 
-/*
- * Alpha uses the default access methods for the RTC.
- */
+#if defined(CONFIG_ALPHA_GENERIC)
+# define get_rtc_time		alpha_mv.rtc_get_time
+# define set_rtc_time		alpha_mv.rtc_set_time
+#else
+# if defined(CONFIG_ALPHA_MARVEL) && defined(CONFIG_SMP)
+#  define get_rtc_time		marvel_get_rtc_time
+#  define set_rtc_time		marvel_set_rtc_time
+# endif
+#endif
 
 #include <asm-generic/rtc.h>
 
diff -puN arch/alpha/kernel/core_marvel.c~alpha-fix-rtc-on-marvel arch/alpha/kernel/core_marvel.c
--- a/arch/alpha/kernel/core_marvel.c~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/kernel/core_marvel.c
@@ -658,16 +658,8 @@ __marvel_rtc_io(u8 b, unsigned long addr
 		rtc_access.data = bcd2bin(b);
 		rtc_access.function = 0x48 + !write;	/* GET/PUT_TOY */
 
-#ifdef CONFIG_SMP
-		if (smp_processor_id() != boot_cpuid)
-			smp_call_function_single(boot_cpuid,
-						 __marvel_access_rtc,
-						 &rtc_access, 1);
-		else
-			__marvel_access_rtc(&rtc_access);
-#else
 		__marvel_access_rtc(&rtc_access);
-#endif
+
 		ret = bin2bcd(rtc_access.data);
 		break;
 
diff -puN arch/alpha/kernel/machvec_impl.h~alpha-fix-rtc-on-marvel arch/alpha/kernel/machvec_impl.h
--- a/arch/alpha/kernel/machvec_impl.h~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/kernel/machvec_impl.h
@@ -40,7 +40,10 @@
 #define CAT1(x,y)  x##y
 #define CAT(x,y)   CAT1(x,y)
 
-#define DO_DEFAULT_RTC .rtc_port = 0x70
+#define DO_DEFAULT_RTC \
+	.rtc_port = 0x70, \
+	.rtc_get_time = common_get_rtc_time, \
+	.rtc_set_time = common_set_rtc_time
 
 #define DO_EV4_MMU							\
 	.max_asn =			EV4_MAX_ASN,			\
diff -puN arch/alpha/kernel/proto.h~alpha-fix-rtc-on-marvel arch/alpha/kernel/proto.h
--- a/arch/alpha/kernel/proto.h~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/kernel/proto.h
@@ -145,6 +145,8 @@ extern void smp_percpu_timer_interrupt(s
 extern irqreturn_t timer_interrupt(int irq, void *dev);
 extern void common_init_rtc(void);
 extern unsigned long est_cycle_freq;
+extern unsigned int common_get_rtc_time(struct rtc_time *time);
+extern int common_set_rtc_time(struct rtc_time *time);
 
 /* smc37c93x.c */
 extern void SMC93x_Init(void);
diff -puN arch/alpha/kernel/sys_jensen.c~alpha-fix-rtc-on-marvel arch/alpha/kernel/sys_jensen.c
--- a/arch/alpha/kernel/sys_jensen.c~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/kernel/sys_jensen.c
@@ -261,6 +261,8 @@ struct alpha_machine_vector jensen_mv __
 	.machine_check		= jensen_machine_check,
 	.max_isa_dma_address	= ALPHA_MAX_ISA_DMA_ADDRESS,
 	.rtc_port		= 0x170,
+	.rtc_get_time		= common_get_rtc_time,
+	.rtc_set_time		= common_set_rtc_time,
 
 	.nr_irqs		= 16,
 	.device_interrupt	= jensen_device_interrupt,
diff -puN arch/alpha/kernel/sys_marvel.c~alpha-fix-rtc-on-marvel arch/alpha/kernel/sys_marvel.c
--- a/arch/alpha/kernel/sys_marvel.c~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/kernel/sys_marvel.c
@@ -23,6 +23,7 @@
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
 #include <asm/vga.h>
+#include <asm/rtc.h>
 
 #include "proto.h"
 #include "err_impl.h"
@@ -426,6 +427,57 @@ marvel_init_rtc(void)
 	init_rtc_irq();
 }
 
+struct marvel_rtc_time {
+	struct rtc_time *time;
+	int retval;
+};
+
+#ifdef CONFIG_SMP
+static void
+smp_get_rtc_time(void *data)
+{
+	struct marvel_rtc_time *mrt = data;
+	mrt->retval = __get_rtc_time(mrt->time);
+}
+
+static void
+smp_set_rtc_time(void *data)
+{
+	struct marvel_rtc_time *mrt = data;
+	mrt->retval = __set_rtc_time(mrt->time);
+}
+#endif
+
+static unsigned int
+marvel_get_rtc_time(struct rtc_time *time)
+{
+#ifdef CONFIG_SMP
+	struct marvel_rtc_time mrt;
+
+	if (smp_processor_id() != boot_cpuid) {
+		mrt.time = time;
+		smp_call_function_single(boot_cpuid, smp_get_rtc_time, &mrt, 1);
+		return mrt.retval;
+	}
+#endif
+	return __get_rtc_time(time);
+}
+
+static int
+marvel_set_rtc_time(struct rtc_time *time)
+{
+#ifdef CONFIG_SMP
+	struct marvel_rtc_time mrt;
+
+	if (smp_processor_id() != boot_cpuid) {
+		mrt.time = time;
+		smp_call_function_single(boot_cpuid, smp_set_rtc_time, &mrt, 1);
+		return mrt.retval;
+	}
+#endif
+	return __set_rtc_time(time);
+}
+
 static void
 marvel_smp_callin(void)
 {
@@ -466,7 +518,9 @@ marvel_smp_callin(void)
 struct alpha_machine_vector marvel_ev7_mv __initmv = {
 	.vector_name		= "MARVEL/EV7",
 	DO_EV7_MMU,
-	DO_DEFAULT_RTC,
+	.rtc_port		= 0x70,
+	.rtc_get_time		= marvel_get_rtc_time,
+	.rtc_set_time		= marvel_set_rtc_time,
 	DO_MARVEL_IO,
 	.machine_check		= marvel_machine_check,
 	.max_isa_dma_address	= ALPHA_MAX_ISA_DMA_ADDRESS,
diff -puN arch/alpha/kernel/time.c~alpha-fix-rtc-on-marvel arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~alpha-fix-rtc-on-marvel
+++ a/arch/alpha/kernel/time.c
@@ -46,6 +46,7 @@
 #include <asm/io.h>
 #include <asm/hwrpb.h>
 #include <asm/8253pit.h>
+#include <asm/rtc.h>
 
 #include <linux/mc146818rtc.h>
 #include <linux/time.h>
@@ -180,6 +181,15 @@ common_init_rtc(void)
 	init_rtc_irq();
 }
 
+unsigned int common_get_rtc_time(struct rtc_time *time)
+{
+	return __get_rtc_time(time);
+}
+
+int common_set_rtc_time(struct rtc_time *time)
+{
+	return __set_rtc_time(time);
+}
 
 /* Validate a computed cycle counter result against the known bounds for
    the given processor core.  There's too much brokenness in the way of
diff -puN include/asm-generic/rtc.h~alpha-fix-rtc-on-marvel include/asm-generic/rtc.h
--- a/include/asm-generic/rtc.h~alpha-fix-rtc-on-marvel
+++ a/include/asm-generic/rtc.h
@@ -42,7 +42,7 @@ static inline unsigned char rtc_is_updat
 	return uip;
 }
 
-static inline unsigned int get_rtc_time(struct rtc_time *time)
+static inline unsigned int __get_rtc_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
@@ -108,8 +108,12 @@ static inline unsigned int get_rtc_time(
 	return RTC_24H;
 }
 
+#ifndef get_rtc_time
+#define get_rtc_time	__get_rtc_time
+#endif
+
 /* Set the current date and time in the real time clock. */
-static inline int set_rtc_time(struct rtc_time *time)
+static inline int __set_rtc_time(struct rtc_time *time)
 {
 	unsigned long flags;
 	unsigned char mon, day, hrs, min, sec;
@@ -190,11 +194,15 @@ static inline int set_rtc_time(struct rt
 	return 0;
 }
 
+#ifndef set_rtc_time
+#define set_rtc_time	__set_rtc_time
+#endif
+
 static inline unsigned int get_rtc_ss(void)
 {
 	struct rtc_time h;
 
-	get_rtc_time(&h);
+	__get_rtc_time(&h);
 	return h.tm_sec;
 }
 
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-fix-vmalloc-breakage.patch
alpha-fix-vmalloc-breakage-fix.patch
alpha-nautilus-fix-compile-failure-with-gcc-43.patch
alpha-nautilus-fix-hang-on-boot.patch
alpha-fix-rtc-on-marvel.patch
alpha-gitignore-vmlinuxlds.patch
alpha-make-pte_alloc_one_kernel-inline.patch
make-sure-nobodys-leaking-resources.patch


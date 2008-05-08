From: akpm@linux-foundation.org
Subject: + common-implementation-of-iterative-div-mod.patch added to -mm tree
Date: Thu, 08 May 2008 13:26:44 -0700
Message-ID: <200805082026.m48KQi5X004206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932460AbYEHU2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, hancockr@shaw.ca, jeremy.fitzhardinge@citrix.com, johnstul@us.ibm.com, lists@nerdbynature.de, mingo@elte.hu, segher@kernel.crashing.org, tglx@linutronix.de


The patch titled
     common implementation of iterative div/mod
has been added to the -mm tree.  Its filename is
     common-implementation-of-iterative-div-mod.patch

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
Subject: common implementation of iterative div/mod
From: Jeremy Fitzhardinge <jeremy@goop.org>

We have a few instances of the open-coded iterative div/mod loop, used when we
don't expcet the dividend to be much bigger than the divisor.  Unfortunately
modern gcc's have the tendency to strength "reduce" this into a full mod
operation, which isn't necessarily any faster, and even if it were, doesn't
exist if gcc implements it in libgcc.

The workaround is to put a dummy asm statement in the loop to prevent gcc from
performing the transformation.

This patch creates a single implementation of this loop, and uses it to
replace the open-coded versions I know about.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/time.c    |   13 +++----------
 include/linux/math64.h |    2 ++
 include/linux/time.h   |   11 ++---------
 lib/div64.c            |   23 +++++++++++++++++++++++
 4 files changed, 30 insertions(+), 19 deletions(-)

diff -puN arch/x86/xen/time.c~common-implementation-of-iterative-div-mod arch/x86/xen/time.c
--- a/arch/x86/xen/time.c~common-implementation-of-iterative-div-mod
+++ a/arch/x86/xen/time.c
@@ -12,6 +12,7 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/kernel_stat.h>
+#include <linux/math64.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -150,11 +151,7 @@ static void do_stolen_accounting(void)
 	if (stolen < 0)
 		stolen = 0;
 
-	ticks = 0;
-	while (stolen >= NS_PER_TICK) {
-		ticks++;
-		stolen -= NS_PER_TICK;
-	}
+	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
 	__get_cpu_var(residual_stolen) = stolen;
 	account_steal_time(NULL, ticks);
 
@@ -166,11 +163,7 @@ static void do_stolen_accounting(void)
 	if (blocked < 0)
 		blocked = 0;
 
-	ticks = 0;
-	while (blocked >= NS_PER_TICK) {
-		ticks++;
-		blocked -= NS_PER_TICK;
-	}
+	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
 	__get_cpu_var(residual_blocked) = blocked;
 	account_steal_time(idle_task(smp_processor_id()), ticks);
 }
diff -puN include/linux/math64.h~common-implementation-of-iterative-div-mod include/linux/math64.h
--- a/include/linux/math64.h~common-implementation-of-iterative-div-mod
+++ a/include/linux/math64.h
@@ -81,4 +81,6 @@ static inline s64 div_s64(s64 dividend, 
 }
 #endif
 
+unsigned iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
+
 #endif /* _LINUX_MATH64_H */
diff -puN include/linux/time.h~common-implementation-of-iterative-div-mod include/linux/time.h
--- a/include/linux/time.h~common-implementation-of-iterative-div-mod
+++ a/include/linux/time.h
@@ -2,6 +2,7 @@
 #define _LINUX_TIME_H
 
 #include <linux/types.h>
+#include <linux/math64.h>
 
 #ifdef __KERNEL__
 # include <linux/cache.h>
@@ -172,15 +173,7 @@ extern struct timeval ns_to_timeval(cons
  */
 static inline void timespec_add_ns(struct timespec *a, u64 ns)
 {
-	ns += a->tv_nsec;
-	while(unlikely(ns >= NSEC_PER_SEC)) {
-		/* The following asm() prevents the compiler from
-		 * optimising this loop into a modulo operation.  */
-		asm("" : "+r"(ns));
-
-		ns -= NSEC_PER_SEC;
-		a->tv_sec++;
-	}
+	a->tv_sec += iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
 #endif /* __KERNEL__ */
diff -puN lib/div64.c~common-implementation-of-iterative-div-mod lib/div64.c
--- a/lib/div64.c~common-implementation-of-iterative-div-mod
+++ a/lib/div64.c
@@ -98,3 +98,26 @@ EXPORT_SYMBOL(div64_u64);
 #endif
 
 #endif /* BITS_PER_LONG == 32 */
+
+/*
+ * Iterative div/mod for use when dividend is not expected to be much
+ * bigger than divisor.
+ */
+unsigned iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
+{
+	unsigned ret = 0;
+
+	while(dividend >= divisor) {
+		/* The following asm() prevents the compiler from
+		   optimising this loop into a modulo operation.  */
+		asm("" : "+rm"(dividend));
+
+		dividend -= divisor;
+		ret++;
+	}
+
+	*remainder = dividend;
+
+	return ret;
+}
+EXPORT_SYMBOL(iter_div_u64_rem);
_

Patches currently in -mm which might be from jeremy@goop.org are

common-implementation-of-iterative-div-mod.patch


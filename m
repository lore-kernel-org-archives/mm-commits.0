From: akpm@linux-foundation.org
Subject: + arm-implement-a-timer-based-__delay-loop.patch added to -mm tree
Date: Tue, 21 Dec 2010 14:24:19 -0800
Message-ID: <201012212224.oBLMOKT6029496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab0LUWYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 17:24:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, skannan@codeaurora.org


The patch titled
     arm: implement a timer based __delay() loop
has been added to the -mm tree.  Its filename is
     arm-implement-a-timer-based-__delay-loop.patch

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
Subject: arm: implement a timer based __delay() loop
From: Stephen Boyd <sboyd@codeaurora.org>

udelay() can be incorrect on SMP machines that scale their CPU frequencies
independently of one another (as pointed out here
http://article.gmane.org/gmane.linux.kernel/977567).  The delay loop can
either be too fast or too slow depending on which CPU the loops_per_jiffy
counter is calibrated on and which CPU the delay loop is running on. 
udelay() can also be incorrect if the CPU frequency switches during the
__delay() loop, causing the loop to either terminate too early, or too
late.

Forcing udelay() to run on one CPU is unreasonable and taking the penalty
of a rather large loops_per_jiffy in udelay() when the CPU is actually
running slower is bad for performance.  Solve the problem by adding a
timer based__delay() loop unaffected by CPU frequency scaling.  Machines
should set this loop as their __delay() implementation by calling
set_timer_fn() during their timer initialization.

The kernel is already prepared for a timer based approach (evident by the
read_current_timer() function).  If an arch implements
read_current_timer(), calibrate_delay() will use calibrate_delay_direct()
to calculate loops_per_jiffy (in which case loops_per_jiffy should really
be renamed to timer_ticks_per_jiffy).  Since the loops_per_jiffy will be
based on timer ticks, __delay() should be implemented as a loop around
read_current_timer().

Doing this makes the expensive loops_per_jiffy calculation go away (saving
~150ms on boot time on my machine) and fixes udelay() by making it safe in
the face of independently scaling CPUs.  The only prerequisite is that
read_current_timer() is monotonically increasing across calls (and doesn't
overflow within ~2000us).

There is a downside to this approach though.  BogoMIPS is no longer
"accurate" in that it reflects the BogoMIPS of the timer and not the CPU. 
On most SoC's the timer isn't running anywhere near as fast as the CPU so
BogoMIPS will be ridiculously low (my timer runs at 4.8 MHz and thus my
BogoMIPS is 9.6 compared to my CPU's 800).  This shouldn't be too much of
a concern though since BogoMIPS are bogus anyway (hence the name).

This loop is pretty much a copy of AVR's version.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-and-reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/delay.h |    2 ++
 arch/arm/lib/delay.c         |   17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff -puN arch/arm/include/asm/delay.h~arm-implement-a-timer-based-__delay-loop arch/arm/include/asm/delay.h
--- a/arch/arm/include/asm/delay.h~arm-implement-a-timer-based-__delay-loop
+++ a/arch/arm/include/asm/delay.h
@@ -47,5 +47,7 @@ static inline void set_delay_fn(void (*f
 	delay_fn = fn;
 }
 
+extern void read_current_timer_delay_loop(unsigned long loops);
+
 #endif /* defined(_ARM_DELAY_H) */
 
diff -puN arch/arm/lib/delay.c~arm-implement-a-timer-based-__delay-loop arch/arm/lib/delay.c
--- a/arch/arm/lib/delay.c~arm-implement-a-timer-based-__delay-loop
+++ a/arch/arm/lib/delay.c
@@ -9,6 +9,7 @@
  */
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/timex.h>
 
 /*
  * Oh, if only we had a cycle counter...
@@ -23,6 +24,22 @@ static void delay_loop(unsigned long loo
 	);
 }
 
+#ifdef ARCH_HAS_READ_CURRENT_TIMER
+/*
+ * Assumes read_current_timer() is monotonically increasing
+ * across calls and wraps at most once within MAX_UDELAY_MS.
+ */
+void read_current_timer_delay_loop(unsigned long loops)
+{
+	unsigned long bclock, now;
+
+	read_current_timer(&bclock);
+	do {
+		read_current_timer(&now);
+	} while ((now - bclock) < loops);
+}
+#endif
+
 void (*delay_fn)(unsigned long) = delay_loop;
 
 /*
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

arm-translate-delays-into-mostly-c.patch
arm-allow-machines-to-override-__delay.patch
arm-implement-a-timer-based-__delay-loop.patch
msm-timer-migrate-to-timer-based-__delay.patch


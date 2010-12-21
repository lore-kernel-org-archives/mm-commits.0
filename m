From: akpm@linux-foundation.org
Subject: + arm-allow-machines-to-override-__delay.patch added to -mm tree
Date: Tue, 21 Dec 2010 14:24:17 -0800
Message-ID: <201012212224.oBLMOHdD029493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab0LUWYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 17:24:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, skannan@codeaurora.org


The patch titled
     arm: allow machines to override __delay()
has been added to the -mm tree.  Its filename is
     arm-allow-machines-to-override-__delay.patch

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
Subject: arm: allow machines to override __delay()
From: Stephen Boyd <sboyd@codeaurora.org>

Some machines want to implement their own __delay() routine based
on fixed rate timers. Expose functionality to set the __delay()
routine at runtime. This should allow two machines with different
__delay() routines to happily co-exist within the same kernel
with minimal overhead.

Russell expressed concern that using a timer based __delay()
would cause problems when an iomapped device isn't mapped in
prior to a delay call being made (see
http://article.gmane.org/gmane.linux.ports.arm.kernel/78543 for
more info). We can sidestep that issue with this approach since
the __delay() routine _should_ only be pointed to a timer based
delay once the timer has been properly mapped. Up until that
point __delay() and udelay() will use delay_loop() which is
always safe to call.

This patch is inspired by x86's delay.c

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/delay.h |    7 +++++++
 arch/arm/lib/delay.c         |   14 +++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN arch/arm/include/asm/delay.h~arm-allow-machines-to-override-__delay arch/arm/include/asm/delay.h
--- a/arch/arm/include/asm/delay.h~arm-allow-machines-to-override-__delay
+++ a/arch/arm/include/asm/delay.h
@@ -40,5 +40,12 @@ extern void __const_udelay(unsigned long
 			__const_udelay((n) * ((2199023U*HZ)>>11))) :	\
 	  __udelay(n))
 
+extern void (*delay_fn)(unsigned long);
+
+static inline void set_delay_fn(void (*fn)(unsigned long))
+{
+	delay_fn = fn;
+}
+
 #endif /* defined(_ARM_DELAY_H) */
 
diff -puN arch/arm/lib/delay.c~arm-allow-machines-to-override-__delay arch/arm/lib/delay.c
--- a/arch/arm/lib/delay.c~arm-allow-machines-to-override-__delay
+++ a/arch/arm/lib/delay.c
@@ -11,11 +11,9 @@
 #include <linux/delay.h>
 
 /*
- * loops = usecs * HZ * loops_per_jiffy / 1000000
- *
  * Oh, if only we had a cycle counter...
  */
-void __delay(unsigned long loops)
+static void delay_loop(unsigned long loops)
 {
 	asm volatile(
 	"1:	subs %0, %0, #1 \n"
@@ -24,6 +22,16 @@ void __delay(unsigned long loops)
 	: "r" (loops)
 	);
 }
+
+void (*delay_fn)(unsigned long) = delay_loop;
+
+/*
+ * loops = usecs * HZ * loops_per_jiffy / 1000000
+ */
+void __delay(unsigned long loops)
+{
+	delay_fn(loops);
+}
 EXPORT_SYMBOL(__delay);
 
 /*
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

arm-translate-delays-into-mostly-c.patch
arm-allow-machines-to-override-__delay.patch
arm-implement-a-timer-based-__delay-loop.patch
msm-timer-migrate-to-timer-based-__delay.patch


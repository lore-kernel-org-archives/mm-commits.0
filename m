From: akpm@linux-foundation.org
Subject: + mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:17:01 -0700
Message-ID: <20120620221702.0185CA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44223 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab2FTWRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:17:05 -0400
Received: by lbbgp10 with SMTP id gp10so61791lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:17:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: mn10300: move setup_jiffies_interrupt() to cevt-mn10300.c
has been added to the -mm tree.  Its filename is
     mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mn10300: move setup_jiffies_interrupt() to cevt-mn10300.c

Move the static inline function setup_jiffies_interrupt() from
<asm/timex.h> to arch/mn10300/kernel/cevt-mn10300.c, which is its only
callsite.

This allows to remove the inclusion of <asm/hardirq.h> and <linux/irq.h>
from <asm/timex.h> and <unit/timex.h>, fixing include hell like:

include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:260:31: warning: "CLOCK_TICK_RATE" is not defined [-Wundef]
include/linux/jiffies.h:46:42: error: division by zero in #if
include/linux/jiffies.h:46:42: error: division by zero in #if
make[4]: *** [arch/mn10300/kernel/asm-offsets.s] Error 1

and (after a quick hack for the above by defining CLOCK_TICK_RATE in
<linux/jiffies.h>):

In file included from include/linux/notifier.h:15:0,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:718,
                 from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from arch/mn10300/unit-asb2303/include/unit/timex.h:15,
                 from arch/mn10300/include/asm/timex.h:15,
                 from include/linux/timex.h:174,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
include/linux/srcu.h:55:22: error: field 'work' has incomplete type

As a consequence, we do need a few more inclusions of <asm/irq.h>, namely
in arch/mn10300/unit-asb2303/smc91111.c and
arch/mn10300/unit-asb2305/unit-init.c.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/timex.h               |   11 -----------
 arch/mn10300/kernel/cevt-mn10300.c             |   10 ++++++++++
 arch/mn10300/unit-asb2303/include/unit/timex.h |    4 ----
 arch/mn10300/unit-asb2303/smc91111.c           |    1 +
 arch/mn10300/unit-asb2305/include/unit/timex.h |    4 ----
 arch/mn10300/unit-asb2305/unit-init.c          |    1 +
 arch/mn10300/unit-asb2364/include/unit/timex.h |    4 ----
 7 files changed, 12 insertions(+), 23 deletions(-)

diff -puN arch/mn10300/include/asm/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c arch/mn10300/include/asm/timex.h
--- a/arch/mn10300/include/asm/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c
+++ a/arch/mn10300/include/asm/timex.h
@@ -11,7 +11,6 @@
 #ifndef _ASM_TIMEX_H
 #define _ASM_TIMEX_H
 
-#include <asm/hardirq.h>
 #include <unit/timex.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
@@ -30,16 +29,6 @@ static inline cycles_t get_cycles(void)
 extern int init_clockevents(void);
 extern int init_clocksource(void);
 
-static inline void setup_jiffies_interrupt(int irq,
-					   struct irqaction *action)
-{
-	u16 tmp;
-	setup_irq(irq, action);
-	set_intr_level(irq, NUM2GxICR_LEVEL(CONFIG_TIMER_IRQ_LEVEL));
-	GxICR(irq) |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
-	tmp = GxICR(irq);
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TIMEX_H */
diff -puN arch/mn10300/kernel/cevt-mn10300.c~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c arch/mn10300/kernel/cevt-mn10300.c
--- a/arch/mn10300/kernel/cevt-mn10300.c~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c
+++ a/arch/mn10300/kernel/cevt-mn10300.c
@@ -70,6 +70,16 @@ static void event_handler(struct clock_e
 {
 }
 
+static inline void setup_jiffies_interrupt(int irq,
+					   struct irqaction *action)
+{
+	u16 tmp;
+	setup_irq(irq, action);
+	set_intr_level(irq, NUM2GxICR_LEVEL(CONFIG_TIMER_IRQ_LEVEL));
+	GxICR(irq) |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	tmp = GxICR(irq);
+}
+
 int __init init_clockevents(void)
 {
 	struct clock_event_device *cd;
diff -puN arch/mn10300/unit-asb2303/include/unit/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c arch/mn10300/unit-asb2303/include/unit/timex.h
--- a/arch/mn10300/unit-asb2303/include/unit/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c
+++ a/arch/mn10300/unit-asb2303/include/unit/timex.h
@@ -11,10 +11,6 @@
 #ifndef _ASM_UNIT_TIMEX_H
 #define _ASM_UNIT_TIMEX_H
 
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */
-
 #include <asm/timer-regs.h>
 #include <unit/clock.h>
 #include <asm/param.h>
diff -puN arch/mn10300/unit-asb2303/smc91111.c~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c arch/mn10300/unit-asb2303/smc91111.c
--- a/arch/mn10300/unit-asb2303/smc91111.c~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c
+++ a/arch/mn10300/unit-asb2303/smc91111.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
+#include <asm/irq.h>
 #include <asm/timex.h>
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
diff -puN arch/mn10300/unit-asb2305/include/unit/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c arch/mn10300/unit-asb2305/include/unit/timex.h
--- a/arch/mn10300/unit-asb2305/include/unit/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c
+++ a/arch/mn10300/unit-asb2305/include/unit/timex.h
@@ -11,10 +11,6 @@
 #ifndef _ASM_UNIT_TIMEX_H
 #define _ASM_UNIT_TIMEX_H
 
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */
-
 #include <asm/timer-regs.h>
 #include <unit/clock.h>
 #include <asm/param.h>
diff -puN arch/mn10300/unit-asb2305/unit-init.c~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c arch/mn10300/unit-asb2305/unit-init.c
--- a/arch/mn10300/unit-asb2305/unit-init.c~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c
+++ a/arch/mn10300/unit-asb2305/unit-init.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/io.h>
+#include <asm/irq.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
diff -puN arch/mn10300/unit-asb2364/include/unit/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c arch/mn10300/unit-asb2364/include/unit/timex.h
--- a/arch/mn10300/unit-asb2364/include/unit/timex.h~mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c
+++ a/arch/mn10300/unit-asb2364/include/unit/timex.h
@@ -11,10 +11,6 @@
 #ifndef _ASM_UNIT_TIMEX_H
 #define _ASM_UNIT_TIMEX_H
 
-#ifndef __ASSEMBLY__
-#include <linux/irq.h>
-#endif /* __ASSEMBLY__ */

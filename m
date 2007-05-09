From: akpm@linux-foundation.org
Subject: - add-irqf_irqpoll-flag-on-arm.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:26 -0700
Message-ID: <200705090256.l492uQ10010046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032609AbXEIC4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add IRQF_IRQPOLL flag on arm
has been removed from the -mm tree.  Its filename was
     add-irqf_irqpoll-flag-on-arm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add IRQF_IRQPOLL flag on arm
From: Bernhard Walle <bwalle@suse.de>

Add IRQF_IRQPOLL for each timer interrupt.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-aaec2000/core.c            |    2 +-
 arch/arm/mach-at91/at91rm9200_time.c     |    2 +-
 arch/arm/mach-at91/at91sam926x_time.c    |    2 +-
 arch/arm/mach-clps711x/time.c            |    2 +-
 arch/arm/mach-clps7500/core.c            |    2 +-
 arch/arm/mach-ebsa110/core.c             |    2 +-
 arch/arm/mach-ep93xx/core.c              |    2 +-
 arch/arm/mach-footbridge/dc21285-timer.c |    2 +-
 arch/arm/mach-footbridge/isa-timer.c     |    2 +-
 arch/arm/mach-h720x/cpu-h7201.c          |    2 +-
 arch/arm/mach-h720x/cpu-h7202.c          |    2 +-
 arch/arm/mach-imx/time.c                 |    2 +-
 arch/arm/mach-integrator/core.c          |    2 +-
 arch/arm/mach-ixp2000/core.c             |    2 +-
 arch/arm/mach-ixp23xx/core.c             |    2 +-
 arch/arm/mach-ixp4xx/common.c            |    2 +-
 arch/arm/mach-lh7a40x/time.c             |    2 +-
 arch/arm/mach-netx/time.c                |    2 +-
 arch/arm/mach-ns9xxx/time.c              |    2 +-
 arch/arm/mach-omap1/time.c               |    2 +-
 arch/arm/mach-omap2/timer-gp.c           |    2 +-
 arch/arm/mach-pnx4008/time.c             |    2 +-
 arch/arm/mach-pxa/time.c                 |    2 +-
 arch/arm/mach-realview/core.c            |    2 +-
 arch/arm/mach-sa1100/h3600.c             |    2 +-
 arch/arm/mach-sa1100/time.c              |    2 +-
 arch/arm/mach-shark/core.c               |    2 +-
 arch/arm/mach-versatile/core.c           |    2 +-
 arch/arm/plat-iop/time.c                 |    2 +-
 arch/arm/plat-omap/timer32k.c            |    2 +-
 arch/arm/plat-s3c24xx/time.c             |    2 +-
 31 files changed, 31 insertions(+), 31 deletions(-)

diff -puN arch/arm/mach-aaec2000/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-aaec2000/core.c
--- a/arch/arm/mach-aaec2000/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-aaec2000/core.c
@@ -142,7 +142,7 @@ aaec2000_timer_interrupt(int irq, void *
 
 static struct irqaction aaec2000_timer_irq = {
 	.name		= "AAEC-2000 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= aaec2000_timer_interrupt,
 };
 
diff -puN arch/arm/mach-at91/at91rm9200_time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-at91/at91rm9200_time.c
--- a/arch/arm/mach-at91/at91rm9200_time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-at91/at91rm9200_time.c
@@ -87,7 +87,7 @@ static irqreturn_t at91rm9200_timer_inte
 
 static struct irqaction at91rm9200_timer_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= at91rm9200_timer_interrupt
 };
 
diff -puN arch/arm/mach-at91/at91sam926x_time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-at91/at91sam926x_time.c
--- a/arch/arm/mach-at91/at91sam926x_time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-at91/at91sam926x_time.c
@@ -66,7 +66,7 @@ static irqreturn_t at91sam926x_timer_int
 
 static struct irqaction at91sam926x_timer_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= at91sam926x_timer_interrupt
 };
 
diff -puN arch/arm/mach-clps711x/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-clps711x/time.c
--- a/arch/arm/mach-clps711x/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-clps711x/time.c
@@ -58,7 +58,7 @@ p720t_timer_interrupt(int irq, void *dev
 
 static struct irqaction clps711x_timer_irq = {
 	.name		= "CLPS711x Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= p720t_timer_interrupt,
 };
 
diff -puN arch/arm/mach-clps7500/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-clps7500/core.c
--- a/arch/arm/mach-clps7500/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-clps7500/core.c
@@ -316,7 +316,7 @@ clps7500_timer_interrupt(int irq, void *
 
 static struct irqaction clps7500_timer_irq = {
 	.name		= "CLPS7500 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= clps7500_timer_interrupt,
 };
 
diff -puN arch/arm/mach-ebsa110/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-ebsa110/core.c
--- a/arch/arm/mach-ebsa110/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-ebsa110/core.c
@@ -199,7 +199,7 @@ ebsa110_timer_interrupt(int irq, void *d
 
 static struct irqaction ebsa110_timer_irq = {
 	.name		= "EBSA110 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ebsa110_timer_interrupt,
 };
 
diff -puN arch/arm/mach-ep93xx/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-ep93xx/core.c
--- a/arch/arm/mach-ep93xx/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-ep93xx/core.c
@@ -116,7 +116,7 @@ static int ep93xx_timer_interrupt(int ir
 
 static struct irqaction ep93xx_timer_irq = {
 	.name		= "ep93xx timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ep93xx_timer_interrupt,
 };
 
diff -puN arch/arm/mach-footbridge/dc21285-timer.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-footbridge/dc21285-timer.c
--- a/arch/arm/mach-footbridge/dc21285-timer.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-footbridge/dc21285-timer.c
@@ -44,7 +44,7 @@ timer1_interrupt(int irq, void *dev_id)
 static struct irqaction footbridge_timer_irq = {
 	.name		= "Timer1 timer tick",
 	.handler	= timer1_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 /*
diff -puN arch/arm/mach-footbridge/isa-timer.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-footbridge/isa-timer.c
--- a/arch/arm/mach-footbridge/isa-timer.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-footbridge/isa-timer.c
@@ -73,7 +73,7 @@ isa_timer_interrupt(int irq, void *dev_i
 static struct irqaction isa_timer_irq = {
 	.name		= "ISA timer tick",
 	.handler	= isa_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 static void __init isa_timer_init(void)
diff -puN arch/arm/mach-h720x/cpu-h7201.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-h720x/cpu-h7201.c
--- a/arch/arm/mach-h720x/cpu-h7201.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-h720x/cpu-h7201.c
@@ -41,7 +41,7 @@ h7201_timer_interrupt(int irq, void *dev
 
 static struct irqaction h7201_timer_irq = {
 	.name		= "h7201 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= h7201_timer_interrupt,
 };
 
diff -puN arch/arm/mach-h720x/cpu-h7202.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-h720x/cpu-h7202.c
--- a/arch/arm/mach-h720x/cpu-h7202.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-h720x/cpu-h7202.c
@@ -170,7 +170,7 @@ static struct irq_chip h7202_timerx_chip
 
 static struct irqaction h7202_timer_irq = {
 	.name		= "h7202 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= h7202_timer_interrupt,
 };
 
diff -puN arch/arm/mach-imx/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-imx/time.c
--- a/arch/arm/mach-imx/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-imx/time.c
@@ -56,7 +56,7 @@ imx_timer_interrupt(int irq, void *dev_i
 
 static struct irqaction imx_timer_irq = {
 	.name		= "i.MX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= imx_timer_interrupt,
 };
 
diff -puN arch/arm/mach-integrator/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-integrator/core.c
--- a/arch/arm/mach-integrator/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-integrator/core.c
@@ -282,7 +282,7 @@ integrator_timer_interrupt(int irq, void
 
 static struct irqaction integrator_timer_irq = {
 	.name		= "Integrator Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= integrator_timer_interrupt,
 };
 
diff -puN arch/arm/mach-ixp2000/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-ixp2000/core.c
--- a/arch/arm/mach-ixp2000/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-ixp2000/core.c
@@ -224,7 +224,7 @@ static int ixp2000_timer_interrupt(int i
 
 static struct irqaction ixp2000_timer_irq = {
 	.name		= "IXP2000 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ixp2000_timer_interrupt,
 };
 
diff -puN arch/arm/mach-ixp23xx/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-ixp23xx/core.c
--- a/arch/arm/mach-ixp23xx/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-ixp23xx/core.c
@@ -363,7 +363,7 @@ ixp23xx_timer_interrupt(int irq, void *d
 static struct irqaction ixp23xx_timer_irq = {
 	.name		= "IXP23xx Timer Tick",
 	.handler	= ixp23xx_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 void __init ixp23xx_init_timer(void)
diff -puN arch/arm/mach-ixp4xx/common.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -279,7 +279,7 @@ static irqreturn_t ixp4xx_timer_interrup
 
 static struct irqaction ixp4xx_timer_irq = {
 	.name		= "timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ixp4xx_timer_interrupt,
 };
 
diff -puN arch/arm/mach-lh7a40x/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-lh7a40x/time.c
--- a/arch/arm/mach-lh7a40x/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-lh7a40x/time.c
@@ -53,7 +53,7 @@ lh7a40x_timer_interrupt(int irq, void *d
 
 static struct irqaction lh7a40x_timer_irq = {
 	.name		= "LHA740x Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= lh7a40x_timer_interrupt,
 };
 
diff -puN arch/arm/mach-netx/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-netx/time.c
--- a/arch/arm/mach-netx/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-netx/time.c
@@ -47,7 +47,7 @@ netx_timer_interrupt(int irq, void *dev_
 
 static struct irqaction netx_timer_irq = {
 	.name           = "NetX Timer Tick",
-	.flags          = IRQF_DISABLED | IRQF_TIMER,
+	.flags          = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler        = netx_timer_interrupt,
 };
 
diff -puN arch/arm/mach-ns9xxx/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-ns9xxx/time.c
--- a/arch/arm/mach-ns9xxx/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-ns9xxx/time.c
@@ -53,7 +53,7 @@ static unsigned long ns9xxx_timer_gettim
 
 static struct irqaction ns9xxx_timer_irq = {
 	.name = "NS9xxx Timer Tick",
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = ns9xxx_timer_interrupt,
 };
 
diff -puN arch/arm/mach-omap1/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-omap1/time.c
--- a/arch/arm/mach-omap1/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-omap1/time.c
@@ -179,7 +179,7 @@ static irqreturn_t omap_mpu_timer1_inter
 
 static struct irqaction omap_mpu_timer1_irq = {
 	.name		= "mpu_timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_mpu_timer1_interrupt,
 };
 
diff -puN arch/arm/mach-omap2/timer-gp.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-omap2/timer-gp.c
--- a/arch/arm/mach-omap2/timer-gp.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-omap2/timer-gp.c
@@ -52,7 +52,7 @@ static irqreturn_t omap2_gp_timer_interr
 
 static struct irqaction omap2_gp_timer_irq = {
 	.name		= "gp timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap2_gp_timer_interrupt,
 };
 
diff -puN arch/arm/mach-pnx4008/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-pnx4008/time.c
--- a/arch/arm/mach-pnx4008/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-pnx4008/time.c
@@ -82,7 +82,7 @@ static irqreturn_t pnx4008_timer_interru
 
 static struct irqaction pnx4008_timer_irq = {
 	.name = "PNX4008 Tick Timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = pnx4008_timer_interrupt
 };
 
diff -puN arch/arm/mach-pxa/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-pxa/time.c
--- a/arch/arm/mach-pxa/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-pxa/time.c
@@ -97,7 +97,7 @@ pxa_timer_interrupt(int irq, void *dev_i
 
 static struct irqaction pxa_timer_irq = {
 	.name		= "PXA Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= pxa_timer_interrupt,
 };
 
diff -puN arch/arm/mach-realview/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-realview/core.c
--- a/arch/arm/mach-realview/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-realview/core.c
@@ -549,7 +549,7 @@ static irqreturn_t realview_timer_interr
 
 static struct irqaction realview_timer_irq = {
 	.name		= "RealView Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= realview_timer_interrupt,
 };
 
diff -puN arch/arm/mach-sa1100/h3600.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-sa1100/h3600.c
--- a/arch/arm/mach-sa1100/h3600.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-sa1100/h3600.c
@@ -740,7 +740,7 @@ static void h3800_IRQ_demux(unsigned int
 static struct irqaction h3800_irq = {
 	.name		= "h3800_asic",
 	.handler	= h3800_IRQ_demux,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 u32 kpio_int_shadow = 0;
diff -puN arch/arm/mach-sa1100/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-sa1100/time.c
--- a/arch/arm/mach-sa1100/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-sa1100/time.c
@@ -111,7 +111,7 @@ sa1100_timer_interrupt(int irq, void *de
 
 static struct irqaction sa1100_timer_irq = {
 	.name		= "SA11xx Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= sa1100_timer_interrupt,
 };
 
diff -puN arch/arm/mach-shark/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-shark/core.c
--- a/arch/arm/mach-shark/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-shark/core.c
@@ -90,7 +90,7 @@ shark_timer_interrupt(int irq, void *dev
 
 static struct irqaction shark_timer_irq = {
 	.name		= "Shark Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= shark_timer_interrupt,
 };
 
diff -puN arch/arm/mach-versatile/core.c~add-irqf_irqpoll-flag-on-arm arch/arm/mach-versatile/core.c
--- a/arch/arm/mach-versatile/core.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/mach-versatile/core.c
@@ -891,7 +891,7 @@ static irqreturn_t versatile_timer_inter
 
 static struct irqaction versatile_timer_irq = {
 	.name		= "Versatile Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= versatile_timer_interrupt,
 };
 
diff -puN arch/arm/plat-iop/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/plat-iop/time.c
--- a/arch/arm/plat-iop/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/plat-iop/time.c
@@ -75,7 +75,7 @@ iop_timer_interrupt(int irq, void *dev_i
 static struct irqaction iop_timer_irq = {
 	.name		= "IOP Timer Tick",
 	.handler	= iop_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 void __init iop_init_time(unsigned long tick_rate)
diff -puN arch/arm/plat-omap/timer32k.c~add-irqf_irqpoll-flag-on-arm arch/arm/plat-omap/timer32k.c
--- a/arch/arm/plat-omap/timer32k.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/plat-omap/timer32k.c
@@ -215,7 +215,7 @@ static irqreturn_t omap_32k_timer_interr
 
 static struct irqaction omap_32k_timer_irq = {
 	.name		= "32KHz timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_32k_timer_interrupt,
 };
 
diff -puN arch/arm/plat-s3c24xx/time.c~add-irqf_irqpoll-flag-on-arm arch/arm/plat-s3c24xx/time.c
--- a/arch/arm/plat-s3c24xx/time.c~add-irqf_irqpoll-flag-on-arm
+++ a/arch/arm/plat-s3c24xx/time.c
@@ -138,7 +138,7 @@ s3c2410_timer_interrupt(int irq, void *d
 
 static struct irqaction s3c2410_timer_irq = {
 	.name		= "S3C2410 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= s3c2410_timer_interrupt,
 };
 
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch

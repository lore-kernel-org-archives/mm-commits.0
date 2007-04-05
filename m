From: akpm@linux-foundation.org
Subject: - clocksource-arm-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:28:35 -0700
Message-ID: <200704051928.l35JSZ92024022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49060 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbXDETbV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: arm initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-arm-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: arm initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update arch/arm/ with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-imx/time.c      |    1 +
 arch/arm/mach-ixp4xx/common.c |    1 +
 arch/arm/mach-netx/time.c     |    1 +
 arch/arm/mach-pxa/time.c      |    1 +
 4 files changed, 4 insertions(+)

diff -puN arch/arm/mach-imx/time.c~clocksource-arm-initialize-list-value arch/arm/mach-imx/time.c
--- a/arch/arm/mach-imx/time.c~clocksource-arm-initialize-list-value
+++ a/arch/arm/mach-imx/time.c
@@ -88,6 +88,7 @@ static struct clocksource clocksource_im
 	.mask		= 0xFFFFFFFF,
 	.shift 		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_imx.list),
 };
 
 static int __init imx_clocksource_init(void)
diff -puN arch/arm/mach-ixp4xx/common.c~clocksource-arm-initialize-list-value arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~clocksource-arm-initialize-list-value
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -396,6 +396,7 @@ static struct clocksource clocksource_ix
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_ixp4xx.list),
 };
 
 unsigned long ixp4xx_timer_freq = FREQ;
diff -puN arch/arm/mach-netx/time.c~clocksource-arm-initialize-list-value arch/arm/mach-netx/time.c
--- a/arch/arm/mach-netx/time.c~clocksource-arm-initialize-list-value
+++ a/arch/arm/mach-netx/time.c
@@ -63,6 +63,7 @@ static struct clocksource clocksource_ne
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_netx.list),
 };
 
 /*
diff -puN arch/arm/mach-pxa/time.c~clocksource-arm-initialize-list-value arch/arm/mach-pxa/time.c
--- a/arch/arm/mach-pxa/time.c~clocksource-arm-initialize-list-value
+++ a/arch/arm/mach-pxa/time.c
@@ -113,6 +113,7 @@ static struct clocksource clocksource_px
 	.mask           = CLOCKSOURCE_MASK(32),
 	.shift          = 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_pxa.list),
 };
 
 static void __init pxa_timer_init(void)
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-arm-initialize-list-value.patch
clocksource-parisc-initialize-list-value.patch
clocksource-avr32-initialize-list-value.patch
clocksource-mips-initialize-list-value.patch
clocksource-i386-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch

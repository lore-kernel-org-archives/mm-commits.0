From: akpm@linux-foundation.org
Subject: - clocksource-fixup-is_continous-changes-on-arm.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:52 -0800
Message-ID: <200702170713.l1H7Dq8G021486@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51408 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946590AbXBQHVO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:21:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, rmk@arm.linux.org.uk, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: fixup is_continous changes on ARM
has been removed from the -mm tree.  Its filename was
     clocksource-fixup-is_continous-changes-on-arm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: fixup is_continous changes on ARM
From: Thomas Gleixner <tglx@linutronix.de>

Fixup the is_contionous replacement by a flag field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-imx/time.c      |    2 +-
 arch/arm/mach-ixp4xx/common.c |    2 +-
 arch/arm/mach-netx/time.c     |    2 +-
 arch/arm/mach-pxa/time.c      |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/mach-imx/time.c~clocksource-fixup-is_continous-changes-on-arm arch/arm/mach-imx/time.c
--- a/arch/arm/mach-imx/time.c~clocksource-fixup-is_continous-changes-on-arm
+++ a/arch/arm/mach-imx/time.c
@@ -87,7 +87,7 @@ static struct clocksource clocksource_im
 	.read		= imx_get_cycles,
 	.mask		= 0xFFFFFFFF,
 	.shift 		= 20,
-	.is_continuous 	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init imx_clocksource_init(void)
diff -puN arch/arm/mach-ixp4xx/common.c~clocksource-fixup-is_continous-changes-on-arm arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~clocksource-fixup-is_continous-changes-on-arm
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -395,7 +395,7 @@ static struct clocksource clocksource_ix
 	.read		= ixp4xx_get_cycles,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
-	.is_continuous 	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 unsigned long ixp4xx_timer_freq = FREQ;
diff -puN arch/arm/mach-netx/time.c~clocksource-fixup-is_continous-changes-on-arm arch/arm/mach-netx/time.c
--- a/arch/arm/mach-netx/time.c~clocksource-fixup-is_continous-changes-on-arm
+++ a/arch/arm/mach-netx/time.c
@@ -62,7 +62,7 @@ static struct clocksource clocksource_ne
 	.read		= netx_get_cycles,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
-	.is_continuous 	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /*
diff -puN arch/arm/mach-pxa/time.c~clocksource-fixup-is_continous-changes-on-arm arch/arm/mach-pxa/time.c
--- a/arch/arm/mach-pxa/time.c~clocksource-fixup-is_continous-changes-on-arm
+++ a/arch/arm/mach-pxa/time.c
@@ -112,7 +112,7 @@ static struct clocksource clocksource_px
 	.read           = pxa_get_cycles,
 	.mask           = CLOCKSOURCE_MASK(32),
 	.shift          = 20,
-	.is_continuous  = 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init pxa_timer_init(void)
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch

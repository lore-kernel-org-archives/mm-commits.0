From: akpm@osdl.org
Subject: - clocksource-initialize-list-value.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:44 -0800
Message-ID: <200612081105.kB8B5imV018666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425397AbWLHLHB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-initialize-list-value.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: initialize list value
From: Daniel Walker <dwalker@mvista.com>

A change to clocksource initialization.  It's optional for new clocksources,
but prefered.  If the list field is initialized it allows clocksource_register
to complete faster since it doesn't have the scan the list of clocks doing
strcmp on each.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/hpet.c          |    1 +
 arch/i386/kernel/i8253.c         |    1 +
 arch/i386/kernel/tsc.c           |    1 +
 drivers/clocksource/acpi_pm.c    |    1 +
 drivers/clocksource/cyclone.c    |    1 +
 drivers/clocksource/scx200_hrt.c |    1 +
 include/linux/clocksource.h      |    3 +++
 7 files changed, 9 insertions(+)

diff -puN arch/i386/kernel/hpet.c~clocksource-initialize-list-value arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clocksource-initialize-list-value
+++ a/arch/i386/kernel/hpet.c
@@ -27,6 +27,7 @@ static struct clocksource clocksource_hp
 	.mult		= 0, /* set below */
 	.shift		= HPET_SHIFT,
 	.is_continuous	= 1,
+	.list		= CLOCKSOURCE_LIST_INIT(clocksource_hpet.list),
 };
 
 static int __init init_hpet_clocksource(void)
diff -puN arch/i386/kernel/i8253.c~clocksource-initialize-list-value arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clocksource-initialize-list-value
+++ a/arch/i386/kernel/i8253.c
@@ -184,6 +184,7 @@ static struct clocksource clocksource_pi
 	.mask	= CLOCKSOURCE_MASK(32),
 	.mult	= 0,
 	.shift	= 20,
+	.list	= CLOCKSOURCE_LIST_INIT(clocksource_pit.list),
 };
 
 static int __init init_pit_clocksource(void)
diff -puN arch/i386/kernel/tsc.c~clocksource-initialize-list-value arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-initialize-list-value
+++ a/arch/i386/kernel/tsc.c
@@ -350,6 +350,7 @@ static struct clocksource clocksource_ts
 	.mult			= 0, /* to be set */
 	.shift			= 22,
 	.is_continuous		= 1,
+	.list			= CLOCKSOURCE_LIST_INIT(clocksource_tsc.list),
 };
 
 
diff -puN drivers/clocksource/acpi_pm.c~clocksource-initialize-list-value drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-initialize-list-value
+++ a/drivers/clocksource/acpi_pm.c
@@ -73,6 +73,7 @@ static struct clocksource clocksource_ac
 	.mult		= 0, /*to be caluclated*/
 	.shift		= 22,
 	.is_continuous	= 1,
+	.list		= CLOCKSOURCE_LIST_INIT(clocksource_acpi_pm.list),
 };
 
 
diff -puN drivers/clocksource/cyclone.c~clocksource-initialize-list-value drivers/clocksource/cyclone.c
--- a/drivers/clocksource/cyclone.c~clocksource-initialize-list-value
+++ a/drivers/clocksource/cyclone.c
@@ -32,6 +32,7 @@ static struct clocksource clocksource_cy
 	.mult		= 10,
 	.shift		= 0,
 	.is_continuous	= 1,
+	.list		= CLOCKSOURCE_LIST_INIT(clocksource_cyclone.list),
 };
 
 static int __init init_cyclone_clocksource(void)
diff -puN drivers/clocksource/scx200_hrt.c~clocksource-initialize-list-value drivers/clocksource/scx200_hrt.c
--- a/drivers/clocksource/scx200_hrt.c~clocksource-initialize-list-value
+++ a/drivers/clocksource/scx200_hrt.c
@@ -58,6 +58,7 @@ static struct clocksource cs_hrt = {
 	.read		= read_hrt,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.is_continuous	= 1,
+	.list		= CLOCKSOURCE_LIST_INIT(cs_hrt.list),
 	/* mult, shift are set based on mhz27 flag */
 };
 
diff -puN include/linux/clocksource.h~clocksource-initialize-list-value include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-initialize-list-value
+++ a/include/linux/clocksource.h
@@ -82,6 +82,9 @@ struct clocksource {
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
 
+/* Abstracted list initialization */
+#define CLOCKSOURCE_LIST_INIT(x)	LIST_HEAD_INIT(x)
+
 /**
  * clocksource_khz2mult - calculates mult from khz and shift
  * @khz:		Clocksource frequency in KHz
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch


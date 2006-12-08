From: akpm@osdl.org
Subject: - clocksource-update-kernel-parameters.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:48 -0800
Message-ID: <200612081105.kB8B5m6W018672@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49302 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938036AbWLHLIa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: update kernel parameters
has been removed from the -mm tree.  Its filename was
     clocksource-update-kernel-parameters.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: update kernel parameters
From: Daniel Walker <dwalker@mvista.com>

Documents two new kernel parameters,

timeofday_clocksource
sched_clocksource

Removed old ones,

clocksource
clock

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN Documentation/kernel-parameters.txt~clocksource-update-kernel-parameters Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~clocksource-update-kernel-parameters
+++ a/Documentation/kernel-parameters.txt
@@ -351,13 +351,6 @@ and is between 256 and 4096 characters. 
 			Value can be changed at runtime via
 				/selinux/checkreqprot.
 
-	clock=		[BUGS=IA-32, HW] gettimeofday clocksource override.
-			[Deprecated]
-			Forces specified clocksource (if available) to be used
-			when calculating gettimeofday(). If specified
-			clocksource is not available, it defaults to PIT.
-			Format: { pit | tsc | cyclone | pmtmr }
-
 	disable_8254_timer
 	enable_8254_timer
 			[IA32/X86_64] Disable/Enable interrupt 0 timer routing
@@ -1645,9 +1638,13 @@ and is between 256 and 4096 characters. 
 
 	time		Show timing data prefixed to each printk message line
 
-	clocksource=	[GENERIC_TIME] Override the default clocksource
-			Override the default clocksource and use the clocksource
-			with the name specified.
+	timeofday_clocksource=	[GENERIC_TIME]
+			Override the default time of day clocksource and use
+			the clocksource with the name specified.
+
+	sched_clocksource=	[GENERIC_TIME]
+			Override the default scheduler clocksource. Used for
+			timing only inside the scheduler.
 
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch


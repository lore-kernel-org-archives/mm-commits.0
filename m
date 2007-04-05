From: akpm@linux-foundation.org
Subject: - clocksource-driver-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:29:07 -0700
Message-ID: <200704051929.l35JT7AX024067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49041 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767242AbXDETau (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:30:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: driver initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-driver-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: driver initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update drivers/clocksource/ with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c    |    1 +
 drivers/clocksource/cyclone.c    |    1 +
 drivers/clocksource/scx200_hrt.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-driver-initialize-list-value drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-driver-initialize-list-value
+++ a/drivers/clocksource/acpi_pm.c
@@ -74,6 +74,7 @@ static struct clocksource clocksource_ac
 	.mult		= 0, /*to be caluclated*/
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_acpi_pm.list),
 
 };
 
diff -puN drivers/clocksource/cyclone.c~clocksource-driver-initialize-list-value drivers/clocksource/cyclone.c
--- a/drivers/clocksource/cyclone.c~clocksource-driver-initialize-list-value
+++ a/drivers/clocksource/cyclone.c
@@ -32,6 +32,7 @@ static struct clocksource clocksource_cy
 	.mult		= 10,
 	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_cyclone.list),
 };
 
 static int __init init_cyclone_clocksource(void)
diff -puN drivers/clocksource/scx200_hrt.c~clocksource-driver-initialize-list-value drivers/clocksource/scx200_hrt.c
--- a/drivers/clocksource/scx200_hrt.c~clocksource-driver-initialize-list-value
+++ a/drivers/clocksource/scx200_hrt.c
@@ -58,6 +58,7 @@ static struct clocksource cs_hrt = {
 	.read		= read_hrt,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(cs_hrt.list),
 	/* mult, shift are set based on mhz27 flag */
 };
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch

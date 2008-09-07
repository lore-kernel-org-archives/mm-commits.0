From: akpm@linux-foundation.org
Subject: - acpi_pmc-check-for-monotonicity.patch removed from -mm tree
Date: Sun, 07 Sep 2008 14:01:43 -0700
Message-ID: <200809072101.m87L1hYu020778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbYIGVDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Sep 2008 17:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@dominikbrodowski.net, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, andi@lisas.de, hirofumi@mail.parknet.co.jp, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commi


The patch titled
     acpi_pm.c: check for monotonicity
has been removed from the -mm tree.  Its filename was
     acpi_pmc-check-for-monotonicity.patch

This patch was dropped because it's kinda crappy

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi_pm.c: check for monotonicity
From: Dominik Brodowski <linux@dominikbrodowski.net>

The current check for monotonicity is way too weak: Andreas Mohr reports (
http://lkml.org/lkml/2008/8/10/77 ) that on one of his test systems the
current check only triggers in 50% of all cases, leading to catastrophic
timer behaviour.  To fix this issue, expand the check for monotonicity by
doing ten consecutive tests instead of one.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Andreas Mohr <andi@lisas.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |   46 ++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~acpi_pmc-check-for-monotonicity drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~acpi_pmc-check-for-monotonicity
+++ a/drivers/clocksource/acpi_pm.c
@@ -21,6 +21,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 /*
@@ -175,10 +176,13 @@ static int verify_pmtmr_rate(void)
 #define verify_pmtmr_rate() (0)
 #endif
 
+/* Number of monotonicity checks to perform during initialization */
+#define ACPI_PM_MONOTONICITY_CHECKS 10
+
 static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
-	unsigned int i;
+	unsigned int i, j, good = 0;
 
 	if (!pmtmr_ioport)
 		return -ENODEV;
@@ -187,24 +191,32 @@ static int __init init_acpi_pm_clocksour
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	value1 = clocksource_acpi_pm.read();
-	for (i = 0; i < 10000; i++) {
-		value2 = clocksource_acpi_pm.read();
-		if (value2 == value1)
-			continue;
-		if (value2 > value1)
-			goto pm_good;
-		if ((value2 < value1) && ((value2) < 0xFFF))
-			goto pm_good;
-		printk(KERN_INFO "PM-Timer had inconsistent results:"
-			" 0x%#llx, 0x%#llx - aborting.\n", value1, value2);
-		return -EINVAL;
+	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
+		value1 = clocksource_acpi_pm.read();
+		for (i = 0; i < 10000; i++) {
+			value2 = clocksource_acpi_pm.read();
+			if (value2 == value1)
+				continue;
+			if (value2 > value1)
+				good++;
+				break;
+			if ((value2 < value1) && ((value2) < 0xFFF))
+				good++;
+				break;
+			printk(KERN_INFO "PM-Timer had inconsistent results:"
+			       " 0x%#llx, 0x%#llx - aborting.\n",
+			       value1, value2);
+			return -EINVAL;
+		}
+		udelay(300 * i);
+	}
+
+	if (good != ACPI_PM_MONOTONICITY_CHECKS) {
+		printk(KERN_INFO "PM-Timer failed consistency check "
+		       " (0x%#llx) - aborting.\n", value1);
+		return -ENODEV;
 	}
-	printk(KERN_INFO "PM-Timer had no reasonable result:"
-			" 0x%#llx - aborting.\n", value1);
-	return -ENODEV;
 
-pm_good:
 	if (verify_pmtmr_rate() != 0)
 		return -ENODEV;
 
_

Patches currently in -mm which might be from linux@dominikbrodowski.net are

origin.patch
linux-next.patch
pcmcia-pccard-deadlock-fix.patch
acpi_pmc-use-proper-read-function-also-in-errata-mode.patch
acpi_pmc-check-for-monotonicity.patch
make-sure-nobodys-leaking-resources.patch


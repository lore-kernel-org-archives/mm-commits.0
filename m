From: akpm@linux-foundation.org
Subject: - acpi_pmc-check-for-monotonicity.patch removed from -mm tree
Date: Tue, 19 Aug 2008 02:43:50 -0700
Message-ID: <200808190943.m7J9hoXH009983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884AbYHSJtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 05:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@dominikbrodowski.net, andi@firstfloor.org, andi@lisas.de, johnstul@us.ibm.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     acpi_pm.c: check for monotonicity
has been removed from the -mm tree.  Its filename was
     acpi_pmc-check-for-monotonicity.patch

This patch was dropped because it had testing failures

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
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |   42 +++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~acpi_pmc-check-for-monotonicity drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~acpi_pmc-check-for-monotonicity
+++ a/drivers/clocksource/acpi_pm.c
@@ -178,7 +178,7 @@ static int verify_pmtmr_rate(void)
 static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
-	unsigned int i;
+	unsigned int i, j, good = 0;
 
 	if (!pmtmr_ioport)
 		return -ENODEV;
@@ -187,24 +187,32 @@ static int __init init_acpi_pm_clocksour
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
+	for (j = 0; j < 10; j++) {
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
+	if (good != 10) {
+		printk(KERN_INFO "PM-Timer had no reasonable result:"
+		       " 0x%#llx - aborting.\n", value1);
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

linux-next.patch
pcmcia-pccard-deadlock-fix.patch
acpi_pmc-check-for-monotonicity.patch
acpi_pmc-check-for-monotonicity-cleanup.patch
make-sure-nobodys-leaking-resources.patch


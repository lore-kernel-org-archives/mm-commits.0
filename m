From: akpm@linux-foundation.org
Subject: + acpi_pmc-check-for-monotonicity-cleanup.patch added to -mm tree
Date: Mon, 18 Aug 2008 13:55:09 -0700
Message-ID: <200808182055.m7IKt9Vr012281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbYHRU4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 16:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@dominikbrodowski.net, andi@firstfloor.org, andi@lisas.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     acpi_pmc-check-for-monotonicity cleanup
has been added to the -mm tree.  Its filename is
     acpi_pmc-check-for-monotonicity-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi_pmc-check-for-monotonicity cleanup
From: Dominik Brodowski <linux@dominikbrodowski.net>

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~acpi_pmc-check-for-monotonicity-cleanup drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~acpi_pmc-check-for-monotonicity-cleanup
+++ a/drivers/clocksource/acpi_pm.c
@@ -175,6 +175,9 @@ static int verify_pmtmr_rate(void)
 #define verify_pmtmr_rate() (0)
 #endif
 
+/* Number of monotonicity checks to perform during initialization */
+#define ACPI_PM_MONOTONICITY_CHECKS 10
+
 static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
@@ -187,7 +190,7 @@ static int __init init_acpi_pm_clocksour
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	for (j = 0; j < 10; j++) {
+	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
 		value1 = clocksource_acpi_pm.read();
 		for (i = 0; i < 10000; i++) {
 			value2 = clocksource_acpi_pm.read();
@@ -207,9 +210,9 @@ static int __init init_acpi_pm_clocksour
 		udelay(300 * i);
 	}
 
-	if (good != 10) {
-		printk(KERN_INFO "PM-Timer had no reasonable result:"
-		       " 0x%#llx - aborting.\n", value1);
+	if (good != ACPI_PM_MONOTONICITY_CHECKS) {
+		printk(KERN_INFO "PM-Timer failed consistency check "
+		       " (0x%#llx) - aborting.\n", value1);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from linux@dominikbrodowski.net are

linux-next.patch
pcmcia-pccard-deadlock-fix.patch
acpi_pmc-use-proper-read-function-also-in-errata-mode.patch
acpi_pmc-check-for-monotonicity.patch
acpi_pmc-check-for-monotonicity-cleanup.patch
make-sure-nobodys-leaking-resources.patch


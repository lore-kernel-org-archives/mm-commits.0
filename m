From: akpm@linux-foundation.org
Subject: - acpi_pmc-use-proper-read-function-also-in-errata-mode.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:33 -0700
Message-ID: <200809081907.m88J7XvU005564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbYIHTId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@dominikbrodowski.net, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, andi@lisas.de, hirofumi@mail.parknet.co.jp, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commi


The patch titled
     acpi_pm.c: use proper read function also in errata mode
has been removed from the -mm tree.  Its filename was
     acpi_pmc-use-proper-read-function-also-in-errata-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi_pm.c: use proper read function also in errata mode
From: Dominik Brodowski <linux@dominikbrodowski.net>

On all hardware (some Intel ICH4, PIIX4 and PIIX4E chipsets) affected by a
hardware errata there's about a 4.2% chance that initialization of the
ACPI PMTMR fails.  On those chipsets, we need to read out the timer value
at least three times to get a correct result, for every once in a while
(i.e.  within a 3 ns window every 69.8 ns) the read returns a bogus
result.  During normal operation we work around this issue, but during
initialization reading a bogus value may lead to -EINVAL even though the
hardware is usable.

Thanks to Andreas Mohr for spotting this issue.

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

 drivers/clocksource/acpi_pm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~acpi_pmc-use-proper-read-function-also-in-errata-mode drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~acpi_pmc-use-proper-read-function-also-in-errata-mode
+++ a/drivers/clocksource/acpi_pm.c
@@ -151,13 +151,13 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SE
  */
 static int verify_pmtmr_rate(void)
 {
-	u32 value1, value2;
+	cycle_t value1, value2;
 	unsigned long count, delta;
 
 	mach_prepare_counter();
-	value1 = read_pmtmr();
+	value1 = clocksource_acpi_pm.read();
 	mach_countup(&count);
-	value2 = read_pmtmr();
+	value2 = clocksource_acpi_pm.read();
 	delta = (value2 - value1) & ACPI_PM_MASK;
 
 	/* Check that the PMTMR delta is within 5% of what we expect */
@@ -177,7 +177,7 @@ static int verify_pmtmr_rate(void)
 
 static int __init init_acpi_pm_clocksource(void)
 {
-	u32 value1, value2;
+	cycle_t value1, value2;
 	unsigned int i;
 
 	if (!pmtmr_ioport)
@@ -187,9 +187,9 @@ static int __init init_acpi_pm_clocksour
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	value1 = read_pmtmr();
+	value1 = clocksource_acpi_pm.read();
 	for (i = 0; i < 10000; i++) {
-		value2 = read_pmtmr();
+		value2 = clocksource_acpi_pm.read();
 		if (value2 == value1)
 			continue;
 		if (value2 > value1)
@@ -197,11 +197,11 @@ static int __init init_acpi_pm_clocksour
 		if ((value2 < value1) && ((value2) < 0xFFF))
 			goto pm_good;
 		printk(KERN_INFO "PM-Timer had inconsistent results:"
-			" 0x%#x, 0x%#x - aborting.\n", value1, value2);
+			" 0x%#llx, 0x%#llx - aborting.\n", value1, value2);
 		return -EINVAL;
 	}
 	printk(KERN_INFO "PM-Timer had no reasonable result:"
-			" 0x%#x - aborting.\n", value1);
+			" 0x%#llx - aborting.\n", value1);
 	return -ENODEV;
 
 pm_good:
_

Patches currently in -mm which might be from linux@dominikbrodowski.net are

origin.patch
linux-next.patch
pcmcia-pccard-deadlock-fix.patch
make-sure-nobodys-leaking-resources.patch


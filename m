From: akpm@linux-foundation.org
Subject: + clocksource-shift-helper.patch added to -mm tree
Date: Thu, 01 May 2008 14:21:21 -0700
Message-ID: <200805012121.m41LLLRb025925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759593AbYEAVYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 17:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     clocksource: shift helper
has been added to the -mm tree.  Its filename is
     clocksource-shift-helper.patch

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
Subject: clocksource: shift helper
From: Daniel Walker <dwalker@mvista.com>

This is a little helper I pulled from the mips tree.  I've seen a couple of
bogus shift values, and this helper calculates the shift.  This should move
the shift selection away from the user, and systematically pick the value base
on the hz.

I also modified the acpi_pm timer to use this new interface.  The original
shift was 22 , and after this patch it's increased to 23.  Which should make
the clocksource slightly more accurate, but shouldn't have much of a visible
effect.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    5 ++++-
 include/linux/acpi_pmtmr.h    |    5 +++--
 include/linux/clocksource.h   |   21 +++++++++++++++++++++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-shift-helper drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-shift-helper
+++ a/drivers/clocksource/acpi_pm.c
@@ -72,7 +72,7 @@ static struct clocksource clocksource_ac
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
 	.mult		= 0, /*to be calculated*/
-	.shift		= 22,
+	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 
 };
@@ -183,6 +183,9 @@ static int __init init_acpi_pm_clocksour
 	if (!pmtmr_ioport)
 		return -ENODEV;
 
+	clocksource_acpi_pm.shift =
+		clocksource_hz2shift(ACPI_PM_BITS, PMTMR_TICKS_PER_SEC);
+
 	clocksource_acpi_pm.mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC,
 						clocksource_acpi_pm.shift);
 
diff -puN include/linux/acpi_pmtmr.h~clocksource-shift-helper include/linux/acpi_pmtmr.h
--- a/include/linux/acpi_pmtmr.h~clocksource-shift-helper
+++ a/include/linux/acpi_pmtmr.h
@@ -7,10 +7,11 @@
 #define PMTMR_TICKS_PER_SEC 3579545
 
 /* limit it to 24 bits */
-#define ACPI_PM_MASK CLOCKSOURCE_MASK(24)
+#define ACPI_PM_BITS	24
+#define ACPI_PM_MASK CLOCKSOURCE_MASK(ACPI_PM_BITS)
 
 /* Overrun value */
-#define ACPI_PM_OVRRUN	(1<<24)
+#define ACPI_PM_OVRRUN	(1 << ACPI_PM_BITS)
 
 #ifdef CONFIG_X86_PM_TIMER
 
diff -puN include/linux/clocksource.h~clocksource-shift-helper include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-shift-helper
+++ a/include/linux/clocksource.h
@@ -159,6 +159,27 @@ static inline u32 clocksource_hz2mult(u3
 }
 
 /**
+ * clocksource_hz2shift - calculates shift from hz and # of bits
+ * @bits:		Number of bits this clocksource uses
+ * @hz:			Clocksource frequency in Hz
+ *
+ * Helper functions that calculates the best shift value
+ * based on the hz and # of bits of any given clock.
+ */
+static inline u32 clocksource_hz2shift(u32 bits, u32 hz)
+{
+	u64 temp;
+
+	for (; bits > 0; bits--) {
+		temp = (u64) NSEC_PER_SEC << bits;
+		do_div(temp, hz);
+		if ((temp >> 32) == 0)
+			break;
+	}
+	return bits;
+}
+
+/**
  * clocksource_read: - Access the clocksource's current cycle value
  * @cs:		pointer to clocksource being read
  *
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
git-x86.patch
macintosh-therm_pm72-driver_lock-semaphore-to-mutex.patch
macintosh-qindfarm_smu_sat-semaphore-to-mutex.patch
machintosh-adb-driver-adb_handler_sem-semaphore-to-mutex.patch
clocksource-shift-helper.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch


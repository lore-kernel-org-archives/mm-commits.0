From: akpm@linux-foundation.org
Subject: - correct-slow-acpi_pm-rating.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:41:52 -0700
Message-ID: <200703290741.l2T7fqW5030264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbXC2HmQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, ak@suse.de, mingo@elte.hu, rct@gherkin.frus.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     correct slow acpi_pm rating
has been removed from the -mm tree.  Its filename was
     correct-slow-acpi_pm-rating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: correct slow acpi_pm rating
From: john stultz <johnstul@us.ibm.com>

On Bob's machine clocksource is selecting PIT over the ACPI PM timer,
because he has the PIIX4 bug.  That bug drops the ACPI PM timers rating
to the same as the PIT, so that's why you're getting the PIT.

Realistically, the PIT is much slower then even the triple read ACPI PM,
so the de-ranking code is probably dropping it too far.

So don't drop ACPI PM quite so low if we see the PIIX4 bug.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Bob Tracy <rct@gherkin.frus.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/clocksource/acpi_pm.c~correct-slow-acpi_pm-rating drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~correct-slow-acpi_pm-rating
+++ a/drivers/clocksource/acpi_pm.c
@@ -90,7 +90,7 @@ __setup("acpi_pm_good", acpi_pm_good_set
 static inline void acpi_pm_need_workaround(void)
 {
 	clocksource_acpi_pm.read = acpi_pm_read_slow;
-	clocksource_acpi_pm.rating = 110;
+	clocksource_acpi_pm.rating = 120;
 }
 
 /*
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
log-reason-why-tsc-was-marked-unstable.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
declare-struct-ktime.patch

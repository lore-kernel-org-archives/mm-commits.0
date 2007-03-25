From: akpm@linux-foundation.org
Subject: + correct-slow-acpi_pm-rating.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:33:49 -0800
Message-ID: <200703250733.l2P7XneM022903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35064 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbXCYHeP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:34:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ak@suse.de, mingo@elte.hu, rct@gherkin.frus.com, tglx@linutronix.de


The patch titled
     correct slow acpi_pm rating
has been added to the -mm tree.  Its filename is
     correct-slow-acpi_pm-rating.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
correct-slow-acpi_pm-rating.patch
log-reason-why-tsc-was-marked-unstable.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch

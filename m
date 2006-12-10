From: akpm@osdl.org
Subject: - clocksource-small-acpi_pm-cleanup.patch removed from -mm tree
Date: Sun, 10 Dec 2006 00:32:14 -0800
Message-ID: <200612100832.kBA8WExd018988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760462AbWLJIeV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 03:34:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: small acpi_pm cleanup
has been removed from the -mm tree.  Its filename was
     clocksource-small-acpi_pm-cleanup.patch

This patch was dropped because it was folded into clocksource-small-cleanup-2.patch

------------------------------------------------------
Subject: clocksource: small acpi_pm cleanup
From: Daniel Walker <dwalker@mvista.com>

corrects two white space errors, and flags acpi_pm_good as __devinitdata.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/clocksource/acpi_pm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-small-acpi_pm-cleanup drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-small-acpi_pm-cleanup
+++ a/drivers/clocksource/acpi_pm.c
@@ -78,11 +78,11 @@ static struct clocksource clocksource_ac
 
 
 #ifdef CONFIG_PCI
-static int acpi_pm_good;
+static int __devinitdata acpi_pm_good;
 static int __init acpi_pm_good_setup(char *__str)
 {
-       acpi_pm_good = 1;
-       return 1;
+	acpi_pm_good = 1;
+	return 1;
 }
 __setup("acpi_pm_good", acpi_pm_good_setup);
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch


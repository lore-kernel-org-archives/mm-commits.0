From: akpm@linux-foundation.org
Subject: - acpi-sbs-fix-sbs-add-alarm-patch.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:27 -0700
Message-ID: <200710102110.l9ALAR8p025934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510AbXJJVKy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: astarikovskiy@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: SBS: fix sbs add alarm patch
has been removed from the -mm tree.  Its filename was
     acpi-sbs-fix-sbs-add-alarm-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: SBS: fix sbs add alarm patch
From: Alexey Starikovskiy <astarikovskiy@suse.de>

drivers/acpi/sbs.c: In function \u2018acpi_battery_alarm_show\u2019:
drivers/acpi/sbs.c:457: error: implicit declaration of function \u2018acpi_battery_get_alarm\u2019
drivers/acpi/sbs.c: In function \u2018acpi_battery_alarm_store\u2019:
drivers/acpi/sbs.c:472: error: implicit declaration of function \u2018acpi_battery_set_alarm\u2019
drivers/acpi/sbs.c: In function \u2018acpi_battery_add\u2019:

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/acpi/sbs.c~acpi-sbs-fix-sbs-add-alarm-patch drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-sbs-fix-sbs-add-alarm-patch
+++ a/drivers/acpi/sbs.c
@@ -395,8 +395,6 @@ static int acpi_battery_get_state(struct
 	return result;
 }
 
-#ifdef CONFIG_ACPI_PROCFS
-
 static int acpi_battery_get_alarm(struct acpi_battery *battery)
 {
 	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
@@ -433,8 +431,6 @@ static int acpi_battery_set_alarm(struct
 	return ret;
 }
 
-#endif
-
 static int acpi_ac_get_present(struct acpi_sbs *sbs)
 {
 	int result;
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

git-acpi.patch

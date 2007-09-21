From: akpm@linux-foundation.org
Subject: + acpi-sbs-fix-sbs-add-alarm-patch.patch added to -mm tree
Date: Fri, 21 Sep 2007 03:46:24 -0700
Message-ID: <200709211046.l8LAkOE8031578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbXIUKql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 06:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, lenb@kernel.org


The patch titled
     ACPI: SBS: fix sbs add alarm patch
has been added to the -mm tree.  Its filename is
     acpi-sbs-fix-sbs-add-alarm-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-sbs-fix-sbs-add-alarm-patch.patch
acpi-suspend-consolidate-handling-of-sx-states.patch

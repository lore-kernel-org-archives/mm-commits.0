From: akpm@linux-foundation.org
Subject: + pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:41:07 -0700
Message-ID: <200807111846.m6BIkmct031036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663AbYGKSrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:47:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: carlos@strangeworlds.co.uk, andi@firstfloor.org, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: acpi pm: add DMI quirk list for ACPI 1.0 suspend ordering
has been added to the -mm tree.  Its filename is
     pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering.patch

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
Subject: pm: acpi pm: add DMI quirk list for ACPI 1.0 suspend ordering
From: Carlos Corbacho <carlos@strangeworlds.co.uk>

There are a few BIOSes that we know of already that need to use the ACPI 1.0
suspend order.  This appears to be only be a small minority of mostly nVidia
based systems.

Based on observation of Windows behaviour, it's clear that Windows is also
doing maintaining its own list of broken hardware that needs this workaround.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN drivers/acpi/sleep/main.c~pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering
+++ a/drivers/acpi/sleep/main.c
@@ -280,6 +280,24 @@ static struct platform_suspend_ops acpi_
 	.end = acpi_pm_end,
 	.recover = acpi_pm_finish,
 };
+
+static int __init init_old_suspend_ordering(const struct dmi_system_id *d)
+{
+	old_suspend_ordering = true;
+	return 0;
+}
+
+static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
+	{
+	.callback = init_old_suspend_ordering,
+	.ident = "Abit KN9 (nForce4 variant)",
+	.matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "http://www.abit.com.tw/"),
+		DMI_MATCH(DMI_BOARD_NAME, "KN9 Series(NF-CK804)"),
+		},
+	},
+	{},
+};
 #endif /* CONFIG_SUSPEND */
 
 #ifdef CONFIG_HIBERNATION
@@ -506,6 +524,8 @@ int __init acpi_sleep_init(void)
 	u8 type_a, type_b;
 #ifdef CONFIG_SUSPEND
 	int i = 0;
+
+	dmi_check_system(acpisleep_dmi_table);
 #endif
 
 	if (acpi_disabled)
_

Patches currently in -mm which might be from carlos@strangeworlds.co.uk are

linux-next.patch
pm-acpi-pm-add-dmi-quirk-list-for-acpi-10-suspend-ordering.patch


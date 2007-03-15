From: akpm@linux-foundation.org
Subject: - acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:39 -0800
Message-ID: <200703152156.l2FLudTh027581@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42413 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXCOV6A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agodshall@ampro.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI disabled due to DMI failure or blacklisted year should be noted, as is done with other ACPI blacklisting
has been removed from the -mm tree.  Its filename was
     acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI disabled due to DMI failure or blacklisted year should be noted, as is done with other ACPI blacklisting
From: "Anthony Godshall, Ampro Computers, Inc." <agodshall@ampro.com>

IMHO, ACPI disabled due to DMI failure or blacklisted year should be noted,
as is done with other ACPI blacklisting.

This will help people troubleshoot when ACPI isn't working.  Status quo is
a mysterious "ACPI Disabled" message without explanation on BIOS that
implements ACPI but not DMI.  This is actually fairly common on embedded
x86 boards.

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/blacklist.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/blacklist.c~acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting drivers/acpi/blacklist.c
--- a/drivers/acpi/blacklist.c~acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting
+++ a/drivers/acpi/blacklist.c
@@ -79,11 +79,17 @@ static int __init blacklist_by_year(void
 {
 	int year = dmi_get_year(DMI_BIOS_DATE);
 	/* Doesn't exist? Likely an old system */
-	if (year == -1)
+	if (year == -1) {
+		printk(KERN_ERR PREFIX "no DMI BIOS year, "
+			"acpi=force is required to enable ACPI\n" );
 		return 1;
+	}
 	/* 0? Likely a buggy new BIOS */
-	if (year == 0)
+	if (year == 0) {
+		printk(KERN_ERR PREFIX "DMI BIOS year==0, "
+			"assuming ACPI-capable machine\n" );
 		return 0;
+	}
 	if (year < CONFIG_ACPI_BLACKLIST_YEAR) {
 		printk(KERN_ERR PREFIX "BIOS age (%d) fails cutoff (%d), "
 		       "acpi=force is required to enable ACPI\n",
_

Patches currently in -mm which might be from agodshall@ampro.com are

origin.patch

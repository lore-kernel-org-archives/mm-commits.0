From: akpm@linux-foundation.org
Subject: + acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:00:01 -0800
Message-ID: <200703072200.l27M036f010344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32986 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423003AbXCGWBV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agodshall@ampro.com, lenb@kernel.org


The patch titled
     ACPI disabled due to DMI failure or blacklisted year should be noted, as is done with other ACPI blacklisting
has been added to the -mm tree.  Its filename is
     acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch

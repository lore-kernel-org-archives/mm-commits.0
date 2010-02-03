From: akpm@linux-foundation.org
Subject: [to-be-updated] acpi-remove-old-blacklist-entries.patch removed from -mm tree
Date: Wed, 03 Feb 2010 15:43:51 -0800
Message-ID: <201002032343.o13NhpaU026785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757779Ab0BCXrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:47:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, arekm@maven.pl, feng.tang@intel.com, flinco@libero.it, lenb@kernel.org, mad_soft@inbox.ru, mjg@redhat.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     acpi: remove old blacklist entries
has been removed from the -mm tree.  Its filename was
     acpi-remove-old-blacklist-entries.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove old blacklist entries
From: Matthew Garrett <mjg59@srcf.ucam.org>

The kernel has a set of blacklist entries that disable ACPI functionality
on various machines.  These all seem to date from pre-git days and most
have no indication of what they were meant to fix.  Let's work on the
assumption that we've fixed whatever it was that was broken before and so
remove most of the entries.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: <flinco@libero.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/boot.c |  147 ----------------------------------
 1 file changed, 147 deletions(-)

diff -puN arch/x86/kernel/acpi/boot.c~acpi-remove-old-blacklist-entries arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~acpi-remove-old-blacklist-entries
+++ a/arch/x86/kernel/acpi/boot.c
@@ -1256,35 +1256,6 @@ static int __init disable_acpi_pci(const
 	return 0;
 }
 
-static int __init dmi_disable_acpi(const struct dmi_system_id *d)
-{
-	if (!acpi_force) {
-		printk(KERN_NOTICE "%s detected: acpi off\n", d->ident);
-		disable_acpi();
-	} else {
-		printk(KERN_NOTICE
-		       "Warning: DMI blacklist says broken, but acpi forced\n");
-	}
-	return 0;
-}
-
-/*
- * Limit ACPI to CPU enumeration for HT
- */
-static int __init force_acpi_ht(const struct dmi_system_id *d)
-{
-	if (!acpi_force) {
-		printk(KERN_NOTICE "%s detected: force use of acpi=ht\n",
-		       d->ident);
-		disable_acpi();
-		acpi_ht = 1;
-	} else {
-		printk(KERN_NOTICE
-		       "Warning: acpi=force overrules DMI blacklist: acpi=ht\n");
-	}
-	return 0;
-}
-
 /*
  * Force ignoring BIOS IRQ0 pin2 override
  */
@@ -1308,116 +1279,6 @@ static int __init dmi_ignore_irq0_timer_
  * works for you, please contact linux-acpi@vger.kernel.org
  */
 static struct dmi_system_id __initdata acpi_dmi_table[] = {
-	/*
-	 * Boxes that need ACPI disabled
-	 */
-	{
-	 .callback = dmi_disable_acpi,
-	 .ident = "IBM Thinkpad",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "2629H1G"),
-		     },
-	 },
-
-	/*
-	 * Boxes that need acpi=ht
-	 */
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "FSC Primergy T850",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "PRIMERGY T850"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "HP VISUALIZE NT Workstation",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "HP VISUALIZE NT Workstation"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "Compaq Workstation W8000",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "Workstation W8000"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "ASUS P2B-DS",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		     DMI_MATCH(DMI_BOARD_NAME, "P2B-DS"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "ASUS CUR-DLS",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		     DMI_MATCH(DMI_BOARD_NAME, "CUR-DLS"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "ABIT i440BX-W83977",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ABIT <http://www.abit.com>"),
-		     DMI_MATCH(DMI_BOARD_NAME, "i440BX-W83977 (BP6)"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM Bladecenter",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "IBM eServer BladeCenter HS20"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM eServer xSeries 360",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "eServer xSeries 360"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM eserver xSeries 330",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "eserver xSeries 330"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
-	 .ident = "IBM eserver xSeries 440",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "eserver xSeries 440"),
-		     },
-	 },
-
-	/*
-	 * Boxes that need ACPI PCI IRQ routing disabled
-	 */
-	{
-	 .callback = disable_acpi_irq,
-	 .ident = "ASUS A7V",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC"),
-		     DMI_MATCH(DMI_BOARD_NAME, "<A7V>"),
-		     /* newer BIOS, Revision 1011, does work */
-		     DMI_MATCH(DMI_BIOS_VERSION,
-			       "ASUS A7V ACPI BIOS Revision 1007"),
-		     },
-	 },
 	{
 		/*
 		 * Latest BIOS for IBM 600E (1.16) has bad pcinum
@@ -1454,14 +1315,6 @@ static struct dmi_system_id __initdata a
 		     DMI_MATCH(DMI_BIOS_DATE, "03/21/2003")
 		     },
 	 },
-	{
-	 .callback = disable_acpi_pci,
-	 .ident = "Acer TravelMate 36x Laptop",
-	 .matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
-		     },
-	 },
 	{}
 };
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

acpi-remove-old-blacklist-entries.patch


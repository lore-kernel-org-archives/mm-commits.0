From: akpm@linux-foundation.org
Subject: - sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:13:20 -0800
Message-ID: <200702080913.l189DK31010310@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34603 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423156AbXBHJNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, mm-commits@vger.kernel.org


The patch titled
     sony_acpi: allow multiple sony_acpi_values for the same .name
has been removed from the -mm tree.  Its filename was
     sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony_acpi: allow multiple sony_acpi_values for the same .name
From: Mattia Dongili <malattia@linux.it>

The acpi handles are kept _only_ if both the requested .acpiget and .acpiset
are available in the DSDT.  Currently only the SCDP/CDPW dualism is known.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sony_acpi.c |   44 +++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN drivers/acpi/sony_acpi.c~sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name drivers/acpi/sony_acpi.c
--- a/drivers/acpi/sony_acpi.c~sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name
+++ a/drivers/acpi/sony_acpi.c
@@ -68,7 +68,7 @@ static struct backlight_properties sony_
 
 static struct sony_acpi_value {
 	char			*name;	 /* name of the entry */
-	struct proc_dir_entry 	*proc;	 /* /proc entry */
+	struct proc_dir_entry	*proc;	 /* /proc entry */
 	char			*acpiget;/* name of the ACPI get function */
 	char			*acpiset;/* name of the ACPI get function */
 	int 			min;	 /* minimum allowed value or -1 */
@@ -78,6 +78,7 @@ static struct sony_acpi_value {
 	int			debug;	 /* active only in debug mode ? */
 } sony_acpi_values[] = {
 	{
+		/* for backward compatibility only */
 		.name		= "brightness",
 		.acpiget	= "GBRT",
 		.acpiset	= "SBRT",
@@ -107,6 +108,14 @@ static struct sony_acpi_value {
 		.debug		= 0,
 	},
 	{
+		.name		= "cdpower",
+		.acpiget	= "GCDP",
+		.acpiset	= "CDPW",
+		.min		= 0,
+		.max		= 1,
+		.debug		= 0,
+	},
+	{
 		.name           = "audiopower",
 		.acpiget        = "GAZP",
 		.acpiset        = "AZPW",
@@ -356,27 +365,24 @@ static int sony_acpi_add(struct acpi_dev
 		if (!debug && item->debug)
 			continue;
 
-		if (item->acpiget &&
-		    ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle,
-		    		 item->acpiget, &handle)))
-			proc_file_mode = S_IRUSR;
-		else
-			printk(LOG_PFX "unable to get ACPI handle for %s (get)\n",
-					item->name);
-
-		if (item->acpiset &&
-		    ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle,
-		    		 item->acpiset, &handle)))
-			proc_file_mode |= S_IWUSR;
-		else
-			printk(LOG_PFX "unable to get ACPI handle for %s (set)\n",
-					item->name);
+		if (item->acpiget) {
+			if (ACPI_FAILURE(acpi_get_handle(sony_acpi_handle,
+							item->acpiget, &handle)))
+				continue;
 
-		if (proc_file_mode == 0)
-			continue;
+			proc_file_mode |= S_IRUSR;
+		}
+
+		if (item->acpiset) {
+			if (ACPI_FAILURE(acpi_get_handle(sony_acpi_handle,
+							item->acpiset, &handle)))
+				continue;
+
+			proc_file_mode |= S_IWUSR;
+		}
 
 		item->proc = create_proc_entry(item->name, proc_file_mode,
-					       acpi_device_dir(device));
+				acpi_device_dir(device));
 		if (!item->proc) {
 			printk(LOG_PFX "unable to create proc entry\n");
 			result = -EIO;
_

Patches currently in -mm which might be from malattia@linux.it are

git-acpi.patch
sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch

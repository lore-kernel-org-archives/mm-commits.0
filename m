From: akpm@osdl.org
Subject: + sony_acpi-add-lanpower-and-audiopower-controls.patch added to -mm tree
Date: Mon, 22 Jan 2007 14:25:39 -0800
Message-ID: <200701222225.l0MMPdi8003947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58122 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539AbXAVWZx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 17:25:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: malattia@linux.it


The patch titled
     sony_acpi: add lanpower and audiopower controls
has been added to the -mm tree.  Its filename is
     sony_acpi-add-lanpower-and-audiopower-controls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sony_acpi: add lanpower and audiopower controls
From: Mattia Dongili <malattia@linux.it>

audiopower works well on my SZ72B so it's not marked has "debug" while
lanpower has at least one report of not resuming power happily so morked as
"debug"

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/sony_acpi.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/sony_acpi.c~sony_acpi-add-lanpower-and-audiopower-controls drivers/acpi/sony_acpi.c
--- a/drivers/acpi/sony_acpi.c~sony_acpi-add-lanpower-and-audiopower-controls
+++ a/drivers/acpi/sony_acpi.c
@@ -102,11 +102,27 @@ static struct sony_acpi_value {
 		.name		= "cdpower",
 		.acpiget	= "GCDP",
 		.acpiset	= "SCDP",
-		.min		= -1,
-		.max		= -1,
+		.min		= 0,
+		.max		= 1,
 		.debug		= 0,
 	},
 	{
+		.name           = "audiopower",
+		.acpiget        = "GAZP",
+		.acpiset        = "AZPW",
+		.min            = 0,
+		.max            = 1,
+		.debug          = 0,
+	},
+	{
+		.name           = "lanpower",
+		.acpiget        = "GLNP",
+		.acpiset        = "LNPW",
+		.min            = 0,
+		.max            = 1,
+		.debug          = 1,
+	},
+	{
 		.name		= "PID",
 		.acpiget	= "GPID",
 		.debug		= 1,
_

Patches currently in -mm which might be from malattia@linux.it are

sony_acpi-addacpi_bus_generate-event.patch
sony_acpi-addacpi_bus_generate-event-fix.patch
sony_acpi-add-lanpower-and-audiopower-controls.patch
allow-multiple-sony_acpi_values-for-the-same-name.patch
fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
fix-x86_64-mm-i386-config-core2.patch

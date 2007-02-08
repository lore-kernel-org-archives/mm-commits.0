From: akpm@linux-foundation.org
Subject: - sony_acpi-add-lanpower-and-audiopower-controls.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:13:16 -0800
Message-ID: <200702080913.l189DGMB010304@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423145AbXBHJNW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, mm-commits@vger.kernel.org


The patch titled
     sony_acpi: add lanpower and audiopower controls
has been removed from the -mm tree.  Its filename was
     sony_acpi-add-lanpower-and-audiopower-controls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony_acpi: add lanpower and audiopower controls
From: Mattia Dongili <malattia@linux.it>

audiopower works well on my SZ72B so it's not marked has "debug" while
lanpower has at least one report of not resuming power happily so morked as
"debug"

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sony_acpi.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

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

git-acpi.patch
sony_acpi-add-lanpower-and-audiopower-controls.patch
sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch

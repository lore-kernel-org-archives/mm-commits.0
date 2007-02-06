From: akpm@linux-foundation.org
Subject: - acpi-add-backlight-support-to-the-sony_acpi-v2.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:05:02 -0800
Message-ID: <200702060006.l16066kd003569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965120AbXBFAGJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.guido@gmail.com, mm-commits@vger.kernel.org


The patch titled
     acpi: add backlight support to the sony_acpi driver (v2)
has been removed from the -mm tree.  Its filename was
     acpi-add-backlight-support-to-the-sony_acpi-v2.patch

This patch was dropped because it was folded into acpi-add-backlight-support-to-the-sony_acpi.patch

------------------------------------------------------
Subject: acpi: add backlight support to the sony_acpi driver (v2)
From: Alessandro Guido <alessandro.guido@gmail.com>

Enable the sony_acpi driver to use the backlight subsysyem for adjusting
the monitor brightness.  Old way of changing the brightness will be still
available for compatibility with existing tools.

Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/sony_acpi.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN drivers/acpi/sony_acpi.c~acpi-add-backlight-support-to-the-sony_acpi-v2 drivers/acpi/sony_acpi.c
--- a/drivers/acpi/sony_acpi.c~acpi-add-backlight-support-to-the-sony_acpi-v2
+++ a/drivers/acpi/sony_acpi.c
@@ -77,6 +77,14 @@ static struct sony_acpi_value {
 	int			debug;	 /* active only in debug mode ? */
 } sony_acpi_values[] = {
 	{
+		.name		= "brightness",
+		.acpiget	= "GBRT",
+		.acpiset	= "SBRT",
+		.min		= 1,
+		.max		= SONY_MAX_BRIGHTNESS,
+		.debug		= 0,
+	},
+	{
 		.name		= "brightness_default",
 		.acpiget	= "GPBR",
 		.acpiset	= "SPBR",
_

Patches currently in -mm which might be from alessandro.guido@gmail.com are

acpi-add-backlight-support-to-the-sony_acpi.patch
acpi-add-backlight-support-to-the-sony_acpi-v2.patch

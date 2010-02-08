From: akpm@linux-foundation.org
Subject: [merged] i915-slow-acpi_lid_open-causes-flickering.patch removed from -mm tree
Date: Mon, 08 Feb 2010 11:52:36 -0800
Message-ID: <201002081952.o18JqaWg031432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab0BHTxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 14:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     i915: slow acpi_lid_open() causes flickering
has been removed from the -mm tree.  Its filename was
     i915-slow-acpi_lid_open-causes-flickering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i915: slow acpi_lid_open() causes flickering
From: Thomas Meyer <thomas@m3y3r.de>

acpi_lid_open() could take up to 10ms on my computer.  Some component is
calling the drm GETCONNECTOR ioctl many times in a row.  This results in
flickering (for example, when starting a video).  Fix it by assuming an
always connected lid status.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14670

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Eric Anholt <eric@anholt.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~i915-slow-acpi_lid_open-causes-flickering drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~i915-slow-acpi_lid_open-causes-flickering
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -632,6 +632,18 @@ static const struct dmi_system_id bad_li
 	{ }
 };
 
+/* Some lid devices take a long time to report the lid status, assume they're connected*/
+static const struct dmi_system_id slow_lid_status[] = {
+	{
+		.ident = "Aspire 1810T",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
+		},
+	},
+	{ }
+};
+
 /**
  * Detect the LVDS connection.
  *
@@ -643,7 +655,8 @@ static enum drm_connector_status intel_l
 {
 	enum drm_connector_status status = connector_status_connected;
 
-	if (!acpi_lid_open() && !dmi_check_system(bad_lid_status))
+	if (!dmi_check_system(slow_lid_status) && !dmi_check_system(bad_lid_status))
+	    if (!acpi_lid_open())
 		status = connector_status_disconnected;
 
 	return status;
_

Patches currently in -mm which might be from thomas@m3y3r.de are



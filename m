From: akpm@linux-foundation.org
Subject: + i915-slow-acpi_lid_open-causes-flickering-v2.patch added to -mm tree
Date: Wed, 03 Feb 2010 17:51:13 -0800
Message-ID: <201002040151.o141pDPv032754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389Ab0BDBwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 20:52:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@m3y3r.de, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org


The patch titled
     i915-slow-acpi_lid_open-causes-flickering-v2
has been added to the -mm tree.  Its filename is
     i915-slow-acpi_lid_open-causes-flickering-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i915-slow-acpi_lid_open-causes-flickering-v2
From: Thomas Meyer <thomas@m3y3r.de>

acpi_lid_open() could take up to 10ms on my computer.  Some component is
calling the drm GETCONNECTOR ioctl many times in a row.  This results in
flickering (for example, when starting a video).  Fix it by assuming an
always connected lid status.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Eric Anholt <eric@anholt.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~i915-slow-acpi_lid_open-causes-flickering-v2 drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~i915-slow-acpi_lid_open-causes-flickering-v2
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -623,22 +623,17 @@ static const struct dmi_system_id bad_li
 		},
 	},
 	{
-		.ident = "PC-81005",
+		.ident = "Aspire 1810T",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MALATA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PC-81005"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
 		},
 	},
-	{ }
-};
-
-/* Some lid devices take a long time to report the lid status, assume they're connected*/
-static const struct dmi_system_id slow_lid_status[] = {
 	{
-		.ident = "Aspire 1810T",
+		.ident = "PC-81005",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
+			DMI_MATCH(DMI_SYS_VENDOR, "MALATA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PC-81005"),
 		},
 	},
 	{ }
@@ -655,8 +650,7 @@ static enum drm_connector_status intel_l
 {
 	enum drm_connector_status status = connector_status_connected;
 
-	if (!dmi_check_system(slow_lid_status) && !dmi_check_system(bad_lid_status))
-	    if (!acpi_lid_open())
+	if (!dmi_check_system(bad_lid_status) && !acpi_lid_open())
 		status = connector_status_disconnected;
 
 	return status;
_

Patches currently in -mm which might be from thomas@m3y3r.de are

i915-slow-acpi_lid_open-causes-flickering.patch
i915-slow-acpi_lid_open-causes-flickering-v2.patch


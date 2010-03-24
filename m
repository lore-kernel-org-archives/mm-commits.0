From: akpm@linux-foundation.org
Subject: [alternative-merged] drm-i915-add-sony-vgn-bz12vn-to-acpi-lid-quirk-list.patch removed from -mm tree
Date: Wed, 24 Mar 2010 13:55:22 -0700
Message-ID: <201003242055.o2OKtM42026365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405Ab0CXU4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 16:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@hubertscorner.de, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     drm/i915: add Sony VGN-BZ12VN to ACPI LID quirk list
has been removed from the -mm tree.  Its filename was
     drm-i915-add-sony-vgn-bz12vn-to-acpi-lid-quirk-list.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/i915: add Sony VGN-BZ12VN to ACPI LID quirk list
From: Hubert Hesse <linux@hubertscorner.de>

The Sony Vaio VGN-BZ12VN laptop always reports the LID
status as closed, therefore add it into the acpi lid quirk list.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15473

Signed-off-by: Hubert Hesse <linux@hubertscorner.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drm-i915-add-sony-vgn-bz12vn-to-acpi-lid-quirk-list drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drm-i915-add-sony-vgn-bz12vn-to-acpi-lid-quirk-list
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -638,6 +638,13 @@ static const struct dmi_system_id bad_li
 		},
 	},
 	{
+		.ident = "Sony VGN-BZ12VN",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-BZ12VN"),
+		},
+	},
+	{
 		.ident = "PC-81005",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MALATA"),
_

Patches currently in -mm which might be from linux@hubertscorner.de are

drm-i915-add-sony-vgn-bz12vn-to-acpi-lid-quirk-list.patch


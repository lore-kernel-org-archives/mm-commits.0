From: akpm@linux-foundation.org
Subject: [alternative-merged] drm-i915-blacklist-lid-status-sony-vgn-bx196vp-dell-inspiron-700m.patch removed from -mm tree
Date: Thu, 11 Mar 2010 14:22:46 -0800
Message-ID: <201003112222.o2BMMlbF014460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758538Ab0CKWXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Mar 2010 17:23:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: surbhi.palande@canonical.com, mm-commits@vger.kernel.org


The patch titled
     drm/i915: blacklist lid status: Sony VGN-BX196VP, Dell Inspiron 700m
has been removed from the -mm tree.  Its filename was
     drm-i915-blacklist-lid-status-sony-vgn-bx196vp-dell-inspiron-700m.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/i915: blacklist lid status: Sony VGN-BX196VP, Dell Inspiron 700m
From: Surbhi Palande <surbhi.palande@canonical.com>

Sony VGN-BX196VP and Dell Inspiron 700m report lid status as closed when
it is open.  This leads to a "no connectors reported" error at startup. 
Blacklisting them, to always return a connected status for the default
lvds connector.

Addresses https://bugs.launchpad.net/bugs/515246

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drm-i915-blacklist-lid-status-sony-vgn-bx196vp-dell-inspiron-700m drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drm-i915-blacklist-lid-status-sony-vgn-bx196vp-dell-inspiron-700m
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -651,6 +651,20 @@ static const struct dmi_system_id bad_li
 			DMI_MATCH(DMI_BOARD_NAME, "M5x0N"),
 		},
 	},
+	{
+		.ident = "Sony VGN-BX196VP",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "VGN-BX196VP"),
+		},
+	},
+	{
+		.ident = "Dell Inspiron 700m",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_MATCH(DMI_BOARD_NAME, "Inspiron 700m"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from surbhi.palande@canonical.com are

drm-i915-blacklist-lid-status-sony-vgn-bx196vp-dell-inspiron-700m.patch


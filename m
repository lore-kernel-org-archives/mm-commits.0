From: akpm@linux-foundation.org
Subject: [merged] drm-ignore-lvds-on-intel-graphics-systems-that-lie-about-having-it.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:37 -0700
Message-ID: <200905171654.n4HGsbqZ017287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbZEQQ6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarod@redhat.com, airlied@linux.ie, eric@anholt.net, jbarnes@virtuousgeek.org, notting@redhat.com, zhenyu.z.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     drm: ignore LVDS on intel graphics systems that lie about having it
has been removed from the -mm tree.  Its filename was
     drm-ignore-lvds-on-intel-graphics-systems-that-lie-about-having-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: ignore LVDS on intel graphics systems that lie about having it
From: Jarod Wilson <jarod@redhat.com>

There are a number of small form factor desktop systems with Intel mobile
graphics chips that lie and say they have an LVDS.  With kernel
mode-setting, this becomes a problem, and makes native resolution boot go
haywire -- for example, my Dell Studio Hybrid, hooked to a 1920x1080
display claims to have a 1024x768 LVDS, and the resulting graphical boot
on the 1920x1080 display uses only the top left 1024x768, and
auto-configured X will end up only 1024x768 as well.  With this change,
graphical boot and X both do 1920x1080 as expected.

Note that we're simply embracing and extending the early bail-out code in
place for the Mac Mini here.  The xorg intel driver uses pci subsystem
device and vendor id for matching, while we're using dmi lookups here. 
The MSI addition is courtesy of and tested by Bill Nottingham.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Bill Nottingham <notting@redhat.com>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |   54 +++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 8 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drm-ignore-lvds-on-intel-graphics-systems-that-lie-about-having-it drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drm-ignore-lvds-on-intel-graphics-systems-that-lie-about-having-it
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -384,7 +384,51 @@ static const struct drm_encoder_funcs in
 	.destroy = intel_lvds_enc_destroy,
 };
 
+static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
+{
+	DRM_DEBUG("Skipping LVDS initialization for %s\n", id->ident);
+	return 1;
+}
 
+/* These systems claim to have LVDS, but really don't */
+static const struct dmi_system_id __initdata intel_no_lvds[] = {
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Apple Mac Mini (Core series)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Apple Mac Mini (Core 2 series)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini2,1"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "MSI IM-945GSE-A",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MSI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "A9830IMS"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Dell Studio Hybrid",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Studio Hybrid 140g"),
+		},
+	},
+
+	/* FIXME: add a check for the Aopen Mini PC */
+
+	{ }	/* terminating entry */
+};
 
 /**
  * intel_lvds_init - setup LVDS connectors on this device
@@ -404,15 +448,9 @@ void intel_lvds_init(struct drm_device *
 	u32 lvds;
 	int pipe;
 
-	/* Blacklist machines that we know falsely report LVDS. */
-	/* FIXME: add a check for the Aopen Mini PC */

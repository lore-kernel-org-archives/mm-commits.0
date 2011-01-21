From: akpm@linux-foundation.org
Subject: + i915-add-native-backlight-control.patch added to -mm tree
Date: Thu, 20 Jan 2011 17:02:25 -0800
Message-ID: <201101210102.p0L12PG4012935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501Ab1AUBC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 20:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, rpurdie@rpsys.net, rui.zhang@intel.com


The patch titled
     i915: add native backlight control
has been added to the -mm tree.  Its filename is
     i915-add-native-backlight-control.patch

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
Subject: i915: add native backlight control
From: Matthew Garrett <mjg@redhat.com>

Not all systems expose a firmware or platform mechanism for changing the
backlight intensity on i915, so add native driver support.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_drv.h       |    4 +
 drivers/gpu/drm/i915/intel_dp.c       |    7 ++
 drivers/gpu/drm/i915/intel_drv.h      |    3 -
 drivers/gpu/drm/i915/intel_lvds.c     |    5 +
 drivers/gpu/drm/i915/intel_opregion.c |    1 
 drivers/gpu/drm/i915/intel_panel.c    |   72 +++++++++++++++++++++++-
 6 files changed, 89 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_drv.h~i915-add-native-backlight-control drivers/gpu/drm/i915/i915_drv.h
--- a/drivers/gpu/drm/i915/i915_drv.h~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/i915_drv.h
@@ -36,6 +36,7 @@
 #include <linux/io-mapping.h>
 #include <linux/i2c.h>
 #include <drm/intel-gtt.h>
+#include <linux/backlight.h>
 
 /* General customization:
  */
@@ -667,6 +668,7 @@ typedef struct drm_i915_private {
 	int child_dev_num;
 	struct child_device_config *child_dev;
 	struct drm_connector *int_lvds_connector;
+	struct drm_connector *int_edp_connector;
 
 	bool mchbar_need_disable;
 
@@ -695,6 +697,8 @@ typedef struct drm_i915_private {
 
 	/* list of fbdev register on this device */
 	struct intel_fbdev *fbdev;
+
+	struct backlight_device *backlight;
 } drm_i915_private_t;
 
 struct drm_i915_gem_object {
diff -puN drivers/gpu/drm/i915/intel_dp.c~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_dp.c
--- a/drivers/gpu/drm/i915/intel_dp.c~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_dp.c
@@ -1682,6 +1682,11 @@ done:
 static void
 intel_dp_destroy (struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
+
+	if (intel_dpd_is_edp(dev))
+		intel_panel_destroy_backlight(dev);
+
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -1911,6 +1916,8 @@ intel_dp_init(struct drm_device *dev, in
 					DRM_MODE_TYPE_PREFERRED;
 			}
 		}
+		dev_priv->int_edp_connector = connector;
+		intel_panel_setup_backlight(dev);
 	}
 
 	intel_dp_add_properties(intel_dp, connector);
diff -puN drivers/gpu/drm/i915/intel_drv.h~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_drv.h
--- a/drivers/gpu/drm/i915/intel_drv.h~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_drv.h
@@ -257,9 +257,10 @@ extern void intel_pch_panel_fitting(stru
 extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
-extern void intel_panel_setup_backlight(struct drm_device *dev);
+extern int intel_panel_setup_backlight(struct drm_device *dev);
 extern void intel_panel_enable_backlight(struct drm_device *dev);
 extern void intel_panel_disable_backlight(struct drm_device *dev);
+extern void intel_panel_destroy_backlight(struct drm_device *dev);
 
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void intel_encoder_prepare (struct drm_encoder *encoder);
diff -puN drivers/gpu/drm/i915/intel_lvds.c~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -580,6 +580,8 @@ static void intel_lvds_destroy(struct dr
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	intel_panel_destroy_backlight(dev);
+
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -1055,6 +1057,9 @@ out:
 	/* keep the LVDS connector */
 	dev_priv->int_lvds_connector = connector;
 	drm_sysfs_connector_add(connector);
+
+	intel_panel_setup_backlight(dev);
+
 	return true;
 
 failed:
diff -puN drivers/gpu/drm/i915/intel_opregion.c~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_opregion.c
--- a/drivers/gpu/drm/i915/intel_opregion.c~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_opregion.c
@@ -224,7 +224,6 @@ void intel_opregion_asle_intr(struct drm
 	asle->aslc = asle_stat;
 }
 
-/* Only present on Ironlake+ */
 void intel_opregion_gse_intr(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff -puN drivers/gpu/drm/i915/intel_panel.c~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_panel.c
--- a/drivers/gpu/drm/i915/intel_panel.c~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_panel.c
@@ -274,10 +274,80 @@ void intel_panel_enable_backlight(struct
 	dev_priv->backlight_enabled = true;
 }
 
-void intel_panel_setup_backlight(struct drm_device *dev)
+void intel_panel_init_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	dev_priv->backlight_level = intel_panel_get_backlight(dev);
 	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
 }
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+static int intel_panel_update_status(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	intel_panel_set_backlight(dev, bd->props.brightness);
+	return 0;
+}
+
+static int intel_panel_get_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	return intel_panel_get_backlight(dev);
+}
+
+static const struct backlight_ops intel_panel_bl_ops = {
+	.update_status = intel_panel_update_status,
+	.get_brightness = intel_panel_get_brightness,
+};
+
+int intel_panel_setup_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
+	struct drm_connector *connector;
+
+	intel_panel_init_backlight(dev);
+
+	if (dev_priv->int_lvds_connector)
+		connector = dev_priv->int_lvds_connector;
+	else if (dev_priv->int_edp_connector)
+		connector = dev_priv->int_edp_connector;
+	else
+		return -ENODEV;
+
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = intel_panel_get_max_backlight(dev);
+	dev_priv->backlight =
+		backlight_device_register("intel_backlight",
+					  &connector->kdev, dev,
+					  &intel_panel_bl_ops, &props);
+
+	if (IS_ERR(dev_priv->backlight)) {
+		DRM_ERROR("Failed to register backlight: %ld\n",
+			  PTR_ERR(dev_priv->backlight));
+		dev_priv->backlight = NULL;
+		return -ENODEV;
+	}
+	dev_priv->backlight->props.brightness = intel_panel_get_backlight(dev);
+	return 0;
+}
+
+void intel_panel_destroy_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	if (dev_priv->backlight)
+		backlight_device_unregister(dev_priv->backlight);
+}
+#else
+int intel_panel_setup_backlight(struct drm_device *dev)
+{
+	intel_panel_init_backlight(dev);
+	return 0;
+}
+
+void intel_panel_destroy_backlight(struct drm_device *dev)
+{
+	return;
+}
+#endif
_

Patches currently in -mm which might be from mjg@redhat.com are

acerhdf-add-support-for-aspire-1410-bios-v13314.patch
backlight-add-backlight-type.patch
backlight-add-backlight-type-fix.patch
i915-add-native-backlight-control.patch
radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch
radeon-expose-backlight-class-device-for-legacy-lvds-encoder-update.patch
nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev.patch
acpi-tie-acpi-backlight-devices-to-pci-devices-if-possible.patch
mbp_nvidia_bl-remove-dmi-dependency.patch
mbp_nvidia_bl-check-that-the-backlight-control-functions.patch
mbp_nvidia_bl-rename-to-apple_bl.patch


From: akpm@linux-foundation.org
Subject: [merged] i915-add-native-backlight-control.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:43 -0700
Message-ID: <201108161848.p7GImoJX015399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPStx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, rpurdie@rpsys.net, rui.zhang@intel.co


The patch titled
     i915: add native backlight control
has been removed from the -mm tree.  Its filename was
     i915-add-native-backlight-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Tested-by: Sedat Dilek <sedat.dilek@googlemail.com>
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
@@ -689,6 +690,7 @@ typedef struct drm_i915_private {
 	int child_dev_num;
 	struct child_device_config *child_dev;
 	struct drm_connector *int_lvds_connector;
+	struct drm_connector *int_edp_connector;
 
 	bool mchbar_need_disable;
 
@@ -722,6 +724,8 @@ typedef struct drm_i915_private {
 	/* list of fbdev register on this device */
 	struct intel_fbdev *fbdev;
 
+	struct backlight_device *backlight;
+
 	struct drm_property *broadcast_rgb_property;
 	struct drm_property *force_audio_property;
 
diff -puN drivers/gpu/drm/i915/intel_dp.c~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_dp.c
--- a/drivers/gpu/drm/i915/intel_dp.c~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_dp.c
@@ -1811,6 +1811,11 @@ done:
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
@@ -2043,6 +2048,8 @@ intel_dp_init(struct drm_device *dev, in
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
@@ -274,9 +274,10 @@ extern void intel_pch_panel_fitting(stru
 extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
-extern void intel_panel_setup_backlight(struct drm_device *dev);
+extern int intel_panel_setup_backlight(struct drm_device *dev);
 extern void intel_panel_enable_backlight(struct drm_device *dev);
 extern void intel_panel_disable_backlight(struct drm_device *dev);
+extern void intel_panel_destroy_backlight(struct drm_device *dev);
 extern enum drm_connector_status intel_panel_detect(struct drm_device *dev);
 
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
diff -puN drivers/gpu/drm/i915/intel_lvds.c~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -582,6 +582,8 @@ static void intel_lvds_destroy(struct dr
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	intel_panel_destroy_backlight(dev);
+
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -1041,6 +1043,9 @@ out:
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
@@ -227,7 +227,6 @@ void intel_opregion_asle_intr(struct drm
 	asle->aslc = asle_stat;
 }
 
-/* Only present on Ironlake+ */
 void intel_opregion_gse_intr(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff -puN drivers/gpu/drm/i915/intel_panel.c~i915-add-native-backlight-control drivers/gpu/drm/i915/intel_panel.c
--- a/drivers/gpu/drm/i915/intel_panel.c~i915-add-native-backlight-control
+++ a/drivers/gpu/drm/i915/intel_panel.c
@@ -273,7 +273,7 @@ void intel_panel_enable_backlight(struct
 	dev_priv->backlight_enabled = true;
 }
 
-void intel_panel_setup_backlight(struct drm_device *dev)
+void intel_panel_init_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
@@ -305,3 +305,73 @@ intel_panel_detect(struct drm_device *de
 
 	return connector_status_unknown;
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

origin.patch
linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch
lis3-update-maintainer-information.patch
lis3-add-support-for-hp-elitebook-2730p.patch
lis3-add-support-for-hp-elitebook-8540w.patch
hp_accel-add-hp-probook-655x.patch
config_hp_accel-fix-help-text.patch
lis3-free-regulators-if-probe-fails.patch
lis3-change-naming-to-consistent.patch
lis3-change-exported-function-to-use-given.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch


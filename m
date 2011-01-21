From: akpm@linux-foundation.org
Subject: + nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev.patch added to -mm tree
Date: Thu, 20 Jan 2011 17:02:33 -0800
Message-ID: <201101210102.p0L12YBI012949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab1AUBDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 20:03:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, rpurdie@rpsys.net, rui.zhang@intel.com


The patch titled
     nouveau: change the backlight parent device to the connector, not the PCI dev
has been added to the -mm tree.  Its filename is
     nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev.patch

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
Subject: nouveau: change the backlight parent device to the connector, not the PCI dev
From: Matthew Garrett <mjg@redhat.com>

We may eventually end up with per-connector backlights, especially with
ddcci devices.  Make sure that the parent node for the backlight device is
the connector rather than the PCI device.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexdeucher@gmail.com>
Acked-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_backlight.c |   24 ++++++++++--------
 drivers/gpu/drm/nouveau/nouveau_connector.c |    9 ++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    8 +++---
 drivers/gpu/drm/nouveau/nouveau_state.c     |    6 ----
 4 files changed, 27 insertions(+), 20 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nouveau_backlight.c~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev drivers/gpu/drm/nouveau/nouveau_backlight.c
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev
+++ a/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -88,10 +88,11 @@ static const struct backlight_ops nv50_b
 	.update_status = nv50_set_intensity,
 };
 
-static int nouveau_nv40_backlight_init(struct drm_device *dev)
+static int nouveau_nv40_backlight_init(struct drm_connector *connector)
 {
-	struct backlight_properties props;
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
 	if (!(nv_rd32(dev, NV40_PMC_BACKLIGHT) & NV40_PMC_BACKLIGHT_MASK))
@@ -100,7 +101,7 @@ static int nouveau_nv40_backlight_init(s
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 31;
-	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
+	bd = backlight_device_register("nv_backlight", &connector->kdev, dev,
 				       &nv40_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
@@ -112,10 +113,11 @@ static int nouveau_nv40_backlight_init(s
 	return 0;
 }
 
-static int nouveau_nv50_backlight_init(struct drm_device *dev)
+static int nouveau_nv50_backlight_init(struct drm_connector *connector)
 {
-	struct backlight_properties props;
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
 	if (!nv_rd32(dev, NV50_PDISPLAY_SOR_BACKLIGHT))
@@ -124,7 +126,7 @@ static int nouveau_nv50_backlight_init(s
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 1025;
-	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
+	bd = backlight_device_register("nv_backlight", &connector->kdev, dev,
 				       &nv50_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
@@ -135,8 +137,9 @@ static int nouveau_nv50_backlight_init(s
 	return 0;
 }
 
-int nouveau_backlight_init(struct drm_device *dev)
+int nouveau_backlight_init(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 
 #ifdef CONFIG_ACPI
@@ -149,9 +152,9 @@ int nouveau_backlight_init(struct drm_de
 
 	switch (dev_priv->card_type) {
 	case NV_40:
-		return nouveau_nv40_backlight_init(dev);
+		return nouveau_nv40_backlight_init(connector);
 	case NV_50:
-		return nouveau_nv50_backlight_init(dev);
+		return nouveau_nv50_backlight_init(connector);
 	default:
 		break;
 	}
@@ -159,8 +162,9 @@ int nouveau_backlight_init(struct drm_de
 	return 0;
 }
 
-void nouveau_backlight_exit(struct drm_device *dev)
+void nouveau_backlight_exit(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 
 	if (dev_priv->backlight) {
diff -puN drivers/gpu/drm/nouveau/nouveau_connector.c~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev drivers/gpu/drm/nouveau/nouveau_connector.c
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev
+++ a/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -116,6 +116,10 @@ nouveau_connector_destroy(struct drm_con
 				      nouveau_connector_hotplug, connector);
 	}
 
+	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS ||
+	    connector->connector_type == DRM_MODE_CONNECTOR_eDP)
+		nouveau_backlight_exit(connector);
+
 	kfree(nv_connector->edid);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
@@ -893,6 +897,11 @@ nouveau_connector_create(struct drm_devi
 	}
 
 	drm_sysfs_connector_add(connector);
+
+	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS ||
+	    connector->connector_type == DRM_MODE_CONNECTOR_eDP)
+		nouveau_backlight_init(connector);
+
 	dcb->drm = connector;
 	return dcb->drm;
 
diff -puN drivers/gpu/drm/nouveau/nouveau_drv.h~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev drivers/gpu/drm/nouveau/nouveau_drv.h
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev
+++ a/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -1000,15 +1000,15 @@ static inline int nouveau_acpi_edid(stru
 
 /* nouveau_backlight.c */
 #ifdef CONFIG_DRM_NOUVEAU_BACKLIGHT
-extern int nouveau_backlight_init(struct drm_device *);
-extern void nouveau_backlight_exit(struct drm_device *);
+extern int nouveau_backlight_init(struct drm_connector *);
+extern void nouveau_backlight_exit(struct drm_connector *);
 #else
-static inline int nouveau_backlight_init(struct drm_device *dev)
+static inline int nouveau_backlight_init(struct drm_connector *dev)
 {
 	return 0;
 }
 
-static inline void nouveau_backlight_exit(struct drm_device *dev) { }
+static inline void nouveau_backlight_exit(struct drm_connector *dev) { }
 #endif
 
 /* nouveau_bios.c */
diff -puN drivers/gpu/drm/nouveau/nouveau_state.c~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev drivers/gpu/drm/nouveau/nouveau_state.c
--- a/drivers/gpu/drm/nouveau/nouveau_state.c~nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev
+++ a/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -738,10 +738,6 @@ nouveau_card_init(struct drm_device *dev
 			goto out_fence;
 	}
 
-	ret = nouveau_backlight_init(dev);
-	if (ret)
-		NV_ERROR(dev, "Error %d registering backlight\n", ret);
-
 	nouveau_fbcon_init(dev);
 	drm_kms_helper_poll_init(dev);
 	return 0;
@@ -793,8 +789,6 @@ static void nouveau_card_takedown(struct
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nouveau_engine *engine = &dev_priv->engine;
 
-	nouveau_backlight_exit(dev);

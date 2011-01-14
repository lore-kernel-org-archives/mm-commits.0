From: akpm@linux-foundation.org
Subject: + radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch added to -mm tree
Date: Fri, 14 Jan 2011 15:32:57 -0800
Message-ID: <201101142332.p0ENWwuS007341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab1ANXde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 18:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michel@daenzer.net, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, mjg@redhat.com, rpurdie@rpsys.net, rui.zhang@intel.com


The patch titled
     radeon: expose backlight class device for legacy LVDS encoder
has been added to the -mm tree.  Its filename is
     radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: radeon: expose backlight class device for legacy LVDS encoder
=46rom: Michel D=E4nzer <michel@daenzer.net>

Allows e.g. power management daemons to control the backlight level. In=
spired
by the corresponding code in radeonfb.

(Updated to add backlight type and make the connector the parent device=
 - mjg)

Signed-off-by: Michel D=E4nzer <michel@daenzer.net>
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

 drivers/gpu/drm/radeon/Kconfig                  |    1=20
 drivers/gpu/drm/radeon/radeon_connectors.c      |   15=20
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  257 +++++++++++++-
 drivers/gpu/drm/radeon/radeon_mode.h            |   10=20
 4 files changed, 277 insertions(+), 6 deletions(-)

diff -puN drivers/gpu/drm/radeon/Kconfig~radeon-expose-backlight-class-=
device-for-legacy-lvds-encoder drivers/gpu/drm/radeon/Kconfig
--- a/drivers/gpu/drm/radeon/Kconfig~radeon-expose-backlight-class-devi=
ce-for-legacy-lvds-encoder
+++ a/drivers/gpu/drm/radeon/Kconfig
@@ -1,6 +1,7 @@
 config DRM_RADEON_KMS
 	bool "Enable modesetting on radeon by default - NEW DRIVER"
 	depends on DRM_RADEON
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  Choose this option if you want kernel modesetting enabled by defaul=
t.
=20
diff -puN drivers/gpu/drm/radeon/radeon_connectors.c~radeon-expose-back=
light-class-device-for-legacy-lvds-encoder drivers/gpu/drm/radeon/radeo=
n_connectors.c
--- a/drivers/gpu/drm/radeon/radeon_connectors.c~radeon-expose-backligh=
t-class-device-for-legacy-lvds-encoder
+++ a/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -40,6 +40,10 @@ radeon_atombios_connected_scratch_regs(s
 				       struct drm_encoder *encoder,
 				       bool connected);
=20
+extern void
+radeon_legacy_backlight_init(struct radeon_encoder *radeon_encoder,
+			     struct drm_connector *drm_connector);
+
 void radeon_connector_hotplug(struct drm_connector *connector)
 {
 	struct drm_device *dev =3D connector->dev;
@@ -1517,6 +1521,17 @@ radeon_add_legacy_connector(struct drm_d
 		connector->polled =3D DRM_CONNECTOR_POLL_HPD;
 	connector->display_info.subpixel_order =3D subpixel_order;
 	drm_sysfs_connector_add(connector);
+	if (connector_type =3D=3D DRM_MODE_CONNECTOR_LVDS) {
+		struct drm_encoder *drm_encoder;
+
+		list_for_each_entry(drm_encoder, &dev->mode_config.encoder_list, hea=
d) {
+			struct radeon_encoder *radeon_encoder;
+
+			radeon_encoder =3D to_radeon_encoder(drm_encoder);
+			if (radeon_encoder->encoder_id =3D=3D ENCODER_OBJECT_ID_INTERNAL_LV=
DS)
+				radeon_legacy_backlight_init(radeon_encoder, connector);
+		}
+	}
 	return;
=20
 failed:
diff -puN drivers/gpu/drm/radeon/radeon_legacy_encoders.c~radeon-expose=
-backlight-class-device-for-legacy-lvds-encoder drivers/gpu/drm/radeon/=
radeon_legacy_encoders.c
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c~radeon-expose-bac=
klight-class-device-for-legacy-lvds-encoder
+++ a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -28,6 +28,10 @@
 #include "radeon_drm.h"
 #include "radeon.h"
 #include "atom.h"
+#include <linux/backlight.h>
+#ifdef CONFIG_PMAC_BACKLIGHT
+#include <asm/backlight.h>
+#endif
=20
 static void radeon_legacy_encoder_disable(struct drm_encoder *encoder)
 {
@@ -39,7 +43,7 @@ static void radeon_legacy_encoder_disabl
 	radeon_encoder->active_device =3D 0;
 }
=20
-static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int m=
ode)
+static void radeon_legacy_lvds_update(struct drm_encoder *encoder, int=
 mode)
 {
 	struct drm_device *dev =3D encoder->dev;
 	struct radeon_device *rdev =3D dev->dev_private;
@@ -47,15 +51,23 @@ static void radeon_legacy_lvds_dpms(stru
 	uint32_t lvds_gen_cntl, lvds_pll_cntl, pixclks_cntl, disp_pwr_man;
 	int panel_pwr_delay =3D 2000;
 	bool is_mac =3D false;
+	uint8_t backlight_level;
 	DRM_DEBUG_KMS("\n");
=20
+	lvds_gen_cntl =3D RREG32(RADEON_LVDS_GEN_CNTL);
+	backlight_level =3D (lvds_gen_cntl >> RADEON_LVDS_BL_MOD_LEVEL_SHIFT)=
 & 0xff;
+
 	if (radeon_encoder->enc_priv) {
 		if (rdev->is_atom_bios) {
 			struct radeon_encoder_atom_dig *lvds =3D radeon_encoder->enc_priv;
 			panel_pwr_delay =3D lvds->panel_pwr_delay;
+			if (lvds->bl_dev)
+				backlight_level =3D lvds->backlight_level;
 		} else {
 			struct radeon_encoder_lvds *lvds =3D radeon_encoder->enc_priv;
 			panel_pwr_delay =3D lvds->panel_pwr_delay;
+			if (lvds->bl_dev)
+				backlight_level =3D lvds->backlight_level;
 		}
 	}
=20
@@ -82,11 +94,13 @@ static void radeon_legacy_lvds_dpms(stru
 		lvds_pll_cntl &=3D ~RADEON_LVDS_PLL_RESET;
 		WREG32(RADEON_LVDS_PLL_CNTL, lvds_pll_cntl);
=20
-		lvds_gen_cntl =3D RREG32(RADEON_LVDS_GEN_CNTL);
-		lvds_gen_cntl |=3D (RADEON_LVDS_ON | RADEON_LVDS_EN | RADEON_LVDS_DI=
GON | RADEON_LVDS_BLON);
+		lvds_gen_cntl &=3D ~(RADEON_LVDS_DISPLAY_DIS |
+				   RADEON_LVDS_BL_MOD_LEVEL_MASK);
+		lvds_gen_cntl |=3D (RADEON_LVDS_ON | RADEON_LVDS_EN |
+				  RADEON_LVDS_DIGON | RADEON_LVDS_BLON |
+				  (backlight_level << RADEON_LVDS_BL_MOD_LEVEL_SHIFT));
 		if (is_mac)
 			lvds_gen_cntl |=3D RADEON_LVDS_BL_MOD_EN;
-		lvds_gen_cntl &=3D ~(RADEON_LVDS_DISPLAY_DIS);
 		udelay(panel_pwr_delay * 1000);
 		WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
 		break;
@@ -95,7 +109,6 @@ static void radeon_legacy_lvds_dpms(stru
 	case DRM_MODE_DPMS_OFF:
 		pixclks_cntl =3D RREG32_PLL(RADEON_PIXCLKS_CNTL);
 		WREG32_PLL_P(RADEON_PIXCLKS_CNTL, 0, ~RADEON_PIXCLK_LVDS_ALWAYS_ONb)=
;
-		lvds_gen_cntl =3D RREG32(RADEON_LVDS_GEN_CNTL);
 		lvds_gen_cntl |=3D RADEON_LVDS_DISPLAY_DIS;
 		if (is_mac) {
 			lvds_gen_cntl &=3D ~RADEON_LVDS_BL_MOD_EN;
@@ -119,6 +132,25 @@ static void radeon_legacy_lvds_dpms(stru
=20
 }
=20
+static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int m=
ode)
+{
+	struct radeon_device *rdev =3D encoder->dev->dev_private;
+	struct radeon_encoder *radeon_encoder =3D to_radeon_encoder(encoder);
+	DRM_DEBUG("\n");
+
+	if (radeon_encoder->enc_priv) {
+		if (rdev->is_atom_bios) {
+			struct radeon_encoder_atom_dig *lvds =3D radeon_encoder->enc_priv;
+			lvds->dpms_mode =3D mode;
+		} else {
+			struct radeon_encoder_lvds *lvds =3D radeon_encoder->enc_priv;
+			lvds->dpms_mode =3D mode;
+		}
+	}
+
+	radeon_legacy_lvds_update(encoder, mode);
+}
+
 static void radeon_legacy_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct radeon_device *rdev =3D encoder->dev->dev_private;
@@ -237,9 +269,222 @@ static const struct drm_encoder_helper_f
 	.disable =3D radeon_legacy_encoder_disable,
 };
=20
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+
+#define MAX_RADEON_LEVEL 0xFF
+
+struct radeon_backlight_privdata {
+	struct radeon_encoder *encoder;
+	uint8_t negative;
+};
+
+static uint8_t radeon_legacy_lvds_level(struct backlight_device *bd)
+{
+	struct radeon_backlight_privdata *pdata =3D bl_get_data(bd);
+	uint8_t level;
+
+	/* Convert brightness to hardware level */
+	if (bd->props.brightness < 0)
+		level =3D 0;
+	else if (bd->props.brightness > MAX_RADEON_LEVEL)
+		level =3D MAX_RADEON_LEVEL;
+	else
+		level =3D bd->props.brightness;
+
+	if (pdata->negative)
+		level =3D MAX_RADEON_LEVEL - level;
+
+	return level;
+}
+
+static int radeon_legacy_backlight_update_status(struct backlight_devi=
ce *bd)
+{
+	struct radeon_backlight_privdata *pdata =3D bl_get_data(bd);
+	struct radeon_encoder *radeon_encoder =3D pdata->encoder;
+	struct drm_device *dev =3D radeon_encoder->base.dev;
+	struct radeon_device *rdev =3D dev->dev_private;
+	int dpms_mode =3D DRM_MODE_DPMS_ON;
+
+	if (radeon_encoder->enc_priv) {
+		if (rdev->is_atom_bios) {
+			struct radeon_encoder_atom_dig *lvds =3D radeon_encoder->enc_priv;
+			dpms_mode =3D lvds->dpms_mode;
+			lvds->backlight_level =3D radeon_legacy_lvds_level(bd);
+		} else {
+			struct radeon_encoder_lvds *lvds =3D radeon_encoder->enc_priv;
+			dpms_mode =3D lvds->dpms_mode;
+			lvds->backlight_level =3D radeon_legacy_lvds_level(bd);
+		}
+	}
+
+	if (bd->props.brightness > 0)
+		radeon_legacy_lvds_update(&radeon_encoder->base, dpms_mode);
+	else
+		radeon_legacy_lvds_update(&radeon_encoder->base, DRM_MODE_DPMS_OFF);
+
+	return 0;
+}
+
+static int radeon_legacy_backlight_get_brightness(struct backlight_dev=
ice *bd)
+{
+	struct radeon_backlight_privdata *pdata =3D bl_get_data(bd);
+	struct radeon_encoder *radeon_encoder =3D pdata->encoder;
+	struct drm_device *dev =3D radeon_encoder->base.dev;
+	struct radeon_device *rdev =3D dev->dev_private;
+	uint8_t backlight_level;
+
+	backlight_level =3D (RREG32(RADEON_LVDS_GEN_CNTL) >>
+			   RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
+	return pdata->negative ? MAX_RADEON_LEVEL - backlight_level : backlig=
ht_level;
+}
+
+static const struct backlight_ops radeon_backlight_ops =3D {
+	.get_brightness =3D radeon_legacy_backlight_get_brightness,
+	.update_status	=3D radeon_legacy_backlight_update_status,
+};
+
+void radeon_legacy_backlight_init(struct radeon_encoder *radeon_encode=
r,
+				  struct drm_connector *drm_connector)
+{
+	struct drm_device *dev =3D radeon_encoder->base.dev;
+	struct radeon_device *rdev =3D dev->dev_private;
+	struct backlight_device *bd;
+	struct backlight_properties props;
+	struct radeon_backlight_privdata *pdata;
+	uint8_t backlight_level;
+
+	if (!radeon_encoder->enc_priv)
+		return;
+
+#ifdef CONFIG_PMAC_BACKLIGHT
+	if (!pmac_has_backlight_type("ati") &&
+	    !pmac_has_backlight_type("mnca"))
+		return;
+#endif
+
+	pdata =3D kmalloc(sizeof(struct radeon_backlight_privdata), GFP_KERNE=
L);
+	if (!pdata) {
+		DRM_ERROR("Memory allocation failed\n");
+		goto error;
+	}
+
+	props.max_brightness =3D MAX_RADEON_LEVEL;
+	props.type =3D BACKLIGHT_RAW;
+	bd =3D backlight_device_register("radeon_bl", &drm_connector->kdev,
+				       pdata, &radeon_backlight_ops, &props);
+	if (IS_ERR(bd)) {
+		DRM_ERROR("Backlight registration failed\n");
+		goto error;
+	}
+
+	pdata->encoder =3D radeon_encoder;
+
+	backlight_level =3D (RREG32(RADEON_LVDS_GEN_CNTL) >>
+			   RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
+	/* First, try to detect backlight level sense based on the assumption
+	 * that firmware set it up at full brightness
+	 */
+	if (backlight_level =3D=3D 0)
+		pdata->negative =3D true;
+	else if (backlight_level =3D=3D 0xff)
+		pdata->negative =3D false;
+	else {
+		/* XXX hack... maybe some day we can figure out in what direction
+		 * backlight should work on a given panel?
+		 */
+		pdata->negative =3D (rdev->family !=3D CHIP_RV200 &&
+				   rdev->family !=3D CHIP_RV250 &&
+				   rdev->family !=3D CHIP_RV280 &&
+				   rdev->family !=3D CHIP_RV350);
+
+#ifdef CONFIG_PMAC_BACKLIGHT
+		pdata->negative =3D (pdata->negative ||
+				   of_machine_is_compatible("PowerBook4,3") ||
+				   of_machine_is_compatible("PowerBook6,3") ||
+				   of_machine_is_compatible("PowerBook6,5"));
+#endif
+	}
+
+	if (rdev->is_atom_bios) {
+		struct radeon_encoder_atom_dig *lvds =3D radeon_encoder->enc_priv;
+		lvds->bl_dev =3D bd;
+	} else {
+		struct radeon_encoder_lvds *lvds =3D radeon_encoder->enc_priv;
+		lvds->bl_dev =3D bd;
+	}
+
+	bd->props.brightness =3D radeon_legacy_backlight_get_brightness(bd);
+	bd->props.power =3D FB_BLANK_UNBLANK;
+	backlight_update_status(bd);
+
+	DRM_INFO("radeon legacy LVDS backlight initialized\n");
+
+	return;
+
+error:
+	kfree(pdata);
+	return;
+}
+
+static void radeon_legacy_backlight_exit(struct radeon_encoder *radeon=
_encoder)
+{
+	struct drm_device *dev =3D radeon_encoder->base.dev;
+	struct radeon_device *rdev =3D dev->dev_private;
+	struct backlight_device *bd =3D NULL;
+
+	if (!radeon_encoder->enc_priv)
+		return;
+
+	if (rdev->is_atom_bios) {
+		struct radeon_encoder_atom_dig *lvds =3D radeon_encoder->enc_priv;
+		bd =3D lvds->bl_dev;
+		lvds->bl_dev =3D NULL;
+	} else {
+		struct radeon_encoder_lvds *lvds =3D radeon_encoder->enc_priv;
+		bd =3D lvds->bl_dev;
+		lvds->bl_dev =3D NULL;
+	}
+
+	if (bd) {
+		struct radeon_legacy_backlight_privdata *pdata;
+
+		pdata =3D bl_get_data(bd);
+		backlight_device_unregister(bd);
+		kfree(pdata);
+
+		DRM_INFO("radeon legacy LVDS backlight unloaded\n");
+	}
+}
+
+#else /* !CONFIG_BACKLIGHT_CLASS_DEVICE */
+
+static void radeon_legacy_backlight_init(struct radeon_encoder *encode=
r)
+{
+}
+
+static void radeon_legacy_backlight_exit(struct radeon_encoder *encode=
r)
+{
+}
+
+#endif
+
+
+static void radeon_lvds_enc_destroy(struct drm_encoder *encoder)
+{
+	struct radeon_encoder *radeon_encoder =3D to_radeon_encoder(encoder);
+
+	if (radeon_encoder->enc_priv) {
+		radeon_legacy_backlight_exit(radeon_encoder);
+		kfree(radeon_encoder->enc_priv);
+	}
+	drm_encoder_cleanup(encoder);
+	kfree(radeon_encoder);
+}
=20
 static const struct drm_encoder_funcs radeon_legacy_lvds_enc_funcs =3D=
 {
-	.destroy =3D radeon_enc_destroy,
+	.destroy =3D radeon_lvds_enc_destroy,
 };
=20
 static void radeon_legacy_primary_dac_dpms(struct drm_encoder *encoder=
, int mode)
diff -puN drivers/gpu/drm/radeon/radeon_mode.h~radeon-expose-backlight-=
class-device-for-legacy-lvds-encoder drivers/gpu/drm/radeon/radeon_mode=
=2Eh
--- a/drivers/gpu/drm/radeon/radeon_mode.h~radeon-expose-backlight-clas=
s-device-for-legacy-lvds-encoder
+++ a/drivers/gpu/drm/radeon/radeon_mode.h
@@ -300,6 +300,11 @@ struct radeon_encoder_lvds {
 	uint32_t lvds_gen_cntl;
 	/* panel mode */
 	struct drm_display_mode native_mode;
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct backlight_device *bl_dev;
+	int      dpms_mode;
+	uint8_t  backlight_level;
+#endif
 };
=20
 struct radeon_encoder_tv_dac {
@@ -353,6 +358,11 @@ struct radeon_encoder_atom_dig {
 	uint32_t lcd_ss_id;
 	/* panel mode */
 	struct drm_display_mode native_mode;
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct backlight_device *bl_dev;
+	int dpms_mode;
+	uint8_t backlight_level;
+#endif
 };
=20
 struct radeon_encoder_atom_dac {
_

Patches currently in -mm which might be from michel@daenzer.net are

radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

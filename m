From: akpm@linux-foundation.org
Subject: [folded] radeon-expose-backlight-class-device-for-legacy-lvds-encoder-update.patch removed from -mm tree
Date: Tue, 22 Mar 2011 15:56:02 -0700
Message-ID: <201103222256.p2MMu2kZ032527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab1CVW4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 18:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michel@daenzer.net, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, mjg@redhat.com, rpurdie@rpsys.net


The patch titled
     radeon-expose-backlight-class-device-for-legacy-lvds-encoder-updat=
e
has been removed from the -mm tree.  Its filename was
     radeon-expose-backlight-class-device-for-legacy-lvds-encoder-updat=
e.patch

This patch was dropped because it was folded into radeon-expose-backlig=
ht-class-device-for-legacy-lvds-encoder.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: radeon-expose-backlight-class-device-for-legacy-lvds-encoder-u=
pdate
=46rom: Michel D=E4nzer <michel@daenzer.net>

v2: Fix problems when CONFIG_BACKLIGHT_CLASS_DEVICE isn't defined.

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
Tested-by: Sedat Dilek <sedat.dilek@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h            |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/gpu/drm/radeon/radeon_legacy_encoders.c~radeon-expose=
-backlight-class-device-for-legacy-lvds-encoder-update drivers/gpu/drm/=
radeon/radeon_legacy_encoders.c
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c~radeon-expose-bac=
klight-class-device-for-legacy-lvds-encoder-update
+++ a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -460,7 +460,7 @@ static void radeon_legacy_backlight_exit
=20
 #else /* !CONFIG_BACKLIGHT_CLASS_DEVICE */
=20
-static void radeon_legacy_backlight_init(struct radeon_encoder *encode=
r)
+void radeon_legacy_backlight_init(struct radeon_encoder *encoder)
 {
 }
=20
diff -puN drivers/gpu/drm/radeon/radeon_mode.h~radeon-expose-backlight-=
class-device-for-legacy-lvds-encoder-update drivers/gpu/drm/radeon/rade=
on_mode.h
--- a/drivers/gpu/drm/radeon/radeon_mode.h~radeon-expose-backlight-clas=
s-device-for-legacy-lvds-encoder-update
+++ a/drivers/gpu/drm/radeon/radeon_mode.h
@@ -302,11 +302,9 @@ struct radeon_encoder_lvds {
 	uint32_t lvds_gen_cntl;
 	/* panel mode */
 	struct drm_display_mode native_mode;
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	struct backlight_device *bl_dev;
 	int      dpms_mode;
 	uint8_t  backlight_level;
-#endif
 };
=20
 struct radeon_encoder_tv_dac {
@@ -360,11 +358,9 @@ struct radeon_encoder_atom_dig {
 	uint32_t lcd_ss_id;
 	/* panel mode */
 	struct drm_display_mode native_mode;
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	struct backlight_device *bl_dev;
 	int dpms_mode;
 	uint8_t backlight_level;
-#endif
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

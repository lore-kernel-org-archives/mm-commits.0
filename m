From: akpm@linux-foundation.org
Subject: + radeon-expose-backlight-class-device-for-legacy-lvds-encoder-update.patch added to -mm tree
Date: Thu, 20 Jan 2011 17:02:31 -0800
Message-ID: <201101210102.p0L12VC8012946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab1AUBDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 20:03:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michel@daenzer.net, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, mjg@redhat.com, rpurdie@rpsys.net, rui.zhang@intel.com


The patch titled
     radeon-expose-backlight-class-device-for-legacy-lvds-encoder-updat=
e
has been added to the -mm tree.  Its filename is
     radeon-expose-backlight-class-device-for-legacy-lvds-encoder-updat=
e.patch

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
@@ -300,11 +300,9 @@ struct radeon_encoder_lvds {
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
@@ -358,11 +356,9 @@ struct radeon_encoder_atom_dig {
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
radeon-expose-backlight-class-device-for-legacy-lvds-encoder-update.pat=
ch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

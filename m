From: akpm@linux-foundation.org
Subject: [merged] drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb.patch removed from -mm tree
Date: Mon, 07 Dec 2009 11:15:22 -0800
Message-ID: <200912071915.nB7JFM70009880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758649AbZLGTQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 14:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm/radeon/kms: fix oops when set_base is call with no FB
has been removed from the -mm tree.  Its filename was
     drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/radeon/kms: fix oops when set_base is call with no FB
From: Jerome Glisse <jglisse@redhat.com>

Just do nothing if crct_set_base() is called with no FB.

The oops happens when the user switches between X & vt or in some case
when changing mode.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/atombios_crtc.c      |    7 +++++--
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/radeon/atombios_crtc.c~drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb drivers/gpu/drm/radeon/atombios_crtc.c
--- a/drivers/gpu/drm/radeon/atombios_crtc.c~drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb
+++ a/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -578,8 +578,11 @@ int atombios_crtc_set_base(struct drm_cr
 	uint64_t fb_location;
 	uint32_t fb_format, fb_pitch_pixels, tiling_flags;
 
-	if (!crtc->fb)
-		return -EINVAL;
+	/* no fb bound */
+	if (!crtc->fb) {
+		DRM_DEBUG("No FB bound\n");
+		return 0;
+	}
 
 	radeon_fb = to_radeon_framebuffer(crtc->fb);
 
diff -puN drivers/gpu/drm/radeon/radeon_legacy_crtc.c~drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb drivers/gpu/drm/radeon/radeon_legacy_crtc.c
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c~drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb
+++ a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -408,6 +408,11 @@ int radeon_crtc_set_base(struct drm_crtc
 	uint32_t gen_cntl_reg, gen_cntl_val;
 
 	DRM_DEBUG("\n");
+	/* no fb bound */
+	if (!crtc->fb) {
+		DRM_DEBUG("No FB bound\n");
+		return 0;
+	}
 
 	radeon_fb = to_radeon_framebuffer(crtc->fb);
 
_

Patches currently in -mm which might be from jglisse@redhat.com are

linux-next.patch


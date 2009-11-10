From: akpm@linux-foundation.org
Subject: + drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb.patch added to -mm tree
Date: Tue, 10 Nov 2009 14:31:03 -0800
Message-ID: <200911102231.nAAMV3oo027388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757096AbZKJWbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 17:31:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jglisse@redhat.com, airlied@linux.ie


The patch titled
     drm/radeon/kms: fix oops when set_base is call with no FB
has been added to the -mm tree.  Its filename is
     drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb.patch

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
Subject: drm/radeon/kms: fix oops when set_base is call with no FB
From: Jerome Glisse <jglisse@redhat.com>

Just do nothing if crct_set_base() is called with no FB.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

drm-radeon-kms-fix-oops-when-set_base-is-call-with-no-fb.patch


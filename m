From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-drm_fb_helperc-drm_fb_helper_setcmap-wrong-index-used-in-inner-loop.patch removed from -mm tree
Date: Tue, 08 Mar 2011 15:54:48 -0800
Message-ID: <201103082355.p28Nthf7002108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab1CHX5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2011 18:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, airlied@linux.ie, chris@chris-wilson.co.uk, sliedes@cc.hut.fi, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/drm_fb_helper.c: drm_fb_helper_setcmap(): wrong index used in inner loop
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-drm_fb_helperc-drm_fb_helper_setcmap-wrong-index-used-in-inner-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/drm_fb_helper.c: drm_fb_helper_setcmap(): wrong index used in inner loop
From: roel <roel.kluin@gmail.com>

Index i was already used in the outer loop.

Chris implies that this solve
https://bugzilla.kernel.org/show_bug.cgi?id=19512.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Sami Liedes <sliedes@cc.hut.fi>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drivers-gpu-drm-drm_fb_helperc-drm_fb_helper_setcmap-wrong-index-used-in-inner-loop drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drivers-gpu-drm-drm_fb_helperc-drm_fb_helper_setcmap-wrong-index-used-in-inner-loop
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -677,7 +677,7 @@ int drm_fb_helper_setcmap(struct fb_cmap
 	struct drm_crtc_helper_funcs *crtc_funcs;
 	u16 *red, *green, *blue, *transp;
 	struct drm_crtc *crtc;
-	int i, rc = 0;
+	int i, j, rc = 0;
 	int start;
 
 	for (i = 0; i < fb_helper->crtc_count; i++) {
@@ -690,7 +690,7 @@ int drm_fb_helper_setcmap(struct fb_cmap
 		transp = cmap->transp;
 		start = cmap->start;
 
-		for (i = 0; i < cmap->len; i++) {
+		for (j = 0; j < cmap->len; j++) {
 			u16 hred, hgreen, hblue, htransp = 0xffff;
 
 			hred = *red++;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch


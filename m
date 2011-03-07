From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-drm_fb_helperc-drm_fb_helper_setcmap-wrong-index-used-in-inner-loop.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:58:11 -0800
Message-ID: <201103072258.p27MwBg4032580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554Ab1CGW6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:58:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, airlied@linux.ie, chris@chris-wilson.co.uk, sliedes@cc.hut.fi


The patch titled
     drivers/gpu/drm/drm_fb_helper.c: drm_fb_helper_setcmap(): wrong index used in inner loop
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-drm_fb_helperc-drm_fb_helper_setcmap-wrong-index-used-in-inner-loop.patch

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
drivers-gpu-drm-drm_fb_helperc-drm_fb_helper_setcmap-wrong-index-used-in-inner-loop.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch


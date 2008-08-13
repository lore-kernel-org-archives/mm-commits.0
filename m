From: akpm@linux-foundation.org
Subject: + freescale-diu-bug-fix-add-sanity-check-for-aoi-position.patch added to -mm tree
Date: Wed, 13 Aug 2008 14:06:07 -0700
Message-ID: <200808132106.m7DL67ut006741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbYHMVGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 17:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yorksun@freescale.com, adaplas@pol.net, galak@gate.crashing.org, krzysztof.h1@poczta.fm


The patch titled
     freescale DIU: bug fix: add sanity check for AOI position
has been added to the -mm tree.  Its filename is
     freescale-diu-bug-fix-add-sanity-check-for-aoi-position.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freescale DIU: bug fix: add sanity check for AOI position
From: York Sun <yorksun@freescale.com>

AOI position cannot be negative.

Signed-off-by: York Sun <yorksun@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/video/fsl-diu-fb.c~freescale-diu-bug-fix-add-sanity-check-for-aoi-position drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~freescale-diu-bug-fix-add-sanity-check-for-aoi-position
+++ a/drivers/video/fsl-diu-fb.c
@@ -479,6 +479,10 @@ static void adjust_aoi_size_position(str
 	base_plane_width = machine_data->fsl_diu_info[0]->var.xres;
 	base_plane_height = machine_data->fsl_diu_info[0]->var.yres;
 
+	if (mfbi->x_aoi_d < 0)
+		mfbi->x_aoi_d = 0;
+	if (mfbi->y_aoi_d < 0)
+		mfbi->y_aoi_d = 0;
 	switch (index) {
 	case 0:
 		if (mfbi->x_aoi_d != 0)
_

Patches currently in -mm which might be from yorksun@freescale.com are

freescale-diu-add-virtual-resolution-and-panning-support.patch
freescale-diu-bug-fix-add-sanity-check-for-aoi-position.patch


From: akpm@linux-foundation.org
Subject: - freescale-diu-bug-fix-add-sanity-check-for-aoi-position.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:44 -0700
Message-ID: <200808181939.m7IJdiIX008359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933604AbYHRToI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yorksun@freescale.com, adaplas@pol.net, galak@gate.crashing.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     freescale DIU: bug fix: add sanity check for AOI position
has been removed from the -mm tree.  Its filename was
     freescale-diu-bug-fix-add-sanity-check-for-aoi-position.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] nvidiafb-fix-missing-space-in-log-message.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:46 -0700
Message-ID: <200906241910.n5OJAkaP010958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbZFXTKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: fix missing space in log message
has been removed from the -mm tree.  Its filename was
     nvidiafb-fix-missing-space-in-log-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nvidiafb: fix missing space in log message
From: Mikael Pettersson <mikpe@it.uu.se>

On bootup nvidiafb prints the following on my Apple G5:

	nvidiafb: CRTC 1appears to have a CRT attached

There should be a space between the '1' and the 'appears'.

Fix: add the space

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_setup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/nvidia/nv_setup.c~nvidiafb-fix-missing-space-in-log-message drivers/video/nvidia/nv_setup.c
--- a/drivers/video/nvidia/nv_setup.c~nvidiafb-fix-missing-space-in-log-message
+++ a/drivers/video/nvidia/nv_setup.c
@@ -543,8 +543,7 @@ int NVCommonSetup(struct fb_info *info)
 		} else if (analog_on_B) {
 			CRTCnumber = outputBfromCRTC;
 			FlatPanel = 0;
-			printk("nvidiafb: CRTC %i"
-			       "appears to have a "
+			printk("nvidiafb: CRTC %i appears to have a "
 			       "CRT attached\n", CRTCnumber);
 		} else if (slaved_on_A) {
 			CRTCnumber = 0;
_

Patches currently in -mm which might be from mikpe@it.uu.se are

origin.patch


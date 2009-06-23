From: akpm@linux-foundation.org
Subject: + nvidiafb-fix-missing-space-in-log-message.patch added to -mm tree
Date: Mon, 22 Jun 2009 23:11:36 -0700
Message-ID: <200906230611.n5N6Ba5f001000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbZFWGLm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 02:11:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se


The patch titled
     From: Mikael Pettersson <mikpe@it.uu.se>
has been added to the -mm tree.  Its filename is
     nvidiafb-fix-missing-space-in-log-message.patch

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
Subject: From: Mikael Pettersson <mikpe@it.uu.se>


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

nvidiafb-fix-missing-space-in-log-message.patch


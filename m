From: akpm@linux-foundation.org
Subject: + viafb-do-modesetting-after-updating-variables.patch added to -mm tree
Date: Mon, 11 Jan 2010 13:46:53 -0800
Message-ID: <201001112146.o0BLkr1p030094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab0AKVrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 16:47:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ej.lfs@xs4all.nl, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: do modesetting after updating variables
has been added to the -mm tree.  Its filename is
     viafb-do-modesetting-after-updating-variables.patch

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
Subject: viafb: do modesetting after updating variables
From: Erik-Jan Post <ej.lfs@xs4all.nl>

Reorder viafb_set_par to allow using the updated variables in
viafb_setmode.  This fixes a regression that prevented proper runtime mode
changes.

Signed-off-by: Erik-Jan Post <ej.lfs@xs4all.nl>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-do-modesetting-after-updating-variables drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-do-modesetting-after-updating-variables
+++ a/drivers/video/via/viafbdev.c
@@ -177,16 +177,15 @@ static int viafb_set_par(struct fb_info 
 	}
 
 	if (vmode_index != VIA_RES_INVALID) {
-		viafb_setmode(vmode_index, info->var.xres, info->var.yres,
-			info->var.bits_per_pixel, vmode_index1,
-			viafb_second_xres, viafb_second_yres, viafb_bpp1);

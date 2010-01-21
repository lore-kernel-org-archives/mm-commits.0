From: akpm@linux-foundation.org
Subject: [merged] viafb-do-modesetting-after-updating-variables.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:02 -0800
Message-ID: <201001212127.o0LLR2W7030603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292Ab0AUV1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ej.lfs@xs4all.nl, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: do modesetting after updating variables
has been removed from the -mm tree.  Its filename was
     viafb-do-modesetting-after-updating-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

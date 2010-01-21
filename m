From: akpm@linux-foundation.org
Subject: [merged] viafb-fix-lcd-hardware-cursor-regression.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:26:58 -0800
Message-ID: <201001212126.o0LLQw8S030598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286Ab0AUV1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:27:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, jwollrath@web.de, mm-commits@vger.kernel.org


The patch titled
     viafb: fix LCD hardware cursor regression
has been removed from the -mm tree.  Its filename was
     viafb-fix-lcd-hardware-cursor-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: fix LCD hardware cursor regression
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Although I'd consider this a hardware bug, as there is hardware out that
for whatever reason does not support hardware cursors on LCD output we
have to care about it in the driver.  This fixes a regression (invisible
cursor) introduced by:

    viafb: cleanup viafb_cursor

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Reported-by: Julian Wollrath <jwollrath@web.de>
Tested-by: Julian Wollrath <jwollrath@web.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/via/viafbdev.c~viafb-fix-lcd-hardware-cursor-regression drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-fix-lcd-hardware-cursor-regression
+++ a/drivers/video/via/viafbdev.c
@@ -872,7 +872,9 @@ static int viafb_cursor(struct fb_info *
 	if (info->flags & FBINFO_HWACCEL_DISABLED || info != viafbinfo)
 		return -ENODEV;
 
-	if (chip_name == UNICHROME_CLE266 && viapar->iga_path == IGA2)
+	/* LCD ouput does not support hw cursors (at least on VN896) */
+	if ((chip_name == UNICHROME_CLE266 && viapar->iga_path == IGA2) ||
+		viafb_LCD_ON)
 		return -ENODEV;
 
 	viafb_show_hw_cursor(info, HW_Cursor_OFF);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch
viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch
viafb-yet-another-dead-code-removal.patch


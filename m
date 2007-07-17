From: akpm@linux-foundation.org
Subject: - sisfb-fix-pseudo_palette-array-size-and-overrun.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:48 -0700
Message-ID: <200707172307.l6HN7mQI012222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760894AbXGQXPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sisfb: fix pseudo_palette array size and overrun
has been removed from the -mm tree.  Its filename was
     sisfb-fix-pseudo_palette-array-size-and-overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sisfb: fix pseudo_palette array size and overrun
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long.
- do not write to the pseudo_palette if regno (array index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis.h      |    2 +-
 drivers/video/sis/sis_main.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/sis/sis.h~sisfb-fix-pseudo_palette-array-size-and-overrun drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~sisfb-fix-pseudo_palette-array-size-and-overrun
+++ a/drivers/video/sis/sis.h
@@ -479,7 +479,7 @@ struct sis_video_info {
 	struct fb_var_screeninfo default_var;
 
 	struct fb_fix_screeninfo sisfb_fix;
-	u32		pseudo_palette[17];
+	u32		pseudo_palette[16];
 
 	struct sisfb_monitor {
 		u16 hmin;
diff -puN drivers/video/sis/sis_main.c~sisfb-fix-pseudo_palette-array-size-and-overrun drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~sisfb-fix-pseudo_palette-array-size-and-overrun
+++ a/drivers/video/sis/sis_main.c
@@ -1405,12 +1405,18 @@ sisfb_setcolreg(unsigned regno, unsigned
 		}
 		break;
 	case 16:
+		if (regno >= 16)
+			break;
+
 		((u32 *)(info->pseudo_palette))[regno] =
 				(red & 0xf800)          |
 				((green & 0xfc00) >> 5) |
 				((blue & 0xf800) >> 11);
 		break;
 	case 32:
+		if (regno >= 16)
+			break;
+
 		red >>= 8;
 		green >>= 8;
 		blue >>= 8;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch

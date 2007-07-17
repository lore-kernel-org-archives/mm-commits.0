From: akpm@linux-foundation.org
Subject: - pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:28 -0700
Message-ID: <200707172307.l6HN7Sel012192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59475 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934447AbXGQXPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     pvr2fb: fix pseudo_palette array overrun and typecast
has been removed from the -mm tree.  Its filename was
     pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pvr2fb: fix pseudo_palette array overrun and typecast
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette has only 16 elements. Do not write if regno (the array
  index) is more than 15.
- if using generic drawing libraries, the typecast of pseudo_palette is
  always u32 *

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pvr2fb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/pvr2fb.c~pvr2fb-fix-pseudo_palette-array-overrun-and-typecast drivers/video/pvr2fb.c
--- a/drivers/video/pvr2fb.c~pvr2fb-fix-pseudo_palette-array-overrun-and-typecast
+++ a/drivers/video/pvr2fb.c
@@ -333,24 +333,25 @@ static int pvr2fb_setcolreg(unsigned int
 		      ((blue  & 0xf800) >> 11);
 
 		pvr2fb_set_pal_entry(par, regno, tmp);
-		((u16*)(info->pseudo_palette))[regno] = tmp;
 		break;
 	    case 24: /* RGB 888 */
 		red >>= 8; green >>= 8; blue >>= 8;
-		((u32*)(info->pseudo_palette))[regno] = (red << 16) | (green << 8) | blue;
+		tmp = (red << 16) | (green << 8) | blue;
 		break;
 	    case 32: /* ARGB 8888 */
 		red >>= 8; green >>= 8; blue >>= 8;
 		tmp = (transp << 24) | (red << 16) | (green << 8) | blue;
 
 		pvr2fb_set_pal_entry(par, regno, tmp);
-		((u32*)(info->pseudo_palette))[regno] = tmp;
 		break;
 	    default:
 		pr_debug("Invalid bit depth %d?!?\n", info->var.bits_per_pixel);
 		return 1;
 	}
 
+	if (regno < 16)
+		((u32*)(info->pseudo_palette))[regno] = tmp;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch

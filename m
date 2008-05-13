From: akpm@linux-foundation.org
Subject: - vt-fix-console-scrolling-regression.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:25 -0700
Message-ID: <200805132134.m4DLYPkg000920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759946AbYEMVee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@medozas.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     vt/fbcon: update scrl_erase_char after 256/512-glyph font switch
has been removed from the -mm tree.  Its filename was
     vt-fix-console-scrolling-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt/fbcon: update scrl_erase_char after 256/512-glyph font switch
From: Jan Engelhardt <jengelh@medozas.de>

Addendum to commit c9e587ab.
vc->vc_scrl_erase_char was not updated when fbcon switches between
256- and 512-glyph fonts.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~vt-fix-console-scrolling-regression drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~vt-fix-console-scrolling-regression
+++ a/drivers/video/console/fbcon.c
@@ -2507,6 +2507,9 @@ static int fbcon_do_set_font(struct vc_d
 			c = vc->vc_video_erase_char;
 			vc->vc_video_erase_char =
 			    ((c & 0xfe00) >> 1) | (c & 0xff);
+			c = vc->vc_def_color;
+			vc->vc_scrl_erase_char =
+			    ((c & 0xFE00) >> 1) | (c & 0xFF);
 			vc->vc_attr >>= 1;
 		}
 	} else if (!vc->vc_hi_font_mask && cnt == 512) {
@@ -2537,9 +2540,14 @@ static int fbcon_do_set_font(struct vc_d
 			if (vc->vc_can_do_color) {
 				vc->vc_video_erase_char =
 				    ((c & 0xff00) << 1) | (c & 0xff);
+				c = vc->vc_def_color;
+				vc->vc_scrl_erase_char =
+				    ((c & 0xFF00) << 1) | (c & 0xFF);
 				vc->vc_attr <<= 1;
-			} else
+			} else {
 				vc->vc_video_erase_char = c & ~0x100;
+				vc->vc_scrl_erase_char = c & ~0x100;
+			}
 		}
 
 	}
_

Patches currently in -mm which might be from jengelh@medozas.de are

origin.patch
fs-make-struct-file-arg-to-d_path-const.patch


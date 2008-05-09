From: akpm@linux-foundation.org
Subject: + vt-fix-console-scrolling-regression.patch added to -mm tree
Date: Fri, 09 May 2008 15:12:28 -0700
Message-ID: <200805092212.m49MCSLh028190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721AbYEIWMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 18:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@medozas.de, davem@davemloft.net


The patch titled
     vt: fix console scrolling regression
has been added to the -mm tree.  Its filename is
     vt-fix-console-scrolling-regression.patch

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
Subject: vt: fix console scrolling regression
From: Jan Engelhardt <jengelh@medozas.de>

Needs sob and changelog, please.

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

vt-fix-console-scrolling-regression.patch


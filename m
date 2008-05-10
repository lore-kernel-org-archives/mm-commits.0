From: akpm@linux-foundation.org
Subject: + vt-fbcon-fix-background-color-on-line-feed.patch added to -mm tree
Date: Sat, 10 May 2008 01:37:22 -0700
Message-ID: <200805100837.m4A8bMa3016461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbYEJIiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 May 2008 04:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@medozas.de


The patch titled
     vt/fbcon: fix background color on line feed
has been added to the -mm tree.  Its filename is
     vt-fbcon-fix-background-color-on-line-feed.patch

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
Subject: vt/fbcon: fix background color on line feed
From: Jan Engelhardt <jengelh@medozas.de>

Addendum to commit c9e587ab.

fbcon still was not doing the right thing (read: continued to do old
behavior).  fbcon_clear() seems to clear the new line (e.g.  where your new
prompt appears after doing echo -en "\e[42mfoo\n"), while scr_memsetw clears
the previous one only (where "foo" appears).  So just temporarily set the
video_erase_char to the scrl_erase_char so that fbcon_clear does the right
thing.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN drivers/video/console/fbcon.c~vt-fbcon-fix-background-color-on-line-feed drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~vt-fbcon-fix-background-color-on-line-feed
+++ a/drivers/video/console/fbcon.c
@@ -1853,6 +1853,8 @@ static int fbcon_scroll(struct vc_data *
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct display *p = &fb_display[vc->vc_num];
 	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
+	unsigned short saved_ec;
+	int ret;
 
 	if (fbcon_is_inactive(vc, info))
 		return -EINVAL;
@@ -1865,6 +1867,11 @@ static int fbcon_scroll(struct vc_data *
 	 *           whole screen (prevents flicker).
 	 */
 
+	saved_ec = vc->vc_video_erase_char;
+	vc->vc_video_erase_char = vc->vc_scrl_erase_char;
+
+	ret = 0;
+
 	switch (dir) {
 	case SM_UP:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
@@ -1883,7 +1890,7 @@ static int fbcon_scroll(struct vc_data *
 							(b - count)),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
@@ -1955,7 +1962,8 @@ static int fbcon_scroll(struct vc_data *
 							(b - count)),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
+			break;
 		}
 		break;
 
@@ -1974,7 +1982,7 @@ static int fbcon_scroll(struct vc_data *
 							t),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
@@ -2044,10 +2052,13 @@ static int fbcon_scroll(struct vc_data *
 							t),
 				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
-			return 1;
+			ret = 1;
+			break;
 		}
+		break;
 	}
-	return 0;
+	vc->vc_video_erase_char = saved_ec;
+	return ret;
 }
 
 
_

Patches currently in -mm which might be from jengelh@medozas.de are

vt-fix-console-scrolling-regression.patch
vt-fbcon-fix-background-color-on-line-feed.patch


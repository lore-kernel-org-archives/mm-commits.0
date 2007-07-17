From: akpm@linux-foundation.org
Subject: - fbcon-smart-blitter-usage-for-scrolling.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:40 -0700
Message-ID: <200707172306.l6HN6erU012041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935658AbXGQXPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: smart blitter usage for scrolling
has been removed from the -mm tree.  Its filename was
     fbcon-smart-blitter-usage-for-scrolling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: smart blitter usage for scrolling
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch replaces the current SCROLL_MOVE method with smarter method using
the same logic as the SCROLL_REDRAW method.  This brings these two methods
much closer in performance and benefits all framebuffers which uses the
SCROLL_MOVE method.

[adaplas]
- remove unnecessary char attribute checking
- whitespace cleanups and 80-column line fixes

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   76 ++++++++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 8 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-smart-blitter-usage-for-scrolling drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-smart-blitter-usage-for-scrolling
+++ a/drivers/video/console/fbcon.c
@@ -1704,6 +1704,56 @@ static void fbcon_redraw_move(struct vc_
 	}
 }
 
+static void fbcon_redraw_blit(struct vc_data *vc, struct fb_info *info,
+			struct display *p, int line, int count, int ycount)
+{
+	int offset = ycount * vc->vc_cols;
+	unsigned short *d = (unsigned short *)
+	    (vc->vc_origin + vc->vc_size_row * line);
+	unsigned short *s = d + offset;
+	struct fbcon_ops *ops = info->fbcon_par;
+
+	while (count--) {
+		unsigned short *start = s;
+		unsigned short *le = advance_row(s, 1);
+		unsigned short c;
+		int x = 0;
+
+		do {
+			c = scr_readw(s);
+
+			if (c == scr_readw(d)) {
+				if (s > start) {
+					ops->bmove(vc, info, line + ycount, x,
+						   line, x, 1, s-start);
+					x += s - start + 1;
+					start = s + 1;
+				} else {
+					x++;
+					start++;
+				}
+			}
+
+			scr_writew(c, d);
+			console_conditional_schedule();
+			s++;
+			d++;
+		} while (s < le);
+		if (s > start)
+			ops->bmove(vc, info, line + ycount, x, line, x, 1,
+				   s-start);
+		console_conditional_schedule();
+		if (ycount > 0)
+			line++;
+		else {
+			line--;
+			/* NOTE: We subtract two lines from these pointers */
+			s -= vc->vc_size_row;
+			d -= vc->vc_size_row;
+		}
+	}
+}
+
 static void fbcon_redraw(struct vc_data *vc, struct display *p,
 			 int line, int count, int offset)
 {
@@ -1789,7 +1839,6 @@ static int fbcon_scroll(struct vc_data *
 {
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct display *p = &fb_display[vc->vc_num];
-	struct fbcon_ops *ops = info->fbcon_par;
 	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
 
 	if (fbcon_is_inactive(vc, info))
@@ -1813,10 +1862,15 @@ static int fbcon_scroll(struct vc_data *
 			goto redraw_up;
 		switch (p->scrollmode) {
 		case SCROLL_MOVE:
-			ops->bmove(vc, info, t + count, 0, t, 0,
-				    b - t - count, vc->vc_cols);
-			ops->clear(vc, info, b - count, 0, count,
-				  vc->vc_cols);
+			fbcon_redraw_blit(vc, info, p, t, b - t - count,
+				     count);
+			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
+			scr_memsetw((unsigned short *) (vc->vc_origin +
+							vc->vc_size_row *
+							(b - count)),
+				    vc->vc_video_erase_char,
+				    vc->vc_size_row * count);
+			return 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
@@ -1899,9 +1953,15 @@ static int fbcon_scroll(struct vc_data *
 			goto redraw_down;
 		switch (p->scrollmode) {
 		case SCROLL_MOVE:
-			ops->bmove(vc, info, t, 0, t + count, 0,
-				    b - t - count, vc->vc_cols);
-			ops->clear(vc, info, t, 0, count, vc->vc_cols);
+			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,
+				     -count);
+			fbcon_clear(vc, t, 0, count, vc->vc_cols);
+			scr_memsetw((unsigned short *) (vc->vc_origin +
+							vc->vc_size_row *
+							t),
+				    vc->vc_video_erase_char,
+				    vc->vc_size_row * count);
+			return 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

From: akpm@linux-foundation.org
Subject: + vt-fix-console-corruption-on-driver-hand-over.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:46:34 -0700
Message-ID: <201008232346.o7NNkYN6022325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab0HWXqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: currojerez@riseup.net, alan@linux.intel.com, gregkh@suse.de, qiaochong@loongson.cn


The patch titled
     vt: fix console corruption on driver hand-over
has been added to the -mm tree.  Its filename is
     vt-fix-console-corruption-on-driver-hand-over.patch

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
Subject: vt: fix console corruption on driver hand-over
From: Francisco Jerez <currojerez@riseup.net>

After 02f0777a0d6560 ("drivers/char/vt.c: fix vc->vc_origin on
take_over_console()"), vc_origin is no longer reset to the screen buffer
before calling the con_init() hook of the new console driver.

If the old driver wasn't using a fixed scanout buffer (e.g.  the case of
vgacon) "vc_origin" may be a pointer to a VRAM location, and its contents
aren't guaranteed to be preserved after calling con_deinit() on the old
driver and con_init() on the new driver, i.e.  the subsequent console
resize may fill the framebuffer with garbage.

It can be reproduced in the transition from vgacon to the nouveau
framebuffer driver: in that case the legacy VGA aperture "vc_origin"
points to becomes unreadable after fbcon_init().

This patch reverts the mentioned commit.  To avoid the problem it intended
to fix, stop using "vc_scr_end" in vc_do_resize() to calculate how many
rows we have to copy (actually the code looks simpler this way without the
help of "vc_scr_end").

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Tested-by: qiaochong <qiaochong@loongson.cn>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/char/vt.c~vt-fix-console-corruption-on-driver-hand-over drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-console-corruption-on-driver-hand-over
+++ a/drivers/char/vt.c
@@ -906,22 +906,16 @@ static int vc_do_resize(struct tty_struc
 			 * bottom of buffer
 			 */
 			old_origin += (old_rows - new_rows) * old_row_size;
-			end = vc->vc_scr_end;
 		} else {
 			/*
 			 * Cursor is in no man's land, copy 1/2 screenful
 			 * from the top and bottom of cursor position
 			 */
 			old_origin += (vc->vc_y - new_rows/2) * old_row_size;
-			end = old_origin + (old_row_size * new_rows);
 		}
-	} else
-		/*
-		 * Cursor near the top, copy contents from the top of buffer
-		 */
-		end = (old_rows > new_rows) ? old_origin +
-			(old_row_size * new_rows) :
-			vc->vc_scr_end;
+	}
+
+	end = old_origin + old_row_size * min(old_rows, new_rows);
 
 	update_attr(vc);
 
@@ -3075,8 +3069,7 @@ static int bind_con_driver(const struct 
 
 		old_was_color = vc->vc_can_do_color;
 		vc->vc_sw->con_deinit(vc);
-		if (!vc->vc_origin)
-			vc->vc_origin = (unsigned long)vc->vc_screenbuf;
+		vc->vc_origin = (unsigned long)vc->vc_screenbuf;
 		visual_init(vc, i, 0);
 		set_origin(vc);
 		update_attr(vc);
_

Patches currently in -mm which might be from currojerez@riseup.net are

vt-fix-console-corruption-on-driver-hand-over.patch


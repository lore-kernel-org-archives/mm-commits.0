From: akpm@linux-foundation.org
Subject: + fbcon-dont-draw-cursor-when-its-disabled.patch added to -mm tree
Date: Mon, 02 Apr 2007 00:04:58 -0700
Message-ID: <200704020704.l3274wjF026841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41857 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbXDBHFD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 03:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     fbcon: don't draw cursor when it's disabled
has been added to the -mm tree.  Its filename is
     fbcon-dont-draw-cursor-when-its-disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: don't draw cursor when it's disabled
From: Michal Januszewski <spock@gentoo.org>

When the cursor and echo are disabled on the current console, pressing a
key will cause a black rectangle to be painted in the cursor's position.
Fix this by not touching the framebuffer in fbcon_cursor() when the
cursor is off.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-dont-draw-cursor-when-its-disabled drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-dont-draw-cursor-when-its-disabled
+++ a/drivers/video/console/fbcon.c
@@ -1305,7 +1305,7 @@ static void fbcon_cursor(struct vc_data 
 	int y;
  	int c = scr_readw((u16 *) vc->vc_pos);
 
-	if (fbcon_is_inactive(vc, info))
+	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
 		return;
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
_

Patches currently in -mm which might be from spock@gentoo.org are

vt-fix-potential-race-in-vt_waitactive-handler.patch
fbcon-dont-draw-cursor-when-its-disabled.patch

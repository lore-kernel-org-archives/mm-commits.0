From: akpm@linux-foundation.org
Subject: - fbcon-dont-draw-cursor-when-its-disabled.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:09 -0700
Message-ID: <200705090300.l49309Ht010529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032797AbXEIDAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbcon: don't draw cursor when it's disabled
has been removed from the -mm tree.  Its filename was
     fbcon-dont-draw-cursor-when-its-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1310,7 +1310,7 @@ static void fbcon_cursor(struct vc_data 
 	int y;
  	int c = scr_readw((u16 *) vc->vc_pos);
 
-	if (fbcon_is_inactive(vc, info))
+	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
 		return;
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch

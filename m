From: akpm@linux-foundation.org
Subject: - vgacon-disallow-console-operations-when-in-kd_graphics.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:45 -0700
Message-ID: <200705090302.l4932jZh010875@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033327AbXEIDCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vgacon: disallow console operations when in KD_GRAPHICS  mode
has been removed from the -mm tree.  Its filename was
     vgacon-disallow-console-operations-when-in-kd_graphics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vgacon: disallow console operations when in KD_GRAPHICS  mode
From: "Antonino A. Daplas" <adaplas@gmail.com>

Reported by James Pearson as:

	 boot to run level 3

	 if not root, then make sure /dev/console is writeable

	 login and type:

	 setterm -blank 0

	 start X

	 type into an xterm:

	 while true; do echo "" > /dev/console; usleep 100000; done

	 while the above loop is running switch to the text console and back
	 again (Ctrl-Alt-F1 then Ctrl-Alt-F7)

	 ... and the screen will be shifting (and wrapping) to the left.

This problem stems from continuously writing text to the system console (which
is in KD_TEXT mode) while the foreground console is in KD_GRAPHICS
mode. Somewhere along the way, console printing got confused and omitted the
KD_GRAPHICS/KD_TEXT test.  Thus, vgacon attempted to scroll the screen of X,
which causes X to shift.

Fix by disallowing vgacon to touch the hardware when the vc is in KD_GRAPHICS
mode. A definitive fix entails a full audit of the console code.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/vgacon.c~vgacon-disallow-console-operations-when-in-kd_graphics drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vgacon-disallow-console-operations-when-in-kd_graphics
+++ a/drivers/video/console/vgacon.c
@@ -660,6 +660,9 @@ static void vgacon_set_cursor_size(int x
 
 static void vgacon_cursor(struct vc_data *c, int mode)
 {
+	if (c->vc_mode != KD_TEXT)
+		return;
+
 	vgacon_restore_screen(c);
 
 	switch (mode) {
@@ -1318,7 +1321,7 @@ static int vgacon_scroll(struct vc_data 
 	unsigned long oldo;
 	unsigned int delta;
 
-	if (t || b != c->vc_rows || vga_is_gfx)
+	if (t || b != c->vc_rows || vga_is_gfx || c->vc_mode != KD_TEXT)
 		return 0;
 
 	if (!vga_hardscroll_enabled || lines >= c->vc_rows / 2)
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch

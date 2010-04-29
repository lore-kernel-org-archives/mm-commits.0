From: akpm@linux-foundation.org
Subject: [merged] cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:57:05 -0400
Message-ID: <201004292058.o3TKwc1H011804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757756Ab0D3RJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuasa@linux-mips.org, arnaud.patard@rtp-net.org, henne@nachtwindheim.de, jayakumar.lkml@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     cobalt_lcdfb: fix section mismatch cobalt_lcdfb_fix
has been removed from the -mm tree.  Its filename was
     cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cobalt_lcdfb: fix section mismatch cobalt_lcdfb_fix
From: Yoichi Yuasa <yuasa@linux-mips.org>

WARNING: drivers/video/built-in.o(.devinit.text+0x78): Section mismatch in reference from the function cobalt_lcdfb_probe() to the variable .init.data:cobalt_lcdfb_fix
The function __devinit cobalt_lcdfb_probe() references
a variable __initdata cobalt_lcdfb_fix.
If cobalt_lcdfb_fix is only used by cobalt_lcdfb_probe then
annotate cobalt_lcdfb_fix with a matching annotation.

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cobalt_lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/cobalt_lcdfb.c~cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix drivers/video/cobalt_lcdfb.c
--- a/drivers/video/cobalt_lcdfb.c~cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix
+++ a/drivers/video/cobalt_lcdfb.c
@@ -123,7 +123,7 @@ static void lcd_clear(struct fb_info *in
 	lcd_write_control(info, LCD_RESET);
 }
 
-static struct fb_fix_screeninfo cobalt_lcdfb_fix __initdata = {
+static struct fb_fix_screeninfo cobalt_lcdfb_fix __devinitdata = {
 	.id		= "cobalt-lcd",
 	.type		= FB_TYPE_TEXT,
 	.type_aux	= FB_AUX_TEXT_MDA,
_

Patches currently in -mm which might be from yuasa@linux-mips.org are

char-drivers-ram-oops-panic-logger.patch
char-drivers-ram-oops-panic-logger-update.patch


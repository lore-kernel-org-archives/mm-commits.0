From: akpm@linux-foundation.org
Subject: + cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix.patch added to -mm tree
Date: Mon, 05 Apr 2010 13:29:53 -0700
Message-ID: <201004052029.o35KTr29007350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082Ab0DEUaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuasa@linux-mips.org, arnaud.patard@rtp-net.org, jayakumar.lkml@gmail.com, ralf@linux-mips.org


The patch titled
     cobalt_lcdfb: fix section mismatch cobalt_lcdfb_fix
has been added to the -mm tree.  Its filename is
     cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix.patch

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

cobalt_lcdfb-fix-section-mismatch-cobalt_lcdfb_fix.patch
char-drivers-ram-oops-panic-logger.patch
char-drivers-ram-oops-panic-logger-update.patch


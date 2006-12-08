From: akpm@osdl.org
Subject: - au1100fb-fix-to-remove-flickering.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:32 -0800
Message-ID: <200612082013.kB8KDWHD003102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946749AbWLHUNp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: freddy@dusktilldawn.nl, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     au11oofb: fix to remove flickering
has been removed from the -mm tree.  Its filename was
     au1100fb-fix-to-remove-flickering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: au11oofb: fix to remove flickering
From: Freddy Spierenburg <freddy@dusktilldawn.nl>

Currently a lot of flickering is seen on the VGA and LCD port when one
starts a DBAu1100 board, with 'CONFIG_PRINTK=3Dy'.

This patch removes the flickering and as a result all kernel messages come
by in a nice steady fashion.

Signed-off-by: Freddy Spierenburg <freddy@dusktilldawn.nl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/au1100fb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/au1100fb.h~au1100fb-fix-to-remove-flickering drivers/video/au1100fb.h
--- a/drivers/video/au1100fb.h~au1100fb-fix-to-remove-flickering
+++ a/drivers/video/au1100fb.h
@@ -274,7 +274,7 @@ static struct au1100fb_panel known_lcd_p
 		.bpp = 16,
 		.control_base =	0x0004886A |
 			LCD_CONTROL_DEFAULT_PO | LCD_CONTROL_DEFAULT_SBPPF |
-			LCD_CONTROL_BPP_16,
+			LCD_CONTROL_BPP_16 | LCD_CONTROL_SBB_4,
 		.clkcontrol_base = 0x00020000,
 		.horztiming = 0x005aff1f,
 		.verttiming = 0x16000e57,
_

Patches currently in -mm which might be from freddy@dusktilldawn.nl are

au1100fb-fix-to-remove-flickering.patch


From: akpm@linux-foundation.org
Subject: + omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:09 -0700
Message-ID: <200906250008.n5P08978005054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754926AbZFYAKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jouni.hogander@nokia.com, imre.deak@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: dispc: disable iface clocks along with func clocks
has been added to the -mm tree.  Its filename is
     omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch

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
Subject: omapfb: dispc: disable iface clocks along with func clocks
From: Jouni Hogander <jouni.hogander@nokia.com>

Leaving interface clocks enabled causes dss pwrdm to stay in active state
when mpu is in active state.  This fix puts dss to sleep state when it is
not needed.

Earlier version broke framebuffer on 24xx.  This is fixed by enabling
clocks before trying to access DISPC_IRQSTATUS register.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/dispc.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/video/omap/dispc.c~omapfb-dispc-disable-iface-clocks-along-with-func-clocks drivers/video/omap/dispc.c
--- a/drivers/video/omap/dispc.c~omapfb-dispc-disable-iface-clocks-along-with-func-clocks
+++ a/drivers/video/omap/dispc.c
@@ -858,8 +858,11 @@ EXPORT_SYMBOL(omap_dispc_free_irq);
 
 static irqreturn_t omap_dispc_irq_handler(int irq, void *dev)
 {
-	u32 stat = dispc_read_reg(DISPC_IRQSTATUS);
+	u32 stat;
 
+	enable_lcd_clocks(1);
+
+	stat = dispc_read_reg(DISPC_IRQSTATUS);
 	if (stat & DISPC_IRQ_FRAMEMASK)
 		complete(&dispc.frame_done);
 
@@ -875,6 +878,8 @@ static irqreturn_t omap_dispc_irq_handle
 
 	dispc_write_reg(DISPC_IRQSTATUS, stat);
 
+	enable_lcd_clocks(0);
+
 	return IRQ_HANDLED;
 }
 
@@ -913,18 +918,13 @@ static void put_dss_clocks(void)
 
 static void enable_lcd_clocks(int enable)
 {
-	if (enable)
+	if (enable) {
+		clk_enable(dispc.dss_ick);
 		clk_enable(dispc.dss1_fck);
-	else
+	} else {
 		clk_disable(dispc.dss1_fck);
-}
-
-static void enable_interface_clocks(int enable)
-{
-	if (enable)
-		clk_enable(dispc.dss_ick);
-	else
 		clk_disable(dispc.dss_ick);
+	}
 }
 
 static void enable_digit_clocks(int enable)
@@ -1365,7 +1365,6 @@ static int omap_dispc_init(struct omapfb
 	if ((r = get_dss_clocks()) < 0)
 		goto fail0;
 
-	enable_interface_clocks(1);
 	enable_lcd_clocks(1);
 
 #ifdef CONFIG_FB_OMAP_BOOTLOADER_INIT
@@ -1469,7 +1468,6 @@ fail2:
 	free_irq(INT_24XX_DSS_IRQ, fbdev);
 fail1:
 	enable_lcd_clocks(0);
-	enable_interface_clocks(0);
 	put_dss_clocks();
 fail0:
 	iounmap(dispc.base);
@@ -1487,7 +1485,6 @@ static void omap_dispc_cleanup(void)
 	cleanup_fbmem();
 	free_palette_ram();
 	free_irq(INT_24XX_DSS_IRQ, dispc.fbdev);
-	enable_interface_clocks(0);
 	put_dss_clocks();
 	iounmap(dispc.base);
 }
_

Patches currently in -mm which might be from jouni.hogander@nokia.com are

origin.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch


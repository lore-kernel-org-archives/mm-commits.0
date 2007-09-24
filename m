From: akpm@linux-foundation.org
Subject: + intel-fb-obvious-changes-and-corrections.patch added to -mm tree
Date: Mon, 24 Sep 2007 14:17:04 -0700
Message-ID: <200709242117.l8OLH4V1018131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbXIXVRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 17:17:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, adaplas@pol.net, sylvain.meyer@worldonline.fr


The patch titled
     Intel FB: obvious changes and corrections
has been added to the -mm tree.  Its filename is
     intel-fb-obvious-changes-and-corrections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel FB: obvious changes and corrections
From: Krzysztof Halasa <khc@pm.waw.pl>

Intel FB: obvious changes and corrections

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: <sylvain.meyer@worldonline.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfb.h   |    5 ++++-
 drivers/video/intelfb/intelfbhw.c |   14 ++++++--------
 drivers/video/intelfb/intelfbhw.h |    4 +++-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/video/intelfb/intelfb.h~intel-fb-obvious-changes-and-corrections drivers/video/intelfb/intelfb.h
--- a/drivers/video/intelfb/intelfb.h~intel-fb-obvious-changes-and-corrections
+++ a/drivers/video/intelfb/intelfb.h
@@ -355,7 +355,10 @@ struct intelfb_info {
 	struct intelfb_output_rec output[MAX_OUTPUTS];
 };
 
-#define IS_I9XX(dinfo) (((dinfo)->chipset == INTEL_915G)||(dinfo->chipset == INTEL_915GM)||((dinfo)->chipset == INTEL_945G)||(dinfo->chipset==INTEL_945GM))
+#define IS_I9XX(dinfo) (((dinfo)->chipset == INTEL_915G) ||	\
+			((dinfo)->chipset == INTEL_915GM) ||	\
+			((dinfo)->chipset == INTEL_945G) ||	\
+			((dinfo)->chipset==INTEL_945GM))
 
 #ifndef FBIO_WAITFORVSYNC
 #define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
diff -puN drivers/video/intelfb/intelfbhw.c~intel-fb-obvious-changes-and-corrections drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~intel-fb-obvious-changes-and-corrections
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -434,14 +434,14 @@ void intelfbhw_setcolreg(struct intelfb_
 			 unsigned red, unsigned green, unsigned blue,
 			 unsigned transp)
 {
+	u32 palette_reg = (dinfo->pipe == PIPE_A) ?
+			  PALETTE_A : PALETTE_B;
+
 #if VERBOSE > 0
 	DBG_MSG("intelfbhw_setcolreg: %d: (%d, %d, %d)\n",
 		regno, red, green, blue);
 #endif
 
-	u32 palette_reg = (dinfo->pipe == PIPE_A) ?
-			  PALETTE_A : PALETTE_B;
-
 	OUTREG(palette_reg + (regno << 2),
 	       (red << PALETTE_8_RED_SHIFT) |
 	       (green << PALETTE_8_GREEN_SHIFT) |
@@ -1305,8 +1305,8 @@ int intelfbhw_program_mode(struct intelf
 
 	count = 0;
 	do {
-		tmp_val[count%3] = INREG(0x70000);
-		if ((tmp_val[0] == tmp_val[1]) && (tmp_val[1]==tmp_val[2]))
+		tmp_val[count % 3] = INREG(PIPEA_DSL);
+		if ((tmp_val[0] == tmp_val[1]) && (tmp_val[1] == tmp_val[2]))
 			break;
 		count++;
 		udelay(1);
@@ -2004,7 +2004,6 @@ intelfbhw_enable_irq(struct intelfb_info
 
 void
 intelfbhw_disable_irq(struct intelfb_info *dinfo) {
-	u16 tmp;
 
 	if (test_and_clear_bit(0, &dinfo->irq_flags)) {
 		if (dinfo->vsync.pan_display) {
@@ -2016,8 +2015,7 @@ intelfbhw_disable_irq(struct intelfb_inf
 		OUTREG16(IMR, 0xffff);
 		OUTREG16(IER, 0x0);
 
-		tmp = INREG16(IIR);
-		OUTREG16(IIR, tmp);
+		OUTREG16(IIR, INREG16(IIR)); /* clear IRQ requests */
 		spin_unlock_irq(&dinfo->int_lock);
 
 		free_irq(dinfo->pdev->irq, dinfo);
diff -puN drivers/video/intelfb/intelfbhw.h~intel-fb-obvious-changes-and-corrections drivers/video/intelfb/intelfbhw.h
--- a/drivers/video/intelfb/intelfbhw.h~intel-fb-obvious-changes-and-corrections
+++ a/drivers/video/intelfb/intelfbhw.h
@@ -93,7 +93,7 @@
 #define IIR			0x20A4
 #define IMR			0x20A8
 #define VSYNC_PIPE_A_INTERRUPT		(1 << 7)
-#define PIPE_A_EVENT_INTERRUPT		(1 << 4)
+#define PIPE_A_EVENT_INTERRUPT		(1 << 6)
 #define VSYNC_PIPE_B_INTERRUPT		(1 << 5)
 #define PIPE_B_EVENT_INTERRUPT		(1 << 4)
 #define HOST_PORT_EVENT_INTERRUPT	(1 << 3)
@@ -276,6 +276,8 @@
 #define DVOB_SRCDIM		0x61144
 #define DVOC_SRCDIM		0x61164
 
+#define PIPEA_DSL		0x70000
+#define PIPEB_DSL		0x71000
 #define PIPEACONF		0x70008
 #define PIPEBCONF		0x71008
 #define PIPECONF_ENABLE			(1 << 31)
_

Patches currently in -mm which might be from khc@pm.waw.pl are

git-wireless.patch
intel-fb-support-for-interlaced-video-modes.patch
intel-fb-whitespace-bracket-and-other-clean-ups.patch
intel-fb-obvious-changes-and-corrections.patch
intel-fb-force-even-line-count-in-interlaced-mode.patch
intel-fb-more-interlaced-mode-support.patch

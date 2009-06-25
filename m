From: akpm@linux-foundation.org
Subject: + omapfb-dispc-allow-multiple-external-irq-handlers.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:14 -0700
Message-ID: <200906250008.n5P08FW1005078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227AbZFYAIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.stone@nokia.com, imre.deak@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: dispc: allow multiple external IRQ handlers
has been added to the -mm tree.  Its filename is
     omapfb-dispc-allow-multiple-external-irq-handlers.patch

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
Subject: omapfb: dispc: allow multiple external IRQ handlers
From: Daniel Stone <daniel.stone@nokia.com>

Previously, the only external (to dispc.c) IRQ handler was RFBI's frame
done handler.  dispc's IRQ framework was very dumb: you could only have
one handler, and the semantics of {request,free}_irq were odd, to say the
least.

The new framework allows multiple consumers to register arbitrary IRQ
masks.

Signed-off-by: Daniel Stone <daniel.stone@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/dispc.c |   95 +++++++++++++++++++++--------------
 drivers/video/omap/dispc.h |    7 +-
 drivers/video/omap/rfbi.c  |    7 +-
 3 files changed, 67 insertions(+), 42 deletions(-)

diff -puN drivers/video/omap/dispc.c~omapfb-dispc-allow-multiple-external-irq-handlers drivers/video/omap/dispc.c
--- a/drivers/video/omap/dispc.c~omapfb-dispc-allow-multiple-external-irq-handlers
+++ a/drivers/video/omap/dispc.c
@@ -155,6 +155,8 @@ struct resmap {
 	unsigned long	*map;
 };
 
+#define MAX_IRQ_HANDLERS            4
+
 static struct {
 	void __iomem	*base;
 
@@ -167,9 +169,11 @@ static struct {
 
 	int		ext_mode;
 
-	unsigned long	enabled_irqs;
-	void		(*irq_callback)(void *);
-	void		*irq_callback_data;
+	struct {
+		u32	irq_mask;
+		void	(*callback)(void *);
+		void	*data;
+	} irq_handlers[MAX_IRQ_HANDLERS];
 	struct completion	frame_done;
 
 	int		fir_hinc[OMAPFB_PLANE_NUM];
@@ -809,56 +813,70 @@ static void set_lcd_timings(void)
 	panel->pixel_clock = fck / lck_div / pck_div / 1000;
 }
 
-int omap_dispc_request_irq(void (*callback)(void *data), void *data)
+static void recalc_irq_mask(void)
 {
-	int r = 0;
+	int i;
+	unsigned long irq_mask = DISPC_IRQ_MASK_ERROR;
 
-	BUG_ON(callback == NULL);
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (!dispc.irq_handlers[i].callback)
+			continue;
 
-	if (dispc.irq_callback)
-		r = -EBUSY;
-	else {
-		dispc.irq_callback = callback;
-		dispc.irq_callback_data = data;
+		irq_mask |= dispc.irq_handlers[i].irq_mask;
 	}
 
-	return r;
-}
-EXPORT_SYMBOL(omap_dispc_request_irq);
-
-void omap_dispc_enable_irqs(int irq_mask)
-{
 	enable_lcd_clocks(1);
-	dispc.enabled_irqs = irq_mask;
-	irq_mask |= DISPC_IRQ_MASK_ERROR;
 	MOD_REG_FLD(DISPC_IRQENABLE, 0x7fff, irq_mask);
 	enable_lcd_clocks(0);
 }
-EXPORT_SYMBOL(omap_dispc_enable_irqs);
 
-void omap_dispc_disable_irqs(int irq_mask)
+int omap_dispc_request_irq(unsigned long irq_mask, void (*callback)(void *data),
+			   void *data)
 {
-	enable_lcd_clocks(1);
-	dispc.enabled_irqs &= ~irq_mask;
-	irq_mask &= ~DISPC_IRQ_MASK_ERROR;
-	MOD_REG_FLD(DISPC_IRQENABLE, 0x7fff, irq_mask);
-	enable_lcd_clocks(0);
+	int i;
+
+	BUG_ON(callback == NULL);
+
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (dispc.irq_handlers[i].callback)
+			continue;
+
+		dispc.irq_handlers[i].irq_mask = irq_mask;
+		dispc.irq_handlers[i].callback = callback;
+		dispc.irq_handlers[i].data = data;
+		recalc_irq_mask();
+
+		return 0;
+	}
+
+	return -EBUSY;
 }
-EXPORT_SYMBOL(omap_dispc_disable_irqs);
+EXPORT_SYMBOL(omap_dispc_request_irq);
 
-void omap_dispc_free_irq(void)
+void omap_dispc_free_irq(unsigned long irq_mask, void (*callback)(void *data),
+			 void *data)
 {
-	enable_lcd_clocks(1);
-	omap_dispc_disable_irqs(DISPC_IRQ_MASK_ALL);
-	dispc.irq_callback = NULL;
-	dispc.irq_callback_data = NULL;
-	enable_lcd_clocks(0);
+	int i;
+
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (dispc.irq_handlers[i].callback == callback &&
+		    dispc.irq_handlers[i].data == data) {
+			dispc.irq_handlers[i].irq_mask = 0;
+			dispc.irq_handlers[i].callback = NULL;
+			dispc.irq_handlers[i].data = NULL;
+			recalc_irq_mask();
+			return;
+		}
+	}
+
+	BUG();
 }
 EXPORT_SYMBOL(omap_dispc_free_irq);
 
 static irqreturn_t omap_dispc_irq_handler(int irq, void *dev)
 {
 	u32 stat;
+	int i = 0;
 
 	enable_lcd_clocks(1);
 
@@ -873,8 +891,12 @@ static irqreturn_t omap_dispc_irq_handle
 		}
 	}
 
-	if ((stat & dispc.enabled_irqs) && dispc.irq_callback)
-		dispc.irq_callback(dispc.irq_callback_data);
+	for (i = 0; i < MAX_IRQ_HANDLERS; i++) {
+		if (unlikely(dispc.irq_handlers[i].callback &&
+			     (stat & dispc.irq_handlers[i].irq_mask)))
+			dispc.irq_handlers[i].callback(
+						dispc.irq_handlers[i].data);
+	}
 
 	dispc_write_reg(DISPC_IRQSTATUS, stat);
 
@@ -1410,8 +1432,7 @@ static int omap_dispc_init(struct omapfb
 	l = dispc_read_reg(DISPC_IRQSTATUS);
 	dispc_write_reg(DISPC_IRQSTATUS, l);
 
-	/* Enable those that we handle always */
-	omap_dispc_enable_irqs(DISPC_IRQ_FRAMEMASK);
+	recalc_irq_mask();
 
 	if ((r = request_irq(INT_24XX_DSS_IRQ, omap_dispc_irq_handler,
 			   0, MODULE_NAME, fbdev)) < 0) {
diff -puN drivers/video/omap/dispc.h~omapfb-dispc-allow-multiple-external-irq-handlers drivers/video/omap/dispc.h
--- a/drivers/video/omap/dispc.h~omapfb-dispc-allow-multiple-external-irq-handlers
+++ a/drivers/video/omap/dispc.h
@@ -37,9 +37,10 @@ extern void omap_dispc_set_lcd_size(int 
 extern void omap_dispc_enable_lcd_out(int enable);
 extern void omap_dispc_enable_digit_out(int enable);
 
-extern int  omap_dispc_request_irq(void (*callback)(void *data), void *data);
-extern void omap_dispc_free_irq(void);
+extern int omap_dispc_request_irq(unsigned long irq_mask,
+				   void (*callback)(void *data), void *data);
+extern void omap_dispc_free_irq(unsigned long irq_mask,
+				 void (*callback)(void *data), void *data);
 
 extern const struct lcd_ctrl omap2_int_ctrl;
-
 #endif
diff -puN drivers/video/omap/rfbi.c~omapfb-dispc-allow-multiple-external-irq-handlers drivers/video/omap/rfbi.c
--- a/drivers/video/omap/rfbi.c~omapfb-dispc-allow-multiple-external-irq-handlers
+++ a/drivers/video/omap/rfbi.c
@@ -57,6 +57,7 @@
 
 #define DISPC_BASE		0x48050400
 #define DISPC_CONTROL		0x0040
+#define DISPC_IRQ_FRAMEMASK     0x0001
 
 static struct {
 	void __iomem	*base;
@@ -553,7 +554,9 @@ static int rfbi_init(struct omapfb_devic
 	l = (0x01 << 2);
 	rfbi_write_reg(RFBI_CONTROL, l);
 
-	if ((r = omap_dispc_request_irq(rfbi_dma_callback, NULL)) < 0) {
+	r = omap_dispc_request_irq(DISPC_IRQ_FRAMEMASK, rfbi_dma_callback,
+				   NULL);
+	if (r < 0) {
 		dev_err(fbdev->dev, "can't get DISPC irq\n");
 		rfbi_enable_clocks(0);
 		return r;
@@ -570,7 +573,7 @@ static int rfbi_init(struct omapfb_devic
 
 static void rfbi_cleanup(void)
 {
-	omap_dispc_free_irq();
+	omap_dispc_free_irq(DISPC_IRQ_FRAMEMASK, rfbi_dma_callback, NULL);
 	rfbi_put_clocks();
 	iounmap(rfbi.base);
 }
_

Patches currently in -mm which might be from daniel.stone@nokia.com are

omapfb-dispc-allow-multiple-external-irq-handlers.patch


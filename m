From: akpm@linux-foundation.org
Subject: + spi-mcspi-saves-chconfx-too.patch added to -mm tree
Date: Tue, 01 Sep 2009 13:59:11 -0700
Message-ID: <200909012059.n81KxB93017340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbZIAU75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 16:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tero.kristo@nokia.com, dbrownell@users.sourceforge.net, khilman@deeprootsystems.com


The patch titled
     spi: McSPI saves CHCONFx too
has been added to the -mm tree.  Its filename is
     spi-mcspi-saves-chconfx-too.patch

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
Subject: spi: McSPI saves CHCONFx too
From: Tero Kristo <tero.kristo@nokia.com>

Previous restore was lazy and only restored CHxCONF when it was needed by
a specific chip select.  This could cause occasional errors on an SPI bus
where multiple chip selects are in use.

Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/spi/omap2_mcspi.c~spi-mcspi-saves-chconfx-too drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-mcspi-saves-chconfx-too
+++ a/drivers/spi/omap2_mcspi.c
@@ -134,6 +134,7 @@ struct omap2_mcspi_cs {
 	void __iomem		*base;
 	unsigned long		phys;
 	int			word_len;
+	struct list_head	node;
 	/* Context save and restore shadow register */
 	u32			chconf0;
 };
@@ -145,6 +146,7 @@ struct omap2_mcspi_regs {
 	u32 sysconfig;
 	u32 modulctrl;
 	u32 wakeupenable;
+	struct list_head cs;
 };
 
 static struct omap2_mcspi_regs omap2_mcspi_ctx[OMAP2_MCSPI_MAX_CTRL];
@@ -255,6 +257,7 @@ static void omap2_mcspi_set_master_mode(
 static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
 {
 	struct spi_master *spi_cntrl;
+	struct omap2_mcspi_cs *cs;
 	spi_cntrl = mcspi->master;
 
 	/* McSPI: context restore */
@@ -266,6 +269,10 @@ static void omap2_mcspi_restore_ctx(stru
 
 	mcspi_write_reg(spi_cntrl, OMAP2_MCSPI_WAKEUPENABLE,
 			omap2_mcspi_ctx[spi_cntrl->bus_num - 1].wakeupenable);
+
+	list_for_each_entry(cs, &omap2_mcspi_ctx[spi_cntrl->bus_num - 1].cs,
+			node)
+		__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 }
 static void omap2_mcspi_disable_clocks(struct omap2_mcspi *mcspi)
 {
@@ -714,6 +721,9 @@ static int omap2_mcspi_setup(struct spi_
 		cs->phys = mcspi->phys + spi->chip_select * 0x14;
 		cs->chconf0 = 0;
 		spi->controller_state = cs;
+		/* Link this to context save list */
+		list_add_tail(&cs->node,
+			&omap2_mcspi_ctx[mcspi->master->bus_num - 1].cs);
 	}
 
 	if (mcspi_dma->dma_rx_channel == -1
@@ -736,10 +746,15 @@ static void omap2_mcspi_cleanup(struct s
 {
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma	*mcspi_dma;
+	struct omap2_mcspi_cs	*cs;
 
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
+	/* Unlink controller state from context save list */
+	cs = spi->controller_state;
+	list_del(&cs->node);
+
 	kfree(spi->controller_state);
 
 	if (mcspi_dma->dma_rx_channel != -1) {
@@ -1104,6 +1119,7 @@ static int __init omap2_mcspi_probe(stru
 
 	spin_lock_init(&mcspi->lock);
 	INIT_LIST_HEAD(&mcspi->msg_queue);
+	INIT_LIST_HEAD(&omap2_mcspi_ctx[master->bus_num - 1].cs);
 
 	mcspi->ick = clk_get(&pdev->dev, "ick");
 	if (IS_ERR(mcspi->ick)) {
_

Patches currently in -mm which might be from tero.kristo@nokia.com are

spi-mcspi-saves-chconfx-too.patch


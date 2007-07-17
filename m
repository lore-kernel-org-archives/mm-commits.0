From: akpm@linux-foundation.org
Subject: - spi_mpc83xxc-support-qe-enabled-83xx-cpus-like-mpc832x.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:20 -0700
Message-ID: <200707172303.l6HN3KTL011683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936710AbXGQXQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joakim.tjernlund@transmode.se, Joakim.Tjernlund@transmode.se, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx.c: support QE enabled 83xx CPU's like mpc832x
has been removed from the -mm tree.  Its filename was
     spi_mpc83xxc-support-qe-enabled-83xx-cpus-like-mpc832x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx.c: support QE enabled 83xx CPU's like mpc832x
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>

Quicc Engine enabled mpc83xx CPU's has a somewhat different HW interface to
the SPI controller.  This patch adds a qe_mode knob that sees to that
needed adaptions are performed.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c   |   32 +++++++++++++++++++++++++++++---
 include/linux/fsl_devices.h |    2 +-
 2 files changed, 30 insertions(+), 4 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xxc-support-qe-enabled-83xx-cpus-like-mpc832x drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xxc-support-qe-enabled-83xx-cpus-like-mpc832x
+++ a/drivers/spi/spi_mpc83xx.c
@@ -47,6 +47,7 @@ struct mpc83xx_spi_reg {
 #define	SPMODE_ENABLE		(1 << 24)
 #define	SPMODE_LEN(x)		((x) << 20)
 #define	SPMODE_PM(x)		((x) << 16)
+#define	SPMODE_OP		(1 << 14)
 
 /*
  * Default for SPI Mode:
@@ -85,6 +86,11 @@ struct mpc83xx_spi {
 	unsigned nsecs;		/* (clock cycle time)/2 */
 
 	u32 sysclk;
+	u32 rx_shift;		/* RX data reg shift when in qe mode */
+	u32 tx_shift;		/* TX data reg shift when in qe mode */
+
+	bool qe_mode;
+
 	void (*activate_cs) (u8 cs, u8 polarity);
 	void (*deactivate_cs) (u8 cs, u8 polarity);
 };
@@ -103,7 +109,7 @@ static inline u32 mpc83xx_spi_read_reg(_
 void mpc83xx_spi_rx_buf_##type(u32 data, struct mpc83xx_spi *mpc83xx_spi) \
 {									  \
 	type * rx = mpc83xx_spi->rx;					  \
-	*rx++ = (type)data;						  \
+	*rx++ = (type)(data >> mpc83xx_spi->rx_shift);			  \
 	mpc83xx_spi->rx = rx;						  \
 }
 
@@ -114,7 +120,7 @@ u32 mpc83xx_spi_tx_buf_##type(struct mpc
 	const type * tx = mpc83xx_spi->tx;			\
 	if (!tx)						\
 		return 0;					\
-	data = *tx++;						\
+	data = *tx++ << mpc83xx_spi->tx_shift;			\
 	mpc83xx_spi->tx = tx;					\
 	return data;						\
 }
@@ -203,12 +209,22 @@ int mpc83xx_spi_setup_transfer(struct sp
 	    || ((bits_per_word > 16) && (bits_per_word != 32)))
 		return -EINVAL;
 
+	mpc83xx_spi->rx_shift = 0;
+	mpc83xx_spi->tx_shift = 0;
 	if (bits_per_word <= 8) {
 		mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u8;
 		mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u8;
+		if (mpc83xx_spi->qe_mode) {
+			mpc83xx_spi->rx_shift = 16;
+			mpc83xx_spi->tx_shift = 24;
+		}
 	} else if (bits_per_word <= 16) {
 		mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u16;
 		mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u16;
+		if (mpc83xx_spi->qe_mode) {
+			mpc83xx_spi->rx_shift = 16;
+			mpc83xx_spi->tx_shift = 16;
+		}
 	} else if (bits_per_word <= 32) {
 		mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u32;
 		mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u32;
@@ -386,7 +402,6 @@ static int __init mpc83xx_spi_probe(stru
 		ret = -ENODEV;
 		goto free_master;
 	}
-
 	mpc83xx_spi = spi_master_get_devdata(master);
 	mpc83xx_spi->bitbang.master = spi_master_get(master);
 	mpc83xx_spi->bitbang.chipselect = mpc83xx_spi_chipselect;
@@ -395,9 +410,17 @@ static int __init mpc83xx_spi_probe(stru
 	mpc83xx_spi->sysclk = pdata->sysclk;
 	mpc83xx_spi->activate_cs = pdata->activate_cs;
 	mpc83xx_spi->deactivate_cs = pdata->deactivate_cs;
+	mpc83xx_spi->qe_mode = pdata->qe_mode;
 	mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u8;
 	mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u8;
 
+	mpc83xx_spi->rx_shift = 0;
+	mpc83xx_spi->tx_shift = 0;
+	if (mpc83xx_spi->qe_mode) {
+		mpc83xx_spi->rx_shift = 16;
+		mpc83xx_spi->tx_shift = 24;
+	}
+
 	mpc83xx_spi->bitbang.master->setup = mpc83xx_spi_setup;
 	init_completion(&mpc83xx_spi->done);
 
@@ -432,6 +455,9 @@ static int __init mpc83xx_spi_probe(stru
 
 	/* Enable SPI interface */
 	regval = pdata->initial_spmode | SPMODE_INIT_VAL | SPMODE_ENABLE;
+	if (pdata->qe_mode)
+		regval |= SPMODE_OP;
+
 	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, regval);
 
 	ret = spi_bitbang_start(&mpc83xx_spi->bitbang);
diff -puN include/linux/fsl_devices.h~spi_mpc83xxc-support-qe-enabled-83xx-cpus-like-mpc832x include/linux/fsl_devices.h
--- a/include/linux/fsl_devices.h~spi_mpc83xxc-support-qe-enabled-83xx-cpus-like-mpc832x
+++ a/include/linux/fsl_devices.h
@@ -112,7 +112,7 @@ struct fsl_usb2_platform_data {
 struct fsl_spi_platform_data {
 	u32 	initial_spmode;	/* initial SPMODE value */
 	u16	bus_num;
-
+	bool	qe_mode;
 	/* board specific information */
 	u16	max_chipselect;
 	void	(*activate_cs)(u8 cs, u8 polarity);
_

Patches currently in -mm which might be from joakim.tjernlund@transmode.se are

origin.patch

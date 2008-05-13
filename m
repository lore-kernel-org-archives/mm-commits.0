From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-much-improved-driver.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:05 -0700
Message-ID: <200805132134.m4DLY5uQ000888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759884AbYEMVeb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, 12o3l@tiscali.nl, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: much improved driver
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-much-improved-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: much improved driver
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

The current driver may cause glitches on SPI CLK line since one must disable
the SPI controller before changing any HW settings.  Fix this by implementing
a local spi_transfer function that won't change speed and/or word size while
CS is active.

While doing that heavy lifting a few other issues were addressed too:
 - Make word size 16 and 32 work too.
 - Honor bits_per_word and speed_hz in spi transaction.
 - Optimize the common path.

This also stops using the "bitbang" framework (except for a few constants).

[Roel Kluin <12o3l@tiscali.nl>: "irq" needs to be signed]
Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig       |    1 
 drivers/spi/spi_mpc83xx.c |  409 ++++++++++++++++++++++++------------
 2 files changed, 281 insertions(+), 129 deletions(-)

diff -puN drivers/spi/Kconfig~spi_mpc83xx-much-improved-driver drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi_mpc83xx-much-improved-driver
+++ a/drivers/spi/Kconfig
@@ -126,7 +126,6 @@ config SPI_MPC52xx_PSC
 config SPI_MPC83xx
 	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
 	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
-	select SPI_BITBANG
 	help
 	  This enables using the Freescale MPC83xx and QUICC Engine SPI
 	  controllers in master mode.
diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-much-improved-driver drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-much-improved-driver
+++ a/drivers/spi/spi_mpc83xx.c
@@ -49,6 +49,7 @@ struct mpc83xx_spi_reg {
 #define	SPMODE_LEN(x)		((x) << 20)
 #define	SPMODE_PM(x)		((x) << 16)
 #define	SPMODE_OP		(1 << 14)
+#define	SPMODE_CG(x)		((x) << 7)
 
 /*
  * Default for SPI Mode:
@@ -67,10 +68,6 @@ struct mpc83xx_spi_reg {
 
 /* SPI Controller driver's private data. */
 struct mpc83xx_spi {
-	/* bitbang has to be first */
-	struct spi_bitbang bitbang;
-	struct completion done;
-
 	struct mpc83xx_spi_reg __iomem *base;
 
 	/* rx & tx bufs from the spi_transfer */
@@ -82,7 +79,7 @@ struct mpc83xx_spi {
 	u32(*get_tx) (struct mpc83xx_spi *);
 
 	unsigned int count;
-	u32 irq;
+	int irq;
 
 	unsigned nsecs;		/* (clock cycle time)/2 */
 
@@ -94,6 +91,25 @@ struct mpc83xx_spi {
 
 	void (*activate_cs) (u8 cs, u8 polarity);
 	void (*deactivate_cs) (u8 cs, u8 polarity);
+
+	u8 busy;
+
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+
+	struct list_head queue;
+	spinlock_t lock;
+
+	struct completion done;
+};
+
+struct spi_mpc83xx_cs {
+	/* functions to deal with different sized buffers */
+	void (*get_rx) (u32 rx_data, struct mpc83xx_spi *);
+	u32 (*get_tx) (struct mpc83xx_spi *);
+	u32 rx_shift;		/* RX data reg shift when in qe mode */
+	u32 tx_shift;		/* TX data reg shift when in qe mode */
+	u32 hw_mode;		/* Holds HW mode register settings */
 };
 
 static inline void mpc83xx_spi_write_reg(__be32 __iomem * reg, u32 val)
@@ -137,6 +153,7 @@ static void mpc83xx_spi_chipselect(struc
 {
 	struct mpc83xx_spi *mpc83xx_spi;
 	u8 pol = spi->mode & SPI_CS_HIGH ? 1 : 0;
+	struct spi_mpc83xx_cs	*cs = spi->controller_state;
 
 	mpc83xx_spi = spi_master_get_devdata(spi->master);
 
@@ -147,50 +164,26 @@ static void mpc83xx_spi_chipselect(struc
 
 	if (value == BITBANG_CS_ACTIVE) {
 		u32 regval = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
-		u32 len = spi->bits_per_word;
-		u8 pm;
-
-		if (len == 32)
-			len = 0;
-		else
-			len = len - 1;
 
-		/* mask out bits we are going to set */
-		regval &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH
-				| SPMODE_LEN(0xF) | SPMODE_DIV16
-				| SPMODE_PM(0xF) | SPMODE_REV | SPMODE_LOOP);
-
-		if (spi->mode & SPI_CPHA)
-			regval |= SPMODE_CP_BEGIN_EDGECLK;
-		if (spi->mode & SPI_CPOL)
-			regval |= SPMODE_CI_INACTIVEHIGH;
-		if (!(spi->mode & SPI_LSB_FIRST))
-			regval |= SPMODE_REV;
-		if (spi->mode & SPI_LOOP)
-			regval |= SPMODE_LOOP;
-
-		regval |= SPMODE_LEN(len);
-
-		if ((mpc83xx_spi->spibrg / spi->max_speed_hz) >= 64) {
-			pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 64) - 1;
-			if (pm > 0x0f) {
-				dev_err(&spi->dev, "Requested speed is too "
-					"low: %d Hz. Will use %d Hz instead.\n",
-					spi->max_speed_hz,
-					mpc83xx_spi->spibrg / 1024);
-				pm = 0x0f;
-			}
-			regval |= SPMODE_PM(pm) | SPMODE_DIV16;
-		} else {
-			pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 4);
-			if (pm)
-				pm--;
-			regval |= SPMODE_PM(pm);
+		mpc83xx_spi->rx_shift = cs->rx_shift;
+		mpc83xx_spi->tx_shift = cs->tx_shift;
+		mpc83xx_spi->get_rx = cs->get_rx;
+		mpc83xx_spi->get_tx = cs->get_tx;
+
+		if (cs->hw_mode != regval) {
+			unsigned long flags;
+			void *tmp_ptr = &mpc83xx_spi->base->mode;
+
+			regval = cs->hw_mode;
+			/* Turn off IRQs locally to minimize time that
+			 * SPI is disabled
+			 */
+			local_irq_save(flags);
+			/* Turn off SPI unit prior changing mode */
+			mpc83xx_spi_write_reg(tmp_ptr, regval & ~SPMODE_ENABLE);
+			mpc83xx_spi_write_reg(tmp_ptr, regval);
+			local_irq_restore(flags);
 		}
-
-		/* Turn off SPI unit prior changing mode */
-		mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, 0);
-		mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, regval);
 		if (mpc83xx_spi->activate_cs)
 			mpc83xx_spi->activate_cs(spi->chip_select, pol);
 	}
@@ -201,8 +194,9 @@ int mpc83xx_spi_setup_transfer(struct sp
 {
 	struct mpc83xx_spi *mpc83xx_spi;
 	u32 regval;
-	u8 bits_per_word;
+	u8 bits_per_word, pm;
 	u32 hz;
+	struct spi_mpc83xx_cs	*cs = spi->controller_state;
 
 	mpc83xx_spi = spi_master_get_devdata(spi->master);
 
@@ -223,72 +217,203 @@ int mpc83xx_spi_setup_transfer(struct sp
 	    || ((bits_per_word > 16) && (bits_per_word != 32)))
 		return -EINVAL;
 
-	mpc83xx_spi->rx_shift = 0;
-	mpc83xx_spi->tx_shift = 0;
+	if (!hz)
+		hz = spi->max_speed_hz;
+
+	cs->rx_shift = 0;
+	cs->tx_shift = 0;
 	if (bits_per_word <= 8) {
-		mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u8;
-		mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u8;
+		cs->get_rx = mpc83xx_spi_rx_buf_u8;
+		cs->get_tx = mpc83xx_spi_tx_buf_u8;
 		if (mpc83xx_spi->qe_mode) {
-			mpc83xx_spi->rx_shift = 16;
-			mpc83xx_spi->tx_shift = 24;
+			cs->rx_shift = 16;
+			cs->tx_shift = 24;
 		}
 	} else if (bits_per_word <= 16) {
-		mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u16;
-		mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u16;
+		cs->get_rx = mpc83xx_spi_rx_buf_u16;
+		cs->get_tx = mpc83xx_spi_tx_buf_u16;
 		if (mpc83xx_spi->qe_mode) {
-			mpc83xx_spi->rx_shift = 16;
-			mpc83xx_spi->tx_shift = 16;
+			cs->rx_shift = 16;
+			cs->tx_shift = 16;
 		}
 	} else if (bits_per_word <= 32) {
-		mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u32;
-		mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u32;
+		cs->get_rx = mpc83xx_spi_rx_buf_u32;
+		cs->get_tx = mpc83xx_spi_tx_buf_u32;
 	} else
 		return -EINVAL;
 
 	if (mpc83xx_spi->qe_mode && spi->mode & SPI_LSB_FIRST) {
-		mpc83xx_spi->tx_shift = 0;
+		cs->tx_shift = 0;
 		if (bits_per_word <= 8)
-			mpc83xx_spi->rx_shift = 8;
+			cs->rx_shift = 8;
 		else
-			mpc83xx_spi->rx_shift = 0;
+			cs->rx_shift = 0;
 	}
 
-	/* nsecs = (clock period)/2 */
-	if (!hz)
-		hz = spi->max_speed_hz;
-	mpc83xx_spi->nsecs = (1000000000 / 2) / hz;
-	if (mpc83xx_spi->nsecs > MAX_UDELAY_MS * 1000)
-		return -EINVAL;
+	mpc83xx_spi->rx_shift = cs->rx_shift;
+	mpc83xx_spi->tx_shift = cs->tx_shift;
+	mpc83xx_spi->get_rx = cs->get_rx;
+	mpc83xx_spi->get_tx = cs->get_tx;
 
 	if (bits_per_word == 32)
 		bits_per_word = 0;
 	else
 		bits_per_word = bits_per_word - 1;
 
-	regval = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
-
 	/* mask out bits we are going to set */
-	regval &= ~(SPMODE_LEN(0xF) | SPMODE_REV);
-	regval |= SPMODE_LEN(bits_per_word);
-	if (!(spi->mode & SPI_LSB_FIRST))
-		regval |= SPMODE_REV;
+	cs->hw_mode &= ~(SPMODE_LEN(0xF) | SPMODE_DIV16
+				  | SPMODE_PM(0xF));
 
-	/* Turn off SPI unit prior changing mode */
-	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, 0);
-	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, regval);
+	cs->hw_mode |= SPMODE_LEN(bits_per_word);
 
+	if ((mpc83xx_spi->spibrg / hz) >= 64) {
+		pm = mpc83xx_spi->spibrg / (hz * 64) - 1;
+		if (pm > 0x0f) {
+			dev_err(&spi->dev, "Requested speed is too "
+				"low: %d Hz. Will use %d Hz instead.\n",
+				hz, mpc83xx_spi->spibrg / 1024);
+			pm = 0x0f;
+		}
+		cs->hw_mode |= SPMODE_PM(pm) | SPMODE_DIV16;
+	} else {
+		pm = mpc83xx_spi->spibrg / (hz * 4);
+		if (pm)
+			pm--;
+		cs->hw_mode |= SPMODE_PM(pm);
+	}
+	regval =  mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
+	if (cs->hw_mode != regval) {
+		unsigned long flags;
+		void *tmp_ptr = &mpc83xx_spi->base->mode;
+
+		regval = cs->hw_mode;
+		/* Turn off IRQs locally to minimize time
+		 * that SPI is disabled
+		 */
+		local_irq_save(flags);
+		/* Turn off SPI unit prior changing mode */
+		mpc83xx_spi_write_reg(tmp_ptr, regval & ~SPMODE_ENABLE);
+		mpc83xx_spi_write_reg(tmp_ptr, regval);
+		local_irq_restore(flags);
+	}
 	return 0;
 }
 
+static int mpc83xx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct mpc83xx_spi *mpc83xx_spi;
+	u32 word, len, bits_per_word;
+
+	mpc83xx_spi = spi_master_get_devdata(spi->master);
+
+	mpc83xx_spi->tx = t->tx_buf;
+	mpc83xx_spi->rx = t->rx_buf;
+	bits_per_word = spi->bits_per_word;
+	if (t->bits_per_word)
+		bits_per_word = t->bits_per_word;
+	len = t->len;
+	if (bits_per_word > 8)
+		len /= 2;
+	if (bits_per_word > 16)
+		len /= 2;
+	mpc83xx_spi->count = len;
+	INIT_COMPLETION(mpc83xx_spi->done);
+
+	/* enable rx ints */
+	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mask, SPIM_NE);
+
+	/* transmit word */
+	word = mpc83xx_spi->get_tx(mpc83xx_spi);
+	mpc83xx_spi_write_reg(&mpc83xx_spi->base->transmit, word);
+
+	wait_for_completion(&mpc83xx_spi->done);
+
+	/* disable rx ints */
+	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mask, 0);
+
+	return mpc83xx_spi->count;
+}
+
+static void mpc83xx_spi_work(struct work_struct *work)
+{
+	struct mpc83xx_spi *mpc83xx_spi =
+		container_of(work, struct mpc83xx_spi, work);
+
+	spin_lock_irq(&mpc83xx_spi->lock);
+	mpc83xx_spi->busy = 1;
+	while (!list_empty(&mpc83xx_spi->queue)) {
+		struct spi_message *m;
+		struct spi_device *spi;
+		struct spi_transfer *t = NULL;
+		unsigned cs_change;
+		int status, nsecs = 50;
+
+		m = container_of(mpc83xx_spi->queue.next,
+				struct spi_message, queue);
+		list_del_init(&m->queue);
+		spin_unlock_irq(&mpc83xx_spi->lock);
+
+		spi = m->spi;
+		cs_change = 1;
+		status = 0;
+		list_for_each_entry(t, &m->transfers, transfer_list) {
+			if (t->bits_per_word || t->speed_hz) {
+				/* Don't allow changes if CS is active */
+				status = -EINVAL;
+
+				if (cs_change)
+					status = mpc83xx_spi_setup_transfer(spi, t);
+				if (status < 0)
+					break;
+			}
+
+			if (cs_change)
+				mpc83xx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
+			cs_change = t->cs_change;
+			if (t->len)
+				status = mpc83xx_spi_bufs(spi, t);
+			if (status) {
+				status = -EMSGSIZE;
+				break;
+			}
+			m->actual_length += t->len;
+
+			if (t->delay_usecs)
+				udelay(t->delay_usecs);
+
+			if (cs_change) {
+				ndelay(nsecs);
+				mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+				ndelay(nsecs);
+			}
+		}
+
+		m->status = status;
+		m->complete(m->context);
+
+		if (status || !cs_change) {
+			ndelay(nsecs);
+			mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+		}
+
+		mpc83xx_spi_setup_transfer(spi, NULL);
+
+		spin_lock_irq(&mpc83xx_spi->lock);
+	}
+	mpc83xx_spi->busy = 0;
+	spin_unlock_irq(&mpc83xx_spi->lock);
+}
+
 /* the spi->mode bits understood by this driver: */
 #define MODEBITS	(SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
 			| SPI_LSB_FIRST | SPI_LOOP)
 
 static int mpc83xx_spi_setup(struct spi_device *spi)
 {
-	struct spi_bitbang *bitbang;
 	struct mpc83xx_spi *mpc83xx_spi;
 	int retval;
+	u32 hw_mode;
+	struct spi_mpc83xx_cs	*cs = spi->controller_state;
 
 	if (spi->mode & ~MODEBITS) {
 		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
@@ -299,63 +424,56 @@ static int mpc83xx_spi_setup(struct spi_
 	if (!spi->max_speed_hz)
 		return -EINVAL;
 
-	bitbang = spi_master_get_devdata(spi->master);
+	if (!cs) {
+		cs = kzalloc(sizeof *cs, GFP_KERNEL);
+		if (!cs)
+			return -ENOMEM;
+		spi->controller_state = cs;
+	}
 	mpc83xx_spi = spi_master_get_devdata(spi->master);
 
 	if (!spi->bits_per_word)
 		spi->bits_per_word = 8;
 
+	hw_mode = cs->hw_mode; /* Save orginal settings */
+	cs->hw_mode = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
+	/* mask out bits we are going to set */
+	cs->hw_mode &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH
+			 | SPMODE_REV | SPMODE_LOOP);
+
+	if (spi->mode & SPI_CPHA)
+		cs->hw_mode |= SPMODE_CP_BEGIN_EDGECLK;
+	if (spi->mode & SPI_CPOL)
+		cs->hw_mode |= SPMODE_CI_INACTIVEHIGH;
+	if (!(spi->mode & SPI_LSB_FIRST))
+		cs->hw_mode |= SPMODE_REV;
+	if (spi->mode & SPI_LOOP)
+		cs->hw_mode |= SPMODE_LOOP;
+
 	retval = mpc83xx_spi_setup_transfer(spi, NULL);
-	if (retval < 0)
+	if (retval < 0) {
+		cs->hw_mode = hw_mode; /* Restore settings */
 		return retval;
+	}
 
-	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec\n",
+	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u Hz\n",
 		__func__, spi->mode & (SPI_CPOL | SPI_CPHA),
-		spi->bits_per_word, 2 * mpc83xx_spi->nsecs);
-
+		spi->bits_per_word, spi->max_speed_hz);
+#if 0 /* Don't think this is needed */
 	/* NOTE we _need_ to call chipselect() early, ideally with adapter
 	 * setup, unless the hardware defaults cooperate to avoid confusion
 	 * between normal (active low) and inverted chipselects.
 	 */
 
 	/* deselect chip (low or high) */
-	spin_lock(&bitbang->lock);
-	if (!bitbang->busy) {
-		bitbang->chipselect(spi, BITBANG_CS_INACTIVE);
-		ndelay(mpc83xx_spi->nsecs);
-	}
-	spin_unlock(&bitbang->lock);
-
+	spin_lock(&mpc83xx_spi->lock);
+	if (!mpc83xx_spi->busy)
+		mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+	spin_unlock(&mpc83xx_spi->lock);
+#endif
 	return 0;
 }
 
-static int mpc83xx_spi_bufs(struct spi_device *spi, struct spi_transfer *t)
-{
-	struct mpc83xx_spi *mpc83xx_spi;
-	u32 word;
-
-	mpc83xx_spi = spi_master_get_devdata(spi->master);
-
-	mpc83xx_spi->tx = t->tx_buf;
-	mpc83xx_spi->rx = t->rx_buf;
-	mpc83xx_spi->count = t->len;
-	INIT_COMPLETION(mpc83xx_spi->done);
-
-	/* enable rx ints */
-	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mask, SPIM_NE);
-
-	/* transmit word */
-	word = mpc83xx_spi->get_tx(mpc83xx_spi);
-	mpc83xx_spi_write_reg(&mpc83xx_spi->base->transmit, word);
-
-	wait_for_completion(&mpc83xx_spi->done);
-
-	/* disable rx ints */
-	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mask, 0);
-
-	return t->len - mpc83xx_spi->count;
-}
-
 irqreturn_t mpc83xx_spi_irq(s32 irq, void *context_data)
 {
 	struct mpc83xx_spi *mpc83xx_spi = context_data;
@@ -395,6 +513,28 @@ irqreturn_t mpc83xx_spi_irq(s32 irq, voi
 
 	return ret;
 }
+static int mpc83xx_spi_transfer(struct spi_device *spi,
+				struct spi_message *m)
+{
+	struct mpc83xx_spi *mpc83xx_spi = spi_master_get_devdata(spi->master);
+	unsigned long flags;
+
+	m->actual_length = 0;
+	m->status = -EINPROGRESS;
+
+	spin_lock_irqsave(&mpc83xx_spi->lock, flags);
+	list_add_tail(&m->queue, &mpc83xx_spi->queue);
+	queue_work(mpc83xx_spi->workqueue, &mpc83xx_spi->work);
+	spin_unlock_irqrestore(&mpc83xx_spi->lock, flags);
+
+	return 0;
+}
+
+
+static void mpc83xx_spi_cleanup(struct spi_device *spi)
+{
+	kfree(spi->controller_state);
+}
 
 static int __init mpc83xx_spi_probe(struct platform_device *dev)
 {
@@ -426,11 +566,11 @@ static int __init mpc83xx_spi_probe(stru
 		ret = -ENODEV;
 		goto free_master;
 	}
+	master->setup = mpc83xx_spi_setup;
+	master->transfer = mpc83xx_spi_transfer;
+	master->cleanup = mpc83xx_spi_cleanup;
+
 	mpc83xx_spi = spi_master_get_devdata(master);
-	mpc83xx_spi->bitbang.master = spi_master_get(master);
-	mpc83xx_spi->bitbang.chipselect = mpc83xx_spi_chipselect;
-	mpc83xx_spi->bitbang.setup_transfer = mpc83xx_spi_setup_transfer;
-	mpc83xx_spi->bitbang.txrx_bufs = mpc83xx_spi_bufs;
 	mpc83xx_spi->activate_cs = pdata->activate_cs;
 	mpc83xx_spi->deactivate_cs = pdata->deactivate_cs;
 	mpc83xx_spi->qe_mode = pdata->qe_mode;
@@ -445,7 +585,6 @@ static int __init mpc83xx_spi_probe(stru
 		mpc83xx_spi->tx_shift = 24;
 	}
 
-	mpc83xx_spi->bitbang.master->setup = mpc83xx_spi_setup;
 	init_completion(&mpc83xx_spi->done);
 
 	mpc83xx_spi->base = ioremap(r->start, r->end - r->start + 1);
@@ -483,11 +622,21 @@ static int __init mpc83xx_spi_probe(stru
 		regval |= SPMODE_OP;
 
 	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, regval);
+	spin_lock_init(&mpc83xx_spi->lock);
+	init_completion(&mpc83xx_spi->done);
+	INIT_WORK(&mpc83xx_spi->work, mpc83xx_spi_work);
+	INIT_LIST_HEAD(&mpc83xx_spi->queue);
 
-	ret = spi_bitbang_start(&mpc83xx_spi->bitbang);
-
-	if (ret != 0)
+	mpc83xx_spi->workqueue = create_singlethread_workqueue(
+		master->dev.parent->bus_id);
+	if (mpc83xx_spi->workqueue == NULL) {
+		ret = -EBUSY;
 		goto free_irq;
+	}
+
+	ret = spi_register_master(master);
+	if (ret < 0)
+		goto unreg_master;
 
 	printk(KERN_INFO
 	       "%s: MPC83xx SPI Controller driver at 0x%p (irq = %d)\n",
@@ -495,6 +644,8 @@ static int __init mpc83xx_spi_probe(stru
 
 	return ret;
 
+unreg_master:
+	destroy_workqueue(mpc83xx_spi->workqueue);
 free_irq:
 	free_irq(mpc83xx_spi->irq, mpc83xx_spi);
 unmap_io:
@@ -515,10 +666,12 @@ static int __exit mpc83xx_spi_remove(str
 	master = platform_get_drvdata(dev);
 	mpc83xx_spi = spi_master_get_devdata(master);
 
-	spi_bitbang_stop(&mpc83xx_spi->bitbang);
+	flush_workqueue(mpc83xx_spi->workqueue);
+	destroy_workqueue(mpc83xx_spi->workqueue);
+	spi_unregister_master(master);
+
 	free_irq(mpc83xx_spi->irq, mpc83xx_spi);
 	iounmap(mpc83xx_spi->base);
-	spi_master_put(mpc83xx_spi->bitbang.master);
 
 	return 0;
 }
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

origin.patch


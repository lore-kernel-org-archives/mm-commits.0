From: akpm@linux-foundation.org
Subject: + spi-superh-msiof-spi-master-driver-update.patch added to -mm tree
Date: Mon, 30 Nov 2009 14:49:04 -0800
Message-ID: <200911302249.nAUMn4LN030410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbZK3WtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 17:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, david-b@pacbell.net, grant.likely@secretlab.ca, lethal@linux-sh.org


The patch titled
     spi-superh-msiof-spi-master-driver-update
has been added to the -mm tree.  Its filename is
     spi-superh-msiof-spi-master-driver-update.patch

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
Subject: spi-superh-msiof-spi-master-driver-update
From: Magnus Damm <damm@opensource.se>

 Changes since V1:
 - added timeout handling code
 - const, size_t, WARN_ON(), BUG() fixes
 - use spi_bitbang_setup_transfer()
 - cosmetic stuff

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: David Brownell <david-b@pacbell.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c          |    1 
 drivers/spi/spi_sh_msiof.c |   74 +++++++++++++++++++++--------------
 2 files changed, 46 insertions(+), 29 deletions(-)

diff -puN drivers/spi/spi.c~spi-superh-msiof-spi-master-driver-update drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-superh-msiof-spi-master-driver-update
+++ a/drivers/spi/spi.c
@@ -17,6 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/init.h>
diff -puN drivers/spi/spi_sh_msiof.c~spi-superh-msiof-spi-master-driver-update drivers/spi/spi_sh_msiof.c
--- a/drivers/spi/spi_sh_msiof.c~spi-superh-msiof-spi-master-driver-update
+++ a/drivers/spi/spi_sh_msiof.c
@@ -92,19 +92,26 @@ static void sh_msiof_write(struct sh_msi
 	}
 }
 
-static void sh_msiof_modify_ctr_wait(struct sh_msiof_spi_priv *p,
-				     unsigned long clr, unsigned long set)
+static int sh_msiof_modify_ctr_wait(struct sh_msiof_spi_priv *p,
+				    unsigned long clr, unsigned long set)
 {
 	unsigned long mask = clr | set;
 	unsigned long data;
+	int k;
 
 	data = sh_msiof_read(p, CTR);
 	data &= ~clr;
 	data |= set;
 	sh_msiof_write(p, CTR, data);
 
-	while ((sh_msiof_read(p, CTR) & mask) != set)
-		;
+	for (k = 100; k > 0; k--) {
+		if ((sh_msiof_read(p, CTR) & mask) == set)
+			break;
+
+		udelay(10);
+	}
+
+	return k > 0 ? 0 : -ETIMEDOUT;
 }
 
 static irqreturn_t sh_msiof_spi_irq(int irq, void *data)
@@ -113,7 +120,6 @@ static irqreturn_t sh_msiof_spi_irq(int 
 
 	/* just disable the interrupt and wake up */
 	sh_msiof_write(p, IER, 0);
-
 	complete(&p->done);
 
 	return IRQ_HANDLED;
@@ -122,7 +128,7 @@ static irqreturn_t sh_msiof_spi_irq(int 
 static struct {
 	unsigned short div;
 	unsigned short scr;
-} sh_msiof_spi_clk_table[] = {
+} const sh_msiof_spi_clk_table[] = {
 	{ 1, 0x0007 },
 	{ 2, 0x0000 },
 	{ 4, 0x0001 },
@@ -141,11 +147,9 @@ static void sh_msiof_spi_set_clk_regs(st
 				      unsigned long spi_hz)
 {
 	unsigned long div = 1024;
-	int k;
+	size_t k;
 
-	if (!spi_hz || !parent_rate)
-		WARN_ON(1);
-	else
+	if (!WARN_ON(!spi_hz || !parent_rate))
 		div = parent_rate / spi_hz;
 
 	/* TODO: make more fine grained */
@@ -324,7 +328,6 @@ static int sh_msiof_spi_bits(struct spi_
 
 	bits = t ? t->bits_per_word : 0;
 	bits = bits ? bits : spi->bits_per_word;
-
 	return bits;
 }
 
@@ -335,7 +338,6 @@ static unsigned long sh_msiof_spi_hz(str
 
 	hz = t ? t->speed_hz : 0;
 	hz = hz ? hz : spi->max_speed_hz;
-
 	return hz;
 }
 
@@ -344,17 +346,15 @@ static int sh_msiof_spi_setup_transfer(s
 {
 	int bits;
 
-	bits = sh_msiof_spi_bits(spi, t);
+	/* noting to check hz values against since parent clock is disabled */
 
+	bits = sh_msiof_spi_bits(spi, t);
 	if (bits < 8)
 		return -EINVAL;
-
 	if (bits > 32)
 		return -EINVAL;
 
-	/* noting to check hz values against since parent clock is disabled */
-
-	return 0;
+	return spi_bitbang_setup_transfer(spi, t);
 }
 
 static void sh_msiof_spi_chipselect(struct spi_device *spi, int is_on)
@@ -362,7 +362,7 @@ static void sh_msiof_spi_chipselect(stru
 	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
 	int value;
 
-	/* chip select ia active low unless SPI_CS_HIGH is set */
+	/* chip select is active low unless SPI_CS_HIGH is set */
 	if (spi->mode & SPI_CS_HIGH)
 		value = (is_on == BITBANG_CS_ACTIVE) ? 1 : 0;
 	else
@@ -381,7 +381,7 @@ static void sh_msiof_spi_chipselect(stru
 					  !!(spi->mode & SPI_LSB_FIRST));
 	}
 
-	/* use spi->controller data for CS (same as spi_gpio) */
+	/* use spi->controller data for CS (same strategy as spi_gpio) */
 	gpio_set_value((unsigned)spi->controller_data, value);
 
 	if (is_on == BITBANG_CS_INACTIVE) {
@@ -401,6 +401,7 @@ static int sh_msiof_spi_txrx_once(struct
 				  int words, int bits)
 {
 	int fifo_shift;
+	int ret;
 
 	/* limit maximum word transfer to rx/tx fifo size */
 	if (tx_buf)
@@ -419,14 +420,18 @@ static int sh_msiof_spi_txrx_once(struct
 		tx_fifo(p, tx_buf, words, fifo_shift);
 
 	/* setup clock and rx/tx signals */
-	sh_msiof_modify_ctr_wait(p, 0, CTR_TSCKE);
+	ret = sh_msiof_modify_ctr_wait(p, 0, CTR_TSCKE);
 	if (rx_buf)
-		sh_msiof_modify_ctr_wait(p, 0, CTR_RXE);
-	sh_msiof_modify_ctr_wait(p, 0, CTR_TXE);
+		ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_RXE);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TXE);
 
 	/* start by setting frame bit */
 	INIT_COMPLETION(p->done);
-	sh_msiof_modify_ctr_wait(p, 0, CTR_TFSE);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TFSE);
+	if (ret) {
+		dev_err(&p->pdev->dev, "failed to start hardware\n");
+		goto err;
+	}
 
 	/* wait for tx fifo to be emptied / rx fifo to be filled */
 	wait_for_completion(&p->done);
@@ -439,13 +444,21 @@ static int sh_msiof_spi_txrx_once(struct
 	sh_msiof_reset_str(p);
 
 	/* shut down frame, tx/tx and clock signals */
-	sh_msiof_modify_ctr_wait(p, CTR_TFSE, 0);
-	sh_msiof_modify_ctr_wait(p, CTR_TXE, 0);
+	ret = sh_msiof_modify_ctr_wait(p, CTR_TFSE, 0);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_TXE, 0);
 	if (rx_buf)
-		sh_msiof_modify_ctr_wait(p, CTR_RXE, 0);
-	sh_msiof_modify_ctr_wait(p, CTR_TSCKE, 0);
+		ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_RXE, 0);
+	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, CTR_TSCKE, 0);
+	if (ret) {
+		dev_err(&p->pdev->dev, "failed to shut down hardware\n");
+		goto err;
+	}
 
 	return words;
+
+ err:
+	sh_msiof_write(p, IER, 0);
+	return ret;
 }
 
 static int sh_msiof_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
@@ -503,6 +516,9 @@ static int sh_msiof_spi_txrx(struct spi_
 					   t->tx_buf + bytes_done,
 					   t->rx_buf + bytes_done,
 					   words, bits);
+		if (n < 0)
+			break;
+
 		bytes_done += n * bytes_per_word;
 		words -= n;
 	}
@@ -513,7 +529,7 @@ static int sh_msiof_spi_txrx(struct spi_
 static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
 				  u32 word, u8 bits)
 {
-	BUG_ON(1); /* unused but needed by bitbang code */
+	BUG(); /* unused but needed by bitbang code */
 	return 0;
 }
 
@@ -651,7 +667,7 @@ static struct platform_driver sh_msiof_s
 	.probe		= sh_msiof_spi_probe,
 	.remove		= sh_msiof_spi_remove,
 	.driver		= {
-		.name	= "spi_sh_msiof",
+		.name		= "spi_sh_msiof",
 		.owner		= THIS_MODULE,
 		.pm		= &sh_msiof_spi_dev_pm_ops,
 	},
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch


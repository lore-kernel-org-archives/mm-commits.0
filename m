From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-fix-sparse-warnings.patch added to -mm tree
Date: Tue, 27 Jan 2009 17:10:23 -0800
Message-ID: <200901280110.n0S1ANu0027721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbZA1BKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 20:10:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca


The patch titled
     spi_mpc83xx: fix sparse warnings
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-fix-sparse-warnings.patch

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
Subject: spi_mpc83xx: fix sparse warnings
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The patch fixes following sparse warnings:

  CHECK   spi_mpc83xx.c
spi_mpc83xx.c:145:1: warning: symbol 'mpc83xx_spi_rx_buf_u8' was not declared. Should it be static?
spi_mpc83xx.c:146:1: warning: symbol 'mpc83xx_spi_rx_buf_u16' was not declared. Should it be static?
spi_mpc83xx.c:147:1: warning: symbol 'mpc83xx_spi_rx_buf_u32' was not declared. Should it be static?
spi_mpc83xx.c:148:1: warning: symbol 'mpc83xx_spi_tx_buf_u8' was not declared. Should it be static?
spi_mpc83xx.c:149:1: warning: symbol 'mpc83xx_spi_tx_buf_u16' was not declared. Should it be static?
spi_mpc83xx.c:150:1: warning: symbol 'mpc83xx_spi_tx_buf_u32' was not declared. Should it be static?
spi_mpc83xx.c:175:32: warning: incorrect type in initializer (different address spaces)
spi_mpc83xx.c:175:32:    expected void *tmp_ptr
spi_mpc83xx.c:175:32:    got unsigned int [noderef] <asn:2>*<noident>
spi_mpc83xx.c:183:26: warning: incorrect type in argument 1 (different address spaces)
spi_mpc83xx.c:183:26:    expected unsigned int [noderef] [usertype] <asn:2>*reg
spi_mpc83xx.c:183:26:    got void *tmp_ptr
spi_mpc83xx.c:184:26: warning: incorrect type in argument 1 (different address spaces)
spi_mpc83xx.c:184:26:    expected unsigned int [noderef] [usertype] <asn:2>*reg
spi_mpc83xx.c:184:26:    got void *tmp_ptr
spi_mpc83xx.c:287:31: warning: incorrect type in initializer (different address spaces)
spi_mpc83xx.c:287:31:    expected void *tmp_ptr
spi_mpc83xx.c:287:31:    got unsigned int [noderef] <asn:2>*<noident>
spi_mpc83xx.c:295:25: warning: incorrect type in argument 1 (different address spaces)
spi_mpc83xx.c:295:25:    expected unsigned int [noderef] [usertype] <asn:2>*reg
spi_mpc83xx.c:295:25:    got void *tmp_ptr
spi_mpc83xx.c:296:25: warning: incorrect type in argument 1 (different address spaces)
spi_mpc83xx.c:296:25:    expected unsigned int [noderef] [usertype] <asn:2>*reg
spi_mpc83xx.c:296:25:    got void *tmp_ptr
spi_mpc83xx.c:486:13: warning: symbol 'mpc83xx_spi_irq' was not declared. Should it be static?

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-sparse-warnings drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-sparse-warnings
+++ a/drivers/spi/spi_mpc83xx.c
@@ -123,6 +123,7 @@ static inline u32 mpc83xx_spi_read_reg(_
 }
 
 #define MPC83XX_SPI_RX_BUF(type) 					  \
+static									  \
 void mpc83xx_spi_rx_buf_##type(u32 data, struct mpc83xx_spi *mpc83xx_spi) \
 {									  \
 	type * rx = mpc83xx_spi->rx;					  \
@@ -131,6 +132,7 @@ void mpc83xx_spi_rx_buf_##type(u32 data,
 }
 
 #define MPC83XX_SPI_TX_BUF(type)				\
+static								\
 u32 mpc83xx_spi_tx_buf_##type(struct mpc83xx_spi *mpc83xx_spi)	\
 {								\
 	u32 data;						\
@@ -172,7 +174,7 @@ static void mpc83xx_spi_chipselect(struc
 
 		if (cs->hw_mode != regval) {
 			unsigned long flags;
-			void *tmp_ptr = &mpc83xx_spi->base->mode;
+			__be32 __iomem *mode = &mpc83xx_spi->base->mode;
 
 			regval = cs->hw_mode;
 			/* Turn off IRQs locally to minimize time that
@@ -180,8 +182,8 @@ static void mpc83xx_spi_chipselect(struc
 			 */
 			local_irq_save(flags);
 			/* Turn off SPI unit prior changing mode */
-			mpc83xx_spi_write_reg(tmp_ptr, regval & ~SPMODE_ENABLE);
-			mpc83xx_spi_write_reg(tmp_ptr, regval);
+			mpc83xx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
+			mpc83xx_spi_write_reg(mode, regval);
 			local_irq_restore(flags);
 		}
 		if (mpc83xx_spi->activate_cs)
@@ -284,7 +286,7 @@ int mpc83xx_spi_setup_transfer(struct sp
 	regval =  mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
 	if (cs->hw_mode != regval) {
 		unsigned long flags;
-		void *tmp_ptr = &mpc83xx_spi->base->mode;
+		__be32 __iomem *mode = &mpc83xx_spi->base->mode;
 
 		regval = cs->hw_mode;
 		/* Turn off IRQs locally to minimize time
@@ -292,8 +294,8 @@ int mpc83xx_spi_setup_transfer(struct sp
 		 */
 		local_irq_save(flags);
 		/* Turn off SPI unit prior changing mode */
-		mpc83xx_spi_write_reg(tmp_ptr, regval & ~SPMODE_ENABLE);
-		mpc83xx_spi_write_reg(tmp_ptr, regval);
+		mpc83xx_spi_write_reg(mode, regval & ~SPMODE_ENABLE);
+		mpc83xx_spi_write_reg(mode, regval);
 		local_irq_restore(flags);
 	}
 	return 0;
@@ -483,7 +485,7 @@ static int mpc83xx_spi_setup(struct spi_
 	return 0;
 }
 
-irqreturn_t mpc83xx_spi_irq(s32 irq, void *context_data)
+static irqreturn_t mpc83xx_spi_irq(s32 irq, void *context_data)
 {
 	struct mpc83xx_spi *mpc83xx_spi = context_data;
 	u32 event;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch


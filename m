From: akpm@linux-foundation.org
Subject: [merged] spi_mpc83xx-fix-checkpatch-issues.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:13 -0700
Message-ID: <200906221700.n5MH0D9a009417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbZFVRCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: fix checkpatch issues
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-fix-checkpatch-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: fix checkpatch issues
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Checkpatch is spitting errors when seeing the rename patch, so fix the
errors prior to moving.

Following errors and warnings were fixed:

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#1027: FILE: drivers/spi/spi_mpc8xxx.c:37:
+#include <asm/io.h>

ERROR: "foo * bar" should be "foo *bar"
#1111: FILE: drivers/spi/spi_mpc8xxx.c:121:
+static inline void mpc83xx_spi_write_reg(__be32 __iomem * reg, u32 val)

ERROR: "foo * bar" should be "foo *bar"
#1116: FILE: drivers/spi/spi_mpc8xxx.c:126:
+static inline u32 mpc83xx_spi_read_reg(__be32 __iomem * reg)

ERROR: "foo * bar" should be "foo *bar"
#1125: FILE: drivers/spi/spi_mpc8xxx.c:135:
+       type * rx = mpc83xx_spi->rx;                                      \

ERROR: "foo * bar" should be "foo *bar"
#1135: FILE: drivers/spi/spi_mpc8xxx.c:145:
+       const type * tx = mpc83xx_spi->tx;                      \

WARNING: suspect code indent for conditional statements (16, 25)
#1504: FILE: drivers/spi/spi_mpc8xxx.c:514:
+               while (((event =
[...]
+                        cpu_relax();

Following warnings were left over, since fixing them will hurt the
readability.  We'd better fix them by lowering the indentation level by
splitting mpc83xx_spi_work function into two parts.

WARNING: line over 80 characters
#1371: FILE: drivers/spi/spi_mpc8xxx.c:381:
+                                       status = mpc83xx_spi_setup_transfer(spi, t);

WARNING: line over 80 characters
#1392: FILE: drivers/spi/spi_mpc8xxx.c:402:
+                               mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-checkpatch-issues drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-checkpatch-issues
+++ a/drivers/spi/spi_mpc83xx.c
@@ -17,6 +17,7 @@
 #include <linux/bug.h>
 #include <linux/errno.h>
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -34,7 +35,6 @@
 
 #include <sysdev/fsl_soc.h>
 #include <asm/irq.h>
-#include <asm/io.h>
 
 /* SPI Controller registers */
 struct mpc83xx_spi_reg {
@@ -118,12 +118,12 @@ struct spi_mpc83xx_cs {
 	u32 hw_mode;		/* Holds HW mode register settings */
 };
 
-static inline void mpc83xx_spi_write_reg(__be32 __iomem * reg, u32 val)
+static inline void mpc83xx_spi_write_reg(__be32 __iomem *reg, u32 val)
 {
 	out_be32(reg, val);
 }
 
-static inline u32 mpc83xx_spi_read_reg(__be32 __iomem * reg)
+static inline u32 mpc83xx_spi_read_reg(__be32 __iomem *reg)
 {
 	return in_be32(reg);
 }
@@ -132,7 +132,7 @@ static inline u32 mpc83xx_spi_read_reg(_
 static									  \
 void mpc83xx_spi_rx_buf_##type(u32 data, struct mpc83xx_spi *mpc83xx_spi) \
 {									  \
-	type * rx = mpc83xx_spi->rx;					  \
+	type *rx = mpc83xx_spi->rx;					  \
 	*rx++ = (type)(data >> mpc83xx_spi->rx_shift);			  \
 	mpc83xx_spi->rx = rx;						  \
 }
@@ -142,7 +142,7 @@ static								\
 u32 mpc83xx_spi_tx_buf_##type(struct mpc83xx_spi *mpc83xx_spi)	\
 {								\
 	u32 data;						\
-	const type * tx = mpc83xx_spi->tx;			\
+	const type *tx = mpc83xx_spi->tx;			\
 	if (!tx)						\
 		return 0;					\
 	data = *tx++ << mpc83xx_spi->tx_shift;			\
@@ -500,7 +500,7 @@ static irqreturn_t mpc83xx_spi_irq(s32 i
 		while (((event =
 			 mpc83xx_spi_read_reg(&mpc83xx_spi->base->event)) &
 						SPIE_NF) == 0)
-			 cpu_relax();
+			cpu_relax();
 
 	mpc83xx_spi->count -= 1;
 	if (mpc83xx_spi->count) {
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
usb-mutually-exclusive-port_status.patch


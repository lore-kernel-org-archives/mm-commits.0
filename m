From: akpm@linux-foundation.org
Subject: [merged] spi-add-dma_alignment-field-to-spi_master.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:09 -0700
Message-ID: <200904071907.n37J79nt011190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760228AbZDGT6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:58:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, bryan.wu@analog.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     SPI: add dma_alignment field to spi_master
has been removed from the -mm tree.  Its filename was
     spi-add-dma_alignment-field-to-spi_master.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SPI: add dma_alignment field to spi_master
From: Mike Rapoport <mike@compulab.co.il>

Some SPI controllers have restrictions on DMAable buffers alignemt. 
Currently if the buffer supplied by protocol driver is not properly
aligned, the controller silently performs transfer in PIO mode.  Addition
of dma_alignment field to spi_master allows protocol drivers to perform
proper alignment.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/spi/spi.h~spi-add-dma_alignment-field-to-spi_master include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-add-dma_alignment-field-to-spi_master
+++ a/include/linux/spi/spi.h
@@ -204,6 +204,7 @@ static inline void spi_unregister_driver
  *	SPI slaves, and are numbered from zero to num_chipselects.
  *	each slave has a chipselect signal, but it's common that not
  *	every chipselect is connected to a slave.
+ * @dma_alignment: SPI controller constraint on DMA buffers alignment.
  * @setup: updates the device mode and clocking records used by a
  *	device's SPI controller; protocol code may call this.  This
  *	must fail if an unrecognized or unsupported mode is requested.
@@ -239,6 +240,11 @@ struct spi_master {
 	 */
 	u16			num_chipselect;
 
+	/* some SPI controllers pose alignment requirements on DMAable
+	 * buffers; let protocol drivers know about these requirements.
+	 */
+	u16			dma_alignment;
+
 	/* setup mode and clock, etc (spi driver may call many times) */
 	int			(*setup)(struct spi_device *spi);
 
_

Patches currently in -mm which might be from mike@compulab.co.il are

origin.patch
linux-next.patch


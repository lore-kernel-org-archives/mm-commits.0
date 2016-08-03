From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-fix-return-value-description-for-dma_prep-functions.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:14:19 -0700
Message-ID: <57a2347b.rAIrKCu5yrYxhlJO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbcHCSOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix return value description for dma_prep functions
has been removed from the -mm tree.  Its filename was
     rapidio-fix-return-value-description-for-dma_prep-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: fix return value description for dma_prep functions

Update return value description for rio_dma_prep_...  functions to include
error-valued pointer that can be returned by HW mport device drivers. 
Return values from these functions must be checked using IS_ERR_OR_NULL
macro.

This patch is applicable to kernel versions starting from v4.6-rc1.

Link: http://lkml.kernel.org/r/1469125134-16523-4-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-fix-return-value-description-for-dma_prep-functions drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-fix-return-value-description-for-dma_prep-functions
+++ a/drivers/rapidio/rio.c
@@ -1848,7 +1848,9 @@ EXPORT_SYMBOL_GPL(rio_release_dma);
  * Initializes RapidIO capable DMA channel for the specified data transfer.
  * Uses DMA channel private extension to pass information related to remote
  * target RIO device.
- * Returns pointer to DMA transaction descriptor or NULL if failed.
+ *
+ * Returns: pointer to DMA transaction descriptor if successful,
+ *          error-valued pointer or NULL if failed.
  */
 struct dma_async_tx_descriptor *rio_dma_prep_xfer(struct dma_chan *dchan,
 	u16 destid, struct rio_dma_data *data,
@@ -1883,7 +1885,9 @@ EXPORT_SYMBOL_GPL(rio_dma_prep_xfer);
  * Initializes RapidIO capable DMA channel for the specified data transfer.
  * Uses DMA channel private extension to pass information related to remote
  * target RIO device.
- * Returns pointer to DMA transaction descriptor or NULL if failed.
+ *
+ * Returns: pointer to DMA transaction descriptor if successful,
+ *          error-valued pointer or NULL if failed.
  */
 struct dma_async_tx_descriptor *rio_dma_prep_slave_sg(struct rio_dev *rdev,
 	struct dma_chan *dchan, struct rio_dma_data *data,
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are



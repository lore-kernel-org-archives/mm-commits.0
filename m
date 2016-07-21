From: akpm@linux-foundation.org
Subject: +
 rapidio-fix-return-value-description-for-dma_prep-functions.patch added to
 -mm tree
Date: Thu, 21 Jul 2016 11:40:20 -0700
Message-ID: <57911714.07F8PmCYDUioD2EN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcGUSkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix return value description for dma_prep functions
has been added to the -mm tree.  Its filename is
     rapidio-fix-return-value-description-for-dma_prep-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-fix-return-value-description-for-dma_prep-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-fix-return-value-description-for-dma_prep-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch


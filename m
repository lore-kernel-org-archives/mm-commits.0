From: akpm@linux-foundation.org
Subject: - i-oat-add-completion-callback-for-async_tx-interface-use.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:37 -0700
Message-ID: <200710190346.l9J3kb9Q013347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966064AbXJSDzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     I/OAT: Add completion callback for async_tx interface use
has been removed from the -mm tree.  Its filename was
     i-oat-add-completion-callback-for-async_tx-interface-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I/OAT: Add completion callback for async_tx interface use
From: Shannon Nelson <shannon.nelson@intel.com>

The async_tx interface includes a completion callback.  This adds support
for using that callback, including using interrupts on completion.

[akpm@linux-foundation.org: various fixes]
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-add-completion-callback-for-async_tx-interface-use
+++ a/drivers/dma/ioat_dma.c
@@ -212,6 +212,18 @@ static dma_cookie_t ioat_tx_submit(struc
 	} while (len && (new = ioat_dma_get_next_descriptor(ioat_chan)));
 
 	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
+	if (new->async_tx.callback) {
+		hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
+		if (first != new) {
+			/* move callback into to last desc */
+			new->async_tx.callback = first->async_tx.callback;
+			new->async_tx.callback_param
+					= first->async_tx.callback_param;
+			first->async_tx.callback = NULL;
+			first->async_tx.callback_param = NULL;
+		}
+	}
+
 	new->tx_cnt = desc_count;
 	new->async_tx.ack = orig_ack; /* client is in control of this ack */
 
@@ -517,6 +529,11 @@ static void ioat_dma_memcpy_cleanup(stru
 					pci_unmap_addr(desc, src),
 					pci_unmap_len(desc, len),
 					PCI_DMA_TODEVICE);
+			if (desc->async_tx.callback) {
+				desc->async_tx.callback(
+						desc->async_tx.callback_param);
+				desc->async_tx.callback = NULL;
+			}
 		}
 
 		if (desc->async_tx.phys != phys_complete) {
@@ -638,6 +655,12 @@ static void ioat_dma_start_null_desc(str
  */
 #define IOAT_TEST_SIZE 2000
 
+static void ioat_dma_test_callback(void *dma_async_param)
+{
+	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(%p)\n",
+			dma_async_param);
+}
+
 /**
  * ioat_dma_self_test - Perform a IOAT transaction to verify the HW works.
  * @device: device to be tested
@@ -692,6 +715,8 @@ static int ioat_dma_self_test(struct ioa
 	addr = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
 			DMA_FROM_DEVICE);
 	ioat_set_dest(addr, tx, 0);
+	tx->callback = ioat_dma_test_callback;
+	tx->callback_param = (void *)0x8086;
 	cookie = ioat_tx_submit(tx);
 	if (cookie < 0) {
 		dev_err(&device->pdev->dev,
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch

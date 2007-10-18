From: akpm@linux-foundation.org
Subject: + i-oat-add-completion-callback-for-async_tx-interface-use.patch added to -mm tree
Date: Wed, 17 Oct 2007 17:44:46 -0700
Message-ID: <200710180044.l9I0ikoF016499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759935AbXJRAos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 20:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com


The patch titled
     I/OAT: Add completion callback for async_tx interface use
has been added to the -mm tree.  Its filename is
     i-oat-add-completion-callback-for-async_tx-interface-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I/OAT: Add completion callback for async_tx interface use
From: Shannon Nelson <shannon.nelson@intel.com>

The async_tx interface includes a completion callback.  This adds support
for using that callback, including using interrupts on completion.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

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
 
@@ -516,6 +528,11 @@ static void ioat_dma_memcpy_cleanup(stru
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
@@ -637,6 +654,13 @@ static void ioat_dma_start_null_desc(str
  */
 #define IOAT_TEST_SIZE 2000
 
+static dma_async_tx_callback ioat_dma_test_callback(void *dma_async_param)
+{
+	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%04llx)\n",
+		(u64)dma_async_param);
+	return 0;
+}
+
 /**
  * ioat_dma_self_test - Perform a IOAT transaction to verify the HW works.
  * @device: device to be tested
@@ -691,6 +715,8 @@ static int ioat_dma_self_test(struct ioa
 	addr = dma_map_single(dma_chan->device->dev, dest, IOAT_TEST_SIZE,
 			DMA_FROM_DEVICE);
 	ioat_set_dest(addr, tx, 0);
+	tx->callback = (void *)ioat_dma_test_callback;
+	tx->callback_param = (void *)0x8086;
 	cookie = ioat_tx_submit(tx);
 	if (cookie < 0) {
 		dev_err(&device->pdev->dev,
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
remove-unsafe-from-module-struct.patch
i-oat-cleanup-pci-issues.patch
i-oat-clean-up-of-dca-provider-start-and-stop.patch
i-oat-clean-up-error-handling-and-some-print-messages.patch
i-oat-tighten-descriptor-setup-performance.patch
i-oat-add-completion-callback-for-async_tx-interface-use.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch

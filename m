From: akpm@linux-foundation.org
Subject: + hpsa-flush-cache-with-interrupts-still-enabled.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:50 -0800
Message-ID: <200911122253.nACMroel006743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791AbZKLWyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:54:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: Flush cache with interrupts still enabled.
has been added to the -mm tree.  Its filename is
     hpsa-flush-cache-with-interrupts-still-enabled.patch

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
Subject: hpsa: Flush cache with interrupts still enabled.
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Flush cache with interrupts still enabled.  It's not
necessary to disable interrupts prior to flushing the cache
on driver unload.  Also, don't dma from the stack.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-flush-cache-with-interrupts-still-enabled drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-flush-cache-with-interrupts-still-enabled
+++ a/drivers/scsi/hpsa.c
@@ -3581,24 +3581,45 @@ clean1:
 	return -1;
 }
 
+static void hpsa_flush_cache(struct ctlr_info *h)
+{
+	char *flush_buf;
+	struct CommandList *c;
+	int rc;
+
+	flush_buf = kzalloc(4, GFP_KERNEL);
+	if (!flush_buf)
+		return;
+
+	c = cmd_special_alloc(h);
+	if (!c) {
+		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		goto out_of_memory;
+	}
+	rc = fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
+		RAID_CTLR_LUNID, TYPE_CMD);
+	if (rc == 0) {
+		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_TODEVICE);
+		if (c->err_info->CommandStatus != 0)
+			dev_warn(&h->pdev->dev,
+				"error flushing cache on controller\n");
+	}
+	cmd_special_free(h, c);
+out_of_memory:
+	kfree(flush_buf);
+}
+
 static void hpsa_shutdown(struct pci_dev *pdev)
 {
 	struct ctlr_info *h;
-	char flush_buf[4];
-	int return_code;
 
 	h = pci_get_drvdata(pdev);
 	/* Turn board interrupts off  and send the flush cache command
 	 * sendcmd will turn off interrupt, and send the flush...
 	 * To write all data in the battery backed cache to disks
 	 */
-	memset(flush_buf, 0, 4);
-	return_code = sendcmd(HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
-				RAID_CTLR_LUNID, TYPE_CMD);
-	if (return_code != IO_OK) {
-		dev_warn(&pdev->dev, "error flushing cache on controller %d\n",
-		       h->ctlr);
-	}
+	hpsa_flush_cache(h);
+	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 	free_irq(h->intr[2], h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector)
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch


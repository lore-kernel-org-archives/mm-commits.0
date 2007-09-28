From: akpm@linux-foundation.org
Subject: + libata-drain-fifo-on-stuck-drq-hsm-violation-try2.patch added to -mm tree
Date: Fri, 28 Sep 2007 15:28:57 -0700
Message-ID: <200709282228.l8SMSvCH020449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755555AbXI1W3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 18:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liml@rtr.ca, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, mlord@pobox.com


The patch titled
     libata: drain fifo on stuck DRQ HSM violation
has been added to the -mm tree.  Its filename is
     libata-drain-fifo-on-stuck-drq-hsm-violation-try2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: drain fifo on stuck DRQ HSM violation
From: Mark Lord <liml@rtr.ca>

Drain up to 512 words from host/bridge FIFO on stuck DRQ HSM violation,
rather than just getting stuck there forever.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ata/libata-sff.c~libata-drain-fifo-on-stuck-drq-hsm-violation-try2 drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-drain-fifo-on-stuck-drq-hsm-violation-try2
+++ a/drivers/ata/libata-sff.c
@@ -378,6 +378,28 @@ void ata_bmdma_thaw(struct ata_port *ap)
 	ap->ops->irq_on(ap);
 }
 
+static void ata_drain_fifo(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	u8 stat = ata_chk_status(ap);
+	/*
+	 * Try to clear stuck DRQ if necessary,
+	 * by reading/discarding up to two sectors worth of data.
+	 */
+	if ((stat & ATA_DRQ) && (!qc || qc->dma_dir != DMA_TO_DEVICE)) {
+		unsigned int i;
+		unsigned int limit = qc ? qc->sect_size : ATA_SECT_SIZE;
+
+		printk(KERN_WARNING "Draining up to %u words from data FIFO.\n",
+									limit);
+		for (i = 0; i < limit ; ++i) {
+			ioread16(ap->ioaddr.data_addr);
+			if (!(ata_chk_status(ap) & ATA_DRQ))
+				break;
+		}
+		printk(KERN_WARNING "Drained %u/%u words.\n", i, limit);
+	}
+}
+
 /**
  *	ata_bmdma_drive_eh - Perform EH with given methods for BMDMA controller
  *	@ap: port to handle error for
@@ -434,7 +456,7 @@ void ata_bmdma_drive_eh(struct ata_port 
 	}
 
 	ata_altstatus(ap);
-	ata_chk_status(ap);
+	ata_drain_fifo(ap, qc);
 	ap->ops->irq_clear(ap);
 
 	spin_unlock_irqrestore(ap->lock, flags);
_

Patches currently in -mm which might be from liml@rtr.ca are

git-libata-all.patch
libata-drain-fifo-on-stuck-drq-hsm-violation-try2.patch

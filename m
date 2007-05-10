From: akpm@linux-foundation.org
Subject: + libata-add-human-readable-error-value-decoding.patch added to -mm tree
Date: Wed, 09 May 2007 22:01:37 -0700
Message-ID: <200705100501.l4A51bPb012552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757787AbXEJFBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca


The patch titled
     libata: add human-readable error value decoding
has been added to the -mm tree.  Its filename is
     libata-add-human-readable-error-value-decoding.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: add human-readable error value decoding
From: Robert Hancock <hancockr@shaw.ca>

This adds human-readable decoding of the ATA status and error registers
(similar to what drivers/ide does) as well as the SATA Serror register to
libata error handling output.  This prevents the need to pore through
standards documents to figure out the meaning of the bits in these
registers when looking at error reports.  Some bits that drivers/ide
decoded are not decoded here, since the bits are either command-dependent
or obsolete, and properly parsing them would add too much complexity.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-eh.c |   44 ++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h     |    9 +++++++
 2 files changed, 53 insertions(+)

diff -puN drivers/ata/libata-eh.c~libata-add-human-readable-error-value-decoding drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c~libata-add-human-readable-error-value-decoding
+++ a/drivers/ata/libata-eh.c
@@ -1550,6 +1550,27 @@ static void ata_eh_report(struct ata_por
 			ata_port_printk(ap, KERN_ERR, "(%s)\n", desc);
 	}
 
+	if (ehc->i.serror)
+		ata_port_printk(ap, KERN_ERR,
+		  "SError: {%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
+		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovDataErr " : "",
+		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovCommErr " : "",
+		  ehc->i.serror & SERR_DATA ? "UnrecovDataErr " : "",
+		  ehc->i.serror & SERR_PERSISTENT ? "PersistErr " : "",
+		  ehc->i.serror & SERR_PROTOCOL ? "ProtocolErr " : "",
+		  ehc->i.serror & SERR_INTERNAL ? "HostInternalErr " : "",
+		  ehc->i.serror & SERR_PHYRDY_CHG ? "PHYRdyChg " : "",
+		  ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInternalErr " : "",
+		  ehc->i.serror & SERR_COMM_WAKE ? "CommWake " : "",
+		  ehc->i.serror & SERR_10B_8B_ERR ? "10B8BErr " : "",
+		  ehc->i.serror & SERR_DISPARITY ? "Disparity " : "",
+		  ehc->i.serror & SERR_CRC ? "CRCErr " : "",
+		  ehc->i.serror & SERR_HANDSHAKE ? "HandshakeErr " : "",
+		  ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeqErr " : "",
+		  ehc->i.serror & SERR_TRANS_ST_ERROR ? "TransStatTransErr " : "",
+		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecogFIS " : "",
+		  ehc->i.serror & SERR_DEV_XCHG ? "DevExchanged " : "" );
+
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		static const char *dma_str[] = {
 			[DMA_BIDIRECTIONAL]	= "bidi",
@@ -1579,6 +1600,29 @@ static void ata_eh_report(struct ata_por
 			res->hob_feature, res->hob_nsect,
 			res->hob_lbal, res->hob_lbam, res->hob_lbah,
 			res->device, qc->err_mask, ata_err_string(qc->err_mask));
+
+		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
+		                    ATA_ERR) ) {
+			if (res->command & ATA_BUSY)
+				ata_dev_printk(qc->dev, KERN_ERR,
+				  "status: {Busy}\n" );
+			else
+				ata_dev_printk(qc->dev, KERN_ERR,
+				  "status: {%s%s%s%s}\n",
+				  res->command & ATA_DRDY ? "DRDY " : "",
+				  res->command & ATA_DF ? "DF " : "",
+				  res->command & ATA_DRQ ? "DRQ " : "",
+				  res->command & ATA_ERR ? "ERR " : "" );
+		}
+
+		if (cmd->command != ATA_CMD_PACKET &&
+		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_IDNF | ATA_ABORTED)))
+			ata_dev_printk(qc->dev, KERN_ERR,
+			  "error: {%s%s%s%s}\n",
+			  res->feature & ATA_ICRC ? "ICRC " : "",
+			  res->feature & ATA_UNC ? "UNC " : "",
+			  res->feature & ATA_IDNF ? "IDNF " : "",
+			  res->feature & ATA_ABORTED ? "ABRT " : "" );
 	}
 }
 
diff -puN include/linux/ata.h~libata-add-human-readable-error-value-decoding include/linux/ata.h
--- a/include/linux/ata.h~libata-add-human-readable-error-value-decoding
+++ a/include/linux/ata.h
@@ -233,6 +233,15 @@ enum {
 	SERR_PROTOCOL		= (1 << 10), /* protocol violation */
 	SERR_INTERNAL		= (1 << 11), /* host internal error */
 	SERR_PHYRDY_CHG		= (1 << 16), /* PHY RDY changed */
+	SERR_PHY_INT_ERR	= (1 << 17), /* PHY internal error */
+	SERR_COMM_WAKE		= (1 << 18), /* Comm wake */
+	SERR_10B_8B_ERR		= (1 << 19), /* 10b to 8b decode error */
+	SERR_DISPARITY		= (1 << 20), /* Disparity */
+	SERR_CRC		= (1 << 21), /* CRC error */
+	SERR_HANDSHAKE		= (1 << 22), /* Handshake error */
+	SERR_LINK_SEQ_ERR	= (1 << 23), /* Link sequence error */
+	SERR_TRANS_ST_ERROR	= (1 << 24), /* Transport state transition error */
+	SERR_UNRECOG_FIS	= (1 << 25), /* Unrecognized FIS */
 	SERR_DEV_XCHG		= (1 << 26), /* device exchanged */
 
 	/* struct ata_taskfile flags */
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
sata_nv-fix-adma-freeze-thaw-irq_clear-issues.patch
libata-add-human-readable-error-value-decoding.patch

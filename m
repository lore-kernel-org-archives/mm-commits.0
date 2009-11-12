From: akpm@linux-foundation.org
Subject: + hpsa-factor-out-some-pci_unmap-code.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:38 -0800
Message-ID: <200911122253.nACMrcDV006254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736AbZKLWyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: Factor out some pci_unmap code
has been added to the -mm tree.  Its filename is
     hpsa-factor-out-some-pci_unmap-code.patch

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
Subject: hpsa: Factor out some pci_unmap code
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Factor out some pci_unmap code.  There are a few places
where the same, or nearly the same code is used to pci_unmap
data buffers of driver initiated commands.  Factor these out
into a separate function.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   45 +++++++++++++-----------------------------
 1 file changed, 14 insertions(+), 31 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-factor-out-some-pci_unmap-code drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-factor-out-some-pci_unmap-code
+++ a/drivers/scsi/hpsa.c
@@ -928,17 +928,18 @@ static int hpsa_scsi_detect(struct ctlr_
 	return -1;
 }
 
-static void hpsa_unmap_one(struct pci_dev *pdev,
-		struct CommandList *cp,
-		size_t buflen,
-		int data_direction)
+static void hpsa_pci_unmap(struct pci_dev *pdev,
+	struct CommandList *c, int sg_used, int data_direction)
 {
+	int i;
 	union u64bit addr64;
 
-	addr64.val32.lower = cp->SG[0].Addr.lower;
-	addr64.val32.upper = cp->SG[0].Addr.upper;
-	pci_unmap_single(pdev, (dma_addr_t) addr64.val,
-		buflen, data_direction);
+	for (i = 0; i < sg_used; i++) {
+		addr64.val32.lower = c->SG[i].Addr.lower;
+		addr64.val32.upper = c->SG[i].Addr.upper;
+		pci_unmap_single(pdev, (dma_addr_t) addr64.val, c->SG[i].Len,
+			data_direction);
+	}
 }
 
 static void hpsa_map_one(struct pci_dev *pdev,
@@ -1055,7 +1056,7 @@ static int hpsa_scsi_do_inquiry(struct c
 		TYPE_CMD);
 	if (rc == 0) {
 		hpsa_scsi_do_simple_cmd_core(h, c);
-		hpsa_unmap_one(h->pdev, c, bufsize, PCI_DMA_FROMDEVICE);
+		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
 
 		ei = c->err_info;
 		if (ei->CommandStatus != 0 &&
@@ -1162,7 +1163,7 @@ static int hpsa_scsi_do_report_luns(stru
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
 	hpsa_scsi_do_simple_cmd_core(h, c);
-	hpsa_unmap_one(h->pdev, c, bufsize, PCI_DMA_FROMDEVICE);
+	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
@@ -2144,12 +2145,7 @@ static int hpsa_passthru_ioctl(struct ct
 		c->SG[0].Ext = 0; /* we are not chaining*/
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
-
-	/* unlock the buffers from DMA */
-	temp64.val32.lower = c->SG[0].Addr.lower;
-	temp64.val32.upper = c->SG[0].Addr.upper;
-	pci_unmap_single(h->pdev, (dma_addr_t) temp64.val, iocommand.buf_size,
-			 PCI_DMA_BIDIRECTIONAL);
+	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
 
 	/* Copy the error information out */
 	memcpy(&iocommand.error_info, c->err_info,
@@ -2277,14 +2273,7 @@ static int hpsa_big_passthru_ioctl(struc
 		}
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
-	/* unlock the buffers from DMA */
-	for (i = 0; i < sg_used; i++) {
-		temp64.val32.lower = c->SG[i].Addr.lower;
-		temp64.val32.upper = c->SG[i].Addr.upper;
-		pci_unmap_single(h->pdev,
-			(dma_addr_t) temp64.val, buff_size[i],
-			PCI_DMA_BIDIRECTIONAL);
-	}
+	hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
 	/* Copy the error information out */
 	memcpy(&ioc->error_info, c->err_info, sizeof(ioc->error_info));
 	if (copy_to_user(argp, ioc, sizeof(*ioc))) {
@@ -2501,7 +2490,6 @@ static int sendcmd_core(struct ctlr_info
 	int i;
 	unsigned long complete;
 	int status = IO_ERROR;
-	union u64bit buff_dma_handle;
 
 resend_cmd1:
 	/*
@@ -2596,12 +2584,7 @@ resend_cmd1:
 	} while (1);
 
 cleanup1:
-
-	/* unlock the data buffer from DMA */
-	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
-	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
-	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
-			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
+	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
 	return status;
 }
 
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


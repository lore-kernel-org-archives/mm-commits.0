From: akpm@linux-foundation.org
Subject: + initio-initio_build_scb-fix.patch added to -mm tree
Date: Mon, 17 Dec 2007 12:42:47 -0800
Message-ID: <200712172042.lBHKglfa000559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758345AbXLQUpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 15:45:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, stable@kernel.org


The patch titled
     initio: initio_build_scb() fix
has been added to the -mm tree.  Its filename is
     initio-initio_build_scb-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: initio: initio_build_scb() fix
From: Boaz Harrosh <bharrosh@panasas.com>

Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/initio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/initio.c~initio-initio_build_scb-fix drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~initio-initio_build_scb-fix
+++ a/drivers/scsi/initio.c
@@ -138,10 +138,10 @@ static struct pci_device_id i91u_pci_dev
 };
 MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
 
-#define DEBUG_INTERRUPT 0
-#define DEBUG_QUEUE     0
-#define DEBUG_STATE     0
-#define INT_DISC	0
+#define DEBUG_INTERRUPT 1
+#define DEBUG_QUEUE     1
+#define DEBUG_STATE     1
+#define INT_DISC	1
 
 /*--- forward references ---*/
 static struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun);
@@ -2616,6 +2616,7 @@ static void initio_build_scb(struct init
 		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
 			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
 			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
+			sg++;
 		}
 
 		cblk->buflen = (scsi_bufflen(cmnd) > total_len) ?
_

Patches currently in -mm which might be from bharrosh@panasas.com are

git-scsi-misc.patch
scsi-gdth-kill-unneeded-irq-argument.patch
initio-initio_build_scb-fix.patch
tgt-use-scsi_init_io-instead-of-scsi_alloc_sgtable.patch
scsi-scsi_data_buffer.patch
scsi-pending-arm-convert-to-accessors.patch
scsi-bidi-support.patch

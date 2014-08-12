From: akpm@linux-foundation.org
Subject: [merged] block-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:21 -0700
Message-ID: <53ea6e1d.TV9/taButfFbspVu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42642 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHLTmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:22 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1312421qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     block-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: block: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c   |   18 +++++++++---------
 drivers/block/cciss.c    |   11 ++++-------
 drivers/block/skd_main.c |   25 +++++++++----------------
 3 files changed, 22 insertions(+), 32 deletions(-)

diff -puN drivers/block/DAC960.c~block-use-pci_zalloc_consistent drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~block-use-pci_zalloc_consistent
+++ a/drivers/block/DAC960.c
@@ -6741,11 +6741,11 @@ static long DAC960_gam_ioctl(struct file
 	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
-	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
-				DataTransferLength, &DataTransferBufferDMA);
+	    DataTransferBuffer = pci_zalloc_consistent(Controller->PCIDevice,
+                                                       DataTransferLength,
+                                                       &DataTransferBufferDMA);
 	    if (DataTransferBuffer == NULL)
 	    	break;
-	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
@@ -6877,11 +6877,11 @@ static long DAC960_gam_ioctl(struct file
     	ErrorCode = -ENOMEM;
 	if (DataTransferLength > 0)
 	  {
-	    DataTransferBuffer = pci_alloc_consistent(Controller->PCIDevice,
-				DataTransferLength, &DataTransferBufferDMA);
+	    DataTransferBuffer = pci_zalloc_consistent(Controller->PCIDevice,
+                                                       DataTransferLength,
+                                                       &DataTransferBufferDMA);
 	    if (DataTransferBuffer == NULL)
 	    	break;
-	    memset(DataTransferBuffer, 0, DataTransferLength);
 	  }
 	else if (DataTransferLength < 0)
 	  {
@@ -6899,14 +6899,14 @@ static long DAC960_gam_ioctl(struct file
 	RequestSenseLength = UserCommand.RequestSenseLength;
 	if (RequestSenseLength > 0)
 	  {
-	    RequestSenseBuffer = pci_alloc_consistent(Controller->PCIDevice,
-			RequestSenseLength, &RequestSenseBufferDMA);
+	    RequestSenseBuffer = pci_zalloc_consistent(Controller->PCIDevice,
+                                                       RequestSenseLength,
+                                                       &RequestSenseBufferDMA);
 	    if (RequestSenseBuffer == NULL)
 	      {
 		ErrorCode = -ENOMEM;
 		goto Failure2;
 	      }
-	    memset(RequestSenseBuffer, 0, RequestSenseLength);
 	  }
 	spin_lock_irqsave(&Controller->queue_lock, flags);
 	while ((Command = DAC960_AllocateCommand(Controller)) == NULL)
diff -puN drivers/block/cciss.c~block-use-pci_zalloc_consistent drivers/block/cciss.c
--- a/drivers/block/cciss.c~block-use-pci_zalloc_consistent
+++ a/drivers/block/cciss.c
@@ -1014,24 +1014,21 @@ static CommandList_struct *cmd_special_a
 	u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
 
-	c = (CommandList_struct *) pci_alloc_consistent(h->pdev,
-		sizeof(CommandList_struct), &cmd_dma_handle);
+	c = pci_zalloc_consistent(h->pdev, sizeof(CommandList_struct),
+				  &cmd_dma_handle);
 	if (c == NULL)
 		return NULL;
-	memset(c, 0, sizeof(CommandList_struct));
 
 	c->cmdindex = -1;
 
-	c->err_info = (ErrorInfo_struct *)
-	    pci_alloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
-		    &err_dma_handle);
+	c->err_info = pci_zalloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
+					    &err_dma_handle);
 
 	if (c->err_info == NULL) {
 		pci_free_consistent(h->pdev,
 			sizeof(CommandList_struct), c, cmd_dma_handle);
 		return NULL;
 	}
-	memset(c->err_info, 0, sizeof(ErrorInfo_struct));
 
 	INIT_LIST_HEAD(&c->list);
 	c->busaddr = (__u32) cmd_dma_handle;
diff -puN drivers/block/skd_main.c~block-use-pci_zalloc_consistent drivers/block/skd_main.c
--- a/drivers/block/skd_main.c~block-use-pci_zalloc_consistent
+++ a/drivers/block/skd_main.c
@@ -4112,16 +4112,14 @@ static int skd_cons_skcomp(struct skd_de
 		 skdev->name, __func__, __LINE__,
 		 nbytes, SKD_N_COMPLETION_ENTRY);
 
-	skcomp = pci_alloc_consistent(skdev->pdev, nbytes,
-				      &skdev->cq_dma_address);
+	skcomp = pci_zalloc_consistent(skdev->pdev, nbytes,
+				       &skdev->cq_dma_address);
 
 	if (skcomp == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
-	memset(skcomp, 0, nbytes);
-
 	skdev->skcomp_table = skcomp;
 	skdev->skerr_table = (struct fit_comp_error_info *)((char *)skcomp +
 							   sizeof(*skcomp) *
@@ -4304,15 +4302,14 @@ static int skd_cons_skspcl(struct skd_de
 
 		nbytes = SKD_N_SPECIAL_FITMSG_BYTES;
 
-		skspcl->msg_buf = pci_alloc_consistent(skdev->pdev, nbytes,
-						       &skspcl->mb_dma_address);
+		skspcl->msg_buf =
+			pci_zalloc_consistent(skdev->pdev, nbytes,
+					      &skspcl->mb_dma_address);
 		if (skspcl->msg_buf == NULL) {
 			rc = -ENOMEM;
 			goto err_out;
 		}
 
-		memset(skspcl->msg_buf, 0, nbytes);
-
 		skspcl->req.sg = kzalloc(sizeof(struct scatterlist) *
 					 SKD_N_SG_PER_SPECIAL, GFP_KERNEL);
 		if (skspcl->req.sg == NULL) {
@@ -4353,25 +4350,21 @@ static int skd_cons_sksb(struct skd_devi
 
 	nbytes = SKD_N_INTERNAL_BYTES;
 
-	skspcl->data_buf = pci_alloc_consistent(skdev->pdev, nbytes,
-						&skspcl->db_dma_address);
+	skspcl->data_buf = pci_zalloc_consistent(skdev->pdev, nbytes,
+						 &skspcl->db_dma_address);
 	if (skspcl->data_buf == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
-	memset(skspcl->data_buf, 0, nbytes);
-
 	nbytes = SKD_N_SPECIAL_FITMSG_BYTES;
-	skspcl->msg_buf = pci_alloc_consistent(skdev->pdev, nbytes,
-					       &skspcl->mb_dma_address);
+	skspcl->msg_buf = pci_zalloc_consistent(skdev->pdev, nbytes,
+						&skspcl->mb_dma_address);
 	if (skspcl->msg_buf == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
-	memset(skspcl->msg_buf, 0, nbytes);

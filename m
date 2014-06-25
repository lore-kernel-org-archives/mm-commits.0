From: akpm@linux-foundation.org
Subject: + block-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:07 -0700
Message-ID: <53ab233f.S9GBEcxzQbtoBiBF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaFYTaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     block-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-use-pci_zalloc_consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 	skspcl->req.sksg_list = skd_cons_sg_list(skdev, 1,
 						 &skspcl->req.sksg_dma_address);
 	if (skspcl->req.sksg_list == NULL) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch


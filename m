From: akpm@linux-foundation.org
Subject: + hpsa-retry-driver-initiated-commands-on-unit-attention.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:48 -0800
Message-ID: <200911122253.nACMrmMH006657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503AbZKLW46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: Retry driver initiated commands on unit attention
has been added to the -mm tree.  Its filename is
     hpsa-retry-driver-initiated-commands-on-unit-attention.patch

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
Subject: hpsa: Retry driver initiated commands on unit attention
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Retry driver initiated commands on unit attention.
There are a some commands initiated by the driver which
are neither ioctls nor normal i/o.  If any of these commands
completes with UNIT ATTENTION, they should be retried.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-retry-driver-initiated-commands-on-unit-attention drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-retry-driver-initiated-commands-on-unit-attention
+++ a/drivers/scsi/hpsa.c
@@ -1173,7 +1173,7 @@ static void hpsa_map_one(struct pci_dev 
 	cp->Header.SGTotal = (__u16) 1; /* total sgs in this cmd list */
 }
 
-static void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
+static inline void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
 	struct CommandList *c)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -1183,6 +1183,19 @@ static void hpsa_scsi_do_simple_cmd_core
 	wait_for_completion(&wait);
 }
 
+static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
+	struct CommandList *c, int data_direction)
+{
+	int retry_count = 0;
+
+	do {
+		memset(c->err_info, 0, sizeof(c->err_info));
+		hpsa_scsi_do_simple_cmd_core(h, c);
+		retry_count++;
+	} while (check_for_unit_attention(h, c) && retry_count <= 3);
+	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
+}
+
 static void hpsa_scsi_interpret_error(struct CommandList *cp)
 {
 	struct ErrorInfo *ei;
@@ -1262,9 +1275,7 @@ static int hpsa_scsi_do_inquiry(struct c
 	rc = fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr,
 		TYPE_CMD);
 	if (rc == 0) {
-		hpsa_scsi_do_simple_cmd_core(h, c);
-		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
-
+		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
 		ei = c->err_info;
 		if (ei->CommandStatus != 0 &&
 		    ei->CommandStatus != CMD_DATA_UNDERRUN) {
@@ -1369,8 +1380,7 @@ static int hpsa_scsi_do_report_luns(stru
 
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
-	hpsa_scsi_do_simple_cmd_core(h, c);
-	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
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


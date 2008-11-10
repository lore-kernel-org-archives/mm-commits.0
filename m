From: akpm@linux-foundation.org
Subject: - u14-34f-fix-scsi_dma_map-failure-case.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:13 -0800
Message-ID: <200811102034.mAAKYDS2024946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbYKJUez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     U14-34F: fix scsi_dma_map failure case
has been removed from the -mm tree.  Its filename was
     u14-34f-fix-scsi_dma_map-failure-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: U14-34F: fix scsi_dma_map failure case
From: roel kluin <roel.kluin@gmail.com>

When unsigned, scsi_dma_map may return -ENOMEM without triggering BUG_ON()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/u14-34f.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/u14-34f.c~u14-34f-fix-scsi_dma_map-failure-case drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c~u14-34f-fix-scsi_dma_map-failure-case
+++ a/drivers/scsi/u14-34f.c
@@ -1111,7 +1111,8 @@ static int u14_34f_detect(struct scsi_ho
 
 static void map_dma(unsigned int i, unsigned int j) {
    unsigned int data_len = 0;
-   unsigned int k, count, pci_dir;
+   unsigned int k, pci_dir;
+   int count;
    struct scatterlist *sg;
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting.patch
linux-next.patch
make-various-things-static.patch


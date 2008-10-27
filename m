From: akpm@linux-foundation.org
Subject: + u14-34f-fix-scsi_dma_map-failure-case.patch added to -mm tree
Date: Sun, 26 Oct 2008 22:23:23 -0700
Message-ID: <200810270523.m9R5NNBZ032544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbYJ0FX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 01:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     U14-34F: fix scsi_dma_map failure case
has been added to the -mm tree.  Its filename is
     u14-34f-fix-scsi_dma_map-failure-case.patch

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

linux-next.patch
u14-34f-fix-scsi_dma_map-failure-case.patch


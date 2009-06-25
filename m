From: akpm@linux-foundation.org
Subject: + scsi-fnic-remove-redundant-bug_ons-and-fix-checks-on-unsigned.patch added to -mm tree
Date: Thu, 25 Jun 2009 15:59:21 -0700
Message-ID: <200906252259.n5PMxLaJ027287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948AbZFYW7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 18:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, abjoglek@cisco.com


The patch titled
     scsi: fnic: remove redundant BUG_ONs and fix checks on unsigned
has been added to the -mm tree.  Its filename is
     scsi-fnic-remove-redundant-bug_ons-and-fix-checks-on-unsigned.patch

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
Subject: scsi: fnic: remove redundant BUG_ONs and fix checks on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

The shost sg tablesize is set to FNIC_MAX_SG_DESC_CNT and fnic uses
scsi_dma_map, so both BUG_ONs can be removed.

scsi_dma_map may return -ENOMEM, sg_count should be int to catch that.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fnic/fnic_scsi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/fnic/fnic_scsi.c~scsi-fnic-remove-redundant-bug_ons-and-fix-checks-on-unsigned drivers/scsi/fnic/fnic_scsi.c
--- a/drivers/scsi/fnic/fnic_scsi.c~scsi-fnic-remove-redundant-bug_ons-and-fix-checks-on-unsigned
+++ a/drivers/scsi/fnic/fnic_scsi.c
@@ -245,7 +245,7 @@ static inline int fnic_queue_wq_copy_des
 					  struct vnic_wq_copy *wq,
 					  struct fnic_io_req *io_req,
 					  struct scsi_cmnd *sc,
-					  u32 sg_count)
+					  int sg_count)
 {
 	struct scatterlist *sg;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc->device));
@@ -260,9 +260,6 @@ static inline int fnic_queue_wq_copy_des
 	char msg[2];
 
 	if (sg_count) {
-		BUG_ON(sg_count < 0);
-		BUG_ON(sg_count > FNIC_MAX_SG_DESC_CNT);
-
 		/* For each SGE, create a device desc entry */
 		desc = io_req->sgl_list;
 		for_each_sg(scsi_sglist(sc), sg, sg_count, i) {
@@ -344,7 +341,7 @@ int fnic_queuecommand(struct scsi_cmnd *
 	struct fnic *fnic;
 	struct vnic_wq_copy *wq;
 	int ret;
-	u32 sg_count;
+	int sg_count;
 	unsigned long flags;
 	unsigned long ptr;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
ext4-remove-redundant-test-on-unsigned.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch
scsi-fnic-remove-redundant-bug_ons-and-fix-checks-on-unsigned.patch


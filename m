From: akpm@linux-foundation.org
Subject: [merged] scsi-bfa-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:09 -0800
Message-ID: <20130228201509.9E62A5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:54703 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab3B1UPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:10 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245308qen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi/bfa: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     scsi-bfa-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: scsi/bfa: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Krishna C Gudipati <kgudipat@brocade.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfad_im.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/bfa/bfad_im.c~scsi-bfa-convert-to-idr_alloc drivers/scsi/bfa/bfad_im.c
--- a/drivers/scsi/bfa/bfad_im.c~scsi-bfa-convert-to-idr_alloc
+++ a/drivers/scsi/bfa/bfad_im.c
@@ -523,20 +523,13 @@ bfad_im_scsi_host_alloc(struct bfad_s *b
 	int error = 1;
 
 	mutex_lock(&bfad_mutex);
-	if (!idr_pre_get(&bfad_im_port_index, GFP_KERNEL)) {
+	error = idr_alloc(&bfad_im_port_index, im_port, 0, 0, GFP_KERNEL);
+	if (error < 0) {
 		mutex_unlock(&bfad_mutex);
-		printk(KERN_WARNING "idr_pre_get failure\n");
+		printk(KERN_WARNING "idr_alloc failure\n");
 		goto out;
 	}
-
-	error = idr_get_new(&bfad_im_port_index, im_port,
-					 &im_port->idr_id);
-	if (error) {
-		mutex_unlock(&bfad_mutex);
-		printk(KERN_WARNING "idr_get_new failure\n");
-		goto out;
-	}

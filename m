From: akpm@linux-foundation.org
Subject: [patch 065/114] rapidio: adjust five function calls
 together with a variable assignment
Date: Tue, 06 Feb 2018 15:39:48 -0800
Message-ID: <20180206233948.SaGnTtTMU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbeBFXjt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org, mporter@kernel.crashing.org, torvalds@linux-foundation.org

From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: adjust five function calls together with a variable assignment

checkpatch pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Link: http://lkml.kernel.org/r/6f5631ed-ec3e-503d-850a-ab09b5736dbe@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-adjust-five-function-calls-together-with-a-variable-assignment drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-adjust-five-function-calls-together-with-a-variable-assignment
+++ a/drivers/rapidio/rio.c
@@ -252,9 +252,9 @@ int rio_request_inb_mbox(struct rio_mpor
 		rio_init_mbox_res(res, mbox, mbox);
 
 		/* Make sure this mailbox isn't in use */
-		if ((rc =
-		     request_resource(&mport->riores[RIO_INB_MBOX_RESOURCE],
-				      res)) < 0) {
+		rc = request_resource(&mport->riores[RIO_INB_MBOX_RESOURCE],
+				      res);
+		if (rc < 0) {
 			kfree(res);
 			goto out;
 		}
@@ -335,9 +335,9 @@ int rio_request_outb_mbox(struct rio_mpo
 		rio_init_mbox_res(res, mbox, mbox);
 
 		/* Make sure this outbound mailbox isn't in use */
-		if ((rc =
-		     request_resource(&mport->riores[RIO_OUTB_MBOX_RESOURCE],
-				      res)) < 0) {
+		rc = request_resource(&mport->riores[RIO_OUTB_MBOX_RESOURCE],
+				      res);
+		if (rc < 0) {
 			kfree(res);
 			goto out;
 		}
@@ -406,9 +406,9 @@ rio_setup_inb_dbell(struct rio_mport *mp
 				  u16 info))
 {
 	int rc = 0;
-	struct rio_dbell *dbell;
+	struct rio_dbell *dbell = kmalloc(sizeof(*dbell), GFP_KERNEL);
 
-	if (!(dbell = kmalloc(sizeof(struct rio_dbell), GFP_KERNEL))) {
+	if (!dbell) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -452,9 +452,9 @@ int rio_request_inb_dbell(struct rio_mpo
 		rio_init_dbell_res(res, start, end);
 
 		/* Make sure these doorbells aren't in use */
-		if ((rc =
-		     request_resource(&mport->riores[RIO_DOORBELL_RESOURCE],
-				      res)) < 0) {
+		rc = request_resource(&mport->riores[RIO_DOORBELL_RESOURCE],
+				      res);
+		if (rc < 0) {
 			kfree(res);
 			goto out;
 		}
@@ -1411,7 +1411,9 @@ rio_mport_get_feature(struct rio_mport *
 						 ext_ftr_ptr, &ftr_header);
 		if (RIO_GET_BLOCK_ID(ftr_header) == ftr)
 			return ext_ftr_ptr;
-		if (!(ext_ftr_ptr = RIO_GET_BLOCK_PTR(ftr_header)))
+
+		ext_ftr_ptr = RIO_GET_BLOCK_PTR(ftr_header);
+		if (!ext_ftr_ptr)
 			break;
 	}
 
_

From: akpm@linux-foundation.org
Subject: +
 rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch added to -mm tree
Date: Tue, 19 Dec 2017 16:05:51 -0800
Message-ID: <5a39a95f.nnWwFI4Rn4j/rBLz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40322 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbdLTAFw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 19:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: adjust five function calls together with a variable assignment
has been added to the -mm tree.  Its filename is
     rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: rapidio: adjust five function calls together with a variable assignment

checkpatch pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Link: http://lkml.kernel.org/r/6f5631ed-ec3e-503d-850a-ab09b5736dbe@users.sourceforge.net
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
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

Patches currently in -mm which might be from elfring@users.sourceforge.net are

rapidio-delete-an-error-message-for-a-failed-memory-allocation-in-rio_init_mports.patch
rapidio-adjust-12-checks-for-null-pointers.patch
rapidio-adjust-five-function-calls-together-with-a-variable-assignment.patch
rapidio-improve-a-size-determination-in-five-functions.patch
rapidio-delete-an-unnecessary-variable-initialisation-in-three-functions.patch
rapidio-return-an-error-code-only-as-a-constant-in-two-functions.patch
rapidio-move-12-export_symbol_gpl-calls-to-function-implementations.patch


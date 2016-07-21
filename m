From: akpm@linux-foundation.org
Subject: +
 rapidio-fix-error-handling-in-mbox-request-release-functions.patch added to -mm tree
Date: Thu, 21 Jul 2016 11:40:30 -0700
Message-ID: <5791171e.EUQR5sGz4f6Vmbkx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcGUSkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix error handling in mbox request/release functions
has been added to the -mm tree.  Its filename is
     rapidio-fix-error-handling-in-mbox-request-release-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-fix-error-handling-in-mbox-request-release-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-fix-error-handling-in-mbox-request-release-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: fix error handling in mbox request/release functions

Add checking for error code returned by HW-specific mbox open routines.
Ensure that resources are properly release if failed.

This patch is applicable to kernel versions starting from v2.6.15.

Link: http://lkml.kernel.org/r/1469125134-16523-9-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |   54 +++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-fix-error-handling-in-mbox-request-release-functions drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-fix-error-handling-in-mbox-request-release-functions
+++ a/drivers/rapidio/rio.c
@@ -268,6 +268,12 @@ int rio_request_inb_mbox(struct rio_mpor
 		mport->inb_msg[mbox].mcback = minb;
 
 		rc = mport->ops->open_inb_mbox(mport, dev_id, mbox, entries);
+		if (rc) {
+			mport->inb_msg[mbox].mcback = NULL;
+			mport->inb_msg[mbox].res = NULL;
+			release_resource(res);
+			kfree(res);
+		}
 	} else
 		rc = -ENOMEM;
 
@@ -285,13 +291,22 @@ int rio_request_inb_mbox(struct rio_mpor
  */
 int rio_release_inb_mbox(struct rio_mport *mport, int mbox)
 {
-	if (mport->ops->close_inb_mbox) {
-		mport->ops->close_inb_mbox(mport, mbox);
+	int rc;
 
-		/* Release the mailbox resource */
-		return release_resource(mport->inb_msg[mbox].res);
-	} else
-		return -ENOSYS;
+	if (!mport->ops->close_inb_mbox || !mport->inb_msg[mbox].res)
+		return -EINVAL;
+
+	mport->ops->close_inb_mbox(mport, mbox);
+	mport->inb_msg[mbox].mcback = NULL;
+
+	rc = release_resource(mport->inb_msg[mbox].res);
+	if (rc)
+		return rc;
+
+	kfree(mport->inb_msg[mbox].res);
+	mport->inb_msg[mbox].res = NULL;
+
+	return 0;
 }
 
 /**
@@ -336,6 +351,12 @@ int rio_request_outb_mbox(struct rio_mpo
 		mport->outb_msg[mbox].mcback = moutb;
 
 		rc = mport->ops->open_outb_mbox(mport, dev_id, mbox, entries);
+		if (rc) {
+			mport->outb_msg[mbox].mcback = NULL;
+			mport->outb_msg[mbox].res = NULL;
+			release_resource(res);
+			kfree(res);
+		}
 	} else
 		rc = -ENOMEM;
 
@@ -353,13 +374,22 @@ int rio_request_outb_mbox(struct rio_mpo
  */
 int rio_release_outb_mbox(struct rio_mport *mport, int mbox)
 {
-	if (mport->ops->close_outb_mbox) {
-		mport->ops->close_outb_mbox(mport, mbox);
+	int rc;
 
-		/* Release the mailbox resource */
-		return release_resource(mport->outb_msg[mbox].res);
-	} else
-		return -ENOSYS;
+	if (!mport->ops->close_outb_mbox || !mport->outb_msg[mbox].res)
+		return -EINVAL;
+
+	mport->ops->close_outb_mbox(mport, mbox);
+	mport->outb_msg[mbox].mcback = NULL;
+
+	rc = release_resource(mport->outb_msg[mbox].res);
+	if (rc)
+		return rc;
+
+	kfree(mport->outb_msg[mbox].res);
+	mport->outb_msg[mbox].res = NULL;
+
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch


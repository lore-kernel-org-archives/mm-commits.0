From: akpm@linux-foundation.org
Subject: [patch 096/111] rapidio: fix error handling in mbox
 request/release functions
Date: Tue, 02 Aug 2016 14:06:49 -0700
Message-ID: <57a10b69.qw0s3xB+8FJSP1XJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbcHBVmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org

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

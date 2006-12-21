From: akpm@osdl.org
Subject: - cciss-fix-xfer_read-xfer_write-in-do_cciss_request.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:37:07 -0800
Message-ID: <200612210037.kBL0b7MT011269@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161095AbWLUAhM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix XFER_READ/XFER_WRITE in do_cciss_request
has been removed from the -mm tree.  Its filename was
     cciss-fix-xfer_read-xfer_write-in-do_cciss_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: fix XFER_READ/XFER_WRITE in do_cciss_request
From: Mike Miller <mike.miller@hp.com>

Fix a stupid bug.  Sometime during the 2tb enhancement I ended up replacing
the macros XFER_READ and XFER_WRITE with h->cciss_read and h->cciss_write
respectively.  It seemed to work somehow at least on x86_64 and ia64.  I don't
know how.  But people started complaining about command timeouts on older
controllers like the 64xx series and only on ia32.  This resolves the issue
reproduced in our lab.  Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-fix-xfer_read-xfer_write-in-do_cciss_request drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-xfer_read-xfer_write-in-do_cciss_request
+++ a/drivers/block/cciss.c
@@ -2492,7 +2492,7 @@ static void do_cciss_request(request_que
 	c->Request.Type.Type = TYPE_CMD;	// It is a command.
 	c->Request.Type.Attribute = ATTR_SIMPLE;
 	c->Request.Type.Direction =
-	    (rq_data_dir(creq) == READ) ? h->cciss_read : h->cciss_write;
+	    (rq_data_dir(creq) == READ) ? XFER_READ : XFER_WRITE;
 	c->Request.Timeout = 0;	// Don't time out
 	c->Request.CDB[0] =
 	    (rq_data_dir(creq) == READ) ? h->cciss_read : h->cciss_write;
_

Patches currently in -mm which might be from mike.miller@hp.com are

git-block.patch


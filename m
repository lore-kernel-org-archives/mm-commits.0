From: akpm@linux-foundation.org
Subject: + fix-soft-lockup-with-iseries-viocd-driver.patch added to -mm tree
Date: Thu, 01 Mar 2007 00:36:59 -0800
Message-ID: <200703010837.l218axeV008620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34371 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXCAIhR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 03:37:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@bakeyournoodle.com, jens.axboe@oracle.com


The patch titled
     Fix soft lockup with iSeries viocd driver
has been added to the -mm tree.  Its filename is
     fix-soft-lockup-with-iseries-viocd-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix soft lockup with iSeries viocd driver
From: Tony Breeds <tony@bakeyournoodle.com>

Fix soft lockup with iSeries viocd driver, caused by eventually calling
end_that_request_first() with nr_bytes 0.

The lockup is triggered by hald, interrogating the device.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/viocd.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff -puN drivers/cdrom/viocd.c~fix-soft-lockup-with-iseries-viocd-driver drivers/cdrom/viocd.c
--- a/drivers/cdrom/viocd.c~fix-soft-lockup-with-iseries-viocd-driver
+++ a/drivers/cdrom/viocd.c
@@ -376,6 +376,25 @@ static int send_request(struct request *
 	return 0;
 }
 
+static void viocd_end_request(struct request *req, int uptodate)
+{
+	int nsectors = req->hard_nr_sectors;
+
+	/*
+	 * Make sure it's fully ended, and ensure that we process
+	 * at least one sector.
+	 */
+	if (blk_pc_request(req))
+		nsectors = (req->data_len + 511) >> 9;
+	if (!nsectors)
+		nsectors = 1;
+
+	if (end_that_request_first(req, uptodate, nsectors))
+		BUG();
+	add_disk_randomness(req->rq_disk);
+	blkdev_dequeue_request(req);
+	end_that_request_last(req, uptodate);
+}
 
 static int rwreq;
 
@@ -385,11 +404,11 @@ static void do_viocd_request(request_que
 
 	while ((rwreq == 0) && ((req = elv_next_request(q)) != NULL)) {
 		if (!blk_fs_request(req))
-			end_request(req, 0);
+			viocd_end_request(req, 0);
 		else if (send_request(req) < 0) {
 			printk(VIOCD_KERN_WARNING
 					"unable to send message to OS/400!");
-			end_request(req, 0);
+			viocd_end_request(req, 0);
 		} else
 			rwreq++;
 	}
@@ -601,9 +620,9 @@ return_complete:
 					"with rc %d:0x%04X: %s\n",
 					req, event->xRc,
 					bevent->sub_result, err->msg);
-			end_request(req, 0);
+			viocd_end_request(req, 0);
 		} else
-			end_request(req, 1);
+			viocd_end_request(req, 1);
 
 		/* restart handling of incoming requests */
 		spin_unlock_irqrestore(&viocd_reqlock, flags);
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

fix-soft-lockup-with-iseries-viocd-driver.patch

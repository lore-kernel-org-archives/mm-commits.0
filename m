From: akpm@linux-foundation.org
Subject: [merged] mg_disk-fix-locking.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:58 -0700
Message-ID: <200904291917.n3TJHwD4030856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754196AbZD2TUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, donari75@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mg_disk: fix locking
has been removed from the -mm tree.  Its filename was
     mg_disk-fix-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mg_disk: fix locking
From: Tejun Heo <tj@kernel.org>

IRQ and timeout handlers call functions which expect locked queue lock
without locking it.  Fix it.

While at it, convert 0s used as null pointer constant to NULLs.

[ Impact: fix locking, cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: unsik Kim <donari75@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mg_disk.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/block/mg_disk.c~mg_disk-fix-locking drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~mg_disk-fix-locking
+++ a/drivers/block/mg_disk.c
@@ -160,11 +160,16 @@ static irqreturn_t mg_irq(int irq, void 
 	struct mg_host *host = dev_id;
 	void (*handler)(struct mg_host *) = host->mg_do_intr;
 
-	host->mg_do_intr = 0;
+	spin_lock(&host->lock);
+
+	host->mg_do_intr = NULL;
 	del_timer(&host->timer);
 	if (!handler)
 		handler = mg_unexpected_intr;
 	handler(host);
+
+	spin_unlock(&host->lock);
+
 	return IRQ_HANDLED;
 }
 
@@ -319,7 +324,7 @@ static void mg_read(struct request *req)
 
 	remains = req->nr_sectors;
 
-	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, 0) !=
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_RD, NULL) !=
 			MG_ERR_NONE)
 		mg_bad_rw_intr(host);
 
@@ -363,7 +368,7 @@ static void mg_write(struct request *req
 
 	remains = req->nr_sectors;
 
-	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, 0) !=
+	if (mg_out(host, req->sector, req->nr_sectors, MG_CMD_WR, NULL) !=
 			MG_ERR_NONE) {
 		mg_bad_rw_intr(host);
 		return;
@@ -521,9 +526,11 @@ void mg_times_out(unsigned long data)
 	char *name;
 	struct request *req;
 
+	spin_lock_irq(&host->lock);
+
 	req = elv_next_request(host->breq);
 	if (!req)
-		return;
+		goto out_unlock;
 
 	host->mg_do_intr = NULL;
 
@@ -534,6 +541,8 @@ void mg_times_out(unsigned long data)
 	mg_bad_rw_intr(host);
 
 	mg_request(host->breq);
+out_unlock:
+	spin_unlock_irq(&host->lock);
 }
 
 static void mg_request_poll(struct request_queue *q)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch


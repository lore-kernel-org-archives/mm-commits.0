From: akpm@linux-foundation.org
Subject: [merged] nbd-clear-waiting_queue-on-shutdown.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:04:53 -0700
Message-ID: <20120918190453.99998100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44109 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2IRTEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:04:54 -0400
Received: by qcqs25 with SMTP id s25so27055qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:04:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: clear waiting_queue on shutdown
has been removed from the -mm tree.  Its filename was
     nbd-clear-waiting_queue-on-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Clements <paul.clements@steeleye.com>
Subject: nbd: clear waiting_queue on shutdown

Fix a serious but uncommon bug in nbd which occurs when there is heavy I/O
going to the nbd device while, at the same time, a failure (server,
network) or manual disconnect of the nbd connection occurs.

There is a small window between the time that the nbd_thread is stopped
and the socket is shutdown where requests can continue to be queued to
nbd's internal waiting_queue.  When this happens, those requests are never
completed or freed.

The fix is to clear the waiting_queue on shutdown of the nbd device, in
the same way that the nbd request queue (queue_head) is already being cleared.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/block/nbd.c~nbd-clear-waiting_queue-on-shutdown drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-clear-waiting_queue-on-shutdown
+++ a/drivers/block/nbd.c
@@ -449,6 +449,14 @@ static void nbd_clear_que(struct nbd_dev
 		req->errors++;
 		nbd_end_request(req);
 	}
+
+	while (!list_empty(&nbd->waiting_queue)) {
+		req = list_entry(nbd->waiting_queue.next, struct request,
+				 queuelist);
+		list_del_init(&req->queuelist);
+		req->errors++;
+		nbd_end_request(req);
+	}
 }
 
 
@@ -598,6 +606,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		BUG_ON(!list_empty(&nbd->queue_head));
+		BUG_ON(!list_empty(&nbd->waiting_queue));
 		if (file)
 			fput(file);
 		return 0;
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

origin.patch
nbd-add-set-flags-ioctl.patch
nbd-handle-discard-requests.patch


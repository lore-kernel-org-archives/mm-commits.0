From: akpm@linux-foundation.org
Subject: + nbd-clear-waiting_queue-on-shutdown.patch added to -mm tree
Date: Fri, 31 Aug 2012 15:03:16 -0700
Message-ID: <20120831220316.8C2A1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:41520 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2HaWDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 18:03:18 -0400
Received: by vbnl22 with SMTP id l22so394404vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 15:03:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.clements@steeleye.com, stable@vger.kernel.org


The patch titled
     Subject: nbd: clear waiting_queue on shutdown
has been added to the -mm tree.  Its filename is
     nbd-clear-waiting_queue-on-shutdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nbd-clear-waiting_queue-on-shutdown.patch
nbd-add-set-flags-ioctl.patch
nbd-handle-discard-requests.patch


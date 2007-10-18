From: akpm@linux-foundation.org
Subject: - nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:08 -0700
Message-ID: <200710180653.l9I6r8e7030413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759114AbXJRHj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: use list_for_each_entry_safe to make it more consolidated and readable
has been removed from the -mm tree.  Its filename was
     nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nbd: use list_for_each_entry_safe to make it more consolidated and readable
From: Denis Cheng <crquan@gmail.com>

Thus the traverse of the loop may delete nodes, use the safe version.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/block/nbd.c~nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable
+++ a/drivers/block/nbd.c
@@ -233,8 +233,7 @@ error_out:
 
 static struct request *nbd_find_request(struct nbd_device *lo, char *handle)
 {
-	struct request *req;
-	struct list_head *tmp;
+	struct request *req, *tmp;
 	struct request *xreq;
 	int err;
 
@@ -245,8 +244,7 @@ static struct request *nbd_find_request(
 		goto out;
 
 	spin_lock(&lo->queue_lock);
-	list_for_each(tmp, &lo->queue_head) {
-		req = list_entry(tmp, struct request, queuelist);
+	list_for_each_entry_safe(req, tmp, &lo->queue_head, queuelist) {
 		if (req != xreq)
 			continue;
 		list_del_init(&req->queuelist);
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch

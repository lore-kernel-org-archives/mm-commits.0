From: akpm@linux-foundation.org
Subject: + nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:23:05 -0700
Message-ID: <200707192223.l6JMN5kb025969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397AbXGSWXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, paul.clements@steeleye.com


The patch titled
     nbd: use list_for_each_entry_safe to make it more consolidated and readable
has been added to the -mm tree.  Its filename is
     nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nbd: use list_for_each_entry_safe to make it more consolidated and readable
From: Denis Cheng <crquan@gmail.com>

Thus the traverse of the loop may delete nodes, use the safe version.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/block/nbd.c~nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable
+++ a/drivers/block/nbd.c
@@ -237,8 +237,7 @@ error_out:
 
 static struct request *nbd_find_request(struct nbd_device *lo, char *handle)
 {
-	struct request *req;
-	struct list_head *tmp;
+	struct request *req, *tmp;
 	struct request *xreq;
 	int err;
 
@@ -249,8 +248,7 @@ static struct request *nbd_find_request(
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
drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch
nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch

From: akpm@linux-foundation.org
Subject: + nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:24:50 -0700
Message-ID: <200707192224.l6JMOoeL026074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231AbXGSWY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:24:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, paul.clements@steeleye.com


The patch titled
     nbd: change a parameter's type to remove a memcpy call
has been added to the -mm tree.  Its filename is
     nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nbd: change a parameter's type to remove a memcpy call
From: Denis Cheng <crquan@gmail.com>

This memcpy looks so strange, in fact it's merely a pointer dereference, so I
change the parameter's type to refer it more directly, this could make the
memcpy not needed anymore.

In the function nbd_read_stat where nbd_find_request is only once called, the
parameter served should be transformed accordingly.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/nbd.c~nbd-change-a-parameters-type-to-remove-a-memcpy-call drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-change-a-parameters-type-to-remove-a-memcpy-call
+++ a/drivers/block/nbd.c
@@ -235,14 +235,12 @@ error_out:
 	return 1;
 }
 
-static struct request *nbd_find_request(struct nbd_device *lo, char *handle)
+static struct request *nbd_find_request(struct nbd_device *lo,
+					struct request *xreq)
 {
 	struct request *req, *tmp;
-	struct request *xreq;
 	int err;
 
-	memcpy(&xreq, handle, sizeof(xreq));
-
 	err = wait_event_interruptible(lo->active_wq, lo->active_req != xreq);
 	if (unlikely(err))
 		goto out;
@@ -297,7 +295,7 @@ static struct request *nbd_read_stat(str
 		goto harderror;
 	}
 
-	req = nbd_find_request(lo, reply.handle);
+	req = nbd_find_request(lo, *(struct request **)reply.handle);
 	if (unlikely(IS_ERR(req))) {
 		result = PTR_ERR(req);
 		if (result != -ENOENT)
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch
nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch
nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch

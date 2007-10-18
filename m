From: akpm@linux-foundation.org
Subject: - nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:10 -0700
Message-ID: <200710180653.l9I6rAAL030416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761031AbXJRHjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: change a parameter's type to remove a memcpy call
has been removed from the -mm tree.  Its filename was
     nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/nbd.c~nbd-change-a-parameters-type-to-remove-a-memcpy-call drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-change-a-parameters-type-to-remove-a-memcpy-call
+++ a/drivers/block/nbd.c
@@ -231,14 +231,12 @@ error_out:
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
@@ -293,7 +291,7 @@ static struct request *nbd_read_stat(str
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

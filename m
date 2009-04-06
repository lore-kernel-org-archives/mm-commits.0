From: akpm@linux-foundation.org
Subject: [merged] nbd-trivial-cleanups.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:36 -0700
Message-ID: <200904061936.n36JaaSg012550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757652AbZDFTjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: trivial cleanups
has been removed from the -mm tree.  Its filename was
     nbd-trivial-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: trivial cleanups
From: Pavel Machek <pavel@suse.cz>

Trivial cleanups for nbd: only the return -EIO one really changes code,
and I've verified all the callers (plus 0 == success, 1 == error
convention is really ugly).

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/block/nbd.c~nbd-trivial-cleanups drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-trivial-cleanups
+++ a/drivers/block/nbd.c
@@ -4,7 +4,7 @@
  * Note that you can not swap over this thing, yet. Seems to work but
  * deadlocks sometimes - you can not swap over TCP in general.
  * 
- * Copyright 1997-2000 Pavel Machek <pavel@ucw.cz>
+ * Copyright 1997-2000, 2008 Pavel Machek <pavel@suse.cz>
  * Parts copyright 2001 Steven Whitehouse <steve@chygwyn.com>
  *
  * This file is released under GPLv2 or later.
@@ -276,7 +276,7 @@ static int nbd_send_req(struct nbd_devic
 	return 0;
 
 error_out:
-	return 1;
+	return -EIO;
 }
 
 static struct request *nbd_find_request(struct nbd_device *lo,
@@ -467,9 +467,7 @@ static void nbd_handle_req(struct nbd_de
 		mutex_unlock(&lo->tx_lock);
 		printk(KERN_ERR "%s: Attempted send on closed socket\n",
 		       lo->disk->disk_name);
-		req->errors++;
-		nbd_end_request(req);
-		return;
+		goto error_out;
 	}
 
 	lo->active_req = req;
@@ -531,7 +529,7 @@ static int nbd_thread(void *data)
  *   { printk( "Warning: Ignoring result!\n"); nbd_end_request( req ); }
  */
 
-static void do_nbd_request(struct request_queue * q)
+static void do_nbd_request(struct request_queue *q)
 {
 	struct request *req;
 	
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch


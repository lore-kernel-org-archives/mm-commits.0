From: akpm@linux-foundation.org
Subject: + nbd-trivial-cleanups.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:06:44 -0800
Message-ID: <200901132206.n0DM6iRM012780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851AbZAMWHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:07:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, paul.clements@steeleye.com


The patch titled
     nbd: trivial cleanups
has been added to the -mm tree.  Its filename is
     nbd-trivial-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/block/nbd.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

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
@@ -465,9 +465,7 @@ static void nbd_handle_req(struct nbd_de
 		mutex_unlock(&lo->tx_lock);
 		printk(KERN_ERR "%s: Attempted send on closed socket\n",
 		       lo->disk->disk_name);
-		req->errors++;
-		nbd_end_request(req);
-		return;
+		goto error_out;
 	}
 
 	lo->active_req = req;
@@ -529,7 +527,7 @@ static int nbd_thread(void *data)
  *   { printk( "Warning: Ignoring result!\n"); nbd_end_request( req ); }
  */
 
-static void do_nbd_request(struct request_queue * q)
+static void do_nbd_request(struct request_queue *q)
 {
 	struct request *req;
 	
@@ -563,7 +561,7 @@ static int nbd_ioctl(struct block_device
 	struct nbd_device *lo = bdev->bd_disk->private_data;
 	struct file *file;
 	int error;
-	struct request sreq ;
+	struct request sreq;
 	struct task_struct *thread;
 
 	if (!capable(CAP_SYS_ADMIN))
_

Patches currently in -mm which might be from pavel@suse.cz are

lis3lv02d-merge-with-leds-hp-disk.patch
maintainers-add-entry-for-freezer.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
nbd-trivial-cleanups.patch


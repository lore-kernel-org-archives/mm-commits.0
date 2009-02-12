From: akpm@linux-foundation.org
Subject: [merged] nbd-fix-i-o-hang-on-disconnected-nbds.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:26:03 -0800
Message-ID: <200902122026.n1CKQ3j3015557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758533AbZBLU1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, jnelson-kernel-bugzilla@jamponi.net, pavel@ucw.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nbd: fix I/O hang on disconnected nbds
has been removed from the -mm tree.  Its filename was
     nbd-fix-i-o-hang-on-disconnected-nbds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: fix I/O hang on disconnected nbds
From: Paul Clements <paul.clements@steeleye.com>

Fix a problem that causes I/O to a disconnected (or partially initialized)
nbd device to hang indefinitely.  To reproduce:

# ioctl NBD_SET_SIZE_BLOCKS /dev/nbd23 514048
# dd if=/dev/nbd23 of=/dev/null bs=4096 count=1

...hangs...

This can also occur when an nbd device loses its nbd-client/server
connection.  Although we clear the queue of any outstanding I/Os after the
client/server connection fails, any additional I/Os that get queued later
will hang.

This bug may also be the problem reported in this bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=12277

Testing would need to be performed to determine if the two issues are the
same.

This problem was introduced by the new request handling thread code ("NBD:
allow nbd to be used locally", 3/2008), which entered into mainline around
2.6.25.

The fix, which is fairly simple, is to restore the check for lo->sock
being NULL in do_nbd_request.  This causes I/O to an uninitialized nbd to
immediately fail with an I/O error, as it did prior to the introduction of
this bug.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Reported-by: Jon Nelson <jnelson-kernel-bugzilla@jamponi.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: <stable@kernel.org>		[2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/block/nbd.c~nbd-fix-i-o-hang-on-disconnected-nbds drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-fix-i-o-hang-on-disconnected-nbds
+++ a/drivers/block/nbd.c
@@ -549,6 +549,15 @@ static void do_nbd_request(struct reques
 
 		BUG_ON(lo->magic != LO_MAGIC);
 
+		if (unlikely(!lo->sock)) {
+			printk(KERN_ERR "%s: Attempted send on closed socket\n",
+				lo->disk->disk_name);
+			req->errors++;
+			nbd_end_request(req);
+			spin_lock_irq(q->queue_lock);
+			continue;
+		}
+
 		spin_lock_irq(&lo->queue_lock);
 		list_add_tail(&req->queuelist, &lo->waiting_queue);
 		spin_unlock_irq(&lo->queue_lock);
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

origin.patch
nbd-add-locking-to-nbd_ioctl.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
nbd-trivial-cleanups.patch


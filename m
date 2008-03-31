From: akpm@linux-foundation.org
Subject: + nbd-prevent-sock_xmit-from-attempting-to-use-a-null-socket.patch added to -mm tree
Date: Mon, 31 Mar 2008 16:16:10 -0700
Message-ID: <200803312316.m2VNGARD030961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385AbYCaXQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 19:16:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snitzer@gmail.com, paul.clements@steeleye.com


The patch titled
     nbd: prevent sock_xmit from attempting to use a NULL socket
has been added to the -mm tree.  Its filename is
     nbd-prevent-sock_xmit-from-attempting-to-use-a-null-socket.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: prevent sock_xmit from attempting to use a NULL socket
From: Mike Snitzer <snitzer@gmail.com>

NBD does not protect the nbd_device's socket from becoming NULL during
receives.

This closes a race with the NBD_CLEAR_SOCK ioctl (nbd-client -d) setting
the nbd_device's socket to NULL right before NBD calls sock_xmit.

Signed-off-by: Mike Snitzer <snitzer@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/block/nbd.c~nbd-prevent-sock_xmit-from-attempting-to-use-a-null-socket drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-prevent-sock_xmit-from-attempting-to-use-a-null-socket
+++ a/drivers/block/nbd.c
@@ -153,6 +153,12 @@ static int sock_xmit(struct nbd_device *
 	struct kvec iov;
 	sigset_t blocked, oldset;
 
+	if (unlikely(!sock)) {
+		printk(KERN_ERR "%s: Attempted %s on closed socket in sock_xmit\n",
+		       lo->disk->disk_name, (send ? "send" : "recv"));
+		return -EINVAL;
+	}
+
 	/* Allow interception of SIGKILL only
 	 * Don't allow other signals to interrupt the transmission */
 	siginitsetinv(&blocked, sigmask(SIGKILL));
_

Patches currently in -mm which might be from snitzer@gmail.com are

percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data-storage.patch
nbd-prevent-sock_xmit-from-attempting-to-use-a-null-socket.patch


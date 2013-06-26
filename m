From: akpm@linux-foundation.org
Subject: + nbd-correct-disconnect-behavior.patch added to -mm tree
Date: Wed, 26 Jun 2013 16:21:14 -0700
Message-ID: <51cb776a.ELqrEpm5X3zBA8RS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3FZXVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 19:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rob@landley.net, paul.clements@steeleye.com

Subject: + nbd-correct-disconnect-behavior.patch added to -mm tree
To: paul.clements@steeleye.com,rob@landley.net,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 16:21:14 -0700


The patch titled
     Subject: nbd: correct disconnect behavior
has been added to the -mm tree.  Its filename is
     nbd-correct-disconnect-behavior.patch

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
Subject: nbd: correct disconnect behavior

Currently, when a disconnect is requested by the user (via NBD_DISCONNECT
ioctl) the return from NBD_DO_IT is undefined (it is usually one of
several error codes).  This means that nbd-client does not know if a
manual disconnect was performed or whether a network error occurred. 
Because of this, nbd-client's persist mode (which tries to reconnect after
error, but not after manual disconnect) does not always work correctly.

This change fixes this by causing NBD_DO_IT to always return 0 if a user
requests a disconnect.  This means that nbd-client can correctly either
persist the connection (if an error occurred) or disconnect (if the user
requested it).

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Acked-by: Rob Landley <rob@landley.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    7 ++++++-
 include/linux/nbd.h |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-correct-disconnect-behavior drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-correct-disconnect-behavior
+++ a/drivers/block/nbd.c
@@ -623,8 +623,10 @@ static int __nbd_ioctl(struct block_devi
 		if (!nbd->sock)
 			return -EINVAL;
 
+		nbd->disconnect = 1;
+
 		nbd_send_req(nbd, &sreq);
-                return 0;
+		return 0;
 	}
  
 	case NBD_CLEAR_SOCK: {
@@ -654,6 +656,7 @@ static int __nbd_ioctl(struct block_devi
 				nbd->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
+				nbd->disconnect = 0; /* we're connected now */
 				return 0;
 			} else {
 				fput(file);
@@ -743,6 +746,8 @@ static int __nbd_ioctl(struct block_devi
 		set_capacity(nbd->disk, 0);
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		if (nbd->disconnect) /* user requested, ignore socket errors */
+			return 0;
 		return nbd->harderror;
 	}
 
diff -puN include/linux/nbd.h~nbd-correct-disconnect-behavior include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-correct-disconnect-behavior
+++ a/include/linux/nbd.h
@@ -41,6 +41,7 @@ struct nbd_device {
 	u64 bytesize;
 	pid_t pid; /* pid of nbd-client, if attached */
 	int xmit_timeout;
+	int disconnect; /* a disconnect has been requested by user */
 };
 
 #endif
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

nbd-remove-bogus-bug_on-in-nbd_clear_que.patch
nbd-correct-disconnect-behavior.patch


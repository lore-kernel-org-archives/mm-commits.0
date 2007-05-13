From: akpm@linux-foundation.org
Subject: + epoll-move-kfree-inside-ep_free.patch added to -mm tree
Date: Sun, 13 May 2007 12:49:24 -0700
Message-ID: <200705131949.l4DJnN7u002077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbXEMTt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 15:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     epoll: move kfree inside ep_free
has been added to the -mm tree.  Its filename is
     epoll-move-kfree-inside-ep_free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: epoll: move kfree inside ep_free
From: Davide Libenzi <davidel@xmailserver.org>

Move the kfree() call inside the ep_free() function.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/eventpoll.c~epoll-move-kfree-inside-ep_free fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-move-kfree-inside-ep_free
+++ a/fs/eventpoll.c
@@ -469,18 +469,16 @@ static void ep_free(struct eventpoll *ep
 	}
 
 	mutex_unlock(&epmutex);
-
 	mutex_destroy(&ep->mtx);
+	kfree(ep);
 }
 
 static int ep_eventpoll_release(struct inode *inode, struct file *file)
 {
 	struct eventpoll *ep = file->private_data;
 
-	if (ep) {
+	if (ep)
 		ep_free(ep);
-		kfree(ep);
-	}
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
 	return 0;
@@ -1107,7 +1105,6 @@ asmlinkage long sys_epoll_create(int siz
 
 error_free:
 	ep_free(ep);
-	kfree(ep);
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
 		     current, size, error));
_

Patches currently in -mm which might be from davidel@xmailserver.org are

fix-epoll-single-pass-code-and-add-wait-exclusive-flag.patch
epoll-locks-changes-and-cleanups.patch
epoll-fix-some-comments.patch
epoll-move-kfree-inside-ep_free.patch

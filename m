From: akpm@linux-foundation.org
Subject: - epoll-move-kfree-inside-ep_free.patch removed from -mm tree
Date: Tue, 15 May 2007 11:06:59 -0700
Message-ID: <200705151806.l4FI6wBK014133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102AbXEOSHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:07:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll: move kfree inside ep_free
has been removed from the -mm tree.  Its filename was
     epoll-move-kfree-inside-ep_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
simplify-compat_sys_timerfd.patch

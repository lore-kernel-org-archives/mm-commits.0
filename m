From: akpm@linux-foundation.org
Subject: [merged] epoll-use-real-type-instead-of-void.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:39 -0700
Message-ID: <200904011840.n31IedMS009089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765196AbZDATLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll: use real type instead of void *
has been removed from the -mm tree.  Its filename was
     epoll-use-real-type-instead-of-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: use real type instead of void *
From: Tony Battersby <tonyb@cybernetics.com>

eventpoll.c uses void * in one place for no obvious reason; change it to
use the real type instead.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-use-real-type-instead-of-void fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-use-real-type-instead-of-void
+++ a/fs/eventpoll.c
@@ -192,7 +192,7 @@ struct eppoll_entry {
 	struct list_head llink;
 
 	/* The "base" pointer is set to the container "struct epitem" */
-	void *base;
+	struct epitem *base;
 
 	/*
 	 * Wait queue item that will be linked to the target file wait
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

origin.patch
vfs-improve-comment-describing-fget_light.patch
make-shm_get_stat-more-robust.patch


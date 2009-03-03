From: akpm@linux-foundation.org
Subject: + epoll-use-real-type-instead-of-void.patch added to -mm tree
Date: Tue, 03 Mar 2009 12:09:14 -0800
Message-ID: <200903032009.n23K9EHk031550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbZCCUJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 15:09:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyb@cybernetics.com, davidel@xmailserver.org


The patch titled
     epoll: use real type instead of void *
has been added to the -mm tree.  Its filename is
     epoll-use-real-type-instead-of-void.patch

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
linux-next.patch
vfs-improve-comment-describing-fget_light.patch
epoll-dont-use-current-in-irq-context.patch
epoll-remember-the-event-if-epoll_wait-returns-efault.patch
epoll-remove-unnecessary-xchg.patch
epoll-clean-up-ep_modify.patch
epoll-use-real-type-instead-of-void.patch
make-shm_get_stat-more-robust.patch


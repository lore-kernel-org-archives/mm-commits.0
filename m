From: akpm@linux-foundation.org
Subject: + epoll-fix-possible-lost-wakeup-on-epoll_ctl-path.patch
 added to -mm tree
Date: Wed, 19 Feb 2020 15:31:13 -0800
Message-ID: <20200219233113.3ZpFQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgBSXbP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 18:31:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, max@arangodb.com, kuba@kernel.org, jbaron@akamai.com, dbueso@suse.de, chris.kohlhoff@clearpool.io, rpenyaev@suse.de


The patch titled
     Subject: epoll: fix possible lost wakeup on epoll_ctl() path
has been added to the -mm tree.  Its filename is
     epoll-fix-possible-lost-wakeup-on-epoll_ctl-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-fix-possible-lost-wakeup-on-epoll_ctl-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-fix-possible-lost-wakeup-on-epoll_ctl-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Penyaev <rpenyaev@suse.de>
Subject: epoll: fix possible lost wakeup on epoll_ctl() path

This fixes possible lost wakeup introduced by commit a218cc491420. 
Originally modifications to ep->wq were serialized by ep->wq.lock, but in
the a218cc491420 new rw lock was introduced in order to relax fd event
path, i.e.  callers of ep_poll_callback() function.

After the change ep_modify and ep_insert (both are called on epoll_ctl()
path) were switched to ep->lock, but ep_poll (epoll_wait) was using
ep->wq.lock on wqueue list modification.

The bug doesn't lead to any wqueue list corruptions, because wake up path
and list modifications were serialized by ep->wq.lock internally, but
actual waitqueue_active() check prior wake_up() call can be reordered with
modifications of ep ready list, thus wake up can be lost.

And yes, can be healed by explicit smp_mb():

  list_add_tail(&epi->rdlink, &ep->rdllist);
  smp_mb();
  if (waitqueue_active(&ep->wq))
	wake_up(&ep->wp);

But let's make it simple, thus current patch replaces ep->wq.lock with the
ep->lock for wqueue modifications, thus wake up path always observes
activeness of the wqueue correcty.

Link: http://lkml.kernel.org/r/20200214170211.561524-1-rpenyaev@suse.de
Fixes: a218cc491420 ("epoll: use rwlock in order to reduce ep_poll_callback() contention")
References: https://bugzilla.kernel.org/show_bug.cgi?id=205933
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Reported-by: Max Neunhoeffer <max@arangodb.com>
Bisected-by: Max Neunhoeffer <max@arangodb.com>
Tested-by: Max Neunhoeffer <max@arangodb.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Christopher Kohlhoff <chris.kohlhoff@clearpool.io>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: <stable@vger.kernel.org>	[5.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/eventpoll.c~epoll-fix-possible-lost-wakeup-on-epoll_ctl-path
+++ a/fs/eventpoll.c
@@ -1854,9 +1854,9 @@ fetch_events:
 		waiter = true;
 		init_waitqueue_entry(&wait, current);
 
-		spin_lock_irq(&ep->wq.lock);
+		write_lock_irq(&ep->lock);
 		__add_wait_queue_exclusive(&ep->wq, &wait);
-		spin_unlock_irq(&ep->wq.lock);
+		write_unlock_irq(&ep->lock);
 	}
 
 	for (;;) {
@@ -1904,9 +1904,9 @@ send_events:
 		goto fetch_events;
 
 	if (waiter) {
-		spin_lock_irq(&ep->wq.lock);
+		write_lock_irq(&ep->lock);
 		__remove_wait_queue(&ep->wq, &wait);
-		spin_unlock_irq(&ep->wq.lock);
+		write_unlock_irq(&ep->lock);
 	}
 
 	return res;
_

Patches currently in -mm which might be from rpenyaev@suse.de are

epoll-fix-possible-lost-wakeup-on-epoll_ctl-path.patch
kselftest-introduce-new-epoll-test-case.patch

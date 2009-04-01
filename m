From: akpm@linux-foundation.org
Subject: [merged] epoll-remember-the-event-if-epoll_wait-returns-efault.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:30 -0700
Message-ID: <200904011840.n31IeUZo009048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933221AbZDASnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     epoll: remember the event if epoll_wait returns -EFAULT
has been removed from the -mm tree.  Its filename was
     epoll-remember-the-event-if-epoll_wait-returns-efault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: remember the event if epoll_wait returns -EFAULT
From: Tony Battersby <tonyb@cybernetics.com>

If epoll_wait returns -EFAULT, the event that was being returned when the
fault was encountered will be forgotten.  This is not a big deal since
EFAULT will happen only if a buggy userspace program passes in a bad
address, in which case what happens later usually doesn't matter. 
However, it is easy to remember the event for later, and this patch makes
a simple change to do that.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-remember-the-event-if-epoll_wait-returns-efault fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-remember-the-event-if-epoll_wait-returns-efault
+++ a/fs/eventpoll.c
@@ -1054,8 +1054,10 @@ static int ep_send_events_proc(struct ev
 		 */
 		if (revents) {
 			if (__put_user(revents, &uevent->events) ||
-			    __put_user(epi->event.data, &uevent->data))
+			    __put_user(epi->event.data, &uevent->data)) {
+				list_add(&epi->rdllink, head);
 				return eventcnt ? eventcnt : -EFAULT;
+			}
 			eventcnt++;
 			uevent++;
 			if (epi->event.events & EPOLLONESHOT)
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

origin.patch
vfs-improve-comment-describing-fget_light.patch
make-shm_get_stat-more-robust.patch


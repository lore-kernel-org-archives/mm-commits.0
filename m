From: akpm@linux-foundation.org
Subject: + epoll-remember-the-event-if-epoll_wait-returns-efault.patch added to -mm tree
Date: Tue, 03 Mar 2009 12:09:07 -0800
Message-ID: <200903032009.n23K98mt031541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbZCCUJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 15:09:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyb@cybernetics.com, davidel@xmailserver.org


The patch titled
     epoll: remember the event if epoll_wait returns -EFAULT
has been added to the -mm tree.  Its filename is
     epoll-remember-the-event-if-epoll_wait-returns-efault.patch

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
linux-next.patch
vfs-improve-comment-describing-fget_light.patch
epoll-dont-use-current-in-irq-context.patch
epoll-remember-the-event-if-epoll_wait-returns-efault.patch
epoll-remove-unnecessary-xchg.patch
epoll-clean-up-ep_modify.patch
epoll-use-real-type-instead-of-void.patch
make-shm_get_stat-more-robust.patch


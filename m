From: akpm@linux-foundation.org
Subject: + epoll-restrict-epollexclusive-to-pollin-and-pollout.patch added to -mm tree
Date: Thu, 04 Feb 2016 15:00:21 -0800
Message-ID: <56b3d805.jSjI5mtP0tiKFsLh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbcBDXAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, corbet@lwn.net, hagen@jauu.net, luto@amacapital.net, m@silodev.com, mingo@kernel.org, mtk.manpages@gmail.com, normalperson@yhbt.net, peterz@infradead.org, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: restrict EPOLLEXCLUSIVE to POLLIN and POLLOUT
has been added to the -mm tree.  Its filename is
     epoll-restrict-epollexclusive-to-pollin-and-pollout.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-restrict-epollexclusive-to-pollin-and-pollout.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-restrict-epollexclusive-to-pollin-and-pollout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: epoll: restrict EPOLLEXCLUSIVE to POLLIN and POLLOUT

In the current implementation of the EPOLLEXCLUSIVE flag (added for 4.5-rc1),
if epoll waiters create different POLL* sets and register them as exclusive
against the same target fd, the current implementation will stop waking any
further waiters once it finds the first idle waiter. This means that waiters
could miss wakeups in certain cases.

For example, when we wake up a pipe for reading we do:
wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);
So if one epoll set or epfd is added to pipe p with POLLIN and a second set
epfd2 is added to pipe p with POLLRDNORM, only epfd may receive the wakeup
since the current implementation will stop after it finds any intersection
of events with a waiter that is blocked in epoll_wait().

We could potentially address this by requiring all epoll waiters that are
added to p be required to pass the same set of POLL* events. IE the first
EPOLL_CTL_ADD that passes EPOLLEXCLUSIVE establishes the set POLL* flags to
be used by any other epfds that are added as EPOLLEXCLUSIVE. However, I think
it might be somewhat confusing interface as we would have to reference count
the number of users for that set, and so userspace would have to keep track
of that count, or we would need a more involved interface. It also adds some
shared state that we'd have store somewhere. I don't think anybody will want
to bloat __wait_queue_head for this.

I think what we could do instead, is to simply restrict EPOLLEXCLUSIVE such
that it can only be specified with EPOLLIN and/or EPOLLOUT. So that way if
the wakeup includes 'POLLIN' and not 'POLLOUT', we can stop once we hit the
first idle waiter that specifies the EPOLLIN bit, since any remaining waiters
that only have 'POLLOUT' set wouldn't need to be woken. Likewise, we can do
the same thing if 'POLLOUT' is in the wakeup bit set and not 'POLLIN'. If both
'POLLOUT' and 'POLLIN' are set in the wake bit set (there is at least one
example of this I saw in fs/pipe.c), then we just wake the entire exclusive
list. Having both 'POLLOUT' and 'POLLIN' both set should not be on any
performance critical path, so I think that's ok (in fs/pipe.c its in
pipe_release()). We also continue to include EPOLLERR and EPOLLHUP by default
in any exclusive set. Thus, the user can specify EPOLLERR and/or EPOLLHUP but
is not required to do so.

Since epoll waiters may be interested in other events as well besides EPOLLIN,
EPOLLOUT, EPOLLERR and EPOLLHUP, these can still be added by doing a 'dup' call
on the target fd and adding that as one normally would with EPOLL_CTL_ADD. Since
I think that the POLLIN and POLLOUT events are what we are interest in balancing,
I think that the 'dup' thing could perhaps be added to only one of the waiter
threads. However, I think that EPOLLIN, EPOLLOUT, EPOLLERR and EPOLLHUP should
be sufficient for the majority of use-cases.

Since EPOLLEXCLUSIVE is intended to be used with a target fd shared among
multiple epfds, where between 1 and n of the epfds may receive an event, it
does not satisfy the semantics of EPOLLONESHOT where only 1 epfd would get an
event. Thus, it is not allowed to be specified in conjunction with
EPOLLEXCLUSIVE.

EPOLL_CTL_MOD is also not allowed if the fd was previously added as
EPOLLEXCLUSIVE. It seems with the limited number of flags to not be as
interesting, but this could be relaxed at some further point.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Tested-by: Madars Vitolins <m@silodev.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff -puN fs/eventpoll.c~epoll-restrict-epollexclusive-to-pollin-and-pollout fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-restrict-epollexclusive-to-pollin-and-pollout
+++ a/fs/eventpoll.c
@@ -94,6 +94,11 @@
 /* Epoll private bits inside the event mask */
 #define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET | EPOLLEXCLUSIVE)
 
+#define EPOLLINOUT_BITS (POLLIN | POLLOUT)
+
+#define EPOLLEXCLUSIVE_OK_BITS (EPOLLINOUT_BITS | POLLERR | POLLHUP | \
+				EPOLLWAKEUP | EPOLLET | EPOLLEXCLUSIVE)
+
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
 
@@ -1068,7 +1073,22 @@ static int ep_poll_callback(wait_queue_t
 	 * wait list.
 	 */
 	if (waitqueue_active(&ep->wq)) {
-		ewake = 1;
+		if ((epi->event.events & EPOLLEXCLUSIVE) &&
+					!((unsigned long)key & POLLFREE)) {
+			switch ((unsigned long)key & EPOLLINOUT_BITS) {
+			case POLLIN:
+				if (epi->event.events & POLLIN)
+					ewake = 1;
+				break;
+			case POLLOUT:
+				if (epi->event.events & POLLOUT)
+					ewake = 1;
+				break;
+			case 0:
+				ewake = 1;
+				break;
+			}
+		}
 		wake_up_locked(&ep->wq);
 	}
 	if (waitqueue_active(&ep->poll_wait))
@@ -1875,9 +1895,13 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
 	 * Also, we do not currently supported nested exclusive wakeups.
 	 */
-	if ((epds.events & EPOLLEXCLUSIVE) && (op == EPOLL_CTL_MOD ||
-		(op == EPOLL_CTL_ADD && is_file_epoll(tf.file))))
-		goto error_tgt_fput;
+	if (epds.events & EPOLLEXCLUSIVE) {
+		if (op == EPOLL_CTL_MOD)
+			goto error_tgt_fput;
+		if (op == EPOLL_CTL_ADD && (is_file_epoll(tf.file) ||
+				(epds.events & ~EPOLLEXCLUSIVE_OK_BITS)))
+			goto error_tgt_fput;
+	}
 
 	/*
 	 * At this point it is safe to assume that the "private_data" contains
@@ -1950,8 +1974,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 		break;
 	case EPOLL_CTL_MOD:
 		if (epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_modify(ep, epi, &epds);
+			if (!(epi->event.events & EPOLLEXCLUSIVE)) {
+				epds.events |= POLLERR | POLLHUP;
+				error = ep_modify(ep, epi, &epds);
+			}
 		} else
 			error = -ENOENT;
 		break;
_

Patches currently in -mm which might be from jbaron@akamai.com are

epoll-restrict-epollexclusive-to-pollin-and-pollout.patch


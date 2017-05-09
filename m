From: akpm@linux-foundation.org
Subject: +
 fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch
 added to -mm tree
Date: Tue, 09 May 2017 16:05:27 -0700
Message-ID: <59124b37.QxcdkXVASP/en2SD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdEIXF2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 19:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, davidel@xmailserver.org, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, epoll: short circuit fetching events if thread has been killed
has been added to the -mm tree.  Its filename is
     fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: fs, epoll: short circuit fetching events if thread has been killed

We've encountered zombies that are waiting for a thread to exit that are
looping in ep_poll() almost endlessly although there is a pending SIGKILL
as a result of a group exit.

This happens because we always find ep_events_available() and fetch more
events and never are able to check for signal_pending() that would break
from the loop and return -EINTR.

Special case fatal signals and break immediately to guarantee that we loop
to fetch more events and delay making a timely exit.

It would also be possible to simply move the check for signal_pending()
higher than checking for ep_events_available(), but there have been no
reports of delayed signal handling other than SIGKILL preventing zombies
from exiting that would be fixed by this.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1705031722350.76784@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/eventpoll.c~fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed fs/eventpoll.c
--- a/fs/eventpoll.c~fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed
+++ a/fs/eventpoll.c
@@ -1748,6 +1748,16 @@ fetch_events:
 			 * to TASK_INTERRUPTIBLE before doing the checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
+			/*
+			 * Always short-circuit for fatal signals to allow
+			 * threads to make a timely exit without the chance of
+			 * finding more events available and fetching
+			 * repeatedly.
+			 */
+			if (fatal_signal_pending(current)) {
+				res = -EINTR;
+				break;
+			}
 			if (ep_events_available(ep) || timed_out)
 				break;
 			if (signal_pending(current)) {
_

Patches currently in -mm which might be from rientjes@google.com are

fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch


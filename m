From: akpm@linux-foundation.org
Subject: [patch 107/115] fs, epoll: short circuit fetching events
 if thread has been killed
Date: Mon, 10 Jul 2017 15:52:33 -0700
Message-ID: <20170710225233.mDRfkyM5G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754867AbdGJWwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, jack@suse.cz, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

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

It fixes an issue for us where we have witnessed zombies sticking
around for at least O(minutes), but considering the code has been like
this forever and nobody else has complained that I have found, I would
simply queue it up for 4.12.

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

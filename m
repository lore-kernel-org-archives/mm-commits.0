From: akpm@linux-foundation.org
Subject: + epoll-optimize-setting-task-running-after-blocking.patch added
 to -mm tree
Date: Mon, 09 Feb 2015 13:46:07 -0800
Message-ID: <54d92a9f.xhRRjrc/4fYAicqA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761033AbbBIVqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2015 16:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: optimize setting task running after blocking
has been added to the -mm tree.  Its filename is
     epoll-optimize-setting-task-running-after-blocking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-optimize-setting-task-running-after-blocking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-optimize-setting-task-running-after-blocking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: epoll: optimize setting task running after blocking

After waking up a task waiting for an event, we explicitly mark it as
TASK_RUNNING (which is necessary as we do the checks for wakeups as
TASK_INTERRUPTABLE).  Once running and dealing with actually delivering
the events, we're obviously not planning on calling schedule, thus we can
relax the implied barrier and simply update the state with
__set_current_state().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-optimize-setting-task-running-after-blocking fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-optimize-setting-task-running-after-blocking
+++ a/fs/eventpoll.c
@@ -1639,9 +1639,9 @@ fetch_events:
 
 			spin_lock_irqsave(&ep->lock, flags);
 		}
-		__remove_wait_queue(&ep->wq, &wait);
 
-		set_current_state(TASK_RUNNING);
+		__remove_wait_queue(&ep->wq, &wait);
+		__set_current_state(TASK_RUNNING);
 	}
 check_events:
 	/* Is it worth to try to dig for events ? */
_

Patches currently in -mm which might be from dave@stgolabs.net are

epoll-optimize-setting-task-running-after-blocking.patch
signal-use-current-state-helpers.patch
ipcsem-use-current-state-helpers.patch
linux-next.patch


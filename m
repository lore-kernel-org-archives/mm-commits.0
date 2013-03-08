From: akpm@linux-foundation.org
Subject: + coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:21:02 -0800
Message-ID: <20130308212102.D8ACD31C1B7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:48876 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3CHVVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:21:04 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so4697qah.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:21:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: coredump: change wait_for_dump_helpers() to use wait_event_interruptible()
has been added to the -mm tree.  Its filename is
     coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: change wait_for_dump_helpers() to use wait_event_interruptible()

wait_for_dump_helpers() calls wake_up/kill_fasync from inside the
wait_event-like loop.  This is not needed and in fact this is not strictly
correct, we can/should do this only once after we change pipe->writers. 
We could even check if it becomes zero.

Change this code to use use wait_event_interruptible(), this can also help
to make this wait freezable.

With this patch we check pipe->readers without pipe_lock(), this is fine. 
Once we see pipe->readers == 1 we know that the handler decremented the
counter, this is all we need.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Neil Horman <nhorman@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/coredump.c~coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible fs/coredump.c
--- a/fs/coredump.c~coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible
+++ a/fs/coredump.c
@@ -439,17 +439,20 @@ static void wait_for_dump_helpers(struct
 	pipe_lock(pipe);
 	pipe->readers++;
 	pipe->writers--;
+	wake_up_interruptible_sync(&pipe->wait);
+	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+	pipe_unlock(pipe);
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
-		wake_up_interruptible_sync(&pipe->wait);
-		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-		pipe_wait(pipe);
-	}
+	/*
+	 * We actually want wait_event_freezable() but then we need
+	 * to clear TIF_SIGPENDING and improve dump_interrupted().
+	 */
+	wait_event_interruptible(pipe->wait, pipe->readers == 1);
 
+	pipe_lock(pipe);
 	pipe->readers--;
 	pipe->writers++;
 	pipe_unlock(pipe);

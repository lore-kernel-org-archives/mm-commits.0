From: akpm@linux-foundation.org
Subject: [merged] coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:38 -0700
Message-ID: <20130507174938.C226631C338@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:60623 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3EGRtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:40 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so85352yen.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: change wait_for_dump_helpers() to use wait_event_interruptible()
has been removed from the -mm tree.  Its filename was
     coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

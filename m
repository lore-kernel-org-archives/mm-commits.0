From: akpm@linux-foundation.org
Subject: [to-be-updated] coredump-make-wait_for_dump_helpers-freezable.patch removed from -mm tree
Date: Fri, 08 Mar 2013 13:07:54 -0800
Message-ID: <20130308210754.8EA5A5A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44420 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab3CHVHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:07:55 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so148907qcs.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:07:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: make wait_for_dump_helpers() freezable
has been removed from the -mm tree.  Its filename was
     coredump-make-wait_for_dump_helpers-freezable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: make wait_for_dump_helpers() freezable

wait_for_dump_helpers() calls wake_up/kill_fasync from inside the
wait_event-like loop.  This is not needed and in fact this is not strictly
correct, we can/should do this only once after we change pipe->writers. 
We could even check if it becomes zero.

With this change it is trivial to convert this code to use
wait_event_freezable() and make this function freezable/killable, only
SIGKILL can set TIF_SIGPENDING.

With this patch we check pipe->readers without pipe_lock(), this is fine. 
Once we see pipe->readers == 1 we know that the handler decremented the
counter, this is all we need.

Note: wait_event_freezable() is "strange", perhaps it should be changed or
simply removed.  In the latter case we can change this code again to use
freezer_do_not_count + wait_event_interruptible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Neil Horman <nhorman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/coredump.c~coredump-make-wait_for_dump_helpers-freezable fs/coredump.c
--- a/fs/coredump.c~coredump-make-wait_for_dump_helpers-freezable
+++ a/fs/coredump.c
@@ -32,6 +32,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -428,17 +429,16 @@ static void wait_for_dump_helpers(struct
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
+	wait_event_freezable(pipe->wait, pipe->readers == 1);
 
+	pipe_lock(pipe);
 	pipe->readers--;
 	pipe->writers++;
 	pipe_unlock(pipe);

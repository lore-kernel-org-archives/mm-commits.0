From: akpm@linux-foundation.org
Subject: + coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:33:04 -0800
Message-ID: <20130215233305.4871131C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:59415 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3BOXdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:33:06 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so404566vea.0
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:33:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benchan@chromium.org, mingo@redhat.com, msb@chromium.org, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: coredump: abort core dump piping only due to a fatal signal
has been added to the -mm tree.  Its filename is
     coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ben Chan <benchan@chromium.org>
Subject: coredump: abort core dump piping only due to a fatal signal

Make wait_for_dump_helpers() not abort piping the core dump data when the
crashing process has received a non-fatal signal.  The abort still occurs
in the case of SIGKILL.

The rationale is that a crashing process may still receive uninteresting
signals such as SIGCHLD when its core dump data is being redirected to a
helper application.  While it's necessary to allow terminating the core
dump piping via SIGKILL, it's practically more useful for the purpose of
debugging and crash reporting if the core dump piping is not aborted due
to other non-fatal signals.

Signed-off-by: Ben Chan <benchan@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/coredump.c~coredump-abort-core-dump-piping-only-due-to-a-fatal-signal fs/coredump.c
--- a/fs/coredump.c~coredump-abort-core-dump-piping-only-due-to-a-fatal-signal
+++ a/fs/coredump.c
@@ -32,6 +32,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -417,10 +418,13 @@ static void wait_for_dump_helpers(struct
 	pipe->readers++;
 	pipe->writers--;
 
-	while ((pipe->readers > 1) && (!signal_pending(current))) {
+	while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		pipe_wait(pipe);
+		pipe_unlock(pipe);
+		try_to_freeze();
+		pipe_lock(pipe);
 	}
 
 	pipe->readers--;
_

Patches currently in -mm which might be from benchan@chromium.org are

vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch


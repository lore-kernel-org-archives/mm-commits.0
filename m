From: akpm@linux-foundation.org
Subject: + coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:33:01 -0800
Message-ID: <20130215233302.1F5D65A4267@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35238 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3BOXdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:33:03 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so406153vch.2
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:33:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: coredump: use a freezable_schedule for the coredump_finish wait
has been added to the -mm tree.  Its filename is
     coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: coredump: use a freezable_schedule for the coredump_finish wait

Prevents hung_task detector from panicing the machine. This is also
needed to prevent this wait from blocking suspend.

(It doesnt' currently block suspend but it would once the next
patch in this series is applied.)

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~coredump-use-a-freezable_schedule-for-the-coredump_finish-wait kernel/exit.c
--- a/kernel/exit.c~coredump-use-a-freezable_schedule-for-the-coredump_finish-wait
+++ a/kernel/exit.c
@@ -20,6 +20,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/freezer.h>
 #include <linux/binfmts.h>
 #include <linux/nsproxy.h>
 #include <linux/pid_namespace.h>
@@ -483,7 +484,7 @@ static void exit_mm(struct task_struct *
 
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		if (self.task) /* see coredump_finish() */
-			schedule();
+			freezable_schedule();
 		__set_task_state(tsk, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
_

Patches currently in -mm which might be from msb@chromium.org are

vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch


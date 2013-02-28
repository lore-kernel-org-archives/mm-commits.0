From: akpm@linux-foundation.org
Subject: [merged] coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:52 -0800
Message-ID: <20130228201152.D0A945A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63929 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:54 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so244575vcd.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: use a freezable_schedule for the coredump_finish wait
has been removed from the -mm tree.  Its filename was
     coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: coredump: use a freezable_schedule for the coredump_finish wait

Prevents hung_task detector from panicing the machine. This is also
needed to prevent this wait from blocking suspend.

(It doesnt' currently block suspend but it would once the next
patch in this series is applied.)

[yongjun_wei@trendmicro.com.cn: kernel/exit.c: remove duplicated include]
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
@@ -31,7 +32,6 @@
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
-#include <linux/freezer.h>
 #include <linux/cgroup.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
@@ -485,7 +485,7 @@ static void exit_mm(struct task_struct *
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 			if (!self.task) /* see coredump_finish() */
 				break;
-			schedule();
+			freezable_schedule();
 		}
 		__set_task_state(tsk, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from msb@chromium.org are

origin.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch


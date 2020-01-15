From: akpm@linux-foundation.org
Subject: + mm-oom-dump-stack-of-victim-when-reaping-failed.patch
 added to -mm tree
Date: Tue, 14 Jan 2020 16:06:35 -0800
Message-ID: <20200115000635.O3y4wmhCg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgAOAGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:06:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com


The patch titled
     Subject: mm, oom: dump stack of victim when reaping failed
has been added to the -mm tree.  Its filename is
     mm-oom-dump-stack-of-victim-when-reaping-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-dump-stack-of-victim-when-reaping-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-dump-stack-of-victim-when-reaping-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: dump stack of victim when reaping failed

When a process cannot be oom reaped, for whatever reason, currently the
list of locks that are held is currently dumped to the kernel log.

Much more interesting is the stack trace of the victim that cannot be
reaped.  If the stack trace is dumped, we have the ability to find related
occurrences in the same kernel code and hopefully solve the issue that is
making it wedged.

Dump the stack trace when a process fails to be oom reaped.

Link: http://lkml.kernel.org/r/alpine.DEB.2.21.2001141519280.200484@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/oom_kill.c~mm-oom-dump-stack-of-victim-when-reaping-failed
+++ a/mm/oom_kill.c
@@ -26,6 +26,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
 #include <linux/sched/task.h>
+#include <linux/sched/debug.h>
 #include <linux/swap.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
@@ -619,6 +620,7 @@ static void oom_reap_task(struct task_st
 
 	pr_info("oom_reaper: unable to reap pid:%d (%s)\n",
 		task_pid_nr(tsk), tsk->comm);
+	sched_show_task(tsk);
 	debug_show_all_locks();
 
 done:
_

Patches currently in -mm which might be from rientjes@google.com are

mm-oom-dump-stack-of-victim-when-reaping-failed.patch

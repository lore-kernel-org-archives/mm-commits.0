From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 061/118] mm, oom: dump stack of victim when
 reaping failed
Date: Thu, 30 Jan 2020 22:14:26 -0800
Message-ID: <20200131061426.VAJIy6dqS%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGO2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:28 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, torvalds@linux-foundation.org

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
Acked-by: Michal Hocko <mhocko@suse.com>
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
@@ -620,6 +621,7 @@ static void oom_reap_task(struct task_st
 
 	pr_info("oom_reaper: unable to reap pid:%d (%s)\n",
 		task_pid_nr(tsk), tsk->comm);
+	sched_show_task(tsk);
 	debug_show_all_locks();
 
 done:
_

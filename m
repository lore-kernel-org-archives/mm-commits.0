From: akpm@linux-foundation.org
Subject: [merged] oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:20 -0800
Message-ID: <200912162033.nBGKXKRj012926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763013AbZLPUd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:33:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom-kill: show virtual size and rss information of the killed process
has been removed from the -mm tree.  Its filename was
     oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom-kill: show virtual size and rss information of the killed process
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

In a typical oom analysis scenario, we frequently want to know whether the
killed process has a memory leak or not at the first step.  This patch
adds vsz and rss information to the oom log to help this analysis.  To
save time for the debugging.

example:
===================================================================
rsyslogd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
Pid: 1308, comm: rsyslogd Not tainted 2.6.32-rc6 #24
Call Trace:
[<ffffffff8132e35b>] ?_spin_unlock+0x2b/0x40
[<ffffffff810f186e>] oom_kill_process+0xbe/0x2b0

(snip)

492283 pages non-shared
Out of memory: kill process 2341 (memhog) score 527276 or a child
Killed process 2341 (memhog) vsz:1054552kB, anon-rss:970588kB, file-rss:4kB
===========================================================================
                             ^
                             |
                            here

[rientjes@google.com: fix race, add pid & comm to message]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-show-virtual-size-and-rss-information-of-the-killed-process
+++ a/mm/oom_kill.c
@@ -352,6 +352,8 @@ static void dump_header(gfp_t gfp_mask, 
 		dump_tasks(mem);
 }
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 /*
  * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
@@ -365,15 +367,23 @@ static void __oom_kill_task(struct task_
 		return;
 	}
 
+	task_lock(p);
 	if (!p->mm) {
 		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill an mm-less task!\n");
+		printk(KERN_WARNING "tried to kill an mm-less task %d (%s)!\n",
+			task_pid_nr(p), p->comm);
+		task_unlock(p);
 		return;
 	}
 
 	if (verbose)
-		printk(KERN_ERR "Killed process %d (%s)\n",
-				task_pid_nr(p), p->comm);
+		printk(KERN_ERR "Killed process %d (%s) "
+		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+		       task_pid_nr(p), p->comm,
+		       K(p->mm->total_vm),
+		       K(get_mm_counter(p->mm, anon_rss)),
+		       K(get_mm_counter(p->mm, file_rss)));
+	task_unlock(p);
 
 	/*
 	 * We give our sacrificial lamb high priority and access to
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


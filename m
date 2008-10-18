From: akpm@linux-foundation.org
Subject: - pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:14 -0700
Message-ID: <200810182319.m9INJEkF029439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYJRXTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid_ns: de_thread: kill the now unneeded ->child_reaper change
has been removed from the -mm tree.  Its filename was
     pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid_ns: de_thread: kill the now unneeded ->child_reaper change
From: Oleg Nesterov <oleg@tv-sign.ru>

de_thread() checks if the old leader was the ->child_reaper, this is not
possible any longer.  With the previous patch ->group_leader itself will
change ->child_reaper on exit.

Henceforth find_new_reaper() is the only function (apart from
initialization) which plays with ->child_reaper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/exec.c~pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change fs/exec.c
--- a/fs/exec.c~pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change
+++ a/fs/exec.c
@@ -825,8 +825,6 @@ static int de_thread(struct task_struct 
 			schedule();
 		}
 
-		if (unlikely(task_child_reaper(tsk) == leader))
-			task_active_pid_ns(tsk)->child_reaper = tsk;
 		/*
 		 * The only record we have of the real-time age of a
 		 * process, regardless of execs it's done, is start_time.
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch


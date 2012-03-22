From: akpm@linux-foundation.org
Subject: [merged] mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:27 -0700
Message-ID: <20120322201727.76550A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33426 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab2CVUR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:28 -0400
Received: by ggnd2 with SMTP id d2so401419ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not emit oom killer warning if chosen thread is already exiting
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: do not emit oom killer warning if chosen thread is already exiting

If a thread is chosen for oom kill and is already PF_EXITING, then the oom
killer simply sets TIF_MEMDIE and returns.  This allows the thread to have
access to memory reserves so that it may quickly exit.  This logic is
preceeded with a comment saying there's no need to alarm the sysadmin. 
This patch adds truth to that statement.

There's no need to emit any warning about the oom condition if the thread
is already exiting since it will not be killed.  In this condition, just
silently return the oom killer since its only giving access to memory
reserves and is otherwise a no-op.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting
+++ a/mm/oom_kill.c
@@ -445,9 +445,6 @@ static void oom_kill_process(struct task
 	struct mm_struct *mm;
 	unsigned int victim_points = 0;
 
-	if (printk_ratelimit())
-		dump_header(p, gfp_mask, order, memcg, nodemask);
-
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
@@ -457,6 +454,9 @@ static void oom_kill_process(struct task
 		return;
 	}
 
+	if (printk_ratelimit())
+		dump_header(p, gfp_mask, order, memcg, nodemask);
+
 	task_lock(p);
 	pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch


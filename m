From: akpm@linux-foundation.org
Subject: [patch 010/101] mm, oom: hide mm which is shared with kthread or
 global init
Date: Thu, 28 Jul 2016 15:45:01 -0700
Message-ID: <579a8aed.WGCJCHNvM4Cp+cEw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbcG1WpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:45:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: hide mm which is shared with kthread or global init

The only case where the oom_reaper is not triggered for the oom victim is
when it shares the memory with a kernel thread (aka use_mm) or with the
global init.  After "mm, oom: skip vforked tasks from being selected" the
victim cannot be a vforked task of the global init so we are left with
clone(CLONE_VM) (without CLONE_SIGHAND).  use_mm() users are quite rare as
well.

In order to help forward progress for the OOM killer, make sure that
this really rare case will not get in the way - we do this by hiding
the mm from the oom killer by setting MMF_OOM_REAPED flag for it. 
oom_scan_process_thread will ignore any TIF_MEMDIE task if it has
MMF_OOM_REAPED flag set to catch these oom victims.

After this patch we should guarantee forward progress for the OOM
killer even when the selected victim is sharing memory with a kernel
thread or global init as long as the victims mm is still alive.

Link: http://lkml.kernel.org/r/1466426628-15074-11-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init
+++ a/mm/oom_kill.c
@@ -283,10 +283,22 @@ enum oom_scan_t oom_scan_process_thread(
 
 	/*
 	 * This task already has access to memory reserves and is being killed.
-	 * Don't allow any other task to have access to the reserves.
-	 */
-	if (!is_sysrq_oom(oc) && atomic_read(&task->signal->oom_victims))
-		return OOM_SCAN_ABORT;
+	 * Don't allow any other task to have access to the reserves unless
+	 * the task has MMF_OOM_REAPED because chances that it would release
+	 * any memory is quite low.
+	 */
+	if (!is_sysrq_oom(oc) && atomic_read(&task->signal->oom_victims)) {
+		struct task_struct *p = find_lock_task_mm(task);
+		enum oom_scan_t ret = OOM_SCAN_ABORT;
+
+		if (p) {
+			if (test_bit(MMF_OOM_REAPED, &p->mm->flags))
+				ret = OOM_SCAN_CONTINUE;
+			task_unlock(p);
+		}
+
+		return ret;
+	}
 
 	/*
 	 * If task is allocating a lot of memory and has been marked to be
@@ -913,9 +925,14 @@ void oom_kill_process(struct oom_control
 			/*
 			 * We cannot use oom_reaper for the mm shared by this
 			 * process because it wouldn't get killed and so the
-			 * memory might be still used.
+			 * memory might be still used. Hide the mm from the oom
+			 * killer to guarantee OOM forward progress.
 			 */
 			can_oom_reap = false;
+			set_bit(MMF_OOM_REAPED, &mm->flags);
+			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
+					task_pid_nr(victim), victim->comm,
+					task_pid_nr(p), p->comm);
 			continue;
 		}
 		do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
_

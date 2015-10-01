From: akpm@linux-foundation.org
Subject: +
 mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
 added to -mm tree
Date: Thu, 01 Oct 2015 15:25:35 -0700
Message-ID: <560db2df.KqKcxCioVsHaKqBd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbJAWZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 18:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kwalker@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: fix the wrong task->mm == mm checks in oom_kill_process()
has been added to the -mm tree.  Its filename is
     mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-fix-the-wrong-task-mm-%3D%3D-mm-checks-in-oom_kill_process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-fix-the-wrong-task-mm-%3D%3D-mm-checks-in-oom_kill_process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/oom_kill: fix the wrong task->mm == mm checks in oom_kill_process()

Both "child->mm == mm" and "p->mm != mm" checks in oom_kill_process() are
wrong.  task->mm can be NULL if the task is the exited group leader.  This
means in particular that "kill sharing same memory" loop can miss a
process with a zombie leader which uses the same ->mm.

Note: the process_has_mm(child, p->mm) check is still not 100% correct,
p->mm can be NULL too.  This is minor, but probably deserves a fix or a
comment anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Stanislav Kozina <skozina@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process
+++ a/mm/oom_kill.c
@@ -483,6 +483,18 @@ void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
+static bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+{
+	struct task_struct *t;
+
+	for_each_thread(p, t) {
+		struct mm_struct *t_mm = READ_ONCE(t->mm);
+		if (t_mm)
+			return t_mm == mm;
+	}
+	return false;
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
@@ -530,7 +542,7 @@ void oom_kill_process(struct oom_control
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
 
-			if (child->mm == p->mm)
+			if (process_shares_mm(child, p->mm))
 				continue;
 			/*
 			 * oom_badness() returns 0 if the thread is unkillable
@@ -584,7 +596,7 @@ void oom_kill_process(struct oom_control
 	 */
 	rcu_read_lock();
 	for_each_process(p) {
-		if (p->mm != mm)
+		if (!process_shares_mm(p, mm))
 			continue;
 		if (same_thread_group(p, victim))
 			continue;
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch


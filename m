From: akpm@linux-foundation.org
Subject: + proc-fix-f_pos-overflows-in-first_tid.patch added to -mm tree
Date: Wed, 20 Nov 2013 14:53:10 -0800
Message-ID: <528d3d56.qJvyNkgr011YCugy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3KTWxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:53:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, snanda@chromium.org, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: + proc-fix-f_pos-overflows-in-first_tid.patch added to -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,snanda@chromium.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:53:10 -0800


The patch titled
     Subject: proc: fix ->f_pos overflows in first_tid()
has been added to the -mm tree.  Its filename is
     proc-fix-f_pos-overflows-in-first_tid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-f_pos-overflows-in-first_tid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-f_pos-overflows-in-first_tid.patch

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
Subject: proc: fix ->f_pos overflows in first_tid()

1. proc_task_readdir()->first_tid() path truncates f_pos to int, this
   is wrong even on 64bit.

   We could check that f_pos < PID_MAX or even INT_MAX in
   proc_task_readdir(), but this patch simply checks the potential
   overflow in first_tid(), this check is nop on 64bit.  We do not care if
   it was negative and the new unsigned value is huge, all we need to
   ensure is that we never wrongly return !NULL.

2. Remove the 2nd "nr != 0" check before get_nr_threads(),
   nr_threads == 0 is not distinguishable from !pid_task() above.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~proc-fix-f_pos-overflows-in-first_tid fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-f_pos-overflows-in-first_tid
+++ a/fs/proc/base.c
@@ -3091,10 +3091,14 @@ out_no_task:
  * In the case of a seek we start with the leader and walk nr
  * threads past it.
  */
-static struct task_struct *first_tid(struct pid *pid, int tid,
-					int nr, struct pid_namespace *ns)
+static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
+					struct pid_namespace *ns)
 {
 	struct task_struct *pos, *task;
+	unsigned long nr = f_pos;
+
+	if (nr != f_pos)	/* 32bit overflow? */
+		return NULL;
 
 	rcu_read_lock();
 	task = pid_task(pid, PIDTYPE_PID);
@@ -3102,14 +3106,14 @@ static struct task_struct *first_tid(str
 		goto fail;
 
 	/* Attempt to start with the tid of a thread */
-	if (tid && (nr > 0)) {
+	if (tid && nr) {
 		pos = find_task_by_pid_ns(tid, ns);
 		if (pos && same_thread_group(pos, task))
 			goto found;
 	}
 
 	/* If nr exceeds the number of threads there is nothing todo */
-	if (nr && nr >= get_nr_threads(task))
+	if (nr >= get_nr_threads(task))
 		goto fail;
 
 	/* If we haven't found our starting place yet start
@@ -3117,7 +3121,7 @@ static struct task_struct *first_tid(str
 	 */
 	pos = task = task->group_leader;
 	do {
-		if (nr-- <= 0)
+		if (!nr--)
 			goto found;
 	} while_each_thread(task, pos);
 fail:
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exit_state-kill-task_is_dead.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
fork-no-need-to-initialize-child-exit_state.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + proc-task_state-read-cred-group_info-outside-of-task_lock.patch added to -mm tree
Date: Wed, 12 Nov 2014 14:56:16 -0800
Message-ID: <5463e590.HvshkJ/68LTu1XMx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaKLW4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: task_state: read cred->group_info outside of task_lock()
has been added to the -mm tree.  Its filename is
     proc-task_state-read-cred-group_info-outside-of-task_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-task_state-read-cred-group_info-outside-of-task_lock.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/proc-task_state-read-cred-group_info-outside-of-task_lock.patch

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
Subject: proc: task_state: read cred->group_info outside of task_lock()

task_state() reads cred->group_info under task_lock() because a long ago
it was task_struct->group_info and it was actually protected by
task->alloc_lock.  Today this task_unlock() after rcu_read_unlock() just
adds the confusion, move task_unlock() up.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/array.c~proc-task_state-read-cred-group_info-outside-of-task_lock fs/proc/array.c
--- a/fs/proc/array.c~proc-task_state-read-cred-group_info-outside-of-task_lock
+++ a/fs/proc/array.c
@@ -201,11 +201,10 @@ static inline void task_state(struct seq
 		"FDSize:\t%d\n"
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
+	task_unlock(p);
 	rcu_read_unlock();
 
 	group_info = cred->group_info;
-	task_unlock(p);
-
 	for (g = 0; g < group_info->ngroups; g++)
 		seq_printf(m, "%d ",
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
_

Patches currently in -mm which might be from oleg@redhat.com are

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
proc-task_state-read-cred-group_info-outside-of-task_lock.patch
proc-task_state-deuglify-the-max_fds-calculation.patch
proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
proc-task_state-ptrace_parent-doesnt-need-pid_alive-check.patch
sched_show_task-fix-unsafe-usage-of-real_parent.patch
exit-reparent-use-ptrace_entry-rather-than-sibling-for-exit_dead-tasks.patch
exit-reparent-cleanup-the-changing-of-parent.patch
exit-reparent-cleanup-the-usage-of-reparent_leader.patch
exit-ptrace-shift-reap-dead-code-from-exit_ptrace-to-forget_original_parent.patch
usermodehelper-dont-use-clone_vfork-for-____call_usermodehelper.patch
usermodehelper-kill-the-kmod_thread_locker-logic.patch
linux-next.patch


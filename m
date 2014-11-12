From: akpm@linux-foundation.org
Subject: + proc-task_state-deuglify-the-max_fds-calculation.patch added to -mm tree
Date: Wed, 12 Nov 2014 14:56:18 -0800
Message-ID: <5463e592.bnk45TwgnA6+w+KX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaKLW4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 17:56:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: task_state: deuglify the max_fds calculation
has been added to the -mm tree.  Its filename is
     proc-task_state-deuglify-the-max_fds-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-task_state-deuglify-the-max_fds-calculation.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/proc-task_state-deuglify-the-max_fds-calculation.patch

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
Subject: proc: task_state: deuglify the max_fds calculation

1. The usage of fdt looks very ugly, it can't be NULL if ->files is
   not NULL. We can use "unsigned int max_fds" instead.

2. This also allows to move seq_printf(max_fds) outside of task_lock()
   and join it with the previous seq_printf(). See also the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN fs/proc/array.c~proc-task_state-deuglify-the-max_fds-calculation fs/proc/array.c
--- a/fs/proc/array.c~proc-task_state-deuglify-the-max_fds-calculation
+++ a/fs/proc/array.c
@@ -157,9 +157,9 @@ static inline void task_state(struct seq
 	struct user_namespace *user_ns = seq_user_ns(m);
 	struct group_info *group_info;
 	int g;
-	struct fdtable *fdt = NULL;
 	const struct cred *cred;
 	pid_t ppid, tpid;
+	unsigned int max_fds = 0;
 
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
@@ -171,6 +171,12 @@ static inline void task_state(struct seq
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
 	cred = get_task_cred(p);
+
+	task_lock(p);
+	if (p->files)
+		max_fds = files_fdtable(p->files)->max_fds;
+	task_unlock(p);
+
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -179,7 +185,8 @@ static inline void task_state(struct seq
 		"PPid:\t%d\n"
 		"TracerPid:\t%d\n"
 		"Uid:\t%d\t%d\t%d\t%d\n"
-		"Gid:\t%d\t%d\t%d\t%d\n",
+		"Gid:\t%d\t%d\t%d\t%d\n"
+		"FDSize:\t%d\nGroups:\t",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
 		task_numa_group_id(p),
@@ -192,16 +199,8 @@ static inline void task_state(struct seq
 		from_kgid_munged(user_ns, cred->gid),
 		from_kgid_munged(user_ns, cred->egid),
 		from_kgid_munged(user_ns, cred->sgid),
-		from_kgid_munged(user_ns, cred->fsgid));
-
-	task_lock(p);
-	if (p->files)
-		fdt = files_fdtable(p->files);
-	seq_printf(m,
-		"FDSize:\t%d\n"
-		"Groups:\t",
-		fdt ? fdt->max_fds : 0);
-	task_unlock(p);
+		from_kgid_munged(user_ns, cred->fsgid),
+		max_fds);
 	rcu_read_unlock();
 
 	group_info = cred->group_info;
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


From: akpm@linux-foundation.org
Subject: [merged]
 proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:08 -0800
Message-ID: <5489e940.K+3iEL29N1UZlG8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505AbaLKS6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, adobriyan@gmail.com, atomlin@redhat.com, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, roland@hack.frob.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: task_state: move the main seq_printf() outside of rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc: task_state: move the main seq_printf() outside of rcu_read_lock()

task_state() does seq_printf() under rcu_read_lock(), but this is only
needed for task_tgid_nr_ns() and task_numa_group_id().  We can calculate
tgid/ngid and drop rcu lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
Cc: Sterling Alexander <stalexan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@hack.frob.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/proc/array.c~proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock fs/proc/array.c
--- a/fs/proc/array.c~proc-task_state-move-the-main-seq_printf-outside-of-rcu_read_lock
+++ a/fs/proc/array.c
@@ -158,7 +158,7 @@ static inline void task_state(struct seq
 	struct group_info *group_info;
 	int g;
 	const struct cred *cred;
-	pid_t ppid, tpid;
+	pid_t ppid, tpid, tgid, ngid;
 	unsigned int max_fds = 0;
 
 	rcu_read_lock();
@@ -170,12 +170,16 @@ static inline void task_state(struct seq
 		if (tracer)
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
+
+	tgid = task_tgid_nr_ns(p, ns);
+	ngid = task_numa_group_id(p);
 	cred = get_task_cred(p);
 
 	task_lock(p);
 	if (p->files)
 		max_fds = files_fdtable(p->files)->max_fds;
 	task_unlock(p);
+	rcu_read_unlock();
 
 	seq_printf(m,
 		"State:\t%s\n"
@@ -188,10 +192,7 @@ static inline void task_state(struct seq
 		"Gid:\t%d\t%d\t%d\t%d\n"
 		"FDSize:\t%d\nGroups:\t",
 		get_task_state(p),
-		task_tgid_nr_ns(p, ns),
-		task_numa_group_id(p),
-		pid_nr_ns(pid, ns),
-		ppid, tpid,
+		tgid, ngid, pid_nr_ns(pid, ns), ppid, tpid,
 		from_kuid_munged(user_ns, cred->uid),
 		from_kuid_munged(user_ns, cred->euid),
 		from_kuid_munged(user_ns, cred->suid),
@@ -201,7 +202,6 @@ static inline void task_state(struct seq
 		from_kgid_munged(user_ns, cred->sgid),
 		from_kgid_munged(user_ns, cred->fsgid),
 		max_fds);
-	rcu_read_unlock();
 
 	group_info = cred->group_info;
 	for (g = 0; g < group_info->ngroups; g++)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch


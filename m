Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234BE405C53
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779146057; cv=none; b=RRl0rvzNb9ZPj7qE49mG+tr9NNoFw7n3DVxQygPxv9Z7DCy9zdqPMvEZMf6cuULqxE+JHhhFFV+XEEaECkbU93ZHBX9KL6QBhBs9SGLxizZEOtuVGtPF9sL1XrIg5v2+Cr01xWvCn8KyIHIilxXttS5/iPNtTfZ7wESwfUOxF0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779146057; c=relaxed/simple;
	bh=q8Y7TOn4wUJD84l8FaEdSUSjnEDcUyTNmiyckOxnFJY=;
	h=Date:To:From:Subject:Message-Id; b=TUYc3aALjqjFmB2sKTQFyWV4SiWEjarv3lXAB2ytopKWFVY72QvBzaC+jQb0dqUNCR4T5MMqRvzA/mytY2jnWAuRgP9NaFu/xB4iaLlkvqIzVuzztLGV2a5L+OOk0FbseX+ROAbgsLpl7k6HGxu3jmaf6cTwg5liMPwOKE6BaYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMWVFjEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMWVFjEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB8EC2BCB7;
	Mon, 18 May 2026 23:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779146057;
	bh=q8Y7TOn4wUJD84l8FaEdSUSjnEDcUyTNmiyckOxnFJY=;
	h=Date:To:From:Subject:From;
	b=kMWVFjEGtOnB77jIf2wYEBovarXVQR4IdwuW78QrVJBgKL2A+3riqM+qMgszpLiWF
	 P3dxoG4ZSHlQ4IKhprZ18TBd7veQnTGfwRFk6oWg8PKycP7ke/A/d00Ln+UPGB2gds
	 QK1bXkWzwvDSGY01GFu7NmzXPu/Y/jenTXwrprdE=
Date: Mon, 18 May 2026 16:14:16 -0700
To: mm-commits@vger.kernel.org,timmurray@google.com,surenb@google.com,mhocko@suse.com,lkp@intel.com,hca@linux.ibm.com,david@kernel.org,brauner@kernel.org,minchan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch removed from -mm tree
Message-Id: <20260518231416.DFB8EC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
has been removed from the -mm tree.  Its filename was
     mm-process_mrelease-introduce-process_mrelease_reap_kill-flag.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
Date: Mon, 11 May 2026 14:42:26 -0700

Currently, process_mrelease() requires userspace to send a SIGKILL signal
prior to invocation.  This separation introduces a scheduling race window
where the victim task may receive the signal and enter the exit path
before the reaper can invoke process_mrelease().

When the victim enters the exit path (do_exit -> exit_mm), it clears its
task->mm immediately.  This causes process_mrelease() to fail with -ESRCH,
leaving the actual address space teardown (exit_mmap) to be deferred until
the mm's reference count drops to zero.  In the field (e.g., Android),
arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
remote VM accesses) frequently delay this teardown indefinitely, defeating
the purpose of expedited reclamation.

In Android's LMKD scenarios, this delay keeps memory pressure high,
forcing the system to unnecessarily kill additional innocent background
apps before the memory from the first victim is recovered.

This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
an integrated auto-kill mode.  When specified, process_mrelease() directly
injects a SIGKILL into the target task after finding its mm.

To solve the race condition, we grab the mm reference via mmgrab() before
sending the SIGKILL.  If the user passed PROCESS_MRELEASE_REAP_KILL, we
assume it will free its memory and proceed with reaping, making the logic
as simple as reap = reap_kill || task_will_free_mem(p).

To handle shared address spaces, we deliver SIGKILL to all processes
sharing the same address space using do_pidfd_send_signal_pidns().  This
ensures the target pid resides inside the caller's PID namespace hierarchy
prior to signal delivery.  We iterate over all processes sharing the mm
and deliver SIGKILL to each.  If delivering the signal to any of the
sharing processes fails, we return an error.  Note that this approach may
leave partial side-effects if some processes are killed successfully
before a failure occurs.

[akpm@linux-foundation.org: move kill_all_shared_mm() inside CONFIG_MMU]
  Reported-by: kernel test robot <lkp@intel.com>
  Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com
Link: https://lore.kernel.org/20260511214226.937793-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h    |    4 ++
 include/uapi/linux/mman.h |    4 ++
 kernel/signal.c           |   29 ++++++++++++++++--
 mm/oom_kill.c             |   55 +++++++++++++++++++++++++++++++-----
 4 files changed, 81 insertions(+), 11 deletions(-)

--- a/include/linux/signal.h~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag
+++ a/include/linux/signal.h
@@ -276,6 +276,8 @@ static inline int valid_signal(unsigned
 
 struct timespec;
 struct pt_regs;
+struct mm_struct;
+struct pid;
 enum pid_type;
 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
@@ -283,6 +285,8 @@ extern int do_send_sig_info(int sig, str
 				struct task_struct *p, enum pid_type type);
 extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
 			       struct task_struct *p, enum pid_type type);
+extern int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
+				      siginfo_t __user *info, unsigned int flags);
 extern int send_signal_locked(int sig, struct kernel_siginfo *info,
 			      struct task_struct *p, enum pid_type type);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
--- a/include/uapi/linux/mman.h~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag
+++ a/include/uapi/linux/mman.h
@@ -56,4 +56,8 @@ struct cachestat {
 	__u64 nr_recently_evicted;
 };
 
+/* Flags for process_mrelease */
+#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
+#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
+
 #endif /* _UAPI_LINUX_MMAN_H */
--- a/kernel/signal.c~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag
+++ a/kernel/signal.c
@@ -4050,6 +4050,30 @@ static int do_pidfd_send_signal(struct p
 }
 
 /**
+ * do_pidfd_send_signal_pidns - Send a signal to a process via its struct pid
+ *                              while validating PID namespace hierarchy.
+ * @pid:   the struct pid of the target process
+ * @sig:   signal to send
+ * @type:  scope of the signal (e.g. PIDTYPE_TGID)
+ * @info:  signal info payload
+ * @flags: signaling flags
+ *
+ * Verify that the target pid resides inside the caller's PID namespace
+ * hierarchy prior to signal delivery.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
+			       siginfo_t __user *info, unsigned int flags)
+{
+	/* Enforce PID namespace hierarchy boundary */
+	if (!access_pidfd_pidns(pid))
+		return -EINVAL;
+
+	return do_pidfd_send_signal(pid, sig, type, info, flags);
+}
+
+/**
  * sys_pidfd_send_signal - Signal a process through a pidfd
  * @pidfd:  file descriptor of the process
  * @sig:    signal to send
@@ -4097,16 +4121,13 @@ SYSCALL_DEFINE4(pidfd_send_signal, int,
 		if (IS_ERR(pid))
 			return PTR_ERR(pid);
 
-		if (!access_pidfd_pidns(pid))
-			return -EINVAL;
-
 		/* Infer scope from the type of pidfd. */
 		if (fd_file(f)->f_flags & PIDFD_THREAD)
 			type = PIDTYPE_PID;
 		else
 			type = PIDTYPE_TGID;
 
-		return do_pidfd_send_signal(pid, sig, type, info, flags);
+		return do_pidfd_send_signal_pidns(pid, sig, type, info, flags);
 	}
 	}
 
--- a/mm/oom_kill.c~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag
+++ a/mm/oom_kill.c
@@ -20,6 +20,7 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <uapi/linux/mman.h>
 #include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
@@ -675,6 +676,39 @@ static void wake_oom_reaper(struct timer
 }
 
 /*
+ * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
+ * @victim: the targeted OOM process group leader
+ * @mm:     the virtual memory space being reaped
+ *
+ * Traverse all threads globally and signal any user processes sharing the
+ * identical mm footprints, ensuring no concurrent users pin the memory. Skips
+ * the system global init and kernel worker threads.
+ */
+static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
+{
+	struct task_struct *p;
+	bool failed = false;
+
+	rcu_read_lock();
+	for_each_process(p) {
+		if (!process_shares_mm(p, mm))
+			continue;
+		if (is_global_init(p)) {
+			failed = true;
+			continue;
+		}
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+
+		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
+			failed = true;
+	}
+	rcu_read_unlock();
+
+	return failed ? -EBUSY : 0;
+}
+
+/*
  * Give the OOM victim time to exit naturally before invoking the oom_reaping.
  * The timers timeout is arbitrary... the longer it is, the longer the worst
  * case scenario for the OOM can take. If it is too small, the oom_reaper can
@@ -1201,9 +1235,11 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	unsigned int f_flags;
 	bool reap = false;
 	long ret = 0;
+	bool reap_kill;
 
-	if (flags)
+	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
 		return -EINVAL;
+	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
 
 	task = pidfd_get_task(pidfd, &f_flags);
 	if (IS_ERR(task))
@@ -1220,19 +1256,24 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	}
 
 	mm = p->mm;
-	mmgrab(mm);
 
-	if (task_will_free_mem(p))
-		reap = true;
-	else {
+	reap = reap_kill || task_will_free_mem(p);
+	if (!reap) {
 		/* Error only if the work has not been done already */
 		if (!mm_flags_test(MMF_OOM_SKIP, mm))
 			ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
 	}
+
+	mmgrab(mm);
 	task_unlock(p);
 
-	if (!reap)
-		goto drop_mm;
+	if (reap_kill) {
+		ret = kill_all_shared_mm(task, mm);
+		if (ret)
+			goto drop_mm;
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		ret = -EINTR;
_

Patches currently in -mm which might be from minchan@kernel.org are



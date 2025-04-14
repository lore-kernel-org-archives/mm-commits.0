Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E576919995D
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 21:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744666703; cv=none; b=cJh94PebygH5IBdRGc5V+DbYWa1x3j1ZhRewC6uBFYS7vMu9q2v3JZvXlP+85HMZ0nsmV9/m9LbLuV4UaugoCQeY2ng+vLIYnQNCPZPlAQ5ssct+1u8JIuDV8C7HurwmRyuL+aH/PTfxw3y3+O4Ig73KL+FpY4UobLoZ2P/xWbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744666703; c=relaxed/simple;
	bh=eLiVhI5XBO97ctXgnKtE/3HtQ6OY6HwinEwvYts4a0k=;
	h=Date:To:From:Subject:Message-Id; b=pvOuHDOgA1B/vLSqcHmuPB9yUJCoxI16dxwIRj4UBE/iw0zjkPjHDXBXDKmSHu35Y+/HUJ6l7SOXRIhtYo52Xwep/+dyd8JgLM8x8w5vUBh1+bn34PJSvrm04R85cGjIExy18qrgFKae3GjTKewC5F8bjMeOFToZnBox5DnuFHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lWiPx5Ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lWiPx5Ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E246C4CEE2;
	Mon, 14 Apr 2025 21:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744666702;
	bh=eLiVhI5XBO97ctXgnKtE/3HtQ6OY6HwinEwvYts4a0k=;
	h=Date:To:From:Subject:From;
	b=lWiPx5Eexxg4eVXskGn6mqMEEca3JShx5zZUv+/o/KHNXqZFuQvHj6HMq8YoPc5rD
	 TMDCa4oEpvsPCguq8MR6B8NCxQXycBruB0lkfIz6XHXrq5M9hhHbbPQepMGYB+IOIb
	 n3f2fWo77gWNo+B0KUhbNgJjmHVxSYYe6QkGPBl8=
Date: Mon, 14 Apr 2025 14:38:21 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,peterz@infradead.org,mingzhe.yang@ly.com,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jstultz@google.com,joel.granados@kernel.org,boqun.feng@gmail.com,anna.schumaker@oracle.com,amaindex@outlook.com,akpm@linux-foundation.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore.patch added to mm-nonmm-unstable branch
Message-Id: <20250414213822.4E246C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: show the blocker task if the task is hung on semaphore
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: hung_task: show the blocker task if the task is hung on semaphore
Date: Mon, 14 Apr 2025 22:59:44 +0800

Inspired by mutex blocker tracking[1], this patch makes a trade-off to
balance the overhead and utility of the hung task detector.

Unlike mutexes, semaphores lack explicit ownership tracking, making it
challenging to identify the root cause of hangs.  To address this, we
introduce a last_holder field to the semaphore structure, which is updated
when a task successfully calls down() and cleared during up().

The assumption is that if a task is blocked on a semaphore, the holders
must not have released it.  While this does not guarantee that the last
holder is one of the current blockers, it likely provides a practical hint
for diagnosing semaphore-related stalls.

With this change, the hung task detector can now show blocker task's info
like below:

[Tue Apr  8 12:19:07 2025] INFO: task cat:945 blocked for more than 120 seconds.
[Tue Apr  8 12:19:07 2025]       Tainted: G            E      6.14.0-rc6+ #1
[Tue Apr  8 12:19:07 2025] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Apr  8 12:19:07 2025] task:cat             state:D stack:0     pid:945   tgid:945   ppid:828    task_flags:0x400000 flags:0x00000000
[Tue Apr  8 12:19:07 2025] Call Trace:
[Tue Apr  8 12:19:07 2025]  <TASK>
[Tue Apr  8 12:19:07 2025]  __schedule+0x491/0xbd0
[Tue Apr  8 12:19:07 2025]  schedule+0x27/0xf0
[Tue Apr  8 12:19:07 2025]  schedule_timeout+0xe3/0xf0
[Tue Apr  8 12:19:07 2025]  ? __folio_mod_stat+0x2a/0x80
[Tue Apr  8 12:19:07 2025]  ? set_ptes.constprop.0+0x27/0x90
[Tue Apr  8 12:19:07 2025]  __down_common+0x155/0x280
[Tue Apr  8 12:19:07 2025]  down+0x53/0x70
[Tue Apr  8 12:19:07 2025]  read_dummy_semaphore+0x23/0x60
[Tue Apr  8 12:19:07 2025]  full_proxy_read+0x5f/0xa0
[Tue Apr  8 12:19:07 2025]  vfs_read+0xbc/0x350
[Tue Apr  8 12:19:07 2025]  ? __count_memcg_events+0xa5/0x140
[Tue Apr  8 12:19:07 2025]  ? count_memcg_events.constprop.0+0x1a/0x30
[Tue Apr  8 12:19:07 2025]  ? handle_mm_fault+0x180/0x260
[Tue Apr  8 12:19:07 2025]  ksys_read+0x66/0xe0
[Tue Apr  8 12:19:07 2025]  do_syscall_64+0x51/0x120
[Tue Apr  8 12:19:07 2025]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[Tue Apr  8 12:19:07 2025] RIP: 0033:0x7f419478f46e
[Tue Apr  8 12:19:07 2025] RSP: 002b:00007fff1c4d2668 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[Tue Apr  8 12:19:07 2025] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f419478f46e
[Tue Apr  8 12:19:07 2025] RDX: 0000000000020000 RSI: 00007f4194683000 RDI: 0000000000000003
[Tue Apr  8 12:19:07 2025] RBP: 00007f4194683000 R08: 00007f4194682010 R09: 0000000000000000
[Tue Apr  8 12:19:07 2025] R10: fffffffffffffbc5 R11: 0000000000000246 R12: 0000000000000000
[Tue Apr  8 12:19:07 2025] R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
[Tue Apr  8 12:19:07 2025]  </TASK>
[Tue Apr  8 12:19:07 2025] INFO: task cat:945 blocked on a semaphore likely last held by task cat:938
[Tue Apr  8 12:19:07 2025] task:cat             state:S stack:0     pid:938   tgid:938   ppid:584    task_flags:0x400000 flags:0x00000000
[Tue Apr  8 12:19:07 2025] Call Trace:
[Tue Apr  8 12:19:07 2025]  <TASK>
[Tue Apr  8 12:19:07 2025]  __schedule+0x491/0xbd0
[Tue Apr  8 12:19:07 2025]  ? _raw_spin_unlock_irqrestore+0xe/0x40
[Tue Apr  8 12:19:07 2025]  schedule+0x27/0xf0
[Tue Apr  8 12:19:07 2025]  schedule_timeout+0x77/0xf0
[Tue Apr  8 12:19:07 2025]  ? __pfx_process_timeout+0x10/0x10
[Tue Apr  8 12:19:07 2025]  msleep_interruptible+0x49/0x60
[Tue Apr  8 12:19:07 2025]  read_dummy_semaphore+0x2d/0x60
[Tue Apr  8 12:19:07 2025]  full_proxy_read+0x5f/0xa0
[Tue Apr  8 12:19:07 2025]  vfs_read+0xbc/0x350
[Tue Apr  8 12:19:07 2025]  ? __count_memcg_events+0xa5/0x140
[Tue Apr  8 12:19:07 2025]  ? count_memcg_events.constprop.0+0x1a/0x30
[Tue Apr  8 12:19:07 2025]  ? handle_mm_fault+0x180/0x260
[Tue Apr  8 12:19:07 2025]  ksys_read+0x66/0xe0
[Tue Apr  8 12:19:07 2025]  do_syscall_64+0x51/0x120
[Tue Apr  8 12:19:07 2025]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[Tue Apr  8 12:19:07 2025] RIP: 0033:0x7f7c584a646e
[Tue Apr  8 12:19:07 2025] RSP: 002b:00007ffdba8ce158 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[Tue Apr  8 12:19:07 2025] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f7c584a646e
[Tue Apr  8 12:19:07 2025] RDX: 0000000000020000 RSI: 00007f7c5839a000 RDI: 0000000000000003
[Tue Apr  8 12:19:07 2025] RBP: 00007f7c5839a000 R08: 00007f7c58399010 R09: 0000000000000000
[Tue Apr  8 12:19:07 2025] R10: fffffffffffffbc5 R11: 0000000000000246 R12: 0000000000000000
[Tue Apr  8 12:19:07 2025] R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
[Tue Apr  8 12:19:07 2025]  </TASK>

[1] https://lore.kernel.org/all/174046694331.2194069.15472952050240807469.stgit@mhiramat.tok.corp.google.com

Link: https://lkml.kernel.org/r/20250414145945.84916-3-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Cc: Zi Li <amaindex@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/semaphore.h  |   15 ++++++++-
 kernel/hung_task.c         |   52 +++++++++++++++++++++++++------
 kernel/locking/semaphore.c |   57 +++++++++++++++++++++++++++++++----
 3 files changed, 106 insertions(+), 18 deletions(-)

--- a/include/linux/semaphore.h~hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore
+++ a/include/linux/semaphore.h
@@ -16,13 +16,25 @@ struct semaphore {
 	raw_spinlock_t		lock;
 	unsigned int		count;
 	struct list_head	wait_list;
+
+#ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
+	unsigned long		last_holder;
+#endif
 };
 
+#ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
+#define __LAST_HOLDER_SEMAPHORE_INITIALIZER				\
+	, .last_holder = 0UL
+#else
+#define __LAST_HOLDER_SEMAPHORE_INITIALIZER
+#endif
+
 #define __SEMAPHORE_INITIALIZER(name, n)				\
 {									\
 	.lock		= __RAW_SPIN_LOCK_UNLOCKED((name).lock),	\
 	.count		= n,						\
-	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
+	.wait_list	= LIST_HEAD_INIT((name).wait_list)		\
+	__LAST_HOLDER_SEMAPHORE_INITIALIZER				\
 }
 
 /*
@@ -47,5 +59,6 @@ extern int __must_check down_killable(st
 extern int __must_check down_trylock(struct semaphore *sem);
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
+extern unsigned long sem_last_holder(struct semaphore *sem);
 
 #endif /* __LINUX_SEMAPHORE_H */
--- a/kernel/hung_task.c~hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore
+++ a/kernel/hung_task.c
@@ -99,32 +99,62 @@ static struct notifier_block panic_block
 static void debug_show_blocker(struct task_struct *task)
 {
 	struct task_struct *g, *t;
-	unsigned long owner, blocker;
+	unsigned long owner, blocker, blocker_type;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "No rcu lock held");
 
 	blocker = READ_ONCE(task->blocker);
-	if (!blocker ||
-	    hung_task_get_blocker_type(blocker) != BLOCKER_TYPE_MUTEX)
+	if (!blocker)
 		return;
 
-	owner = mutex_get_owner(
-		(struct mutex *)hung_task_blocker_to_lock(blocker));
+	blocker_type = hung_task_get_blocker_type(blocker);
+
+	switch (blocker_type) {
+	case BLOCKER_TYPE_MUTEX:
+		owner = mutex_get_owner(
+			(struct mutex *)hung_task_blocker_to_lock(blocker));
+		break;
+	case BLOCKER_TYPE_SEM:
+		owner = sem_last_holder(
+			(struct semaphore *)hung_task_blocker_to_lock(blocker));
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 
 	if (unlikely(!owner)) {
-		pr_err("INFO: task %s:%d is blocked on a mutex, but the owner is not found.\n",
-			task->comm, task->pid);
+		switch (blocker_type) {
+		case BLOCKER_TYPE_MUTEX:
+			pr_err("INFO: task %s:%d is blocked on a mutex, but the owner is not found.\n",
+			       task->comm, task->pid);
+			break;
+		case BLOCKER_TYPE_SEM:
+			pr_err("INFO: task %s:%d is blocked on a semaphore, but the last holder is not found.\n",
+			       task->comm, task->pid);
+			break;
+		}
 		return;
 	}
 
 	/* Ensure the owner information is correct. */
 	for_each_process_thread(g, t) {
-		if ((unsigned long)t == owner) {
+		if ((unsigned long)t != owner)
+			continue;
+
+		switch (blocker_type) {
+		case BLOCKER_TYPE_MUTEX:
 			pr_err("INFO: task %s:%d is blocked on a mutex likely owned by task %s:%d.\n",
-				task->comm, task->pid, t->comm, t->pid);
-			sched_show_task(t);
-			return;
+			       task->comm, task->pid, t->comm, t->pid);
+			break;
+		case BLOCKER_TYPE_SEM:
+			pr_err("INFO: task %s:%d blocked on a semaphore likely last held by task %s:%d\n",
+			       task->comm, task->pid, t->comm, t->pid);
+			break;
 		}
+		sched_show_task(t);
+		return;
 	}
 }
 #else
--- a/kernel/locking/semaphore.c~hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore
+++ a/kernel/locking/semaphore.c
@@ -34,6 +34,7 @@
 #include <linux/spinlock.h>
 #include <linux/ftrace.h>
 #include <trace/events/lock.h>
+#include <linux/hung_task.h>
 
 static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
@@ -41,6 +42,41 @@ static noinline int __down_killable(stru
 static noinline int __down_timeout(struct semaphore *sem, long timeout);
 static noinline void __up(struct semaphore *sem, struct wake_q_head *wake_q);
 
+#ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
+static inline void hung_task_sem_set_holder(struct semaphore *sem)
+{
+	WRITE_ONCE((sem)->last_holder, (unsigned long)current);
+}
+
+static inline void hung_task_sem_clear_if_holder(struct semaphore *sem)
+{
+	if (READ_ONCE((sem)->last_holder) == (unsigned long)current)
+		WRITE_ONCE((sem)->last_holder, 0UL);
+}
+
+unsigned long sem_last_holder(struct semaphore *sem)
+{
+	return READ_ONCE(sem->last_holder);
+}
+#else
+static inline void hung_task_sem_set_holder(struct semaphore *sem)
+{
+}
+static inline void hung_task_sem_clear_if_holder(struct semaphore *sem)
+{
+}
+unsigned long sem_last_holder(struct semaphore *sem)
+{
+	return 0UL;
+}
+#endif
+
+static inline void __sem_acquire(struct semaphore *sem)
+{
+	sem->count--;
+	hung_task_sem_set_holder(sem);
+}
+
 /**
  * down - acquire the semaphore
  * @sem: the semaphore to be acquired
@@ -59,7 +95,7 @@ void __sched down(struct semaphore *sem)
 	might_sleep();
 	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
-		sem->count--;
+		__sem_acquire(sem);
 	else
 		__down(sem);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
@@ -83,7 +119,7 @@ int __sched down_interruptible(struct se
 	might_sleep();
 	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
-		sem->count--;
+		__sem_acquire(sem);
 	else
 		result = __down_interruptible(sem);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
@@ -110,7 +146,7 @@ int __sched down_killable(struct semapho
 	might_sleep();
 	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
-		sem->count--;
+		__sem_acquire(sem);
 	else
 		result = __down_killable(sem);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
@@ -140,7 +176,7 @@ int __sched down_trylock(struct semaphor
 	raw_spin_lock_irqsave(&sem->lock, flags);
 	count = sem->count - 1;
 	if (likely(count >= 0))
-		sem->count = count;
+		__sem_acquire(sem);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
 
 	return (count < 0);
@@ -165,7 +201,7 @@ int __sched down_timeout(struct semaphor
 	might_sleep();
 	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
-		sem->count--;
+		__sem_acquire(sem);
 	else
 		result = __down_timeout(sem, timeout);
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
@@ -187,6 +223,9 @@ void __sched up(struct semaphore *sem)
 	DEFINE_WAKE_Q(wake_q);
 
 	raw_spin_lock_irqsave(&sem->lock, flags);
+
+	hung_task_sem_clear_if_holder(sem);
+
 	if (likely(list_empty(&sem->wait_list)))
 		sem->count++;
 	else
@@ -228,8 +267,10 @@ static inline int __sched ___down_common
 		raw_spin_unlock_irq(&sem->lock);
 		timeout = schedule_timeout(timeout);
 		raw_spin_lock_irq(&sem->lock);
-		if (waiter.up)
+		if (waiter.up) {
+			hung_task_sem_set_holder(sem);
 			return 0;
+		}
 	}
 
  timed_out:
@@ -246,10 +287,14 @@ static inline int __sched __down_common(
 {
 	int ret;
 
+	hung_task_set_blocker(sem, BLOCKER_TYPE_SEM);
+
 	trace_contention_begin(sem, 0);
 	ret = ___down_common(sem, state, timeout);
 	trace_contention_end(sem, ret);
 
+	hung_task_clear_blocker();
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are

hung_task-replace-blocker_mutex-with-encoded-blocker.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore.patch


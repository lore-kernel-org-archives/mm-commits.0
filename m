Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C982EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011358; cv=none; b=DYUWb7LQF311ppfGiIAYnG+kEdyaRh/F7/qv8F3vFa2zucVx/REIy+amFkQBUfetMUTb6Or1o6Tx16MjeCl5MiqKlgdKIl4zT0QVDDsRzlaMkQABL/+0aHxH1U9W1SESFohpGAdBnNbRRl8yPzhHy70OAvY5/C238IyY3VlVTSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011358; c=relaxed/simple;
	bh=mX9IMiHtsfCovE+Ia/NG7GVAU48QkadceAeXURmkO3w=;
	h=Date:To:From:Subject:Message-Id; b=mSUxOHxyflsRg1vIEB7akVmYLS9CNSQHs7nBroam2+yj8B4kRY01rvam/kSdUsYO0J5bRICFe7iWYBfWsl3ua0ESJuNwnoqtP5y9xml6YSgUUuBgSe15gtK1Hzp2B90Bgw76TDzwgkAXpYfCg0CQy6qCgTHJrjPDe2Tp5rxVpE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIWsbSas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIWsbSas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5604C4CEE4;
	Mon, 12 May 2025 00:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011357;
	bh=mX9IMiHtsfCovE+Ia/NG7GVAU48QkadceAeXURmkO3w=;
	h=Date:To:From:Subject:From;
	b=zIWsbSasNUz7x5gnJdw62CITHedl2y/OByEfnLAQUJWvfZp6PSsRrUnQ1yrxr+jTV
	 JCB0eKZh+Nn9lQR/lWnOB4cFecLw4HCcHqWQpvvGruwQKgxX3B6QGaJpQIdfnPFplC
	 omNpuLtroy3QwZkuZp3vEiQhSMf18PgiflxFrRJk=
Date: Sun, 11 May 2025 17:55:57 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,peterz@infradead.org,mingzhe.yang@ly.com,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jstultz@google.com,joel.granados@kernel.org,boqun.feng@gmail.com,anna.schumaker@oracle.com,amaindex@outlook.com,akpm@linux-foundation.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-replace-blocker_mutex-with-encoded-blocker.patch removed from -mm tree
Message-Id: <20250512005557.A5604C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: replace blocker_mutex with encoded blocker
has been removed from the -mm tree.  Its filename was
     hung_task-replace-blocker_mutex-with-encoded-blocker.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: hung_task: replace blocker_mutex with encoded blocker
Date: Mon, 14 Apr 2025 22:59:43 +0800

Patch series "hung_task: extend blocking task stacktrace dump to
semaphore", v5.

Inspired by mutex blocker tracking[1], this patch series extend the
feature to not only dump the blocker task holding a mutex but also to
support semaphores.  Unlike mutexes, semaphores lack explicit ownership
tracking, making it challenging to identify the root cause of hangs.  To
address this, we introduce a last_holder field to the semaphore structure,
which is updated when a task successfully calls down() and cleared during
up().

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


This patch (of 3):

This patch replaces 'struct mutex *blocker_mutex' with 'unsigned long
blocker', as only one blocker is active at a time.

The blocker filed can store both the lock addrees and the lock type, with
LSB used to encode the type as Masami suggested, making it easier to
extend the feature to cover other types of locks.

Also, once the lock type is determined, we can directly extract the
address and cast it to a lock pointer ;)

Link: https://lkml.kernel.org/r/20250414145945.84916-1-ioworker0@gmail.com
Link: https://lore.kernel.org/all/174046694331.2194069.15472952050240807469.stgit@mhiramat.tok.corp.google.com [1]
Link: https://lkml.kernel.org/r/20250414145945.84916-2-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
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

 include/linux/hung_task.h |   99 ++++++++++++++++++++++++++++++++++++
 include/linux/sched.h     |    6 +-
 kernel/hung_task.c        |   13 ++--
 kernel/locking/mutex.c    |    5 +
 4 files changed, 115 insertions(+), 8 deletions(-)

diff --git a/include/linux/hung_task.h a/include/linux/hung_task.h
new file mode 100644
--- /dev/null
+++ a/include/linux/hung_task.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Detect Hung Task: detecting tasks stuck in D state
+ *
+ * Copyright (C) 2025 Tongcheng Travel (www.ly.com)
+ * Author: Lance Yang <mingzhe.yang@ly.com>
+ */
+#ifndef __LINUX_HUNG_TASK_H
+#define __LINUX_HUNG_TASK_H
+
+#include <linux/bug.h>
+#include <linux/sched.h>
+#include <linux/compiler.h>
+
+/*
+ * @blocker: Combines lock address and blocking type.
+ *
+ * Since lock pointers are at least 4-byte aligned(32-bit) or 8-byte
+ * aligned(64-bit). This leaves the 2 least bits (LSBs) of the pointer
+ * always zero. So we can use these bits to encode the specific blocking
+ * type.
+ *
+ * Type encoding:
+ * 00 - Blocked on mutex        (BLOCKER_TYPE_MUTEX)
+ * 01 - Blocked on semaphore    (BLOCKER_TYPE_SEM)
+ * 10 - Blocked on rt-mutex     (BLOCKER_TYPE_RTMUTEX)
+ * 11 - Blocked on rw-semaphore (BLOCKER_TYPE_RWSEM)
+ */
+#define BLOCKER_TYPE_MUTEX      0x00UL
+#define BLOCKER_TYPE_SEM        0x01UL
+#define BLOCKER_TYPE_RTMUTEX    0x02UL
+#define BLOCKER_TYPE_RWSEM      0x03UL
+
+#define BLOCKER_TYPE_MASK       0x03UL
+
+#ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
+static inline void hung_task_set_blocker(void *lock, unsigned long type)
+{
+	unsigned long lock_ptr = (unsigned long)lock;
+
+	WARN_ON_ONCE(!lock_ptr);
+	WARN_ON_ONCE(READ_ONCE(current->blocker));
+
+	/*
+	 * If the lock pointer matches the BLOCKER_TYPE_MASK, return
+	 * without writing anything.
+	 */
+	if (WARN_ON_ONCE(lock_ptr & BLOCKER_TYPE_MASK))
+		return;
+
+	WRITE_ONCE(current->blocker, lock_ptr | type);
+}
+
+static inline void hung_task_clear_blocker(void)
+{
+	WARN_ON_ONCE(!READ_ONCE(current->blocker));
+
+	WRITE_ONCE(current->blocker, 0UL);
+}
+
+/*
+ * hung_task_get_blocker_type - Extracts blocker type from encoded blocker
+ * address.
+ *
+ * @blocker: Blocker pointer with encoded type (via LSB bits)
+ *
+ * Returns: BLOCKER_TYPE_MUTEX, BLOCKER_TYPE_SEM, etc.
+ */
+static inline unsigned long hung_task_get_blocker_type(unsigned long blocker)
+{
+	WARN_ON_ONCE(!blocker);
+
+	return blocker & BLOCKER_TYPE_MASK;
+}
+
+static inline void *hung_task_blocker_to_lock(unsigned long blocker)
+{
+	WARN_ON_ONCE(!blocker);
+
+	return (void *)(blocker & ~BLOCKER_TYPE_MASK);
+}
+#else
+static inline void hung_task_set_blocker(void *lock, unsigned long type)
+{
+}
+static inline void hung_task_clear_blocker(void)
+{
+}
+static inline unsigned long hung_task_get_blocker_type(unsigned long blocker)
+{
+	return 0UL;
+}
+static inline void *hung_task_blocker_to_lock(unsigned long blocker)
+{
+	return NULL;
+}
+#endif
+
+#endif /* __LINUX_HUNG_TASK_H */
--- a/include/linux/sched.h~hung_task-replace-blocker_mutex-with-encoded-blocker
+++ a/include/linux/sched.h
@@ -1240,7 +1240,11 @@ struct task_struct {
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
-	struct mutex			*blocker_mutex;
+	/*
+	 * Encoded lock address causing task block (lower 2 bits = type from
+	 * <linux/hung_task.h>). Accessed via hung_task_*() helpers.
+	 */
+	unsigned long			blocker;
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
--- a/kernel/hung_task.c~hung_task-replace-blocker_mutex-with-encoded-blocker
+++ a/kernel/hung_task.c
@@ -22,6 +22,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/sysctl.h>
+#include <linux/hung_task.h>
 
 #include <trace/events/sched.h>
 
@@ -98,16 +99,18 @@ static struct notifier_block panic_block
 static void debug_show_blocker(struct task_struct *task)
 {
 	struct task_struct *g, *t;
-	unsigned long owner;
-	struct mutex *lock;
+	unsigned long owner, blocker;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "No rcu lock held");
 
-	lock = READ_ONCE(task->blocker_mutex);
-	if (!lock)
+	blocker = READ_ONCE(task->blocker);
+	if (!blocker ||
+	    hung_task_get_blocker_type(blocker) != BLOCKER_TYPE_MUTEX)
 		return;
 
-	owner = mutex_get_owner(lock);
+	owner = mutex_get_owner(
+		(struct mutex *)hung_task_blocker_to_lock(blocker));
+
 	if (unlikely(!owner)) {
 		pr_err("INFO: task %s:%d is blocked on a mutex, but the owner is not found.\n",
 			task->comm, task->pid);
--- a/kernel/locking/mutex.c~hung_task-replace-blocker_mutex-with-encoded-blocker
+++ a/kernel/locking/mutex.c
@@ -29,6 +29,7 @@
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
 #include <linux/osq_lock.h>
+#include <linux/hung_task.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/lock.h>
@@ -191,7 +192,7 @@ __mutex_add_waiter(struct mutex *lock, s
 		   struct list_head *list)
 {
 #ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
-	WRITE_ONCE(current->blocker_mutex, lock);
+	hung_task_set_blocker(lock, BLOCKER_TYPE_MUTEX);
 #endif
 	debug_mutex_add_waiter(lock, waiter, current);
 
@@ -209,7 +210,7 @@ __mutex_remove_waiter(struct mutex *lock
 
 	debug_mutex_remove_waiter(lock, waiter, current);
 #ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
-	WRITE_ONCE(current->blocker_mutex, NULL);
+	hung_task_clear_blocker();
 #endif
 }
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are



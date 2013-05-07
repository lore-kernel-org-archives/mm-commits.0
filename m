From: akpm@linux-foundation.org
Subject: [merged] kthread-implement-probe_kthread_data.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:23 -0700
Message-ID: <20130507174723.A90FA31C2DA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61352 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EGRrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:25 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so85119yen.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, david@fromorbit.com, jack@suse.cz, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: implement probe_kthread_data()
has been removed from the -mm tree.  Its filename was
     kthread-implement-probe_kthread_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: kthread: implement probe_kthread_data()

One of the problems that arise when converting dedicated custom threadpool
to workqueue is that the shared worker pool used by workqueue anonimizes
each worker making it more difficult to identify what the worker was doing
on which target from the output of sysrq-t or debug dump from oops, BUG()
and friends.

For example, after writeback is converted to use workqueue instead of
priviate thread pool, there's no easy to tell which backing device a
writeback work item was working on at the time of task dump, which,
according to our writeback brethren, is important in tracking down issues
with a lot of mounted file systems on a lot of different devices.

This patchset implements a way for a work function to mark its execution
instance so that task dump of the worker task includes information to
indicate what the work item was doing.

An example WARN dump would look like the following.

 WARNING: at fs/fs-writeback.c:1015 bdi_writeback_workfn+0x2b4/0x3c0()
 Modules linked in:
 CPU: 0 Pid: 28 Comm: kworker/u18:0 Not tainted 3.9.0-rc1-work+ #24
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
 Workqueue: writeback bdi_writeback_workfn (flush-8:16)
  ffffffff820a3a98 ffff88015b927cb8 ffffffff81c61855 ffff88015b927cf8
  ffffffff8108f500 0000000000000000 ffff88007a171948 ffff88007a1716b0
  ffff88015b49df00 ffff88015b8d3940 0000000000000000 ffff88015b927d08
 Call Trace:
  [<ffffffff81c61855>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  ...



This patch:

Implement probe_kthread_data() which returns kthread_data if accessible. 
The function is equivalent to kthread_data() except that the specified
@task may not be a kthread or its vfork_done is already cleared rendering
struct kthread inaccessible.  In the former case, probe_kthread_data() may
return any value.  In the latter, NULL.

This will be used to safely print debug information without affecting
synchronization in the normal paths.  Workqueue debug info printing on
dump_stack() and friends will make use of it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    1 +
 kernel/kthread.c        |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/kthread.h~kthread-implement-probe_kthread_data include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-implement-probe_kthread_data
+++ a/include/linux/kthread.h
@@ -43,6 +43,7 @@ bool kthread_should_stop(void);
 bool kthread_should_park(void);
 bool kthread_freezable_should_stop(bool *was_frozen);
 void *kthread_data(struct task_struct *k);
+void *probe_kthread_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
diff -puN kernel/kthread.c~kthread-implement-probe_kthread_data kernel/kthread.c
--- a/kernel/kthread.c~kthread-implement-probe_kthread_data
+++ a/kernel/kthread.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/freezer.h>
 #include <linux/ptrace.h>
+#include <linux/uaccess.h>
 #include <trace/events/sched.h>
 
 static DEFINE_SPINLOCK(kthread_create_lock);
@@ -135,6 +136,24 @@ void *kthread_data(struct task_struct *t
 	return to_kthread(task)->data;
 }
 
+/**
+ * probe_kthread_data - speculative version of kthread_data()
+ * @task: possible kthread task in question
+ *
+ * @task could be a kthread task.  Return the data value specified when it
+ * was created if accessible.  If @task isn't a kthread task or its data is
+ * inaccessible for any reason, %NULL is returned.  This function requires
+ * that @task itself is safe to dereference.
+ */
+void *probe_kthread_data(struct task_struct *task)
+{
+	struct kthread *kthread = to_kthread(task);
+	void *data = NULL;
+
+	probe_kernel_read(&data, &kthread->data, sizeof(data));
+	return data;
+}
+
 static void __kthread_parkme(struct kthread *self)
 {
 	__set_current_state(TASK_PARKED);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch


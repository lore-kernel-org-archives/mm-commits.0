From: akpm@linux-foundation.org
Subject: + kthread-implement-probe_kthread_data.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:29:53 -0700
Message-ID: <20130411202953.EF8435A42F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:53987 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763192Ab3DKU3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:29:55 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so182055vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:29:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk, david@fromorbit.com, jack@suse.cz, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org


The patch titled
     Subject: kthread: implement probe_kthread_data()
has been added to the -mm tree.  Its filename is
     kthread-implement-probe_kthread_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Jan Kara <jack@suse.cz>
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
 	__set_current_state(TASK_INTERRUPTIBLE);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
x86-dont-show-trace-beyond-show_stacknull-null.patch
sparc32-make-show_stack-acquire-%fp-if-_ksp-is-not-specified.patch
dump_stack-consolidate-dump_stack-implementations-and-unify-their-behaviors.patch
dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-formats-into-a-buffer.patch
dump_stack-implement-arch-specific-hardware-description-in-task-dumps.patch
dump_stack-unify-debug-information-printed-by-show_regs.patch
arc-print-fatal-signals-reduce-duplicated-information.patch
kthread-implement-probe_kthread_data.patch
workqueue-include-workqueue-info-when-printing-debug-dump-of-a-worker-task.patch
writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch
idr-introduce-idr_alloc_cyclic.patch
drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch
drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch
nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch
inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch
sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch


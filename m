From: akpm@linux-foundation.org
Subject: + writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:29:58 -0700
Message-ID: <20130411202959.04BC15A42F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49564 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762735Ab3DKUaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:30:00 -0400
Received: by mail-gg0-f202.google.com with SMTP id q1so182356ggn.3
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:29:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk, david@fromorbit.com, jack@suse.cz, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org


The patch titled
     Subject: writeback: set worker desc to identify writeback workers in task dumps
has been added to the -mm tree.  Its filename is
     writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch

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
Subject: writeback: set worker desc to identify writeback workers in task dumps

Writeback has been recently converted to use workqueue instead of its
private thread pool implementation.  One negative side effect of this
conversion is that there's no easy to tell which backing device a
writeback work item was working on at the time of task dump, be it
sysrq-t, BUG, WARN or whatever, which, according to our writeback
brethren, is important in tracking down issues with a lot of mounted file
systems on a lot of different devices.

This patch restores that information using the new worker description
facility.  bdi_writeback_workfn() calls set_work_desc() to identify which
bdi it's working on.  The description is printed out together with the
worqueue name and worker function as in the following example dump.

 WARNING: at fs/fs-writeback.c:1015 bdi_writeback_workfn+0x2b4/0x3c0()
 Modules linked in:
 Pid: 28, comm: kworker/u18:0 Not tainted 3.9.0-rc1-work+ #24 empty empty/S3992
 Workqueue: writeback bdi_writeback_workfn (flush-8:16)
  ffffffff820a3a98 ffff88015b927cb8 ffffffff81c61855 ffff88015b927cf8
  ffffffff8108f500 0000000000000000 ffff88007a171948 ffff88007a1716b0
  ffff88015b49df00 ffff88015b8d3940 0000000000000000 ffff88015b927d08
 Call Trace:
  [<ffffffff81c61855>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff81200144>] bdi_writeback_workfn+0x2b4/0x3c0
  [<ffffffff810b4c87>] process_one_work+0x1d7/0x660
  [<ffffffff810b5c72>] worker_thread+0x122/0x380
  [<ffffffff810bdfea>] kthread+0xea/0xf0
  [<ffffffff81c6cedc>] ret_from_fork+0x7c/0xb0

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fs-writeback.c~writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps
+++ a/fs/fs-writeback.c
@@ -1009,6 +1009,7 @@ void bdi_writeback_workfn(struct work_st
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
+	set_worker_desc("flush-%s", dev_name(bdi->dev));
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
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


From: akpm@linux-foundation.org
Subject: + x86-dont-show-trace-beyond-show_stacknull-null.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:07:33 -0700
Message-ID: <20130411200733.5AE655A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37459 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3DKUHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:07:35 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so84612qae.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:07:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, bhelgaas@google.com, davem@davemloft.net, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, jesper.nilsson@axis.com, sam@ravnborg.org, schwidefsky@de.ibm.com, vapier@gentoo.org, vgupta@synopsys.com


The patch titled
     Subject: x86: don't show trace beyond show_stack(NULL, NULL)
has been added to the -mm tree.  Its filename is
     x86-dont-show-trace-beyond-show_stacknull-null.patch

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
Subject: x86: don't show trace beyond show_stack(NULL, NULL)

There are multiple ways a task can be dumped - explicit call to
dump_stack(), triggering WARN() or BUG(), through sysrq-t and so on.  Most
of what gets printed is upto each architecture and the current state is
not particularly pretty.  Different pieces of information are presented
differently depending on which path the dump takes and which architecture
it's running on.  This is messy for no good reason and makes it
exceedingly difficult to add or modify debug information to task dumps.

In all archs except for s390, there's nothing arch-specific about the
printed debug information.  This patchset updates all those archs to use
the same helpers to consistently print out the same debug information.

An example WARN dump after this patchset.

 WARNING: at /work/os/work/kernel/workqueue.c:4841 init_workqueues+0x35/0x505()
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #3
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
  0000000000000009 ffff88007c861e08 ffffffff81c614dc ffff88007c861e48
  ffffffff8108f500 ffffffff82228240 0000000000000040 ffffffff8234a08e
  0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
 Call Trace:
  [<ffffffff81c614dc>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8234a0c3>] init_workqueues+0x35/0x505
  ...

And BUG dump.

 kernel BUG at /work/os/work/kernel/workqueue.c:4841!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #7
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
 RIP: 0010:[<ffffffff8234a07e>]  [<ffffffff8234a07e>] init_workqueues+0x4/0x6
 RSP: 0000:ffff88007c861ec8  EFLAGS: 00010246
 RAX: ffff88007c861fd8 RBX: ffffffff824466a8 RCX: 0000000000000001
 RDX: 0000000000000046 RSI: 0000000000000001 RDI: ffffffff8234a07a
 RBP: ffff88007c861ec8 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8234a07a
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffff88015f7ff000 CR3: 00000000021f1000 CR4: 00000000000007f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffff88007c861ef8 ffffffff81000312 ffffffff824466a8 ffff88007c85e650
  0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
  ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47760
 Call Trace:
  [<ffffffff81000312>] do_one_initcall+0x122/0x170
  [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  [<ffffffff81c4776e>] kernel_init+0xe/0xf0
  [<ffffffff81c6be9c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  ...

This patchset contains the following seven patches.

 0001-x86-don-t-show-trace-beyond-show_stack-NULL-NULL.patch
 0002-sparc32-make-show_stack-acquire-fp-if-_ksp-is-not-sp.patch
 0003-dump_stack-consolidate-dump_stack-implementations-an.patch
 0004-dmi-morph-dmi_dump_ids-into-dmi_format_ids-which-for.patch
 0005-dump_stack-implement-arch-specific-hardware-descript.patch
 0006-dump_stack-unify-debug-information-printed-by-show_r.patch
 0007-arc-print-fatal-signals-reduce-duplicated-informatio.patch

0001-0002 update stack dumping functions in x86 and sparc32 in
preparation.

0003 makes all arches except blackfin use generic dump_stack().
blackfin still uses the generic helper to print the same info.

0004-0005 properly abstract DMI identifier printing in WARN() and
show_regs() so that all dumps print out the information.  This enables
show_regs() to use the same debug info message.

0006 updates show_regs() of all arches to use a common generic helper
to print debug info.

0007 removes somem duplicate information from arc dumps.

While this patchset changes how debug info is printed on some archs,
the printed information is always superset of what used to be there.

This patchset makes task dump debug messages consistent and enables
adding more information.  Workqueue is scheduled to add worker
information including the workqueue in use and work item specific
description.

While this patch touches a lot of archs, it isn't too likely to cause
non-trivial conflicts with arch-specfic changes and would probably be
best to route together either through -mm.

x86 is tested but other archs are either only compile tested or not
tested at all.  Changes to most archs are generally trivial.



This patch:

show_stack(current or NULL, NULL) is used to print the backtrace of the
current task.  As trace beyond the function itself isn't of much interest
to anyone, don't show it by determining sp and bp in show_stack()'s frame
and passing them to show_stack_log_lvl().

This brings show_stack(NULL, NULL)'s behavior in line with
dump_stack().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/dumpstack.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/dumpstack.c~x86-dont-show-trace-beyond-show_stacknull-null arch/x86/kernel/dumpstack.c
--- a/arch/x86/kernel/dumpstack.c~x86-dont-show-trace-beyond-show_stacknull-null
+++ a/arch/x86/kernel/dumpstack.c
@@ -176,7 +176,19 @@ void show_trace(struct task_struct *task
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	show_stack_log_lvl(task, NULL, sp, 0, "");
+	unsigned long bp = 0;
+	unsigned long stack;
+
+	/*
+	 * Stack frames below this one aren't interesting.  Don't show them
+	 * if we're printing for %current.
+	 */
+	if (!sp && (!task || task == current)) {
+		sp = &stack;
+		bp = stack_frame(current, NULL);
+	}
+
+	show_stack_log_lvl(task, NULL, sp, bp, "");
 }
 
 /*
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


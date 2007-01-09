From: akpm@osdl.org
Subject: - x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails-fix.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:11:52 -0800
Message-ID: <200701092011.l09KBqF0013962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbXAIUMC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:12:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, yinghai.lu@amd.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 ioapic: check_timer_pin Don't add_pin_to_irq if it is already there
has been removed from the -mm tree.  Its filename was
     x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64 ioapic: check_timer_pin Don't add_pin_to_irq if it is already there
From: Eric W. Biederman <ebiederm@xmission.com>

"Lu, Yinghai" <yinghai.lu@amd.com> writes:

>>Any updates to add_pin_to_irq are wrong.  It works fine.  If there
>>is something wrong we need to fix remove_pin_to_irq.
>
>>What is the problem you see?  Sorry I'm dense at the moment.

> In the check_timer_pin, irq_from_pin could return 0, it mean some entry
> is for IRQ0 already.
> The add_pin_to_irq could add another same entry for it again.

Yep.  My oversight.  Here is the trivial patch to fix it.  I don't
see how we could hit this case but if we are going to allow for it
we should handle it correctly.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Yinghai Lu" <yinghai.lu@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails-fix arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails-fix
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1686,7 +1686,8 @@ static int check_timer_pin(int apic, int
 	idx = update_irq0_entry(apic, pin);
 
 	/* Add an entry in irq_to_pin */
-	add_pin_to_irq(0, apic, pin);
+	if (irq != 0)
+		add_pin_to_irq(0, apic, pin);
 
 	/* Now setup the irq */
 	setup_IO_APIC_irq(apic, pin, idx, 0);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails-fix.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

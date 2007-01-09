From: akpm@osdl.org
Subject: - x86_64-io_apic-implment-update_irq0_entry.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:11:41 -0800
Message-ID: <200701092011.l09KBfa8013956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbXAIULy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:11:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, yinghai.lu@amd.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 io_apic: Implment update_irq0_entry
has been removed from the -mm tree.  Its filename was
     x86_64-io_apic-implment-update_irq0_entry.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64 io_apic: Implment update_irq0_entry
From: Eric W. Biederman <ebiederm@xmission.com>

To guess different irq routing strategies for irq 0 we need the ability to
update our data structures to reflect our guess.

update_irq0_entry updates the mp routing table information to reflect our
current guess as to the routing of the timer irq.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Yinghai Lu" <yinghai.lu@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-io_apic-implment-update_irq0_entry arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-io_apic-implment-update_irq0_entry
+++ a/arch/x86_64/kernel/io_apic.c
@@ -446,6 +446,37 @@ static int __init find_isa_irq_apic(int 
 	return -1;
 }
 
+static int update_irq0_entry(int apic, int pin)
+{
+	int irq = 0;
+	int idx;
+	int isa_bus;
+
+	/* Figure out the isa bus, by convention it is bus 0,
+	 * but be prepared for someone being creative.
+	 */
+	for (isa_bus = 0; isa_bus < MAX_MP_BUSSES; isa_bus++)
+		if (test_bit(isa_bus, mp_bus_not_pci))
+			break;
+	if (isa_bus >= MAX_MP_BUSSES)
+		isa_bus = 0;
+
+	idx = find_irq_entry(apic, pin, mp_INT);
+	if (idx == -1) {
+		idx = mp_irq_entries;
+		if (++mp_irq_entries >= MAX_IRQ_SOURCES)
+			panic("MAX # of irq sources exceeded!!!\n");
+	}
+	mp_irqs[idx].mpc_type = MP_INTSRC;
+	mp_irqs[idx].mpc_irqtype = mp_INT;
+	mp_irqs[idx].mpc_irqflag = 0;	/* Use bus defaults */
+	mp_irqs[idx].mpc_srcbus = isa_bus;
+	mp_irqs[idx].mpc_srcbusirq = irq;
+	mp_irqs[idx].mpc_dstapic = mp_ioapics[apic].mpc_apicid;
+	mp_irqs[idx].mpc_dstirq = pin;
+	return idx;
+}
+
 /*
  * Find a specific PCI IRQ entry.
  * Not an __init, possibly needed by modules
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
x86_64-io_apic-implment-update_irq0_entry.patch
x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails.patch
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

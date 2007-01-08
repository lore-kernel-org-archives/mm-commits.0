From: akpm@osdl.org
Subject: + x86_64-io_apic-implement-remove_pin_to_irq.patch added to -mm tree
Date: Mon, 08 Jan 2007 13:35:01 -0800
Message-ID: <200701082135.l08LZ1So019623@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45204 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbXAHVfL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 16:35:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, yinghai.lu@amd.com


The patch titled
     x86_64 io_apic: Implement remove_pin_to_irq
has been added to the -mm tree.  Its filename is
     x86_64-io_apic-implement-remove_pin_to_irq.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 io_apic: Implement remove_pin_to_irq
From: Eric W. Biederman <ebiederm@xmission.com>

To try different irq routing combinations so we can make an informed guess as
to how to route irqs when the BIOS gets it wrong we need the ability to modify
our irq routing data structures.

This adds remove_pin_to_irq which removes the mapping from and apic pin to an
irq.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Yinghai Lu" <yinghai.lu@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-io_apic-implement-remove_pin_to_irq arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-io_apic-implement-remove_pin_to_irq
+++ a/arch/x86_64/kernel/io_apic.c
@@ -286,6 +286,29 @@ static void add_pin_to_irq(unsigned int 
 	entry->pin = pin;
 }
 
+static void remove_pin_to_irq(unsigned int irq, int apic, int pin)
+{
+	struct irq_pin_list *entry = irq_2_pin + irq;
+
+	BUG_ON(irq >= NR_IRQS);
+
+	while (entry->next && ((entry->apic != apic) || (entry->pin != pin)))
+		entry = irq_2_pin + entry->next;
+
+	if (entry->pin == apic && entry->pin == pin) {
+		if (entry->next) {
+			struct irq_pin_list *next = irq_2_pin + entry->next;
+			*entry = *next;
+			next->pin = -1;
+			next->apic = -1;
+			next->next = 0;
+		} else {
+			entry->pin = -1;
+			entry->apic = -1;
+		}
+	}
+}
+
 
 #define DO_ACTION(name,R,ACTION, FINAL)					\
 									\
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
x86_64-io_apic-implement-remove_pin_to_irq.patch
x86_64-io_apic-implement-irq_from_pin.patch
x86_64-io_apic-implment-update_irq0_entry.patch
x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails.patch
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

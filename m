From: akpm@osdl.org
Subject: + x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:06:39 -0800
Message-ID: <200702030106.l1316dJL022817@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47496 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946199AbXBCBGp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:06:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de


The patch titled
     x86_64 irq: handle irqs pending in IRR during irq migration
has been added to the -mm tree.  Its filename is
     x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 irq: handle irqs pending in IRR during irq migration
From: Eric W. Biederman <ebiederm@xmission.com>

When making the interrupt vectors per cpu I failed to handle a case during
irq migration.  If the same interrupt comes in while we are servicing the
irq but before we migrate it the pending bit in the local apic IRR register
will be set for that irq.

After migrating the irq to another cpu and or vector the data structures
will no longer be setup to handle this pending irq.  Then as soon as we
return from servicing the irq we just migrated we will get a nasty: "No irq
handler for vector" message.

Since we do not disable irqs for edge triggered interrupts except in the
smallest possible window during migration I cannot avoid migrating an irq
in the unlikely event that it becomes pending.  This is because by the time
the irq could no longer become pending I have already updated all of my
data structures.

Therefore this patch introduces an intermediate state that exists soley on
the cpu where we are handling the irq during migration.  The irq number is
changed to negative in the vector_irq data structure.

Once the migration operation is complete we know we will receive no more
interrupts on this vector so the irq pending state for this irq will no
longer be updated.  If the irq is not pending and we are in the
intermediate state we immediately free the vector, otherwise in we free the
vector in do_IRQ when the pending irq arrives.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |   56 ++++++++++++++++++++++++++++++---
 arch/x86_64/kernel/irq.c     |   19 ++++++++++-
 2 files changed, 69 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration
+++ a/arch/x86_64/kernel/io_apic.c
@@ -730,9 +730,17 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		for_each_cpu_mask(old_cpu, old_mask)
-			per_cpu(vector_irq, old_cpu)[old_vector] = -1;
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask(old_cpu, old_mask) {
+			int free = -1;
+			/* When migrating we need to preserve the old
+			 * vector until we have processed all of the
+			 * pending irqs.
+			 */
+			if (old_cpu == smp_processor_id())
+				free = -irq;
+			per_cpu(vector_irq, old_cpu)[old_vector] = free;
+		}
+ 		for_each_cpu_mask(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		irq_vector[irq] = vector;
 		irq_domain[irq] = domain;
@@ -1389,6 +1397,37 @@ static int ioapic_retrigger_irq(unsigned
 	return 1;
 }
 
+static unsigned apic_in_service_vector(void)
+{
+	unsigned isr, vector;
+	/* Figure out which vector we are servicing */
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < FIRST_SYSTEM_VECTOR; vector += 32) {
+		isr = apic_read(APIC_ISR + ((vector/32) * 0x10));
+		if (isr)
+			break;
+	}
+	/* Find the low bits of the vector we are servicing */
+	vector += __ffs(isr);
+	return vector;
+}
+
+static void apic_handle_pending_vector(unsigned vector)
+{
+	unsigned irr;
+	int irq;
+
+	irq = __get_cpu_var(vector_irq)[vector];
+	if (irq >= 0)
+		return;
+
+	/* If the irq we are servicing has moved and is not pending
+	 * free it's vector.
+	 */
+	irr = apic_read(APIC_IRR + ((vector/32) * 0x10));
+	if (!(irr & (1 << (vector % 32))))
+		__get_cpu_var(vector_irq)[vector] = -1;
+}
+
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
  * so we use two separate IRQ descriptors. Edge triggered IRQs can be
@@ -1400,19 +1439,24 @@ static int ioapic_retrigger_irq(unsigned
 
 static void ack_apic_edge(unsigned int irq)
 {
-	move_native_irq(irq);
+	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+		move_native_irq(irq);
+		apic_handle_pending_vector(apic_in_service_vector());
+	}
 	ack_APIC_irq();
 }
 
 static void ack_apic_level(unsigned int irq)
 {
 	int do_unmask_irq = 0;
+	unsigned int vector = 0;
 
 #if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
+		vector = apic_in_service_vector();
 	}
 #endif
 
@@ -1424,8 +1468,10 @@ static void ack_apic_level(unsigned int 
 
 	/* Now we can move and renable the irq */
 	move_masked_irq(irq);
-	if (unlikely(do_unmask_irq))
+	if (unlikely(do_unmask_irq)) {
+		apic_handle_pending_vector(vector);
 		unmask_IO_APIC_irq(irq);
+	}
 }
 
 static struct irq_chip ioapic_chip __read_mostly = {
diff -puN arch/x86_64/kernel/irq.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration
+++ a/arch/x86_64/kernel/irq.c
@@ -97,6 +97,23 @@ skip:
 	return 0;
 }
 
+static inline unsigned int irq_from_vector(unsigned int vector)
+{
+	int irq;
+	irq = __get_cpu_var(vector_irq)[vector];
+
+	/* If we changed vectors during migration and we had a pending
+	 * irq, we left the irq allocated on this cpu.  Now that the
+	 * pending irq has arrived get the irq number and free this
+	 * vector.
+	 */
+	if (irq < -1) {
+		__get_cpu_var(vector_irq)[vector] = -1;
+		irq = -irq;
+	}
+	return irq;
+}
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -112,7 +129,7 @@ asmlinkage unsigned int do_IRQ(struct pt
 
 	exit_idle();
 	irq_enter();
-	irq = __get_cpu_var(vector_irq)[vector];
+	irq = irq_from_vector(vector);
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	stack_overflow_check(regs);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
powerpc-rtas-msi-support.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
fix-i-oat-for-kexec.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
kexec-update-io-apic-dest-field-to-8-bit-for.patch
x86_64-survive-having-no-irq-mapping-for-a-vector.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
_proc_do_string-fix-short-reads.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
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
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc-fix.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-reimplement-the-sysctl-proc-support-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

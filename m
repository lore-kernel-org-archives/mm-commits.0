From: akpm@linux-foundation.org
Subject: + i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch added to -mm tree
Date: Wed, 28 Mar 2007 14:07:09 -0700
Message-ID: <200703282107.l2SL79il020090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59615 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbXC1VHV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 17:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, len.brown@intel.com, michal.k.k.piotrowski@gmail.com, nataliep@google.com


The patch titled
     i386 irq: Kill NR_IRQ_VECTORS and increase NR_IRQS
has been added to the -mm tree.  Its filename is
     i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 irq: Kill NR_IRQ_VECTORS and increase NR_IRQS
From: Eric W. Biederman <ebiederm@xmission.com>

Due to hardware and software implementation limits the i386 kernel can only
use 224 or so different IRQs at one time.  However except for actually
having the irqs delivered there are no limits except the arbitrary number
NR_IRQS on how many irqs we can talk about and deal with.

Frequently not all io_apics inputs are connected to interrupt traces going
to real devices, and since even when they are devices don't always use all
of interrupt traces routed to them.  So it makes sense to be able to talk
about many more irq sources then we can actually use.

So this patch consolidates NR_IRQS and NR_IRQ_VECTORS into just NR_IRQS and
raises NR_IRQS where appropriate above the number of irqs we can use at one
time.

Allowing the kernel to work on big machines without complicated and error
prone irq remapping logic.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Natalie Protasevich <nataliep@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c                       |    4 ++--
 arch/i386/kernel/io_apic.c                         |    6 +++---
 include/asm-i386/mach-default/irq_vectors_limits.h |    8 +++-----
 include/asm-i386/mach-generic/irq_vectors_limits.h |    3 +--
 include/asm-i386/mach-summit/irq_vectors_limits.h  |    3 +--
 include/asm-i386/mach-visws/irq_vectors.h          |    1 -
 include/asm-i386/mach-voyager/irq_vectors.h        |    1 -
 7 files changed, 10 insertions(+), 16 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs
+++ a/arch/i386/kernel/acpi/boot.c
@@ -811,7 +811,7 @@ static int __init acpi_parse_madt_ioapic
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
-				  NR_IRQ_VECTORS);
+				  NR_IRQS);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -831,7 +831,7 @@ static int __init acpi_parse_madt_ioapic
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  NR_IRQ_VECTORS);
+				  NR_IRQS);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
diff -puN arch/i386/kernel/io_apic.c~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs
+++ a/arch/i386/kernel/io_apic.c
@@ -1223,14 +1223,14 @@ static inline int IO_APIC_irq_trigger(in
 }
 
 /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
+static u8 irq_vector[NR_IRQS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
 
 static int __assign_irq_vector(int irq)
 {
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	int vector, offset, i;
 
-	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
+	BUG_ON((unsigned)irq >= NR_IRQS);
 
 	if (irq_vector[irq] > 0)
 		return irq_vector[irq];
@@ -1247,7 +1247,7 @@ next:
 		return -ENOSPC;
 	if (vector == SYSCALL_VECTOR)
 		goto next;
-	for (i = 0; i < NR_IRQ_VECTORS; i++)
+	for (i = 0; i < NR_IRQS; i++)
 		if (irq_vector[i] == vector)
 			goto next;
 
diff -puN include/asm-i386/mach-default/irq_vectors_limits.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs include/asm-i386/mach-default/irq_vectors_limits.h
--- a/include/asm-i386/mach-default/irq_vectors_limits.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs
+++ a/include/asm-i386/mach-default/irq_vectors_limits.h
@@ -2,15 +2,13 @@
 #define _ASM_IRQ_VECTORS_LIMITS_H
 
 #ifdef CONFIG_X86_IO_APIC
-#define NR_IRQS 224
-# if (224 >= 32 * NR_CPUS)
-# define NR_IRQ_VECTORS NR_IRQS
+# if (200 >= 32 * NR_CPUS)
+#  define NR_IRQS 200
 # else
-# define NR_IRQ_VECTORS (32 * NR_CPUS)
+#  define NR_IRQS (32 * NR_CPUS)
 # endif
 #else
 #define NR_IRQS 16
-#define NR_IRQ_VECTORS NR_IRQS
 #endif
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff -puN include/asm-i386/mach-generic/irq_vectors_limits.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs include/asm-i386/mach-generic/irq_vectors_limits.h
--- a/include/asm-i386/mach-generic/irq_vectors_limits.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs
+++ a/include/asm-i386/mach-generic/irq_vectors_limits.h
@@ -8,7 +8,6 @@
  * This value should be the same in both the generic and summit subarches.
  * Change one, change 'em both.
  */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
+#define NR_IRQS	1024
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff -puN include/asm-i386/mach-summit/irq_vectors_limits.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs include/asm-i386/mach-summit/irq_vectors_limits.h
--- a/include/asm-i386/mach-summit/irq_vectors_limits.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs
+++ a/include/asm-i386/mach-summit/irq_vectors_limits.h
@@ -8,7 +8,6 @@
  * This value should be the same in both the generic and summit subarches.
  * Change one, change 'em both.
  */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
+#define NR_IRQS	1024
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff -puN include/asm-i386/mach-visws/irq_vectors.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs include/asm-i386/mach-visws/irq_vectors.h
--- a/include/asm-i386/mach-visws/irq_vectors.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs
+++ a/include/asm-i386/mach-visws/irq_vectors.h
@@ -51,7 +51,6 @@
  */
 #define NR_VECTORS 256
 #define NR_IRQS 224
-#define NR_IRQ_VECTORS NR_IRQS
 
 #define FPU_IRQ			13
 
diff -puN include/asm-i386/mach-voyager/irq_vectors.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs include/asm-i386/mach-voyager/irq_vectors.h
--- a/include/asm-i386/mach-voyager/irq_vectors.h~i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs
+++ a/include/asm-i386/mach-voyager/irq_vectors.h
@@ -57,7 +57,6 @@
 
 #define NR_VECTORS 256
 #define NR_IRQS 224
-#define NR_IRQ_VECTORS NR_IRQS
 
 #define FPU_IRQ				13
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

utsns-fix-config_uts_ns-behavior.patch
ipcns-fix-config_ipc_ns-behavior.patch
fix-kernel-build-with-embedded-proc_fs-proc_sysctl.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch
x86_64-irq-remove-extra-smp_processor_id-calling.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

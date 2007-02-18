From: akpm@linux-foundation.org
Subject: - x86_64-irq-simplfy-__assign_irq_vector.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:33 -0800
Message-ID: <200702180215.l1I2FXnC008401@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55762 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993145AbXBRCQu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 irq: Simplfy __assign_irq_vector
has been removed from the -mm tree.  Its filename was
     x86_64-irq-simplfy-__assign_irq_vector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 irq: Simplfy __assign_irq_vector
From: Eric W. Biederman <ebiederm@xmission.com>

By precomputing old_mask I remove an extra if statement, remove an
indentation level and make the code slightly easier to read.

This comes before my bugfix in the next patch so the patch and the
resulting code stay readable.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-simplfy-__assign_irq_vector arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-simplfy-__assign_irq_vector
+++ a/arch/x86_64/kernel/io_apic.c
@@ -685,6 +685,7 @@ static int __assign_irq_vector(int irq, 
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	cpumask_t old_mask = CPU_MASK_NONE;
 	int old_vector = -1;
 	int cpu;
 
@@ -699,11 +700,12 @@ static int __assign_irq_vector(int irq, 
 		cpus_and(*result, irq_domain[irq], mask);
 		if (!cpus_empty(*result))
 			return old_vector;
+		cpus_and(old_mask, irq_domain[irq], cpu_online_map);
 	}
 
 	for_each_cpu_mask(cpu, mask) {
 		cpumask_t domain, new_mask;
-		int new_cpu;
+		int new_cpu, old_cpu;
 		int vector, offset;
 
 		domain = vector_allocation_domain(cpu);
@@ -728,13 +730,8 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		if (old_vector >= 0) {
-			cpumask_t old_mask;
-			int old_cpu;
-			cpus_and(old_mask, irq_domain[irq], cpu_online_map);
-			for_each_cpu_mask(old_cpu, old_mask)
-				per_cpu(vector_irq, old_cpu)[old_vector] = -1;
-		}
+		for_each_cpu_mask(old_cpu, old_mask)
+			per_cpu(vector_irq, old_cpu)[old_vector] = -1;
 		for_each_cpu_mask(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		irq_vector[irq] = vector;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
i386-irq-kill-irq-compression.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

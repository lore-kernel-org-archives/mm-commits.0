From: akpm@linux-foundation.org
Subject: + i386-balance_irq-convert-to-the-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 19:11:10 -0700
Message-ID: <200704200211.l3K2BAeT004846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbXDTCLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 22:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de


The patch titled
     i386 balance_irq: convert to the kthread API
has been added to the -mm tree.  Its filename is
     i386-balance_irq-convert-to-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 balance_irq: convert to the kthread API
From: "Eric W. Biederman" <ebiederm@xmission.com>

This patch just trivial converts from calling kernel_thread and daemonize
to just calling kthread_run.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/io_apic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/io_apic.c~i386-balance_irq-convert-to-the-kthread-api arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~i386-balance_irq-convert-to-the-kthread-api
+++ a/arch/i386/kernel/io_apic.c
@@ -35,6 +35,7 @@
 #include <linux/msi.h>
 #include <linux/htirq.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -661,8 +662,6 @@ static int balanced_irq(void *unused)
 	unsigned long prev_balance_time = jiffies;
 	long time_remaining = balanced_irq_interval;
 
-	daemonize("kirqd");
-	
 	/* push everything to CPU 0 to give us a starting point.  */
 	for (i = 0 ; i < NR_IRQS ; i++) {
 		irq_desc[i].pending_mask = cpumask_of_cpu(0);
@@ -722,10 +721,9 @@ static int __init balanced_irq_init(void
 	}
 	
 	printk(KERN_INFO "Starting balanced_irq\n");
-	if (kernel_thread(balanced_irq, NULL, CLONE_KERNEL) >= 0) 
+	if (!IS_ERR(kthread_run(balanced_irq, NULL, "kirqd")))
 		return 0;
-	else 
-		printk(KERN_ERR "balanced_irq_init: failed to spawn balanced_irq");
+	printk(KERN_ERR "balanced_irq_init: failed to spawn balanced_irq");
 failed:
 	for_each_possible_cpu(i) {
 		kfree(irq_cpu_data[i].irq_delta);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

arm-ecard-convert-to-use-the-kthread-api.patch
powerpc-rtas-msi-support.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
powerpc-pseries-rtasd-convert-to-kthread-api.patch
powerpc-pseries-eeh-convert-to-kthread-api.patch
mm-only-dvb_en_50221-convert-to-kthread-api.patch
mm-only-saa7134-tvaudio-convert-to-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api.patch
mtd_blkdevs-convert-to-use-the-kthread-api.patch
fix-i-oat-for-kexec.patch
cpqphp-partially-convert-to-use-the-kthread-api.patch
ibmphp-partially-convert-to-use-the-kthreads-api.patch
cpci_hotplug-partially-convert-to-use-the-kthread-api.patch
s390-scsi-zfcp_erp-partially-convert-to-use-the-kthread-api.patch
s390-qeth-convert-to-use-the-kthread-api.patch
s390-net-lcs-convert-to-the-kthread-api.patch
sas_scsi_host-partially-convert-to-use-the-kthread-api.patch
sparc64-powerc-convert-to-use-the-kthread-api.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api.patch
i386-balance_irq-convert-to-the-kthread-api.patch
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
clean-up-elf-note-generation.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
smbfs-remove-unnecessary-allow_signal.patch
pnpbios-conert-to-use-the-kthread-api.patch
kthread-dont-depend-on-work-queues-take-2.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
edac-k8-driver-coding-tidy.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
md-remove-broken-sigkill-support.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

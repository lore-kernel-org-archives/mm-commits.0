From: akpm@linux-foundation.org
Subject: - arm-ecard-convert-to-use-the-kthread-api.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:27 -0700
Message-ID: <200704302144.l3ULiRBY015600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031136AbXD3VpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm ecard: convert to use the kthread API
has been removed from the -mm tree.  Its filename was
     arm-ecard-convert-to-use-the-kthread-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arm ecard: convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the startup of kecardd to use kthread_run not a
kernel_thread combination of kernel_thread and daemonize.  Making the code
slightly simpler and more maintainable.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ecard.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/arm/kernel/ecard.c~arm-ecard-convert-to-use-the-kthread-api arch/arm/kernel/ecard.c
--- a/arch/arm/kernel/ecard.c~arm-ecard-convert-to-use-the-kthread-api
+++ a/arch/arm/kernel/ecard.c
@@ -40,6 +40,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #include <asm/dma.h>
 #include <asm/ecard.h>
@@ -263,8 +264,6 @@ static int ecard_init_mm(void)
 static int
 ecard_task(void * unused)
 {
-	daemonize("kecardd");
-
 	/*
 	 * Allocate a mm.  We're not a lazy-TLB kernel task since we need
 	 * to set page table entries where the user space would be.  Note
@@ -1059,13 +1058,14 @@ ecard_probe(int slot, card_type_t type)
  */
 static int __init ecard_init(void)
 {
-	int slot, irqhw, ret;
+	struct task_struct *task;
+	int slot, irqhw;
 
-	ret = kernel_thread(ecard_task, NULL, CLONE_KERNEL);
-	if (ret < 0) {
+	task = kthread_run(ecard_task, NULL, "kecardd");
+	if (IS_ERR(task)) {
 		printk(KERN_ERR "Ecard: unable to create kernel thread: %d\n",
-		       ret);
-		return ret;
+		       PTR_ERR(task));
+		return PTR_ERR(task);
 	}
 
 	printk("Probing expansion cards\n");
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
powerpc-pseries-rtasd-convert-to-kthread-api.patch
powerpc-pseries-eeh-convert-to-kthread-api.patch
dvb_en_50221-convert-to-kthread-api.patch
mm-only-saa7134-tvaudio-convert-to-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
fix-i-oat-for-kexec.patch
cpqphp-partially-convert-to-use-the-kthread-api.patch
ibmphp-partially-convert-to-use-the-kthreads-api.patch
cpci_hotplug-partially-convert-to-use-the-kthread-api.patch
msi-fix-arm-compile.patch
s390-scsi-zfcp_erp-partially-convert-to-use-the-kthread-api.patch
s390-qeth-convert-to-use-the-kthread-api.patch
s390-net-lcs-convert-to-the-kthread-api.patch
sas_scsi_host-partially-convert-to-use-the-kthread-api.patch
sparc64-powerc-convert-to-use-the-kthread-api.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
smbfs-remove-unnecessary-allow_signal.patch
pnpbios-conert-to-use-the-kthread-api.patch
kthread-dont-depend-on-work-queues-take-2.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
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

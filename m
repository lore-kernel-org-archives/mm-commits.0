From: akpm@linux-foundation.org
Subject: + sparc64-powerc-convert-to-use-the-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 17:30:31 -0700
Message-ID: <200704200030.l3K0UVAr003172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbXDTAbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 20:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, davem@davemloft.net


The patch titled
     sparc64/power.c: convert to use the kthread API
has been added to the -mm tree.  Its filename is
     sparc64-powerc-convert-to-use-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sparc64/power.c: convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This starts the sparc64 powerd using kthread_run instead of kernel_thread
and daemonize.  Making the code slightly simpler and more maintainable.

In addition the unnecessary flush_signals is removed.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/power.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/sparc64/kernel/power.c~sparc64-powerc-convert-to-use-the-kthread-api arch/sparc64/kernel/power.c
--- a/arch/sparc64/kernel/power.c~sparc64-powerc-convert-to-use-the-kthread-api
+++ a/arch/sparc64/kernel/power.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/pm.h>
 #include <linux/syscalls.h>
+#include <linux/kthread.h>
 
 #include <asm/system.h>
 #include <asm/auxio.h>
@@ -81,15 +82,12 @@ static int powerd(void *__unused)
 	char *argv[] = { "/sbin/shutdown", "-h", "now", NULL };
 	DECLARE_WAITQUEUE(wait, current);
 
-	daemonize("powerd");
-
 	add_wait_queue(&powerd_wait, &wait);
 again:
 	for (;;) {
 		set_task_state(current, TASK_INTERRUPTIBLE);
 		if (button_pressed)
 			break;
-		flush_signals(current);
 		schedule();
 	}
 	__set_current_state(TASK_RUNNING);
@@ -128,7 +126,9 @@ static int __devinit power_probe(struct 
 	poweroff_method = machine_halt;  /* able to use the standard halt */
 
 	if (has_button_interrupt(irq, op->node)) {
-		if (kernel_thread(powerd, NULL, CLONE_FS) < 0) {
+		struct task_struct *task;
+		task = kthread_run(powerd, NULL, "powerd");
+		if (IS_ERR(task)) {
 			printk("Failed to start power daemon.\n");
 			return 0;
 		}
_

Patches currently in -mm which might be from ebiederm@xmission.com are

arm-ecard-convert-to-use-the-kthread-api.patch
powerpc-rtas-msi-support.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_windtunnelc-convert-to-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
powerpc-pseries-rtasd-convert-to-kthread-api.patch
powerpc-pseries-eeh-convert-to-kthread-api.patch
mm-only-dvb_en_50221-convert-to-kthread-api.patch
mm-only-saa7134-tvaudio-convert-to-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api.patch
fix-i-oat-for-kexec.patch
s390-scsi-zfcp_erp-partially-convert-to-use-the-kthread-api.patch
s390-qeth-convert-to-use-the-kthread-api.patch
s390-net-lcs-convert-to-the-kthread-api.patch
sparc64-powerc-convert-to-use-the-kthread-api.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
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

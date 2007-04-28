From: akpm@linux-foundation.org
Subject: - i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:39 -0700
Message-ID: <200704281055.l3SAtd2l020194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965804AbXD1Kzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     i386 voyager: convert the monitor thread to use the kthread API
has been removed from the -mm tree.  Its filename was
     i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 voyager: convert the monitor thread to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch just trivially replaces kernel_thread and daemonize with a
single call to kthread_run.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-voyager/voyager_thread.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/i386/mach-voyager/voyager_thread.c~i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api arch/i386/mach-voyager/voyager_thread.c
--- a/arch/i386/mach-voyager/voyager_thread.c~i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api
+++ a/arch/i386/mach-voyager/voyager_thread.c
@@ -24,6 +24,7 @@
 #include <linux/kmod.h>
 #include <linux/completion.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 #include <asm/desc.h>
 #include <asm/voyager.h>
 #include <asm/vic.h>
@@ -44,7 +45,7 @@ static __u8 set_timeout = 0;
 static int __init
 voyager_thread_start(void)
 {
-	if(kernel_thread(thread, NULL, CLONE_KERNEL) < 0) {
+	if (IS_ERR(kthread_run(thread, NULL, "%s", THREAD_NAME))) {
 		/* This is serious, but not fatal */
 		printk(KERN_ERR "Voyager: Failed to create system monitor thread!!!\n");
 		return 1;
@@ -123,8 +124,6 @@ thread(void *unused)
 
 	kvoyagerd_running = 1;
 
-	daemonize(THREAD_NAME);
-
 	set_timeout = 0;
 
 	init_timer(&wakeup_timer);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
arm-ecard-convert-to-use-the-kthread-api.patch
iop13xx-msi-support-rev6.patch
powerpc-rtas-msi-support.patch
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
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
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
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
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

From: akpm@linux-foundation.org
Subject: - cpqphp-partially-convert-to-use-the-kthread-api.patch removed from -mm tree
Date: Wed, 02 May 2007 12:33:44 -0700
Message-ID: <200705021933.l42JXiOM028276@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766694AbXEBTe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, gregkh@suse.de, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpqphp: partially convert to use the kthread API
has been removed from the -mm tree.  Its filename was
     cpqphp-partially-convert-to-use-the-kthread-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cpqphp: partially convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch changes cpqphp to use kthread_run and not kernel_thread and
daemonize to startup and setup the cpqphp thread.

akpm: needs to be converted to use kthread_should_stop() and kthread_stop()
too.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpqphp_ctrl.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/pci/hotplug/cpqphp_ctrl.c~cpqphp-partially-convert-to-use-the-kthread-api drivers/pci/hotplug/cpqphp_ctrl.c
--- a/drivers/pci/hotplug/cpqphp_ctrl.c~cpqphp-partially-convert-to-use-the-kthread-api
+++ a/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -37,6 +37,7 @@
 #include <linux/smp_lock.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
+#include <linux/kthread.h>
 #include "cpqphp.h"
 
 static u32 configure_new_device(struct controller* ctrl, struct pci_func *func,
@@ -1746,10 +1747,6 @@ static void pushbutton_helper_thread(uns
 static int event_thread(void* data)
 {
 	struct controller *ctrl;
-	lock_kernel();
-	daemonize("phpd_event");
-	
-	unlock_kernel();
 
 	while (1) {
 		dbg("!!!!event_thread sleeping\n");
@@ -1771,7 +1768,7 @@ static int event_thread(void* data)
 
 int cpqhp_event_start_thread(void)
 {
-	int pid;
+	struct task_struct *task;
 
 	/* initialize our semaphores */
 	init_MUTEX(&delay_sem);
@@ -1779,12 +1776,11 @@ int cpqhp_event_start_thread(void)
 	init_MUTEX_LOCKED(&event_exit);
 	event_finished=0;
 
-	pid = kernel_thread(event_thread, NULL, 0);
-	if (pid < 0) {
+	task = kthread_run(event_thread, NULL, "phpd_event");
+	if (IS_ERR(task)) {
 		err ("Can't start up our event thread\n");
 		return -1;
 	}
-	dbg("Our event thread pid = %d\n", pid);
 	return 0;
 }
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
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
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

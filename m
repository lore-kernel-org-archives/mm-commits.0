From: akpm@linux-foundation.org
Subject: - cpci_hotplug-partially-convert-to-use-the-kthread-api.patch removed from -mm tree
Date: Wed, 02 May 2007 12:33:54 -0700
Message-ID: <200705021933.l42JXtnd028282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766738AbXEBTeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, greg@kroah.com, kristen.c.accardi@intel.com, scottm@somanetworks.com, mm-commits@vger.kernel.org


The patch titled
     cpci_hotplug: partially convert to use the kthread API
has been removed from the -mm tree.  Its filename was
     cpci_hotplug-partially-convert-to-use-the-kthread-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cpci_hotplug: partially convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

kthread_run replaces the kernel_thread and daemonize calls during thread
startup.

Calls to signal_pending were also removed as it is currently impossible for
the cpci_hotplug thread to receive signals.

akpm: needs to be converted to kthread_should_stop() and kthread_stop().

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Scott Murray <scottm@somanetworks.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpci_hotplug_core.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN drivers/pci/hotplug/cpci_hotplug_core.c~cpci_hotplug-partially-convert-to-use-the-kthread-api drivers/pci/hotplug/cpci_hotplug_core.c
--- a/drivers/pci/hotplug/cpci_hotplug_core.c~cpci_hotplug-partially-convert-to-use-the-kthread-api
+++ a/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -33,6 +33,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/smp_lock.h>
+#include <linux/kthread.h>
 #include <asm/atomic.h>
 #include <linux/delay.h>
 #include "cpci_hotplug.h"
@@ -521,17 +522,13 @@ event_thread(void *data)
 {
 	int rc;
 
-	lock_kernel();
-	daemonize("cpci_hp_eventd");
-	unlock_kernel();
-
 	dbg("%s - event thread started", __FUNCTION__);
 	while (1) {
 		dbg("event thread sleeping");
 		down_interruptible(&event_semaphore);
 		dbg("event thread woken, thread_finished = %d",
 		    thread_finished);
-		if (thread_finished || signal_pending(current))
+		if (thread_finished)
 			break;
 		do {
 			rc = check_slots();
@@ -562,12 +559,8 @@ poll_thread(void *data)
 {
 	int rc;
 
-	lock_kernel();
-	daemonize("cpci_hp_polld");
-	unlock_kernel();
-
 	while (1) {
-		if (thread_finished || signal_pending(current))
+		if (thread_finished)
 			break;
 		if (controller->ops->query_enum()) {
 			do {
@@ -592,7 +585,7 @@ poll_thread(void *data)
 static int
 cpci_start_thread(void)
 {
-	int pid;
+	struct task_struct *task;
 
 	/* initialize our semaphores */
 	init_MUTEX_LOCKED(&event_semaphore);
@@ -600,14 +593,13 @@ cpci_start_thread(void)
 	thread_finished = 0;
 
 	if (controller->irq)
-		pid = kernel_thread(event_thread, NULL, 0);
+		task = kthread_run(event_thread, NULL, "cpci_hp_eventd");
 	else
-		pid = kernel_thread(poll_thread, NULL, 0);
-	if (pid < 0) {
+		task = kthread_run(poll_thread, NULL, "cpci_hp_polld");
+	if (IS_ERR(task)) {
 		err("Can't start up our thread");
 		return -1;
 	}
-	dbg("Our thread pid = %d", pid);
 	return 0;
 }
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
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

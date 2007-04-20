From: akpm@linux-foundation.org
Subject: + cpqphp-partially-convert-to-use-the-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 18:55:15 -0700
Message-ID: <200704200155.l3K1tFQT004593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbXDTBzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 21:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, gregkh@suse.de, kristen.c.accardi@intel.com


The patch titled
     cpqphp: partially convert to use the kthread API
has been added to the -mm tree.  Its filename is
     cpqphp-partially-convert-to-use-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-i-oat-for-kexec.patch
cpqphp-partially-convert-to-use-the-kthread-api.patch
s390-scsi-zfcp_erp-partially-convert-to-use-the-kthread-api.patch
s390-qeth-convert-to-use-the-kthread-api.patch
s390-net-lcs-convert-to-the-kthread-api.patch
sas_scsi_host-partially-convert-to-use-the-kthread-api.patch
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

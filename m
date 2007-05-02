From: akpm@linux-foundation.org
Subject: - macintosh-adb-convert-to-the-kthread-api.patch removed from -mm tree
Date: Wed, 02 May 2007 12:33:04 -0700
Message-ID: <200705021933.l42JX4oC028249@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993161AbXEBTdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:33:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     macintosh/adb: convert to the kthread API
has been removed from the -mm tree.  Its filename was
     macintosh-adb-convert-to-the-kthread-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: macintosh/adb: convert to the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the startup of kadbprobe to use kthread_run instead of
scheduling a work event which later calls kernel_thread and in the thread
calls daemonize and blocks signals.  kthread_run is simpler and more
maintainable.

The variable pid_t adb_probe_task_pid is replaced by a struct task_struct
variable named adb_probe_task.  Which works equally well with for testing
if the current process is the adb_probe thread, does not get confused in
the presence of a pid namespace and is easier to compare against current as
it is the same type.

The result is code that is slightly simpler and easier to maintain.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adb.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff -puN drivers/macintosh/adb.c~macintosh-adb-convert-to-the-kthread-api drivers/macintosh/adb.c
--- a/drivers/macintosh/adb.c~macintosh-adb-convert-to-the-kthread-api
+++ a/drivers/macintosh/adb.c
@@ -35,6 +35,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/device.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
@@ -82,7 +83,7 @@ struct adb_driver *adb_controller;
 BLOCKING_NOTIFIER_HEAD(adb_client_list);
 static int adb_got_sleep;
 static int adb_inited;
-static pid_t adb_probe_task_pid;
+static struct task_struct *adb_probe_task;
 static DECLARE_MUTEX(adb_probe_mutex);
 static struct completion adb_probe_task_comp;
 static int sleepy_trackpad;
@@ -137,8 +138,7 @@ static void printADBreply(struct adb_req
 
 static __inline__ void adb_wait_ms(unsigned int ms)
 {
-	if (current->pid && adb_probe_task_pid &&
-	  adb_probe_task_pid == current->pid)
+	if (adb_probe_task == current)
 		msleep(ms);
 	else
 		mdelay(ms);
@@ -245,35 +245,19 @@ static int adb_scan_bus(void)
  * This kernel task handles ADB probing. It dies once probing is
  * completed.
  */
-static int
-adb_probe_task(void *x)
+static int adb_probe(void *x)
 {
-	sigset_t blocked;
-
-	strcpy(current->comm, "kadbprobe");
-
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(current);
 
 	printk(KERN_INFO "adb: starting probe task...\n");
 	do_adb_reset_bus();
 	printk(KERN_INFO "adb: finished probe task...\n");
 	
-	adb_probe_task_pid = 0;
+	adb_probe_task = NULL;
 	up(&adb_probe_mutex);
 	
 	return 0;
 }
 
-static void
-__adb_probe_task(struct work_struct *bullshit)
-{
-	adb_probe_task_pid = kernel_thread(adb_probe_task, NULL, SIGCHLD | CLONE_KERNEL);
-}
-
-static DECLARE_WORK(adb_reset_work, __adb_probe_task);
-
 int
 adb_reset_bus(void)
 {
@@ -283,7 +267,7 @@ adb_reset_bus(void)
 	}
 
 	down(&adb_probe_mutex);
-	schedule_work(&adb_reset_work);
+	adb_probe_task = kthread_run(adb_probe, NULL, "kadbprobe");
 	return 0;
 }
 
@@ -469,9 +453,7 @@ adb_request(struct adb_request *req, voi
 	/* Synchronous requests send from the probe thread cause it to
 	 * block. Beware that the "done" callback will be overriden !
 	 */
-	if ((flags & ADBREQ_SYNC) &&
-	    (current->pid && adb_probe_task_pid &&
-	    adb_probe_task_pid == current->pid)) {
+	if ((flags & ADBREQ_SYNC) && (current == adb_probe_task)) {
 		req->done = adb_probe_wakeup;
 		rc = adb_controller->send_request(req, 0);
 		if (rc || req->complete)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
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
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

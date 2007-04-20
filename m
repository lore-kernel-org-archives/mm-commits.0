From: akpm@linux-foundation.org
Subject: + ibmphp-partially-convert-to-use-the-kthreads-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 18:57:58 -0700
Message-ID: <200704200157.l3K1vw0g004634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315AbXDTB6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 21:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, gregkh@suse.de, jshah@us.ibm.com, kristen.c.accardi@intel.com


The patch titled
     ibmphp: partially convert to use the kthreads API
has been added to the -mm tree.  Its filename is
     ibmphp-partially-convert-to-use-the-kthreads-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ibmphp: partially convert to use the kthreads API
From: Eric W. Biederman <ebiederm@xmission.com>

kthread_run replaces kernel_thread and dameonize.

allow_signal is unnecessary and has been removed.  tid_poll was unused and
has been removed.

akpm: needs to be converted to use kthread_should_stop() and kthread_stop().

akpm: and mutexes!

Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jyoti Shah <jshah@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_hpc.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/pci/hotplug/ibmphp_hpc.c~ibmphp-partially-convert-to-use-the-kthreads-api drivers/pci/hotplug/ibmphp_hpc.c
--- a/drivers/pci/hotplug/ibmphp_hpc.c~ibmphp-partially-convert-to-use-the-kthreads-api
+++ a/drivers/pci/hotplug/ibmphp_hpc.c
@@ -35,6 +35,7 @@
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #include "ibmphp.h"
 
@@ -102,7 +103,6 @@ static int to_debug = 0;
 // global variables
 //----------------------------------------------------------------------------
 static int ibmphp_shutdown;
-static int tid_poll;
 static struct mutex sem_hpcaccess;	// lock access to HPC
 static struct semaphore semOperations;	// lock all operations and
 					// access to data structures
@@ -138,7 +138,6 @@ void __init ibmphp_hpc_initvars (void)
 	init_MUTEX_LOCKED (&sem_exit);
 	to_debug = 0;
 	ibmphp_shutdown = 0;
-	tid_poll = 0;
 
 	debug ("%s - Exit\n", __FUNCTION__);
 }
@@ -1061,12 +1060,8 @@ static int hpc_poll_thread (void *data)
 {
 	debug ("%s - Entry\n", __FUNCTION__);
 
-	daemonize("hpc_poll");
-	allow_signal(SIGKILL);
-
 	poll_hpc ();
 
-	tid_poll = 0;
 	debug ("%s - Exit\n", __FUNCTION__);
 	return 0;
 }
@@ -1079,17 +1074,18 @@ static int hpc_poll_thread (void *data)
 *---------------------------------------------------------------------*/
 int __init ibmphp_hpc_start_poll_thread (void)
 {
+	struct task_struct *task;
 	int rc = 0;
 
 	debug ("%s - Entry\n", __FUNCTION__);
 
-	tid_poll = kernel_thread (hpc_poll_thread, NULL, 0);
-	if (tid_poll < 0) {
+	task = kthread_run(hpc_poll_thread, NULL, "hpc_poll");
+	if (IS_ERR(task)) {
 		err ("%s - Error, thread not started\n", __FUNCTION__);
 		rc = -1;
 	}
 
-	debug ("%s - Exit tid_poll[%d] rc[%d]\n", __FUNCTION__, tid_poll, rc);
+	debug ("%s - Exit rc[%d]\n", __FUNCTION__, rc);
 	return rc;
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
ibmphp-partially-convert-to-use-the-kthreads-api.patch
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

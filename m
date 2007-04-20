From: akpm@linux-foundation.org
Subject: + sas_scsi_host-partially-convert-to-use-the-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 17:38:35 -0700
Message-ID: <200704200038.l3K0cZfe003298@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbXDTAij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 20:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, James.Bottomley@SteelEye.com, djwong@us.ibm.com


The patch titled
     sas_scsi_host: partially convert to use the kthread API
has been added to the -mm tree.  Its filename is
     sas_scsi_host-partially-convert-to-use-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sas_scsi_host: partially convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the sas scsi host thread startup to use kthread_run not
kernel_thread and deamonize.  kthread_run is slightly simpler and more
maintainable.

akpm: the driver should also be converted to use kthread_should_stop() and
kthread_stop().

Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_scsi_host.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/libsas/sas_scsi_host.c~sas_scsi_host-partially-convert-to-use-the-kthread-api drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~sas_scsi_host-partially-convert-to-use-the-kthread-api
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -40,6 +40,7 @@
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 /* ---------- SCSI Host glue ---------- */
 
@@ -870,7 +871,6 @@ static int sas_queue_thread(void *_sas_h
 	struct sas_ha_struct *sas_ha = _sas_ha;
 	struct scsi_core *core = &sas_ha->core;
 
-	daemonize("sas_queue_%d", core->shost->host_no);
 	current->flags |= PF_NOFREEZE;
 
 	complete(&queue_th_comp);
@@ -891,19 +891,20 @@ static int sas_queue_thread(void *_sas_h
 
 int sas_init_queue(struct sas_ha_struct *sas_ha)
 {
-	int res;
 	struct scsi_core *core = &sas_ha->core;
+	struct task_struct *task;
 
 	spin_lock_init(&core->task_queue_lock);
 	core->task_queue_size = 0;
 	INIT_LIST_HEAD(&core->task_queue);
 	init_MUTEX_LOCKED(&core->queue_thread_sema);
 
-	res = kernel_thread(sas_queue_thread, sas_ha, 0);
-	if (res >= 0)
+	task = kthread_run(sas_queue_thread, sas_ha,
+			   "sas_queue_%d", core->shost->host_no);
+	if (!IS_ERR(task))
 		wait_for_completion(&queue_th_comp);
 
-	return res < 0 ? res : 0;
+	return IS_ERR(task) ? PTR_ERR(task) : 0;
 }
 
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha)
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

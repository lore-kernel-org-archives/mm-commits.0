From: akpm@linux-foundation.org
Subject: - sas_scsi_host-partially-convert-to-use-the-kthread-api.patch removed from -mm tree
Date: Wed, 02 May 2007 12:34:27 -0700
Message-ID: <200705021934.l42JYRau028317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766768AbXEBTfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, James.Bottomley@SteelEye.com, djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sas_scsi_host: partially convert to use the kthread API
has been removed from the -mm tree.  Its filename was
     sas_scsi_host-partially-convert-to-use-the-kthread-api.patch

This patch was dropped because an updated version will be merged

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
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/libsas/sas_scsi_host.c~sas_scsi_host-partially-convert-to-use-the-kthread-api drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~sas_scsi_host-partially-convert-to-use-the-kthread-api
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -38,6 +38,7 @@
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
+#include <linux/kthread.h>
 #include <linux/scatterlist.h>
 
 /* ---------- SCSI Host glue ---------- */
@@ -869,7 +870,6 @@ static int sas_queue_thread(void *_sas_h
 	struct sas_ha_struct *sas_ha = _sas_ha;
 	struct scsi_core *core = &sas_ha->core;
 
-	daemonize("sas_queue_%d", core->shost->host_no);
 	current->flags |= PF_NOFREEZE;
 
 	complete(&queue_th_comp);
@@ -888,19 +888,20 @@ static int sas_queue_thread(void *_sas_h
 
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

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
msi-fix-arm-compile.patch
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

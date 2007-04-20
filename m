From: akpm@linux-foundation.org
Subject: + mtd_blkdevs-convert-to-use-the-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 19:07:35 -0700
Message-ID: <200704200207.l3K27ZIm004811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXDTCIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 22:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, dwmw2@infradead.org


The patch titled
     mtd_blkdevs: convert to use the kthread API
has been added to the -mm tree.  Its filename is
     mtd_blkdevs-convert-to-use-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtd_blkdevs: convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

kthread_run is used intead of kernel_thread, daemonize, and mucking around
blocking signals directly.

akpm: needs to be converted to kthread_should_stop() and kthread_stop(), too.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtd_blkdevs.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN drivers/mtd/mtd_blkdevs.c~mtd_blkdevs-convert-to-use-the-kthread-api drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~mtd_blkdevs-convert-to-use-the-kthread-api
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/fs.h>
+#include <linux/kthread.h>
 #include <linux/mtd/blktrans.h>
 #include <linux/mtd/mtd.h>
 #include <linux/blkdev.h>
@@ -83,17 +84,6 @@ static int mtd_blktrans_thread(void *arg
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
 	current->flags |= PF_MEMALLOC | PF_NOFREEZE;
 
-	daemonize("%sd", tr->name);
-
-	/* daemonize() doesn't do this for us since some kernel threads
-	   actually want to deal with signals. We can't just call
-	   exit_sighand() since that'll cause an oops when we finally
-	   do exit. */
-	spin_lock_irq(&current->sighand->siglock);
-	sigfillset(&current->blocked);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
 	spin_lock_irq(rq->queue_lock);
 
 	while (!tr->blkcore_priv->exiting) {
@@ -365,6 +355,7 @@ static struct mtd_notifier blktrans_noti
 
 int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 {
+	struct task_struct *task;
 	int ret, i;
 
 	/* Register the notifier if/when the first device type is
@@ -403,13 +394,13 @@ int register_mtd_blktrans(struct mtd_blk
 	blk_queue_hardsect_size(tr->blkcore_priv->rq, tr->blksize);
 	tr->blkshift = ffs(tr->blksize) - 1;
 
-	ret = kernel_thread(mtd_blktrans_thread, tr, CLONE_KERNEL);
-	if (ret < 0) {
+	task = kthread_run(mtd_blktrans_thread, tr, "%sd", tr->name);
+	if (IS_ERR(task)) {
 		blk_cleanup_queue(tr->blkcore_priv->rq);
 		unregister_blkdev(tr->major, tr->name);
 		kfree(tr->blkcore_priv);
 		mutex_unlock(&mtd_table_mutex);
-		return ret;
+		return PTR_ERR(task);
 	}
 
 	INIT_LIST_HEAD(&tr->devs);
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
mtd_blkdevs-convert-to-use-the-kthread-api.patch
fix-i-oat-for-kexec.patch
cpqphp-partially-convert-to-use-the-kthread-api.patch
ibmphp-partially-convert-to-use-the-kthreads-api.patch
cpci_hotplug-partially-convert-to-use-the-kthread-api.patch
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

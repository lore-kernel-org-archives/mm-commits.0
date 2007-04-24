From: akpm@linux-foundation.org
Subject: - kthread-simplify-kthread_create.patch removed from -mm tree
Date: Tue, 24 Apr 2007 03:10:23 -0700
Message-ID: <200704241010.l3OAANoX006025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161707AbXDXKK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 06:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, hch@lst.de, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     kthread: simplify kthread_create
has been removed from the -mm tree.  Its filename was
     kthread-simplify-kthread_create.patch

This patch was dropped because it edpended upon kthread-enhance-kthread_stop-to-abort-interruptible-sleeps.patch

------------------------------------------------------
Subject: kthread: simplify kthread_create
From: Eric W. Biederman <ebiederm@xmission.com>

This removes an unneeded completion from kthread_create and moves
wake_up_process out of the kthread_create_lock making it clear that
wake_up_process doesn't need the protection of the kthread_create_lock.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/kthread.c~kthread-simplify-kthread_create kernel/kthread.c
--- a/kernel/kthread.c~kthread-simplify-kthread_create
+++ a/kernel/kthread.c
@@ -24,7 +24,6 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
-	struct completion started;
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
@@ -41,6 +40,9 @@ static int kthread(void *_create)
 	void *data;
 	int ret = -EINTR;
 
+	/* Report which task_struct I am */
+	create->result = current;
+
 	/* Setup a completion on this thread's stack */
 	init_completion(&done);
 	current->vfork_done = &done;
@@ -51,7 +53,7 @@ static int kthread(void *_create)
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_INTERRUPTIBLE);
-	complete(&create->started);
+	complete(&create->done);
 	schedule();
 
 	if (!kthread_should_stop())
@@ -68,13 +70,8 @@ static void create_kthread(struct kthrea
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {
 		create->result = ERR_PTR(pid);
-	} else {
-		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid(pid);
-		read_unlock(&tasklist_lock);
+		complete(&create->done);
 	}
-	complete(&create->done);
 }
 
 /**
@@ -105,14 +102,13 @@ struct task_struct *kthread_create(int (
 
 	create.threadfn = threadfn;
 	create.data = data;
-	init_completion(&create.started);
 	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
-	wake_up_process(kthreadd_task);
 	spin_unlock(&kthread_create_lock);
 
+	wake_up_process(kthreadd_task);
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
_

Patches currently in -mm which might be from ebiederm@xmission.com are

arm-ecard-convert-to-use-the-kthread-api.patch
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
git-mtd.patch
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
i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api.patch
i386-balance_irq-convert-to-the-kthread-api.patch
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
kthread-simplify-kthread_create.patch
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
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
md-remove-broken-sigkill-support.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

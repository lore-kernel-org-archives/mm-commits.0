From: akpm@linux-foundation.org
Subject: - ia64-sn-xpc-convert-to-use-kthread-api.patch removed from -mm tree
Date: Wed, 02 May 2007 12:33:28 -0700
Message-ID: <200705021933.l42JXSXC028265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766663AbXEBTeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:34:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, holt@sgi.com, jes@sgi.com, rja@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64 sn xpc: convert to use kthread API
has been removed from the -mm tree.  Its filename was
     ia64-sn-xpc-convert-to-use-kthread-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ia64 sn xpc: convert to use kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch starts the xpc kernel threads using kthread_run not a
combination of kernel_thread and daemonize.  Resuling in slightly simpler
and more maintainable code.

Cc: Jes Sorensen <jes@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/xpc_main.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff -puN arch/ia64/sn/kernel/xpc_main.c~ia64-sn-xpc-convert-to-use-kthread-api arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c~ia64-sn-xpc-convert-to-use-kthread-api
+++ a/arch/ia64/sn/kernel/xpc_main.c
@@ -50,6 +50,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/syscalls.h>
+#include <linux/kthread.h>
 #include <linux/cache.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -253,8 +254,6 @@ xpc_hb_checker(void *ignore)
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	daemonize(XPC_HB_CHECK_THREAD_NAME);
-
 	set_cpus_allowed(current, cpumask_of_cpu(XPC_HB_CHECK_CPU));
 
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
@@ -324,8 +323,6 @@ xpc_hb_checker(void *ignore)
 static int
 xpc_initiate_discovery(void *ignore)
 {
-	daemonize(XPC_DISCOVERY_THREAD_NAME);
-
 	xpc_discovery();
 
 	dev_dbg(xpc_part, "discovery thread is exiting\n");
@@ -494,8 +491,6 @@ xpc_activating(void *__partid)
 
 	dev_dbg(xpc_part, "bringing partition %d up\n", partid);
 
-	daemonize("xpc%02d", partid);
-
 	/*
 	 * This thread needs to run at a realtime priority to prevent a
 	 * significant performance degradation.
@@ -559,7 +554,7 @@ xpc_activate_partition(struct xpc_partit
 {
 	partid_t partid = XPC_PARTID(part);
 	unsigned long irq_flags;
-	pid_t pid;
+	struct task_struct *task;
 
 
 	spin_lock_irqsave(&part->act_lock, irq_flags);
@@ -571,9 +566,10 @@ xpc_activate_partition(struct xpc_partit
 
 	spin_unlock_irqrestore(&part->act_lock, irq_flags);
 
-	pid = kernel_thread(xpc_activating, (void *) ((u64) partid), 0);
+	task = kthread_run(xpc_activating, (void *) ((u64) partid),
+			  "xpc%02d", partid);
 
-	if (unlikely(pid <= 0)) {
+	if (unlikely(IS_ERR(task))) {
 		spin_lock_irqsave(&part->act_lock, irq_flags);
 		part->act_state = XPC_P_INACTIVE;
 		XPC_SET_REASON(part, xpcCloneKThreadFailed, __LINE__);
@@ -724,8 +720,6 @@ xpc_daemonize_kthread(void *args)
 	unsigned long irq_flags;
 
 
-	daemonize("xpc%02dc%d", partid, ch_number);
-
 	dev_dbg(xpc_chan, "kthread starting, partid=%d, channel=%d\n",
 		partid, ch_number);
 
@@ -844,8 +838,9 @@ xpc_create_kthreads(struct xpc_channel *
 		(void) xpc_part_ref(part);
 		xpc_msgqueue_ref(ch);
 
-		pid = kernel_thread(xpc_daemonize_kthread, (void *) args, 0);
-		if (pid < 0) {
+		task = kthread_run(xpc_daemonize_kthread, args,
+				   "xpc%02dc%d", partid, ch_number);
+		if (IS_ERR(task)) {
 			/* the fork failed */
 
 			/*
@@ -1222,7 +1217,7 @@ xpc_init(void)
 	int ret;
 	partid_t partid;
 	struct xpc_partition *part;
-	pid_t pid;
+	struct task_struct *task;
 	size_t buf_size;
 
 
@@ -1353,8 +1348,8 @@ xpc_init(void)
 	 * The real work-horse behind xpc.  This processes incoming
 	 * interrupts and monitors remote heartbeats.
 	 */
-	pid = kernel_thread(xpc_hb_checker, NULL, 0);
-	if (pid < 0) {
+	task = kthread_run(xpc_hb_checker, NULL, XPC_HB_CHECK_THREAD_NAME);
+	if (IS_ERR(task)) {
 		dev_err(xpc_part, "failed while forking hb check thread\n");
 
 		/* indicate to others that our reserved page is uninitialized */
@@ -1384,8 +1379,8 @@ xpc_init(void)
 	 * activate based on info provided by SAL. This new thread is short
 	 * lived and will exit once discovery is complete.
 	 */
-	pid = kernel_thread(xpc_initiate_discovery, NULL, 0);
-	if (pid < 0) {
+	task = kthread_run(xpc_initiate_discovery, NULL, XPC_DISCOVERY_THREAD_NAME);
+	if (IS_ERR(task)) {
 		dev_err(xpc_part, "failed while forking discovery thread\n");
 
 		/* mark this new thread as a non-starter */
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
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

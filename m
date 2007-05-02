From: akpm@linux-foundation.org
Subject: - s390-qeth-convert-to-use-the-kthread-api.patch removed from -mm tree
Date: Wed, 02 May 2007 12:34:17 -0700
Message-ID: <200705021934.l42JYHnc028303@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766739AbXEBTfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:35:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, fpavlic@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390 qeth: convert to use the kthread API
has been removed from the -mm tree.  Its filename was
     s390-qeth-convert-to-use-the-kthread-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: s390 qeth: convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the qeth_recover thread to be started with kthread_run
not a combination of kernel_thread and daemonize.  Resulting in slightly
simpler and more maintainable code.

Cc: Frank Pavlic <fpavlic@de.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/qeth_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/s390/net/qeth_main.c~s390-qeth-convert-to-use-the-kthread-api drivers/s390/net/qeth_main.c
--- a/drivers/s390/net/qeth_main.c~s390-qeth-convert-to-use-the-kthread-api
+++ a/drivers/s390/net/qeth_main.c
@@ -50,6 +50,7 @@
 #include <linux/mii.h>
 #include <linux/rcupdate.h>
 #include <linux/ethtool.h>
+#include <linux/kthread.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -957,7 +958,6 @@ qeth_recover(void *ptr)
 	int rc = 0;
 
 	card = (struct qeth_card *) ptr;
-	daemonize("qeth_recover");
 	QETH_DBF_TEXT(trace,2,"recover1");
 	QETH_DBF_HEX(trace, 2, &card, sizeof(void *));
 	if (!qeth_do_run_thread(card, QETH_RECOVER_THREAD))
@@ -1014,7 +1014,7 @@ qeth_start_kernel_thread(struct work_str
 	    card->write.state != CH_STATE_UP)
 		return;
 	if (qeth_do_start_thread(card, QETH_RECOVER_THREAD))
-		kernel_thread(qeth_recover, (void *) card, SIGCHLD);
+		kthread_run(qeth_recover, card, "qeth_recover");
 }
 
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
msi-fix-arm-compile.patch
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

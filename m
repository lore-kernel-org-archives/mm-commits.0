From: akpm@linux-foundation.org
Subject: - powerpc-pseries-rtasd-convert-to-kthread-api.patch removed from -mm tree
Date: Wed, 02 May 2007 12:33:14 -0700
Message-ID: <200705021933.l42JXErA028255@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766663AbXEBTdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 15:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc pseries rtasd: convert to kthread API
has been removed from the -mm tree.  Its filename was
     powerpc-pseries-rtasd-convert-to-kthread-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: powerpc pseries rtasd: convert to kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the startup of rtasd to use kthread_run instaed of a
combination of kernel_thread and daemonize.  Making the code a little
simpler and more maintainble.

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/rtasd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/pseries/rtasd.c~powerpc-pseries-rtasd-convert-to-kthread-api arch/powerpc/platforms/pseries/rtasd.c
--- a/arch/powerpc/platforms/pseries/rtasd.c~powerpc-pseries-rtasd-convert-to-kthread-api
+++ a/arch/powerpc/platforms/pseries/rtasd.c
@@ -20,6 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -429,8 +430,6 @@ static int rtasd(void *unused)
 	int event_scan = rtas_token("event-scan");
 	int rc;
 
-	daemonize("rtasd");
-
 	if (event_scan == RTAS_UNKNOWN_SERVICE || get_eventscan_parms() == -1)
 		goto error;
 
@@ -497,7 +496,7 @@ static int __init rtas_init(void)
 	else
 		printk(KERN_ERR "Failed to create error_log proc entry\n");
 
-	if (kernel_thread(rtasd, NULL, CLONE_FS) < 0)
+	if (IS_ERR(kthread_run(rtasd, NULL, "rtasd")))
 		printk(KERN_ERR "Failed to start RTAS daemon\n");
 
 	return 0;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
git-arm.patch
iop13xx-msi-support-rev6.patch
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

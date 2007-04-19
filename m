From: akpm@linux-foundation.org
Subject: + powerpc-pseries-rtasd-convert-to-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 16:42:31 -0700
Message-ID: <200704192342.l3JNgVkj002087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbXDSXme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 19:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, paulus@samba.org


The patch titled
     powerpc pseries rtasd: convert to kthread API
has been added to the -mm tree.  Its filename is
     powerpc-pseries-rtasd-convert-to-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 3 deletions(-)

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

powerpc-rtas-msi-support.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_windtunnelc-convert-to-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
powerpc-pseries-rtasd-convert-to-kthread-api.patch
mm-only-dvb_en_50221-convert-to-kthread-api.patch
mm-only-saa7134-tvaudio-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
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

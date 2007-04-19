From: akpm@linux-foundation.org
Subject: + macintosh-therm_pm72c-partially-convert-to-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 16:40:53 -0700
Message-ID: <200704192340.l3JNer0c002050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbXDSXk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 19:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, benh@kernel.crashing.org


The patch titled
     macintosh/therm_pm72.c: partially convert to kthread API
has been added to the -mm tree.  Its filename is
     macintosh-therm_pm72c-partially-convert-to-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: macintosh/therm_pm72.c: partially convert to kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies startup of the kfand to use kthread_run not a
combination of kernel_thread and daemonize, making the code a little
simpler and more maintaintable.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/therm_pm72.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/macintosh/therm_pm72.c~macintosh-therm_pm72c-partially-convert-to-kthread-api drivers/macintosh/therm_pm72.c
--- a/drivers/macintosh/therm_pm72.c~macintosh-therm_pm72c-partially-convert-to-kthread-api
+++ a/drivers/macintosh/therm_pm72.c
@@ -121,6 +121,7 @@
 #include <linux/reboot.h>
 #include <linux/kmod.h>
 #include <linux/i2c.h>
+#include <linux/kthread.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
@@ -161,7 +162,7 @@ static struct slots_pid_state		slots_sta
 static int				state;
 static int				cpu_count;
 static int				cpu_pid_type;
-static pid_t				ctrl_task;
+static int				ctrl_task;
 static struct completion		ctrl_complete;
 static int				critical_state;
 static int				rackmac;
@@ -1779,8 +1780,6 @@ static int call_critical_overtemp(void)
  */
 static int main_control_loop(void *x)
 {
-	daemonize("kfand");
-
 	DBG("main_control_loop started\n");
 
 	down(&driver_lock);
@@ -1859,7 +1858,6 @@ static int main_control_loop(void *x)
 			machine_power_off();
 		}
 
-		// FIXME: Deal with signals
 		elapsed = jiffies - start;
 		if (elapsed < HZ)
 			schedule_timeout_interruptible(HZ - elapsed);
@@ -1954,9 +1952,12 @@ static int create_control_loops(void)
  */
 static void start_control_loops(void)
 {
+	struct task_struct *task;
 	init_completion(&ctrl_complete);
 
-	ctrl_task = kernel_thread(main_control_loop, NULL, SIGCHLD | CLONE_KERNEL);
+	task = kthread_run(main_control_loop, NULL, "kfand");
+	if (!IS_ERR(task))
+		ctrl_task = 1;
 }
 
 /*
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_windtunnelc-convert-to-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
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

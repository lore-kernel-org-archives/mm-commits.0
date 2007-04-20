From: akpm@linux-foundation.org
Subject: + pnpbios-conert-to-use-the-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 17:54:06 -0700
Message-ID: <200704200054.l3K0s6Tk003548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbXDTAy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 20:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ambx1@neo.rr.com, bjorn.helgaas@hp.com


The patch titled
     pnpbios: convert to use the kthread API
has been added to the -mm tree.  Its filename is
     pnpbios-conert-to-use-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pnpbios: convert to use the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

This patches modifies the pnpbios kernel thread to start with ktrhead_run
not kernel_thread and deamonize.  Doing this makes the code a little
simpler and easier to maintain.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpbios/core.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/pnp/pnpbios/core.c~pnpbios-conert-to-use-the-kthread-api drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnpbios-conert-to-use-the-kthread-api
+++ a/drivers/pnp/pnpbios/core.c
@@ -62,6 +62,7 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 #include <asm/page.h>
 #include <asm/desc.h>
@@ -159,9 +160,7 @@ static int pnp_dock_thread(void * unused
 {
 	static struct pnp_docking_station_info now;
 	int docked = -1, d = 0;
-	daemonize("kpnpbiosd");
-	allow_signal(SIGKILL);
-	while(!unloading && !signal_pending(current))
+	while (!unloading)
 	{
 		int status;
 		
@@ -170,11 +169,8 @@ static int pnp_dock_thread(void * unused
 		 */
 		msleep_interruptible(2000);
 
-		if(signal_pending(current)) {
-			if (try_to_freeze())
-				continue;
-			break;
-		}
+		if (try_to_freeze())
+			continue;
 
 		status = pnp_bios_dock_station_info(&now);
 
@@ -581,6 +577,7 @@ subsys_initcall(pnpbios_init);
 
 static int __init pnpbios_thread_init(void)
 {
+	struct task_struct *task;
 #if defined(CONFIG_PPC_MERGE)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return 0;
@@ -589,7 +586,8 @@ static int __init pnpbios_thread_init(vo
 		return 0;
 #ifdef CONFIG_HOTPLUG
 	init_completion(&unload_sem);
-	if (kernel_thread(pnp_dock_thread, NULL, CLONE_KERNEL) > 0)
+	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
+	if (!IS_ERR(task))
 		unloading = 0;
 #endif
 	return 0;
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

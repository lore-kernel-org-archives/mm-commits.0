From: akpm@linux-foundation.org
Subject: - sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:14 -0800
Message-ID: <200702150850.l1F8oEAf025202@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40183 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965493AbXBOIuP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: move init_irq_proc into init/main where it belongs
has been removed from the -mm tree.  Its filename was
     sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: move init_irq_proc into init/main where it belongs
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c     |    3 +++
 kernel/sysctl.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN init/main.c~sysctl-move-init_irq_proc-into-init-main-where-it-belongs init/main.c
--- a/init/main.c~sysctl-move-init_irq_proc-into-init-main-where-it-belongs
+++ a/init/main.c
@@ -705,6 +705,9 @@ static void __init do_basic_setup(void)
 #ifdef CONFIG_SYSCTL
 	sysctl_init();
 #endif
+#ifdef CONFIG_PROC_FS
+	init_irq_proc();
+#endif
 
 	do_initcalls();
 }
diff -puN kernel/sysctl.c~sysctl-move-init_irq_proc-into-init-main-where-it-belongs kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-move-init_irq_proc-into-init-main-where-it-belongs
+++ a/kernel/sysctl.c
@@ -1177,8 +1177,6 @@ static ctl_table dev_table[] = {
 	{ .ctl_name = 0 }
 };
 
-extern void init_irq_proc (void);
-
 static DEFINE_SPINLOCK(sysctl_lock);
 
 /* called under sysctl_lock */
@@ -1224,7 +1222,6 @@ void __init sysctl_init(void)
 {
 #ifdef CONFIG_PROC_SYSCTL
 	register_proc_table(root_table, proc_sys_root, &root_table_header);
-	init_irq_proc();
 #endif
 }
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

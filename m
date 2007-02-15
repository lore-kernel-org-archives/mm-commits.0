From: akpm@linux-foundation.org
Subject: - sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:49:32 -0800
Message-ID: <200702150849.l1F8nWWX025135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40160 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965487AbXBOIt7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:49:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: s390: remove unnecessary use of insert_at_head
has been removed from the -mm tree.  Its filename was
     sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: s390: remove unnecessary use of insert_at_head
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/appldata/appldata_base.c |    4 ++--
 arch/s390/kernel/debug.c           |    2 +-
 arch/s390/mm/cmm.c                 |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/s390/appldata/appldata_base.c~sysctl-s390-remove-unnecessary-use-of-insert_at_head arch/s390/appldata/appldata_base.c
--- a/arch/s390/appldata/appldata_base.c~sysctl-s390-remove-unnecessary-use-of-insert_at_head
+++ a/arch/s390/appldata/appldata_base.c
@@ -506,7 +506,7 @@ int appldata_register_ops(struct appldat
 
 	ops->ctl_table[3].ctl_name = 0;
 
-	ops->sysctl_header = register_sysctl_table(ops->ctl_table,1);
+	ops->sysctl_header = register_sysctl_table(ops->ctl_table,0);
 
 	P_INFO("%s-ops registered!\n", ops->name);
 	return 0;
@@ -606,7 +606,7 @@ static int __init appldata_init(void)
 	/* Register cpu hotplug notifier */
 	register_hotcpu_notifier(&appldata_nb);
 
-	appldata_sysctl_header = register_sysctl_table(appldata_dir_table, 1);
+	appldata_sysctl_header = register_sysctl_table(appldata_dir_table, 0);
 #ifdef MODULE
 	appldata_dir_table[0].de->owner = THIS_MODULE;
 	appldata_table[0].de->owner = THIS_MODULE;
diff -puN arch/s390/kernel/debug.c~sysctl-s390-remove-unnecessary-use-of-insert_at_head arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~sysctl-s390-remove-unnecessary-use-of-insert_at_head
+++ a/arch/s390/kernel/debug.c
@@ -1053,7 +1053,7 @@ __init debug_init(void)
 {
 	int rc = 0;
 
-	s390dbf_sysctl_header = register_sysctl_table(s390dbf_dir_table, 1);
+	s390dbf_sysctl_header = register_sysctl_table(s390dbf_dir_table, 0);
 	down(&debug_lock);
 	debug_debugfs_root_entry = debugfs_create_dir(DEBUG_DIR_ROOT,NULL);
 	printk(KERN_INFO "debug: Initialization complete\n");
diff -puN arch/s390/mm/cmm.c~sysctl-s390-remove-unnecessary-use-of-insert_at_head arch/s390/mm/cmm.c
--- a/arch/s390/mm/cmm.c~sysctl-s390-remove-unnecessary-use-of-insert_at_head
+++ a/arch/s390/mm/cmm.c
@@ -418,7 +418,7 @@ cmm_init (void)
 	int rc = -ENOMEM;
 
 #ifdef CONFIG_CMM_PROC
-	cmm_sysctl_header = register_sysctl_table(cmm_dir_table, 1);
+	cmm_sysctl_header = register_sysctl_table(cmm_dir_table, 0);
 	if (!cmm_sysctl_header)
 		goto out;
 #endif
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

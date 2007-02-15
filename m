From: akpm@linux-foundation.org
Subject: - sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:45 -0800
Message-ID: <200702150850.l1F8ojbv025251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40235 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965513AbXBOIux (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     sysctl: add a parent entry to ctl_table and set the parent entry
has been removed from the -mm tree.  Its filename was
     sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: add a parent entry to ctl_table and set the parent entry
From: Eric W. Biederman <ebiederm@xmission.com>

Add a parent entry into the ctl_table so you can walk the list of parents and
find the entire path to a ctl_table entry.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 +
 kernel/sysctl.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff -puN include/linux/sysctl.h~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry
+++ a/include/linux/sysctl.h
@@ -1022,6 +1022,7 @@ struct ctl_table 
 	int maxlen;
 	mode_t mode;
 	ctl_table *child;
+	ctl_table *parent;		/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	ctl_handler *strategy;		/* Callback function for all r/w */
 	struct proc_dir_entry *de;	/* /proc control block */
diff -puN kernel/sysctl.c~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-a-parent-entry-to-ctl_table-and-set-the-parent-entry
+++ a/kernel/sysctl.c
@@ -1240,6 +1240,23 @@ int do_sysctl_strategy (ctl_table *table
 }
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
+static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
+{
+	for (; table->ctl_name || table->procname; table++) {
+		table->parent = parent;
+		if (table->child)
+			sysctl_set_parent(table, table->child);
+	}
+}
+
+static __init int sysctl_init(void)
+{
+	sysctl_set_parent(NULL, root_table);
+	return 0;
+}
+
+core_initcall(sysctl_init);
+
 /**
  * register_sysctl_table - register a sysctl hierarchy
  * @table: the top-level table structure
@@ -1318,6 +1335,7 @@ struct ctl_table_header *register_sysctl
 	INIT_LIST_HEAD(&tmp->ctl_entry);
 	tmp->used = 0;
 	tmp->unregistering = NULL;
+	sysctl_set_parent(NULL, table);
 	spin_lock(&sysctl_lock);
 	list_add_tail(&tmp->ctl_entry, &root_table_header.ctl_entry);
 	spin_unlock(&sysctl_lock);
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

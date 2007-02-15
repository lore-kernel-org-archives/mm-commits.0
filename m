From: akpm@linux-foundation.org
Subject: - sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:37 -0800
Message-ID: <200702150850.l1F8obld025242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40210 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965508AbXBOIuj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: factor out sysctl_head_next from do_sysctl
has been removed from the -mm tree.  Its filename was
     sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: factor out sysctl_head_next from do_sysctl
From: Eric W. Biederman <ebiederm@xmission.com>

The current logic to walk through the list of sysctl table headers is slightly
painful and implement in a way it cannot be used by code outside sysctl.c

I am in the process of implementing a version of the sysctl proc support that
instead of using the proc generic non-caching monster, just uses the existing
sysctl data structure as backing store for building the dcache entries and for
doing directory reads.  To use the existing data structures however I need a
way to get at them.

[akpm@osdl.org: warning fix]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    4 ++
 kernel/sysctl.c        |   60 +++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 17 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-factor-out-sysctl_head_next-from-do_sysctl include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-factor-out-sysctl_head_next-from-do_sysctl
+++ a/include/linux/sysctl.h
@@ -924,6 +924,10 @@ enum
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+/* For the /proc/sys support */
+extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
+extern void sysctl_head_finish(struct ctl_table_header *prev);
+
 extern void sysctl_init(void);
 
 typedef struct ctl_table ctl_table;
diff -puN kernel/sysctl.c~sysctl-factor-out-sysctl_head_next-from-do_sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-factor-out-sysctl_head_next-from-do_sysctl
+++ a/kernel/sysctl.c
@@ -1070,6 +1070,42 @@ static void start_unregistering(struct c
 	list_del_init(&p->ctl_entry);
 }
 
+void sysctl_head_finish(struct ctl_table_header *head)
+{
+	if (!head)
+		return;
+	spin_lock(&sysctl_lock);
+	unuse_table(head);
+	spin_unlock(&sysctl_lock);
+}
+
+struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev)
+{
+	struct ctl_table_header *head;
+	struct list_head *tmp;
+	spin_lock(&sysctl_lock);
+	if (prev) {
+		tmp = &prev->ctl_entry;
+		unuse_table(prev);
+		goto next;
+	}
+	tmp = &root_table_header.ctl_entry;
+	for (;;) {
+		head = list_entry(tmp, struct ctl_table_header, ctl_entry);
+
+		if (!use_table(head))
+			goto next;
+		spin_unlock(&sysctl_lock);
+		return head;
+	next:
+		tmp = tmp->next;
+		if (tmp == &root_table_header.ctl_entry)
+			break;
+	}
+	spin_unlock(&sysctl_lock);
+	return NULL;
+}
+
 void __init sysctl_init(void)
 {
 #ifdef CONFIG_PROC_SYSCTL
@@ -1081,7 +1117,7 @@ void __init sysctl_init(void)
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
 {
-	struct list_head *tmp;
+	struct ctl_table_header *head;
 	int error = -ENOTDIR;
 
 	if (nlen <= 0 || nlen >= CTL_MAXNAME)
@@ -1091,26 +1127,16 @@ int do_sysctl(int __user *name, int nlen
 		if (!oldlenp || get_user(old_len, oldlenp))
 			return -EFAULT;
 	}
-	spin_lock(&sysctl_lock);
-	tmp = &root_table_header.ctl_entry;
-	do {
-		struct ctl_table_header *head =
-			list_entry(tmp, struct ctl_table_header, ctl_entry);
-
-		if (!use_table(head))
-			continue;
-
-		spin_unlock(&sysctl_lock);
 
+	for (head = sysctl_head_next(NULL); head;
+			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
 					newval, newlen, head->ctl_table);
-
-		spin_lock(&sysctl_lock);
-		unuse_table(head);
-		if (error != -ENOTDIR)
+		if (error != -ENOTDIR) {
+			sysctl_head_finish(head);
 			break;
-	} while ((tmp = tmp->next) != &root_table_header.ctl_entry);
-	spin_unlock(&sysctl_lock);
+		}
+	}
 	return error;
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

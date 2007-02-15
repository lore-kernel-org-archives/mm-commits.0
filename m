From: akpm@linux-foundation.org
Subject: - sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:40 -0800
Message-ID: <200702150850.l1F8oexE025245@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40214 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965510AbXBOIum (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: allow sysctl_perm to be called from outside of sysctl.c
has been removed from the -mm tree.  Its filename was
     sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: allow sysctl_perm to be called from outside of sysctl.c
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 ++
 kernel/sysctl.c        |   10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc
+++ a/include/linux/sysctl.h
@@ -925,8 +925,10 @@ enum
 #include <linux/list.h>
 
 /* For the /proc/sys support */
+struct ctl_table;
 extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
 extern void sysctl_head_finish(struct ctl_table_header *prev);
+extern int sysctl_perm(struct ctl_table *table, int op);
 
 extern void sysctl_init(void);
 
diff -puN kernel/sysctl.c~sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc
+++ a/kernel/sysctl.c
@@ -1157,7 +1157,7 @@ asmlinkage long sys_sysctl(struct __sysc
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
 /*
- * ctl_perm does NOT grant the superuser all rights automatically, because
+ * sysctl_perm does NOT grant the superuser all rights automatically, because
  * some sysctl variables are readonly even to root.
  */
 
@@ -1172,7 +1172,7 @@ static int test_perm(int mode, int op)
 	return -EACCES;
 }
 
-static inline int ctl_perm(ctl_table *table, int op)
+int sysctl_perm(ctl_table *table, int op)
 {
 	int error;
 	error = security_sysctl(table, op);
@@ -1199,7 +1199,7 @@ repeat:
 		if (n == table->ctl_name) {
 			int error;
 			if (table->child) {
-				if (ctl_perm(table, 001))
+				if (sysctl_perm(table, 001))
 					return -EPERM;
 				name++;
 				nlen--;
@@ -1228,7 +1228,7 @@ int do_sysctl_strategy (ctl_table *table
 		op |= 004;
 	if (newval) 
 		op |= 002;
-	if (ctl_perm(table, op))
+	if (sysctl_perm(table, op))
 		return -EPERM;
 
 	if (table->strategy) {
@@ -1498,7 +1498,7 @@ static ssize_t do_rw_proc(int write, str
 			goto out;
 		error = -EPERM;
 		op = (write ? 002 : 004);
-		if (ctl_perm(table, op))
+		if (sysctl_perm(table, op))
 			goto out;
 		
 		/* careful: calling conventions are nasty here */
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

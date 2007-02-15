From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:05 -0800
Message-ID: <200702150850.l1F8o5h3025187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965490AbXBOIuJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert coda ctl_tables and remove binary sysctls
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert coda ctl_tables and remove binary sysctls
From: Eric W. Biederman <ebiederm@xmission.com>

Will converting the coda sysctl initializers I discovered that it is yet
another user of sysctl that was stomping CTL_KERN.  So off with it's
sys_sysctl support since it wasn't done in a supportable way.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/sysctl.c |   58 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 10 deletions(-)

diff -puN fs/coda/sysctl.c~sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls
+++ a/fs/coda/sysctl.c
@@ -33,8 +33,6 @@
 
 static struct ctl_table_header *fs_table_header;
 
-#define FS_CODA         1       /* Coda file system */
-
 #define CODA_TIMEOUT    3       /* timeout on upcalls to become intrble */
 #define CODA_HARD       5       /* mount type "hard" or "soft" */
 #define CODA_VFS 	 6       /* vfs statistics */
@@ -183,17 +181,57 @@ static const struct file_operations proc
 };
 
 static ctl_table coda_table[] = {
- 	{CODA_TIMEOUT, "timeout", &coda_timeout, sizeof(int), 0644, NULL, &proc_dointvec},
- 	{CODA_HARD, "hard", &coda_hard, sizeof(int), 0644, NULL, &proc_dointvec},
- 	{CODA_VFS, "vfs_stats", NULL, 0, 0644, NULL, &do_reset_coda_vfs_stats},
- 	{CODA_CACHE_INV, "cache_inv_stats", NULL, 0, 0644, NULL, &do_reset_coda_cache_inv_stats},
- 	{CODA_FAKE_STATFS, "fake_statfs", &coda_fake_statfs, sizeof(int), 0600, NULL, &proc_dointvec},
-	{ 0 }
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "timeout",
+		.data		= &coda_timeout,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hard",
+		.data		= &coda_hard,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "vfs_stats",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0644,
+		.proc_handler	= &do_reset_coda_vfs_stats
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "cache_inv_stats",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0644,
+		.proc_handler	= &do_reset_coda_cache_inv_stats
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "fake_statfs",
+		.data		= &coda_fake_statfs,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= &proc_dointvec
+	},
+	{}
 };
 
 static ctl_table fs_table[] = {
-       {FS_CODA, "coda",    NULL, 0, 0555, coda_table},
-       {0}
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "coda",
+		.mode		= 0555,
+		.child		= coda_table
+	},
+	{}
 };
 
 
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

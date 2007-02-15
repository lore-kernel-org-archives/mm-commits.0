From: akpm@linux-foundation.org
Subject: - sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:08 -0800
Message-ID: <200702150850.l1F8o8Sh025191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965495AbXBOIuQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     sysctl: C99 convert ctl_tables in NTFS and remove sys_sysctl support
has been removed from the -mm tree.  Its filename was
     sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: C99 convert ctl_tables in NTFS and remove sys_sysctl support
From: Eric W. Biederman <ebiederm@xmission.com>

Putting ntfs-debug under FS_NRINODE was not a kosher thing to do so don't give
it any binary number.

[akpm@osdl.org: build fix]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/sysctl.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN fs/ntfs/sysctl.c~sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support
+++ a/fs/ntfs/sysctl.c
@@ -33,20 +33,28 @@
 #include "sysctl.h"
 #include "debug.h"
 
-#define FS_NTFS	1
-
 /* Definition of the ntfs sysctl. */
 static ctl_table ntfs_sysctls[] = {
-	{ FS_NTFS, "ntfs-debug",		/* Binary and text IDs. */
-	  &debug_msgs,sizeof(debug_msgs),	/* Data pointer and size. */
-	  0644,	NULL, &proc_dointvec },		/* Mode, child, proc handler. */
-	{ 0 }
+	{
+		.ctl_name	= CTL_UNNUMBERED,	/* Binary and text IDs. */
+		.procname	= "ntfs-debug",
+		.data		= &debug_msgs,		/* Data pointer and size. */
+		.maxlen		= sizeof(debug_msgs),
+		.mode		= 0644,			/* Mode, proc handler. */
+		.proc_handler	= &proc_dointvec
+	},
+	{}
 };
 
 /* Define the parent directory /proc/sys/fs. */
 static ctl_table sysctls_root[] = {
-	{ CTL_FS, "fs", NULL, 0, 0555, ntfs_sysctls },
-	{ 0 }
+	{
+		.ctl_name	= CTL_FS,
+		.procname	= "fs",
+		.mode		= 0555,
+		.child		= ntfs_sysctls
+	},
+	{}
 };
 
 /* Storage for the sysctls header. */
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

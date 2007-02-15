From: akpm@linux-foundation.org
Subject: - sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:24 -0800
Message-ID: <200702150850.l1F8oOK0025227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40195 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965299AbXBOIu0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: create sys/fs/binfmt_misc as an ordinary sysctl entry
has been removed from the -mm tree.  Its filename was
     sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: create sys/fs/binfmt_misc as an ordinary sysctl entry
From: Eric W. Biederman <ebiederm@xmission.com>

binfmt_misc has a mount point in the middle of the sysctl and that mount point
is created as a proc_generic directory.

Doing it that way gets in the way of cleaning up the sysctl proc support as it
continues the existence of a horrible hack.  So instead simply create the
directory as an ordinary sysctl directory.  At least that removes the magic
special case.

[akpm@osdl.org: warning fix]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c  |    4 ----
 kernel/sysctl.c |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/proc/root.c~sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry fs/proc/root.c
--- a/fs/proc/root.c~sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry
+++ a/fs/proc/root.c
@@ -74,10 +74,6 @@ void __init proc_root_init(void)
 #ifdef CONFIG_SYSCTL
 	proc_sys_root = proc_mkdir("sys", NULL);
 #endif
-#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
-	proc_mkdir("sys/fs", NULL);
-	proc_mkdir("sys/fs/binfmt_misc", NULL);
-#endif
 	proc_root_fs = proc_mkdir("fs", NULL);
 	proc_root_driver = proc_mkdir("driver", NULL);
 	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
diff -puN kernel/sysctl.c~sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry
+++ a/kernel/sysctl.c
@@ -881,6 +881,12 @@ static ctl_table vm_table[] = {
 	{ .ctl_name = 0 }
 };
 
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+static ctl_table binfmt_misc_table[] = {
+	{ .ctl_name = 0 }
+};
+#endif
+
 static ctl_table fs_table[] = {
 	{
 		.ctl_name	= FS_NRINODE,
@@ -1004,6 +1010,14 @@ static ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "binfmt_misc",
+		.mode		= 0555,
+		.child		= binfmt_misc_table,
+	},
+#endif
 	{ .ctl_name = 0 }
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

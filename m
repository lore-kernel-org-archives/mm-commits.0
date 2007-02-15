From: akpm@linux-foundation.org
Subject: - sysctl-hide-the-sysctl-proc-inodes-from-selinux.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:56 -0800
Message-ID: <200702150850.l1F8ouNV025263@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965522AbXBOIu5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:50:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: hide the sysctl proc inodes from selinux
has been removed from the -mm tree.  Its filename was
     sysctl-hide-the-sysctl-proc-inodes-from-selinux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: hide the sysctl proc inodes from selinux
From: Eric W. Biederman <ebiederm@xmission.com>

Since the security checks are applied on each read and write of a sysctl file,
just like they are applied when calling sys_sysctl, they are redundant on the
standard VFS constructs.  Since it is difficult to compute the security labels
on the standard VFS constructs we just mark the sysctl inodes in proc private
so selinux won't even bother with them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/proc_sysctl.c~sysctl-hide-the-sysctl-proc-inodes-from-selinux fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-hide-the-sysctl-proc-inodes-from-selinux
+++ a/fs/proc/proc_sysctl.c
@@ -47,6 +47,7 @@ static struct inode *proc_sys_make_inode
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode->i_op = &proc_sys_inode_operations;
 	inode->i_fop = &proc_sys_file_operations;
+	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
 	proc_sys_refresh_inode(inode, table);
 out:
 	return inode;
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

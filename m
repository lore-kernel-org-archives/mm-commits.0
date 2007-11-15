From: akpm@linux-foundation.org
Subject: - proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:42:04 -0800
Message-ID: <200711150042.lAF0g4Ig001956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756921AbXKOAxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:53:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@sw.ru, ebiederm@xmission.com, sukadev@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch

This patch was dropped because it was folded into proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch

------------------------------------------------------
Subject: proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#51: FILE: fs/proc/generic.c:573:
+			struct file * filp = list_entry(p, struct file, f_u.fu_list);

ERROR: "foo * bar" should be "foo *bar"
#51: FILE: fs/proc/generic.c:573:
+			struct file * filp = list_entry(p, struct file, f_u.fu_list);

ERROR: "foo * bar" should be "foo *bar"
#52: FILE: fs/proc/generic.c:574:
+			struct dentry * dentry = filp->f_path.dentry;

ERROR: "foo * bar" should be "foo *bar"
#53: FILE: fs/proc/generic.c:575:
+			struct inode * inode;

total: 3 errors, 1 warnings, 62 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/generic.c~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes fs/proc/generic.c
--- a/fs/proc/generic.c~proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes
+++ a/fs/proc/generic.c
@@ -570,9 +570,10 @@ static void proc_kill_inodes(struct proc
 	list_for_each_entry(sb, &proc_fs_type.fs_supers, s_instances) {
 		file_list_lock();
 		list_for_each(p, &sb->s_files) {
-			struct file * filp = list_entry(p, struct file, f_u.fu_list);
-			struct dentry * dentry = filp->f_path.dentry;
-			struct inode * inode;
+			struct file *filp = list_entry(p, struct file,
+							f_u.fu_list);
+			struct dentry *dentry = filp->f_path.dentry;
+			struct inode *inode;
 			const struct file_operations *fops;
 
 			if (dentry->d_op != &proc_dentry_operations)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch

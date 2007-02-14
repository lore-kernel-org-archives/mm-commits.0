From: akpm@linux-foundation.org
Subject: - sysctl-reimplement-the-sysctl-proc-support-fix-2.patch removed from -mm tree
Date: Tue, 13 Feb 2007 22:59:24 -0800
Message-ID: <200702140659.l1E6xOn0023851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbXBNG7b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 01:59:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sysctl-reimplement-the-sysctl-proc-support-fix-2
has been removed from the -mm tree.  Its filename was
     sysctl-reimplement-the-sysctl-proc-support-fix-2.patch

This patch was dropped because it was folded into sysctl-reimplement-the-sysctl-proc-support.patch

------------------------------------------------------
Subject: sysctl-reimplement-the-sysctl-proc-support-fix-2
From: Andrew Morton <akpm@osdl.org>

Stupid fix for this, on arm:

fs/built-in.o(.text+0x45f44): In function `proc_sys_readdir':
: undefined reference to `__cmpdi2'
fs/built-in.o(.text+0x45f68): In function `proc_sys_readdir':
: undefined reference to `__cmpdi2'

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_sysctl.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-reimplement-the-sysctl-proc-support-fix-2 fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-reimplement-the-sysctl-proc-support-fix-2
+++ a/fs/proc/proc_sysctl.c
@@ -321,21 +321,20 @@ static int proc_sys_readdir(struct file 
 		goto out;
 
 	ret = 0;
-	switch(filp->f_pos) {
-	case 0:
-		if (filldir(dirent, ".", 1, filp->f_pos, inode->i_ino, DT_DIR) < 0)
+	/* Avoid a switch here: arm builds fail with missing __cmpdi2 */
+	if (filp->f_pos == 0) {
+		if (filldir(dirent, ".", 1, filp->f_pos,
+				inode->i_ino, DT_DIR) < 0)
 			goto out;
 		filp->f_pos++;
-		/* fall through */
-	case 1:
-		if (filldir(dirent, "..", 2, filp->f_pos, parent_ino(dentry), DT_DIR) < 0)
+	}
+	if (filp->f_pos == 1) {
+		if (filldir(dirent, "..", 2, filp->f_pos,
+				parent_ino(dentry), DT_DIR) < 0)
 			goto out;
 		filp->f_pos++;
-		/* fall through */
-	default:
-		pos = 2;
-		break;
 	}
+	pos = 2;
 
 	/* - Find each instance of the directory
 	 * - Read all entries in each instance
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

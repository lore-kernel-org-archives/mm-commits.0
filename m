From: akpm@linux-foundation.org
Subject: - sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 23:02:29 -0800
Message-ID: <200702140702.l1E72TPN023957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174AbXBNHCa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 02:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables ntfs fix
has been removed from the -mm tree.  Its filename was
     sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch

This patch was dropped because it was folded into sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch

------------------------------------------------------
Subject: sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables ntfs fix
From: Andrew Morton <akpm@osdl.org>

Is this right?

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ntfs/sysctl.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/ntfs/sysctl.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix
+++ a/fs/ntfs/sysctl.c
@@ -73,14 +73,6 @@ int ntfs_sysctl(int add)
 		sysctls_root_table = register_sysctl_table(sysctls_root);
 		if (!sysctls_root_table)
 			return -ENOMEM;
-#ifdef CONFIG_PROC_FS
-		/*
-		 * If the proc filesystem is in use and we are a module, need
-		 * to set the owner of our proc entry to our module. In the
-		 * non-modular case, THIS_MODULE is NULL, so this is ok.
-		 */
-		ntfs_sysctls[0].de->owner = THIS_MODULE;
-#endif
 	} else {
 		BUG_ON(!sysctls_root_table);
 		unregister_sysctl_table(sysctls_root_table);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
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

From: akpm@linux-foundation.org
Subject: - sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 22:58:11 -0800
Message-ID: <200702140658.l1E6wBLA023817@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbXBNG6N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 01:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry warning fix
has been removed from the -mm tree.  Its filename was
     sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch

This patch was dropped because it was folded into sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch

------------------------------------------------------
Subject: sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry warning fix
From: Andrew Morton <akpm@osdl.org>

kernel/sysctl.c:1046: warning: 'binfmt_misc_table' defined but not used

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/sysctl.c~sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix
+++ a/kernel/sysctl.c
@@ -150,7 +150,6 @@ static struct ctl_table_header root_tabl
 static ctl_table kern_table[];
 static ctl_table vm_table[];
 static ctl_table fs_table[];
-static ctl_table binfmt_misc_table[];
 static ctl_table debug_table[];
 static ctl_table dev_table[];
 extern ctl_table random_table[];
@@ -920,6 +919,12 @@ static ctl_table vm_table[] = {
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
@@ -1054,10 +1059,6 @@ static ctl_table fs_table[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table binfmt_misc_table[] = {
-	{ .ctl_name = 0 }
-};
-
 static ctl_table debug_table[] = {
 	{ .ctl_name = 0 }
 };
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
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

From: akpm@linux-foundation.org
Subject: - sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 22:58:48 -0800
Message-ID: <200702140658.l1E6wmYn023829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbXBNG6t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 01:58:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-factor-out-sysctl_head_next-from-do_sysctl warning fix
has been removed from the -mm tree.  Its filename was
     sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch

This patch was dropped because it was folded into sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch

------------------------------------------------------
Subject: sysctl-factor-out-sysctl_head_next-from-do_sysctl warning fix
From: Andrew Morton <akpm@osdl.org>

Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/sysctl.c~sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix
+++ a/kernel/sysctl.c
@@ -1156,7 +1156,6 @@ int do_sysctl(int __user *name, int nlen
 	       void __user *newval, size_t newlen)
 {
 	struct ctl_table_header *head;
-	struct list_head *tmp;
 	int error = -ENOTDIR;
 
 	if (nlen <= 0 || nlen >= CTL_MAXNAME)
@@ -1167,8 +1166,8 @@ int do_sysctl(int __user *name, int nlen
 			return -EFAULT;
 	}
 
-	for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
-
+	for (head = sysctl_head_next(NULL); head;
+			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
 					newval, newlen, head->ctl_table);
 		if (error != -ENOTDIR) {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
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

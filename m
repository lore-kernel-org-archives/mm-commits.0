From: akpm@linux-foundation.org
Subject: - sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 22:59:22 -0800
Message-ID: <200702140659.l1E6xM9e023847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbXBNG7X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 01:59:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-reimplement-the-sysctl-proc-support warning fix
has been removed from the -mm tree.  Its filename was
     sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch

This patch was dropped because it was folded into sysctl-reimplement-the-sysctl-proc-support.patch

------------------------------------------------------
Subject: sysctl-reimplement-the-sysctl-proc-support warning fix
From: Andrew Morton <akpm@osdl.org>

fs/proc/proc_sysctl.c: In function 'do_proc_sys_lookup':
fs/proc/proc_sysctl.c:128: warning: 'table' may be used uninitialized in this function

It this a bugfix too?


Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/proc_sysctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-reimplement-the-sysctl-proc-support-warning-fix fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-reimplement-the-sysctl-proc-support-warning-fix
+++ a/fs/proc/proc_sysctl.c
@@ -125,9 +125,10 @@ static struct ctl_table *do_proc_sys_loo
 						struct ctl_table_header **ptr)
 {
 	struct ctl_table_header *head;
-	struct ctl_table *table;
+	struct ctl_table *table = NULL;
 
-	for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
+	for (head = sysctl_head_next(NULL); head;
+			head = sysctl_head_next(head)) {
 		table = proc_sys_lookup_entry(parent, name, head->ctl_table);
 		if (table)
 			break;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-reimplement-the-sysctl-proc-support.patch
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

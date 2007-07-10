From: akpm@linux-foundation.org
Subject: - schedstats-fix-printk-format.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:50:00 -0700
Message-ID: <200707101950.l6AJo05q026214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760439AbXGJTzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     schedstats: fix printk format
has been removed from the -mm tree.  Its filename was
     schedstats-fix-printk-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: schedstats: fix printk format
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings for schedstats:

fs/proc/base.c:309: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'
fs/proc/base.c:309: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'long long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~schedstats-fix-printk-format fs/proc/base.c
--- a/fs/proc/base.c~schedstats-fix-printk-format
+++ a/fs/proc/base.c
@@ -300,7 +300,7 @@ static int proc_pid_wchan(struct task_st
  */
 static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 {
-	return sprintf(buffer, "%lu %lu %lu\n",
+	return sprintf(buffer, "%llu %llu %lu\n",
 			task->sched_info.cpu_time,
 			task->sched_info.run_delay,
 			task->sched_info.pcnt);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-alsa.patch
git-mtd.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
profile-likely-unlikely-macros.patch

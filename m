From: akpm@linux-foundation.org
Subject: - file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:46:05 -0800
Message-ID: <200711150046.lAF0k544002061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbXKOAv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:51:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch

This patch was dropped because it was folded into file-capabilities-allow-sigcont-within-session-v2.patch

------------------------------------------------------
Subject: file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need spaces around that '==' (ctx:VxV)
#41: FILE: security/commoncap.c:535:
+	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
 	                                               ^

total: 1 errors, 0 warnings, 15 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/commoncap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/commoncap.c~file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes security/commoncap.c
--- a/security/commoncap.c~file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes
+++ a/security/commoncap.c
@@ -532,7 +532,7 @@ int cap_task_kill(struct task_struct *p,
 		return 0;
 
 	/* sigcont is permitted within same session */
-	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
+	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
 		return 0;
 
 	if (secid)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns.patch
pidns-place-under-config_experimental.patch
fix-64kb-blocksize-in-ext3-directories.patch
file-capabilities-allow-sigcont-within-session-v2.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch

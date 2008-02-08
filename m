From: akpm@linux-foundation.org
Subject: - pid-sys_wait-fixes-v2-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:39:46 -0800
Message-ID: <200802080839.m188dR9k016002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247AbYBHIj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:39:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     pid-sys_wait-fixes-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pid-sys_wait-fixes-v2-checkpatch-fixes.patch

This patch was dropped because it was folded into pid-sys_wait-fixes-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid-sys_wait-fixes-v2-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: else should follow close brace '}'
#190: FILE: kernel/exit.c:1636:
+	}
+	else if (upid == 0) {

ERROR: else should follow close brace '}'
#194: FILE: kernel/exit.c:1640:
+	}
+	else /* upid > 0 */ {

ERROR: need spaces around that '=' (ctx:VxW)
#195: FILE: kernel/exit.c:1641:
+		type= PIDTYPE_PID;
 		    ^

total: 3 errors, 0 warnings, 160 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~pid-sys_wait-fixes-v2-checkpatch-fixes kernel/exit.c
--- a/kernel/exit.c~pid-sys_wait-fixes-v2-checkpatch-fixes
+++ a/kernel/exit.c
@@ -1632,13 +1632,11 @@ asmlinkage long sys_wait4(pid_t upid, in
 	else if (upid < 0) {
 		type = PIDTYPE_PGID;
 		pid = find_get_pid(-upid);
-	}
-	else if (upid == 0) {
+	} else if (upid == 0) {
 		type = PIDTYPE_PGID;
 		pid = get_pid(task_pgrp(current));
-	}
-	else /* upid > 0 */ {
-		type= PIDTYPE_PID;
+	} else /* upid > 0 */ {
+		type = PIDTYPE_PID;
 		pid = find_get_pid(upid);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
pid-sys_wait-fixes-v2.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch

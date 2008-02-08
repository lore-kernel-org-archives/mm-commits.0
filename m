From: akpm@linux-foundation.org
Subject: - wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:37:58 -0800
Message-ID: <200802080837.m188bdAi015897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756884AbYBHIi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:38:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@tv-sign.ru, roland@redhat.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix
has been removed from the -mm tree.  Its filename was
     wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch

This patch was dropped because it was folded into wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix
+++ a/kernel/exit.c
@@ -1358,7 +1358,7 @@ static int wait_task_stopped(struct task
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
 
-	if (unlikely(!is_task_stopped_or_traced(p)))
+	if (unlikely(!task_is_stopped_or_traced(p)))
 		goto unlock_sig;
 
 	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
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
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
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

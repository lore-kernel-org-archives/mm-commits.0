From: akpm@linux-foundation.org
Subject: + whitespace-fixes-syscall-auditing.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:56 -0700
Message-ID: <200707210018.l6L0IuxE023899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759646AbXGUAU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, dwmw2@infradead.org


The patch titled
     whitespace fixes: syscall auditing
has been added to the -mm tree.  Its filename is
     whitespace-fixes-syscall-auditing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: syscall auditing
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/auditsc.c~whitespace-fixes-syscall-auditing kernel/auditsc.c
--- a/kernel/auditsc.c~whitespace-fixes-syscall-auditing
+++ a/kernel/auditsc.c
@@ -327,7 +327,7 @@ static int audit_filter_rules(struct tas
 			result = audit_comparator(tsk->personality, f->op, f->val);
 			break;
 		case AUDIT_ARCH:
- 			if (ctx)
+			if (ctx)
 				result = audit_comparator(ctx->arch, f->op, f->val);
 			break;
 
@@ -909,7 +909,7 @@ static void audit_log_exit(struct audit_
 	if (context->personality != PER_LINUX)
 		audit_log_format(ab, " per=%lx", context->personality);
 	if (context->return_valid)
-		audit_log_format(ab, " success=%s exit=%ld", 
+		audit_log_format(ab, " success=%s exit=%ld",
 				 (context->return_valid==AUDITSC_SUCCESS)?"yes":"no",
 				 context->return_code);
 
@@ -994,7 +994,7 @@ static void audit_log_exit(struct audit_
 
 		case AUDIT_IPC: {
 			struct audit_aux_data_ipcctl *axi = (void *)aux;
-			audit_log_format(ab, 
+			audit_log_format(ab,
 				 "ouid=%u ogid=%u mode=%x",
 				 axi->uid, axi->gid, axi->mode);
 			if (axi->osid != 0) {
@@ -1151,8 +1151,8 @@ void audit_free(struct task_struct *tsk)
 		return;
 
 	/* Check for system calls that do not go through the exit
-	 * function (e.g., exit_group), then free context block. 
-	 * We use GFP_ATOMIC here because we might be doing this 
+	 * function (e.g., exit_group), then free context block.
+	 * We use GFP_ATOMIC here because we might be doing this
 	 * in the context of the idle thread */
 	/* that can happen only if we are called from do_exit() */
 	if (context->in_syscall && context->auditable)
@@ -1332,7 +1332,7 @@ void __audit_getname(const char *name)
 		context->pwdmnt = mntget(current->fs->pwdmnt);
 		read_unlock(&current->fs->lock);
 	}
-		
+
 }
 
 /* audit_putname - intercept a putname request
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch

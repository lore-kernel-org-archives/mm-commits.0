From: akpm@linux-foundation.org
Subject: - whitespace-fixes-syscall-auditing.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:50 -0700
Message-ID: <200710190343.l9J3hoOf013098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934567AbXJSD4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: syscall auditing
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-syscall-auditing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: syscall auditing
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/auditsc.c~whitespace-fixes-syscall-auditing kernel/auditsc.c
--- a/kernel/auditsc.c~whitespace-fixes-syscall-auditing
+++ a/kernel/auditsc.c
@@ -320,7 +320,7 @@ static int audit_filter_rules(struct tas
 			result = audit_comparator(tsk->personality, f->op, f->val);
 			break;
 		case AUDIT_ARCH:
- 			if (ctx)
+			if (ctx)
 				result = audit_comparator(ctx->arch, f->op, f->val);
 			break;
 
@@ -898,7 +898,7 @@ static void audit_log_exit(struct audit_
 	if (context->personality != PER_LINUX)
 		audit_log_format(ab, " per=%lx", context->personality);
 	if (context->return_valid)
-		audit_log_format(ab, " success=%s exit=%ld", 
+		audit_log_format(ab, " success=%s exit=%ld",
 				 (context->return_valid==AUDITSC_SUCCESS)?"yes":"no",
 				 context->return_code);
 
@@ -1135,8 +1135,8 @@ void audit_free(struct task_struct *tsk)
 		return;
 
 	/* Check for system calls that do not go through the exit
-	 * function (e.g., exit_group), then free context block. 
-	 * We use GFP_ATOMIC here because we might be doing this 
+	 * function (e.g., exit_group), then free context block.
+	 * We use GFP_ATOMIC here because we might be doing this
 	 * in the context of the idle thread */
 	/* that can happen only if we are called from do_exit() */
 	if (context->in_syscall && context->auditable)
@@ -1316,7 +1316,7 @@ void __audit_getname(const char *name)
 		context->pwdmnt = mntget(current->fs->pwdmnt);
 		read_unlock(&current->fs->lock);
 	}
-		
+
 }
 
 /* audit_putname - intercept a putname request
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

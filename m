From: akpm@linux-foundation.org
Subject: - fix-oops-in-__audit_signal_info.patch removed from -mm tree
Date: Thu, 09 Aug 2007 15:50:07 -0700
Message-ID: <200708092250.l79Mo7sK023553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757AbXHIWuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, jmorris@namei.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix oops in __audit_signal_info()
has been removed from the -mm tree.  Its filename was
     fix-oops-in-__audit_signal_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix oops in __audit_signal_info()
From: Al Viro <viro@ftp.linux.org.uk>

Check for audit_signals is misplaced and check for audit_dummy_context() is
missing; as the result, if we send signal to auditd from task with NULL
->audit_context while we have audit_signals != 0 we end up with an oops.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/auditsc.c~fix-oops-in-__audit_signal_info kernel/auditsc.c
--- a/kernel/auditsc.c~fix-oops-in-__audit_signal_info
+++ a/kernel/auditsc.c
@@ -1992,19 +1992,19 @@ int __audit_signal_info(int sig, struct 
 	extern uid_t audit_sig_uid;
 	extern u32 audit_sig_sid;
 
-	if (audit_pid && t->tgid == audit_pid &&
-	    (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1)) {
-		audit_sig_pid = tsk->pid;
-		if (ctx)
-			audit_sig_uid = ctx->loginuid;
-		else
-			audit_sig_uid = tsk->uid;
-		selinux_get_task_sid(tsk, &audit_sig_sid);
+	if (audit_pid && t->tgid == audit_pid) {
+		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1) {
+			audit_sig_pid = tsk->pid;
+			if (ctx)
+				audit_sig_uid = ctx->loginuid;
+			else
+				audit_sig_uid = tsk->uid;
+			selinux_get_task_sid(tsk, &audit_sig_sid);
+		}
+		if (!audit_signals || audit_dummy_context())
+			return 0;
 	}
 
-	if (!audit_signals) /* audit_context checked in wrapper */
-		return 0;
-
 	/* optimize the common case by putting first signal recipient directly
 	 * in audit_context */
 	if (!ctx->target_pid) {
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
introduce-i_sync.patch
slab-leaks3-default-y.patch

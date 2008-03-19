From: akpm@linux-foundation.org
Subject: - file-capabilities-remove-cap_task_kill-git.patch removed from -mm tree
Date: Wed, 19 Mar 2008 16:36:30 -0700
Message-ID: <200803192346.m2JNkGKN011094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761177AbYCSXqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 19:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, lcapitulino@mandriva.com.br, morgan@kernel.org, serge@hallyn.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     file capabilities: remove cap_task_kill()
has been removed from the -mm tree.  Its filename was
     file-capabilities-remove-cap_task_kill-git.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: file capabilities: remove cap_task_kill()
From: "Serge E. Hallyn" <serue@us.ibm.com>

The original justification for cap_task_kill() was as follows:

	check_kill_permission() does appropriate uid equivalence checks.
	However with file capabilities it becomes possible for an
	unprivileged user to execute a file with file capabilities
	resulting in a more privileged task with the same uid.

However now that cap_task_kill() always returns 0 (permission granted) when
p->uid==current->uid, the whole hook is worthless, and only likely to create
more subtle problems in the corner cases where it might still be called but
return -EPERM.  Those cases are basically when uids are different but
euid/suid is equivalent as per the check in check_kill_permission().

One example of a still-broken application is 'at' for non-root users.

This patch removes cap_task_kill().

Signed-off-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    3 --
 security/capability.c    |    1 
 security/commoncap.c     |   40 -------------------------------------
 3 files changed, 1 insertion(+), 43 deletions(-)

diff -puN include/linux/security.h~file-capabilities-remove-cap_task_kill-git include/linux/security.h
--- a/include/linux/security.h~file-capabilities-remove-cap_task_kill-git
+++ a/include/linux/security.h
@@ -57,7 +57,6 @@ extern int cap_inode_need_killpriv(struc
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
-extern int cap_task_kill(struct task_struct *p, struct siginfo *info, int sig, u32 secid);
 extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
 extern int cap_task_setioprio (struct task_struct *p, int ioprio);
 extern int cap_task_setnice (struct task_struct *p, int nice);
@@ -2187,7 +2186,7 @@ static inline int security_task_kill (st
 				      struct siginfo *info, int sig,
 				      u32 secid)
 {
-	return cap_task_kill(p, info, sig, secid);
+	return 0;
 }
 
 static inline int security_task_wait (struct task_struct *p)
diff -puN security/capability.c~file-capabilities-remove-cap_task_kill-git security/capability.c
--- a/security/capability.c~file-capabilities-remove-cap_task_kill-git
+++ a/security/capability.c
@@ -40,7 +40,6 @@ static struct security_operations capabi
 	.inode_need_killpriv =		cap_inode_need_killpriv,
 	.inode_killpriv =		cap_inode_killpriv,
 
-	.task_kill =			cap_task_kill,
 	.task_setscheduler =		cap_task_setscheduler,
 	.task_setioprio =		cap_task_setioprio,
 	.task_setnice =			cap_task_setnice,
diff -puN security/commoncap.c~file-capabilities-remove-cap_task_kill-git security/commoncap.c
--- a/security/commoncap.c~file-capabilities-remove-cap_task_kill-git
+++ a/security/commoncap.c
@@ -540,41 +540,6 @@ int cap_task_setnice (struct task_struct
 	return cap_safe_nice(p);
 }
 
-int cap_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
-{
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-
-	/*
-	 * Running a setuid root program raises your capabilities.
-	 * Killing your own setuid root processes was previously
-	 * allowed.
-	 * We must preserve legacy signal behavior in this case.
-	 */
-	if (p->uid == current->uid)
-		return 0;
-
-	/* sigcont is permitted within same session */
-	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
-		return 0;
-
-	if (secid)
-		/*
-		 * Signal sent as a particular user.
-		 * Capabilities are ignored.  May be wrong, but it's the
-		 * only thing we can do at the moment.
-		 * Used only by usb drivers?
-		 */
-		return 0;
-	if (cap_issubset(p->cap_permitted, current->cap_permitted))
-		return 0;
-	if (capable(CAP_KILL))
-		return 0;
-
-	return -EPERM;
-}

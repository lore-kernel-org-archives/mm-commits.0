From: akpm@linux-foundation.org
Subject: + file-capabilities-remove-cap_task_kill.patch added to -mm tree
Date: Thu, 20 Mar 2008 12:08:12 -0700
Message-ID: <200803201908.m2KJ8Cc6019539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbYCTTIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 15:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, morgan@kernel.org


The patch titled
     file capabilities: remove cap_task_kill()
has been added to the -mm tree.  Its filename is
     file-capabilities-remove-cap_task_kill.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: file capabilities: remove cap_task_kill()
From: Serge Hallyn <serge@hallyn.com>

The original justification for cap_task_kill() was as follows:

	check_kill_permission() does appropriate uid equivalence checks.
	However with file capabilities it becomes possible for an
	unprivileged user to execute a file with file capabilities
	resulting in a more privileged task with the same uid.

However now that cap_task_kill() always returns 0 (permission granted) when
p->uid==current->uid, the whole hook is worthless, and only likely to
create more subtle problems in the corner cases where it might still be
called but return -EPERM.  Those cases are basically when uids are
different but euid/suid is equivalent as per the check in
check_kill_permission().

One example of a still-broken application is 'at' for non-root users.

This patch removes cap_task_kill().

Signed-off-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h   |    3 --
 security/capability.c      |    1 
 security/commoncap.c       |   40 -----------------------------------
 security/smack/smack_lsm.c |    5 ----
 4 files changed, 1 insertion(+), 48 deletions(-)

diff -puN include/linux/security.h~file-capabilities-remove-cap_task_kill include/linux/security.h
--- a/include/linux/security.h~file-capabilities-remove-cap_task_kill
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
diff -puN security/capability.c~file-capabilities-remove-cap_task_kill security/capability.c
--- a/security/capability.c~file-capabilities-remove-cap_task_kill
+++ a/security/capability.c
@@ -40,7 +40,6 @@ static struct security_operations capabi
 	.inode_need_killpriv =		cap_inode_need_killpriv,
 	.inode_killpriv =		cap_inode_killpriv,
 
-	.task_kill =			cap_task_kill,
 	.task_setscheduler =		cap_task_setscheduler,
 	.task_setioprio =		cap_task_setioprio,
 	.task_setnice =			cap_task_setnice,
diff -puN security/commoncap.c~file-capabilities-remove-cap_task_kill security/commoncap.c
--- a/security/commoncap.c~file-capabilities-remove-cap_task_kill
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
-
 /*
  * called from kernel/sys.c for prctl(PR_CABSET_DROP)
  * done without task_capability_lock() because it introduces
@@ -605,11 +570,6 @@ int cap_task_setnice (struct task_struct
 {
 	return 0;
 }
-int cap_task_kill(struct task_struct *p, struct siginfo *info,
-				int sig, u32 secid)
-{
-	return 0;
-}
 #endif
 
 void cap_task_reparent_to_init (struct task_struct *p)
diff -puN security/smack/smack_lsm.c~file-capabilities-remove-cap_task_kill security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~file-capabilities-remove-cap_task_kill
+++ a/security/smack/smack_lsm.c
@@ -1117,11 +1117,6 @@ static int smack_task_movememory(struct 
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 			   int sig, u32 secid)
 {
-	int rc;

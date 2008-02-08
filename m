From: akpm@linux-foundation.org
Subject: - get-rid-of-the-kill_pgrp_info-function.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:40 -0800
Message-ID: <200802082014.m18KEL2m010410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbYBHUvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Get rid of the kill_pgrp_info() function
has been removed from the -mm tree.  Its filename was
     get-rid-of-the-kill_pgrp_info-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Get rid of the kill_pgrp_info() function
From: Pavel Emelyanov <xemul@openvz.org>

There's only one caller left - the kill_pgrp one - so merge these two
functions and forget the kill_pgrp_info one.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 kernel/signal.c       |   21 ++++++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff -puN include/linux/sched.h~get-rid-of-the-kill_pgrp_info-function include/linux/sched.h
--- a/include/linux/sched.h~get-rid-of-the-kill_pgrp_info-function
+++ a/include/linux/sched.h
@@ -1689,7 +1689,6 @@ extern int send_sig_info(int, struct sig
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
-extern int kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
 extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
diff -puN kernel/signal.c~get-rid-of-the-kill_pgrp_info-function kernel/signal.c
--- a/kernel/signal.c~get-rid-of-the-kill_pgrp_info-function
+++ a/kernel/signal.c
@@ -1018,7 +1018,7 @@ int group_send_sig_info(int sig, struct 
 }
 
 /*
- * kill_pgrp_info() sends a signal to a process group: this is what the tty
+ * __kill_pgrp_info() sends a signal to a process group: this is what the tty
  * control characters do (^C, ^Z etc)
  */
 
@@ -1037,17 +1037,6 @@ int __kill_pgrp_info(int sig, struct sig
 	return success ? 0 : retval;
 }
 
-int kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
-{
-	int retval;
-
-	read_lock(&tasklist_lock);
-	retval = __kill_pgrp_info(sig, info, pgrp);
-	read_unlock(&tasklist_lock);
-
-	return retval;
-}
-
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
 	int error = -ESRCH;
@@ -1236,7 +1225,13 @@ force_sigsegv(int sig, struct task_struc
 
 int kill_pgrp(struct pid *pid, int sig, int priv)
 {
-	return kill_pgrp_info(sig, __si_special(priv), pid);
+	int ret;
+
+	read_lock(&tasklist_lock);
+	ret = __kill_pgrp_info(sig, __si_special(priv), pid);
+	read_unlock(&tasklist_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(kill_pgrp);
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch

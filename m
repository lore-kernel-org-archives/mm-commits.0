From: akpm@linux-foundation.org
Subject: - clean-up-the-kill_something_info.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:39 -0800
Message-ID: <200802082014.m18KEKp4010406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbYBHUuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Clean up the kill_something_info
has been removed from the -mm tree.  Its filename was
     clean-up-the-kill_something_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Clean up the kill_something_info
From: Pavel Emelyanov <xemul@openvz.org>

This is the first step (of two) in removing the kill_pgrp_info.

All the users of this function are in kernel/signal.c, but all they need is to
call __kill_pgrp_info() with the tasklist_lock read-locked.

Fortunately, one of its users is the kill_something_info(), which already
needs this lock in one of its branches, so clean these branches up and call
the __kill_pgrp_info() directly.

Based on Oleg's view of how this function should look.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN kernel/signal.c~clean-up-the-kill_something_info kernel/signal.c
--- a/kernel/signal.c~clean-up-the-kill_something_info
+++ a/kernel/signal.c
@@ -1134,14 +1134,22 @@ EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
 static int kill_something_info(int sig, struct siginfo *info, int pid)
 {
 	int ret;
-	rcu_read_lock();
-	if (!pid) {
-		ret = kill_pgrp_info(sig, info, task_pgrp(current));
-	} else if (pid == -1) {
+
+	if (pid > 0) {
+		rcu_read_lock();
+		ret = kill_pid_info(sig, info, find_vpid(pid));
+		rcu_read_unlock();
+		return ret;
+	}
+
+	read_lock(&tasklist_lock);
+	if (pid != -1) {
+		ret = __kill_pgrp_info(sig, info,
+				pid ? find_vpid(-pid) : task_pgrp(current));
+	} else {
 		int retval = 0, count = 0;
 		struct task_struct * p;
 
-		read_lock(&tasklist_lock);
 		for_each_process(p) {
 			if (p->pid > 1 && !same_thread_group(p, current)) {
 				int err = group_send_sig_info(sig, info, p);
@@ -1150,14 +1158,10 @@ static int kill_something_info(int sig, 
 					retval = err;
 			}
 		}
-		read_unlock(&tasklist_lock);
 		ret = count ? retval : -ESRCH;
-	} else if (pid < 0) {
-		ret = kill_pgrp_info(sig, info, find_vpid(-pid));
-	} else {
-		ret = kill_pid_info(sig, info, find_vpid(pid));
 	}
-	rcu_read_unlock();
+	read_unlock(&tasklist_lock);
+
 	return ret;
 }
 
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

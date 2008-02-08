From: akpm@linux-foundation.org
Subject: - uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:27 -0800
Message-ID: <200802082014.m18KE8Nx010367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758760AbYBHVDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     uglify while_each_pid_task() to make sure we don't count the execing pricess twice
has been removed from the -mm tree.  Its filename was
     uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uglify while_each_pid_task() to make sure we don't count the execing pricess twice
From: Oleg Nesterov <oleg@tv-sign.ru>

There is a window when de_thread() switches the leader and drops
tasklist_lock.  In that window do_each_pid_task(PIDTYPE_PID) finds both new
and old leaders.

The problem is pretty much theoretical and probably can be ignored.  Currently
the only users of do_each_pid_task(PIDTYPE_PID) are send_sigio/send_sigurg, so
they can send the signal to the same process twice.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/pid.h~uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice include/linux/pid.h
--- a/include/linux/pid.h~uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice
+++ a/include/linux/pid.h
@@ -152,7 +152,13 @@ pid_t pid_vnr(struct pid *pid);
 			hlist_for_each_entry_rcu((task), pos___,	\
 				&pid->tasks[type], pids[type].node) {
 
+			/*
+			 * Both old and new leaders may be attached to
+			 * the same pid in the middle of de_thread().
+			 */
 #define while_each_pid_task(pid, type, task)				\
+				if (type == PIDTYPE_PID)		\
+					break;				\
 			}						\
 	} while (0)
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch

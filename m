From: akpm@linux-foundation.org
Subject: + fix-setpriorityprio_pgrp-thread-iterator-breakage.patch added to -mm tree
Date: Mon, 18 Aug 2008 15:30:54 -0700
Message-ID: <200808182230.m7IMUsMS016435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669AbYHRWdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 18:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, jens.axboe@oracle.com, mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     fix setpriority(PRIO_PGRP) thread iterator breakage
has been added to the -mm tree.  Its filename is
     fix-setpriorityprio_pgrp-thread-iterator-breakage.patch

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
Subject: fix setpriority(PRIO_PGRP) thread iterator breakage
From: "Ken Chen" <kenchen@google.com>

When user calls sys_setpriority(PRIO_PGRP ...) on a NPTL style multi-LWP
process, only the task leader of the process is affected, all other
sibling LWP threads didn't receive the setting.  The problem was that the
iterator used in sys_setpriority() only iteartes over one task for each
process, ignoring all other sibling thread.

Introduce a new macro do_each_pid_thread / while_each_pid_thread to walk
each thread of a process.  Convert 4 call sites in {set/get}priority and
ioprio_{set/get}.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioprio.c         |    8 ++++----
 include/linux/pid.h |    9 +++++++++
 kernel/sys.c        |    8 ++++----
 3 files changed, 17 insertions(+), 8 deletions(-)

diff -puN fs/ioprio.c~fix-setpriorityprio_pgrp-thread-iterator-breakage fs/ioprio.c
--- a/fs/ioprio.c~fix-setpriorityprio_pgrp-thread-iterator-breakage
+++ a/fs/ioprio.c
@@ -121,11 +121,11 @@ asmlinkage long sys_ioprio_set(int which
 				pgrp = task_pgrp(current);
 			else
 				pgrp = find_vpid(who);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				ret = set_task_ioprio(p, ioprio);
 				if (ret)
 					break;
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
@@ -210,7 +210,7 @@ asmlinkage long sys_ioprio_get(int which
 				pgrp = task_pgrp(current);
 			else
 				pgrp = find_vpid(who);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
 					continue;
@@ -218,7 +218,7 @@ asmlinkage long sys_ioprio_get(int which
 					ret = tmpio;
 				else
 					ret = ioprio_best(ret, tmpio);
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case IOPRIO_WHO_USER:
 			if (!who)
diff -puN include/linux/pid.h~fix-setpriorityprio_pgrp-thread-iterator-breakage include/linux/pid.h
--- a/include/linux/pid.h~fix-setpriorityprio_pgrp-thread-iterator-breakage
+++ a/include/linux/pid.h
@@ -161,4 +161,13 @@ pid_t pid_vnr(struct pid *pid);
 			}						\
 	} while (0)
 
+#define do_each_pid_thread(pid, type, task)				\
+	do_each_pid_task(pid, type, task) {				\
+		struct task_struct *tg___ = task;			\
+		do {
+
+#define while_each_pid_thread(pid, type, task)				\
+		} while_each_thread(tg___, task);			\
+		task = tg___;						\
+	} while_each_pid_task(pid, type, task)
 #endif /* _LINUX_PID_H */
diff -puN kernel/sys.c~fix-setpriorityprio_pgrp-thread-iterator-breakage kernel/sys.c
--- a/kernel/sys.c~fix-setpriorityprio_pgrp-thread-iterator-breakage
+++ a/kernel/sys.c
@@ -175,9 +175,9 @@ asmlinkage long sys_setpriority(int whic
 				pgrp = find_vpid(who);
 			else
 				pgrp = task_pgrp(current);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				error = set_one_prio(p, niceval, error);
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = (struct user_struct *) cred->user;
@@ -236,11 +236,11 @@ asmlinkage long sys_getpriority(int whic
 				pgrp = find_vpid(who);
 			else
 				pgrp = task_pgrp(current);
-			do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
+			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
 					retval = niceval;
-			} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
 			user = (struct user_struct *) cred->user;
_

Patches currently in -mm which might be from kenchen@google.com are

fix-setpriorityprio_pgrp-thread-iterator-breakage.patch


From: akpm@linux-foundation.org
Subject: + remove-the-likelypid-check-in-copy_process.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:54:42 -0800
Message-ID: <200703151854.l2FIsi9o023464@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36232 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563AbXCOS6J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, serue@us.ibm.com


The patch titled
     Remove the likely(pid) check in copy_process
has been added to the -mm tree.  Its filename is
     remove-the-likelypid-check-in-copy_process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove the likely(pid) check in copy_process
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Now that we pass in a struct pid parameter to copy_process() and even the
swapper (pid_t == 0) has a valid struct pid, we no longer need this check.

Changelog:
	Per Eric Biederman's comments, moved this out to a separate
	patch for easier review.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: <containers@lists.osdl.org>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN kernel/fork.c~remove-the-likelypid-check-in-copy_process kernel/fork.c
--- a/kernel/fork.c~remove-the-likelypid-check-in-copy_process
+++ a/kernel/fork.c
@@ -1237,26 +1237,24 @@ static struct task_struct *copy_process(
 		}
 	}
 
-	if (likely(p->pid)) {
-		add_parent(p);
-		tracehook_init_task(p);
-
-		if (thread_group_leader(p)) {
-			pid_t pgid = process_group(current);
-			pid_t sid = process_session(current);
-
-			p->signal->tty = current->signal->tty;
-			p->signal->pgrp = pgid;
-			set_signal_session(p->signal, process_session(current));
-			attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
-			attach_pid(p, PIDTYPE_SID, find_pid(sid));
+	add_parent(p);
+	tracehook_init_task(p);
 
-			list_add_tail_rcu(&p->tasks, &init_task.tasks);
-			__get_cpu_var(process_counts)++;
-		}
-		attach_pid(p, PIDTYPE_PID, pid);
-		nr_threads++;
+	if (thread_group_leader(p)) {
+		pid_t pgid = process_group(current);
+		pid_t sid = process_session(current);
+
+		p->signal->tty = current->signal->tty;
+		p->signal->pgrp = pgid;
+		set_signal_session(p->signal, process_session(current));
+		attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
+		attach_pid(p, PIDTYPE_SID, find_pid(sid));
+
+		list_add_tail_rcu(&p->tasks, &init_task.tasks);
+		__get_cpu_var(process_counts)++;
 	}
+	attach_pid(p, PIDTYPE_PID, pid);
+	nr_threads++;
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
remove-the-likelypid-check-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch

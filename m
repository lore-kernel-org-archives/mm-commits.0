From: akpm@linux-foundation.org
Subject: + use-task_pgrp-task_session-in-copy_process.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:54:44 -0800
Message-ID: <200703151854.l2FIskj4023467@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35885 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXCOSy4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, serue@us.ibm.com


The patch titled
     Use task_pgrp() task_session() in copy_process()
has been added to the -mm tree.  Its filename is
     use-task_pgrp-task_session-in-copy_process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use task_pgrp() task_session() in copy_process()
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Use task_pgrp() and task_session() in copy_process(), and avoid find_pid()
call when attaching the task to its process group and session.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: <containers@lists.osdl.org>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~use-task_pgrp-task_session-in-copy_process kernel/fork.c
--- a/kernel/fork.c~use-task_pgrp-task_session-in-copy_process
+++ a/kernel/fork.c
@@ -1241,14 +1241,11 @@ static struct task_struct *copy_process(
 	tracehook_init_task(p);
 
 	if (thread_group_leader(p)) {
-		pid_t pgid = process_group(current);
-		pid_t sid = process_session(current);
-
 		p->signal->tty = current->signal->tty;
-		p->signal->pgrp = pgid;
+		p->signal->pgrp = process_group(current);
 		set_signal_session(p->signal, process_session(current));
-		attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
-		attach_pid(p, PIDTYPE_SID, find_pid(sid));
+		attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
+		attach_pid(p, PIDTYPE_SID, task_session(current));
 
 		list_add_tail_rcu(&p->tasks, &init_task.tasks);
 		__get_cpu_var(process_counts)++;
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

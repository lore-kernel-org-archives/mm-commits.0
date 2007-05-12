From: akpm@linux-foundation.org
Subject: - use-task_pgrp-task_session-in-copy_process.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:38 -0700
Message-ID: <200705120534.l4C5YcRG002217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296AbXELFev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use task_pgrp() task_session() in copy_process()
has been removed from the -mm tree.  Its filename was
     use-task_pgrp-task_session-in-copy_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1249,14 +1249,11 @@ static struct task_struct *copy_process(
 			__ptrace_link(p, current->parent);
 
 		if (thread_group_leader(p)) {
-			pid_t pgid = process_group(current);
-			pid_t sid = process_session(current);
-
 			p->signal->tty = current->signal->tty;
-			p->signal->pgrp = pgid;
+			p->signal->pgrp = process_group(current);
 			set_signal_session(p->signal, process_session(current));
-			attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
-			attach_pid(p, PIDTYPE_SID, find_pid(sid));
+			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
+			attach_pid(p, PIDTYPE_SID, task_session(current));
 
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__get_cpu_var(process_counts)++;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch

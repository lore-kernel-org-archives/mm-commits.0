From: akpm@linux-foundation.org
Subject: - assign-task_structexit_code-before-taskstats_exit.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:55:53 -0700
Message-ID: <200708311655.l7VGtrIF017439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759967AbXHaQz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlim@sgi.com, balbir@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Assign task_struct.exit_code before taskstats_exit()
has been removed from the -mm tree.  Its filename was
     assign-task_structexit_code-before-taskstats_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Assign task_struct.exit_code before taskstats_exit()
From: Jonathan Lim <jlim@sgi.com>

taskstats.ac_exitcode is assigned to task_struct.exit_code in bacct_add_tsk()
through the following kernel function calls:

  do_exit()
    taskstats_exit()
      fill_pid()
        bacct_add_tsk()

The problem is that in do_exit(), task_struct.exit_code is set to 'code' only
after taskstats_exit() has been called.  So we need to move the assignment
before taskstats_exit().

Signed-off-by: Jonathan Lim <jlim@sgi.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~assign-task_structexit_code-before-taskstats_exit kernel/exit.c
--- a/kernel/exit.c~assign-task_structexit_code-before-taskstats_exit
+++ a/kernel/exit.c
@@ -975,6 +975,7 @@ fastcall NORET_TYPE void do_exit(long co
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
 
+	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);
@@ -996,7 +997,6 @@ fastcall NORET_TYPE void do_exit(long co
 	if (tsk->binfmt)
 		module_put(tsk->binfmt->module);
 
-	tsk->exit_code = code;
 	proc_exit_connector(tsk);
 	exit_task_namespaces(tsk);
 	exit_notify(tsk);
_

Patches currently in -mm which might be from jlim@sgi.com are

origin.patch
add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch

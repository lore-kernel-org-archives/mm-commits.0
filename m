From: akpm@linux-foundation.org
Subject: - pid-namespaces-use-task_pid-to-find-leaders-pid.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:50:52 -0700
Message-ID: <200710192250.l9JMoq6Y024127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967040AbXJSXHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: use task_pid() to find leader's pid
has been removed from the -mm tree.  Its filename was
     pid-namespaces-use-task_pid-to-find-leaders-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: use task_pid() to find leader's pid
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Use task_pid() to get leader's 'struct pid' and avoid the find_pid().

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Pavel Emelianov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzel <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~pid-namespaces-use-task_pid-to-find-leaders-pid fs/exec.c
--- a/fs/exec.c~pid-namespaces-use-task_pid-to-find-leaders-pid
+++ a/fs/exec.c
@@ -857,7 +857,7 @@ static int de_thread(struct task_struct 
 		 */
 		detach_pid(tsk, PIDTYPE_PID);
 		tsk->pid = leader->pid;
-		attach_pid(tsk, PIDTYPE_PID,  find_pid(tsk->pid));
+		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
 		list_replace_rcu(&leader->tasks, &tsk->tasks);
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch

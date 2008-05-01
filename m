From: akpm@linux-foundation.org
Subject: - use-find_task_by_vpid-in-taskstats.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:13 -0700
Message-ID: <200805010931.m419VDGS030852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755570AbYEAJbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, jlan@engr.sgi.com, jlim@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use find_task_by_vpid in taskstats
has been removed from the -mm tree.  Its filename was
     use-find_task_by_vpid-in-taskstats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use find_task_by_vpid in taskstats
From: Pavel Emelyanov <xemul@openvz.org>

The pid to lookup a task by is passed inside taskstats code via genetlink
message.

Since netlink packets are now processed in the context of the sending task,
this is correct to lookup the task with find_task_by_vpid() here.

Besides, I fix the call to fill_pid() from taskstats_exit(), since the
tsk->pid is not required in fill_pid() in this case, and the pid field on
task_struct is going to be deprecated as well.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/taskstats.c~use-find_task_by_vpid-in-taskstats kernel/taskstats.c
--- a/kernel/taskstats.c~use-find_task_by_vpid-in-taskstats
+++ a/kernel/taskstats.c
@@ -183,7 +183,7 @@ static int fill_pid(pid_t pid, struct ta
 
 	if (!tsk) {
 		rcu_read_lock();
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (tsk)
 			get_task_struct(tsk);
 		rcu_read_unlock();
@@ -230,7 +230,7 @@ static int fill_tgid(pid_t tgid, struct 
 	 */
 	rcu_read_lock();
 	if (!first)
-		first = find_task_by_pid(tgid);
+		first = find_task_by_vpid(tgid);
 
 	if (!first || !lock_task_sighand(first, &flags))
 		goto out;
@@ -547,7 +547,7 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
-	rc = fill_pid(tsk->pid, tsk, stats);
+	rc = fill_pid(-1, tsk, stats);
 	if (rc < 0)
 		goto err;
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch


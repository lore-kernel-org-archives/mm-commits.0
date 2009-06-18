From: akpm@linux-foundation.org
Subject: [merged] pids-clean-up-find_task_by_pid-variants.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:28 -0700
Message-ID: <200906182247.n5IMlSvc006555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758722AbZFRW6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pids: clean up find_task_by_pid variants
has been removed from the -mm tree.  Its filename was
     pids-clean-up-find_task_by_pid-variants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: clean up find_task_by_pid variants
From: Christoph Hellwig <hch@lst.de>

find_task_by_pid_type_ns is only used to implement find_task_by_vpid and
find_task_by_pid_ns, but both of them pass PIDTYPE_PID as first argument. 
So just fold find_task_by_pid_type_ns into find_task_by_pid_ns and use
find_task_by_pid_ns to implement find_task_by_vpid.

While we're at it also remove the exports for find_task_by_pid_ns and
find_task_by_vpid - we don't have any modular callers left as the only
modular caller of he old pre pid namespace find_task_by_pid (gfs2) was
switched to pid_task which operates on a struct pid pointer instead of a
pid_t.  Given the confusion about pid_t values vs namespace that's
generally the better option anyway and I think we're better of restricting
modules to do it that way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ------
 kernel/pid.c          |   17 +++--------------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff -puN include/linux/sched.h~pids-clean-up-find_task_by_pid-variants include/linux/sched.h
--- a/include/linux/sched.h~pids-clean-up-find_task_by_pid-variants
+++ a/include/linux/sched.h
@@ -1878,9 +1878,6 @@ extern struct pid_namespace init_pid_ns;
 /*
  * find a task by one of its numerical ids
  *
- * find_task_by_pid_type_ns():
- *      it is the most generic call - it finds a task by all id,
- *      type and namespace specified
  * find_task_by_pid_ns():
  *      finds a task by its pid in the specified namespace
  * find_task_by_vpid():
@@ -1889,9 +1886,6 @@ extern struct pid_namespace init_pid_ns;
  * see also find_vpid() etc in include/linux/pid.h
  */
 
-extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
-		struct pid_namespace *ns);
-
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
diff -puN kernel/pid.c~pids-clean-up-find_task_by_pid-variants kernel/pid.c
--- a/kernel/pid.c~pids-clean-up-find_task_by_pid-variants
+++ a/kernel/pid.c
@@ -378,26 +378,15 @@ EXPORT_SYMBOL(pid_task);
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
  */
-struct task_struct *find_task_by_pid_type_ns(int type, int nr,
-		struct pid_namespace *ns)
+struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
-	return pid_task(find_pid_ns(nr, ns), type);
+	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
-EXPORT_SYMBOL(find_task_by_pid_type_ns);
-
 struct task_struct *find_task_by_vpid(pid_t vnr)
 {
-	return find_task_by_pid_type_ns(PIDTYPE_PID, vnr,
-			current->nsproxy->pid_ns);
-}
-EXPORT_SYMBOL(find_task_by_vpid);

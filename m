From: akpm@linux-foundation.org
Subject: - deprecate-find_task_by_pid-warning-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:17:30 -0700
Message-ID: <200804300617.m3U6HUHj031313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542AbYD3GRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, ebiederm@xmission.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Fix warning in kernel/pid.c
has been removed from the -mm tree.  Its filename was
     deprecate-find_task_by_pid-warning-fix.patch

This patch was dropped because it was folded into deprecate-find_task_by_pid.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix warning in kernel/pid.c
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

We get a warning in kernel/pid.c due to the deprecated find_task_by_pid(). 
Make the function inline in sched.h to avoid the warning.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 ++++-
 kernel/pid.c          |    6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN include/linux/sched.h~deprecate-find_task_by_pid-warning-fix include/linux/sched.h
--- a/include/linux/sched.h~deprecate-find_task_by_pid-warning-fix
+++ a/include/linux/sched.h
@@ -1655,7 +1655,10 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-extern struct task_struct *find_task_by_pid(pid_t nr) __deprecated;
+static inline struct task_struct *__deprecated find_task_by_pid(pid_t nr)
+{
+	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
+}
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
diff -puN kernel/pid.c~deprecate-find_task_by_pid-warning-fix kernel/pid.c
--- a/kernel/pid.c~deprecate-find_task_by_pid-warning-fix
+++ a/kernel/pid.c
@@ -382,12 +382,6 @@ struct task_struct *find_task_by_pid_typ
 
 EXPORT_SYMBOL(find_task_by_pid_type_ns);
 
-struct task_struct *find_task_by_pid(pid_t nr)
-{
-	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
-}
-EXPORT_SYMBOL(find_task_by_pid);

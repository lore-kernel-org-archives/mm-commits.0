From: akpm@linux-foundation.org
Subject: - bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:05 -0700
Message-ID: <200807252303.m6PN35wF003923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304AbYGYXGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     bsdacct: account dying tasks in all relevant namespaces
has been removed from the -mm tree.  Its filename was
     bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: account dying tasks in all relevant namespaces
From: Pavel Emelyanov <xemul@openvz.org>

This just makes the acct_proces walk the pid namespaces from current up to
the top and account a task in each with the accounting turned on.

ns->parent access if safe lockless, since current it still alive and holds
its namespace, which in turn holds its parent.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN kernel/acct.c~bsdacct-account-dying-tasks-in-all-relevant-namespaces kernel/acct.c
--- a/kernel/acct.c~bsdacct-account-dying-tasks-in-all-relevant-namespaces
+++ a/kernel/acct.c
@@ -631,15 +631,9 @@ void acct_collect(long exitcode, int gro
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-/**
- * acct_process - now just a wrapper around do_acct_process
- *
- * handles process accounting for an exiting task
- */
-void acct_process(void)
+static void acct_process_in_ns(struct pid_namespace *ns)
 {
 	struct file *file = NULL;
-	struct pid_namespace *ns = task_active_pid_ns(current);
 	struct bsd_acct_struct *acct;
 
 	acct = ns->bacct;
@@ -661,3 +655,16 @@ void acct_process(void)
 	do_acct_process(acct, ns, file);
 	fput(file);
 }
+
+/**
+ * acct_process - now just a wrapper around do_acct_process
+ *
+ * handles process accounting for an exiting task
+ */
+void acct_process(void)
+{
+	struct pid_namespace *ns;
+
+	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
+		acct_process_in_ns(ns);
+}
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch


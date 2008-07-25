From: akpm@linux-foundation.org
Subject: - bsdacct-stir-up-comments-around-acct_process.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:07 -0700
Message-ID: <200807252303.m6PN37uJ003926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbYGYXDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     bsdacct: fix and add comments around acct_process()
has been removed from the -mm tree.  Its filename was
     bsdacct-stir-up-comments-around-acct_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: fix and add comments around acct_process()
From: Pavel Emelyanov <xemul@openvz.org>

Fix the one describing what this function is and add one more - about
locking absence around pid namespaces loop.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/acct.c~bsdacct-stir-up-comments-around-acct_process kernel/acct.c
--- a/kernel/acct.c~bsdacct-stir-up-comments-around-acct_process
+++ a/kernel/acct.c
@@ -657,7 +657,8 @@ static void acct_process_in_ns(struct pi
 }
 
 /**
- * acct_process - now just a wrapper around do_acct_process
+ * acct_process - now just a wrapper around acct_process_in_ns,
+ * which in turn is a wrapper around do_acct_process.
  *
  * handles process accounting for an exiting task
  */
@@ -665,6 +666,11 @@ void acct_process(void)
 {
 	struct pid_namespace *ns;
 
+	/*
+	 * This loop is safe lockless, since current is still
+	 * alive and holds its namespace, which in turn holds
+	 * its parent.
+	 */
 	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
 		acct_process_in_ns(ns);
 }
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


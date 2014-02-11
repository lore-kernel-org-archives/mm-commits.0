From: akpm@linux-foundation.org
Subject: +
 ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch added to -mm tree
Date: Tue, 11 Feb 2014 14:16:28 -0800
Message-ID: <52faa13c.SHAB5YEBCNHWzqgZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKWQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 17:16:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, manfred@colorfullife.com, m@silodev.com, dledford@redhat.com, davidlohr@hp.com

Subject: + ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch added to -mm tree
To: davidlohr@hp.com,dledford@redhat.com,m@silodev.com,manfred@colorfullife.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 14:16:28 -0800


The patch titled
     Subject: ipc,mqueue: remove limits for the amount of system-wide queues
has been added to the -mm tree.  Its filename is
     ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,mqueue: remove limits for the amount of system-wide queues

93e6f119 ("ipc/mqueue: cleanup definition names and locations") added
global hardcoded limits to the amount of message queues that can be
created.  While these limits are per-namespace, reality is that it ends up
breaking userspace applications.  Historically users have, at least in
theory, been able to create up to INT_MAX queues, and limiting it to just
1024 is way too low and dramatic for some workloads and use cases.  For
instance, Madars reports:

"This update imposes bad limits on our multi-process application.  As our
app uses approaches that each process opens its own set of queues (usually
something about 3-5 queues per process).  In some scenarios we might run
up to 3000 processes or more (which of-course for linux is not a problem).
 Thus we might need up to 9000 queues or more.  All processes run under
one user."

Other affected users can be found in launchpad bug #1155695:
https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/1155695

Instead of increasing this limit, revert it entirely and fallback to the
original way of dealing queue limits -- where once a user's resource limit
is reached, and all memory is used, new queues cannot be created.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reported-by: Madars Vitolins <m@silodev.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>	[3.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 --
 ipc/mq_sysctl.c               |   18 ++++++++++++------
 ipc/mqueue.c                  |    6 +++---
 3 files changed, 15 insertions(+), 11 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues
+++ a/include/linux/ipc_namespace.h
@@ -118,9 +118,7 @@ extern int mq_init_ns(struct ipc_namespa
  *     the new maximum will handle anyone else.  I may have to revisit this
  *     in the future.
  */
-#define MIN_QUEUESMAX			1
 #define DFLT_QUEUESMAX		      256
-#define HARD_QUEUESMAX		     1024
 #define MIN_MSGMAX			1
 #define DFLT_MSG		       10U
 #define DFLT_MSGMAX		       10
diff -puN ipc/mq_sysctl.c~ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues
+++ a/ipc/mq_sysctl.c
@@ -22,6 +22,16 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
+static int proc_mq_dointvec(ctl_table *table, int write,
+			    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table mq_table;
+	memcpy(&mq_table, table, sizeof(mq_table));
+	mq_table.data = get_mq(table);
+
+	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
+}
+
 static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -33,12 +43,10 @@ static int proc_mq_dointvec_minmax(ctl_t
 					lenp, ppos);
 }
 #else
+#define proc_mq_dointvec NULL
 #define proc_mq_dointvec_minmax NULL
 #endif
 
-static int msg_queues_limit_min = MIN_QUEUESMAX;
-static int msg_queues_limit_max = HARD_QUEUESMAX;
-
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = HARD_MSGMAX;
 
@@ -51,9 +59,7 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_mq_dointvec_minmax,
-		.extra1		= &msg_queues_limit_min,
-		.extra2		= &msg_queues_limit_max,
+		.proc_handler	= proc_mq_dointvec,
 	},
 	{
 		.procname	= "msg_max",
diff -puN ipc/mqueue.c~ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues ipc/mqueue.c
--- a/ipc/mqueue.c~ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues
+++ a/ipc/mqueue.c
@@ -433,9 +433,9 @@ static int mqueue_create(struct inode *d
 		error = -EACCES;
 		goto out_unlock;
 	}
-	if (ipc_ns->mq_queues_count >= HARD_QUEUESMAX ||
-	    (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
-	     !capable(CAP_SYS_RESOURCE))) {
+
+	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
+	    !capable(CAP_SYS_RESOURCE)) {
 		error = -ENOSPC;
 		goto out_unlock;
 	}
_

Patches currently in -mm which might be from davidlohr@hp.com are

ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
linux-next.patch


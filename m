From: akpm@linux-foundation.org
Subject: [merged] ipc-use-a-work-queue-to-free_ipc.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 15:31:33 -0700
Message-ID: <20200608223133.u_BH99rPf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgFHWbe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:31:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, gscrivan@redhat.com, longman@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, paulmck@kernel.org


The patch titled
     Subject: ipc/namespace.c: use a work queue to free_ipc
has been removed from the -mm tree.  Its filename was
     ipc-use-a-work-queue-to-free_ipc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Giuseppe Scrivano <gscrivan@redhat.com>
Subject: ipc/namespace.c: use a work queue to free_ipc

the reason is to avoid a delay caused by the synchronize_rcu() call in
kern_umount() when the mqueue mount is freed.

the code:

\#define _GNU_SOURCE
\#include <sched.h>
\#include <error.h>
\#include <errno.h>
\#include <stdlib.h>
int main()
{
  int i;
  for (i = 0; i < 1000; i++)
    if (unshare (CLONE_NEWIPC) < 0)
      error (EXIT_FAILURE, errno, "unshare");
}

gets from

	Command being timed: "./ipc-namespace"
	User time (seconds): 0.00
	System time (seconds): 0.06
	Percent of CPU this job got: 0%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:08.05

to

	Command being timed: "./ipc-namespace"
	User time (seconds): 0.00
	System time (seconds): 0.02
	Percent of CPU this job got: 96%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.03

Link: http://lkml.kernel.org/r/20200225145419.527994-1-gscrivan@redhat.com
Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 ++
 ipc/namespace.c               |   24 ++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

--- a/include/linux/ipc_namespace.h~ipc-use-a-work-queue-to-free_ipc
+++ a/include/linux/ipc_namespace.h
@@ -68,6 +68,8 @@ struct ipc_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 
+	struct llist_node mnt_llist;
+
 	struct ns_common ns;
 } __randomize_layout;
 
--- a/ipc/namespace.c~ipc-use-a-work-queue-to-free_ipc
+++ a/ipc/namespace.c
@@ -117,6 +117,10 @@ void free_ipcs(struct ipc_namespace *ns,
 
 static void free_ipc_ns(struct ipc_namespace *ns)
 {
+	/* mq_put_mnt() waits for a grace period as kern_unmount()
+	 * uses synchronize_rcu().
+	 */
+	mq_put_mnt(ns);
 	sem_exit_ns(ns);
 	msg_exit_ns(ns);
 	shm_exit_ns(ns);
@@ -127,6 +131,21 @@ static void free_ipc_ns(struct ipc_names
 	kfree(ns);
 }
 
+static LLIST_HEAD(free_ipc_list);
+static void free_ipc(struct work_struct *unused)
+{
+	struct llist_node *node = llist_del_all(&free_ipc_list);
+	struct ipc_namespace *n, *t;
+
+	llist_for_each_entry_safe(n, t, node, mnt_llist)
+		free_ipc_ns(n);
+}
+
+/*
+ * The work queue is used to avoid the cost of synchronize_rcu in kern_unmount.
+ */
+static DECLARE_WORK(free_ipc_work, free_ipc);
+
 /*
  * put_ipc_ns - drop a reference to an ipc namespace.
  * @ns: the namespace to put
@@ -148,8 +167,9 @@ void put_ipc_ns(struct ipc_namespace *ns
 	if (refcount_dec_and_lock(&ns->count, &mq_lock)) {
 		mq_clear_sbinfo(ns);
 		spin_unlock(&mq_lock);
-		mq_put_mnt(ns);
-		free_ipc_ns(ns);
+
+		if (llist_add(&ns->mnt_llist, &free_ipc_list))
+			schedule_work(&free_ipc_work);
 	}
 }
 
_

Patches currently in -mm which might be from gscrivan@redhat.com are

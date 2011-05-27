From: akpm@linux-foundation.org
Subject: [merged] cgroups-use-flex_array-in-attach_proc.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:45 -0700
Message-ID: <201105271955.p4RJtpks017490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756808Ab1E0T4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, miaox@cn.fujitsu.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: use flex_array in attach_proc
has been removed from the -mm tree.  Its filename was
     cgroups-use-flex_array-in-attach_proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: use flex_array in attach_proc
From: Ben Blum <bblum@andrew.cmu.edu>

Convert cgroup_attach_proc to use flex_array.

The cgroup_attach_proc implementation requires a pre-allocated array to
store task pointers to atomically move a thread-group, but asking for a
monolithic array with kmalloc() may be unreliable for very large groups. 
Using flex_array provides the same functionality with less risk of
failure.

This is a post-patch for cgroup-procs-write.patch.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff -puN kernel/cgroup.c~cgroups-use-flex_array-in-attach_proc kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-use-flex_array-in-attach_proc
+++ a/kernel/cgroup.c
@@ -57,6 +57,7 @@
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/eventfd.h>
 #include <linux/poll.h>
+#include <linux/flex_array.h> /* used in cgroup_attach_proc */
 
 #include <asm/atomic.h>
 
@@ -1995,7 +1996,7 @@ int cgroup_attach_proc(struct cgroup *cg
 	struct cgroupfs_root *root = cgrp->root;
 	/* threadgroup list cursor and array */
 	struct task_struct *tsk;
-	struct task_struct **group;
+	struct flex_array *group;
 	/*
 	 * we need to make sure we have css_sets for all the tasks we're
 	 * going to move -before- we actually start moving them, so that in
@@ -2012,9 +2013,15 @@ int cgroup_attach_proc(struct cgroup *cg
 	 * and if threads exit, this will just be an over-estimate.
 	 */
 	group_size = get_nr_threads(leader);
-	group = kmalloc(group_size * sizeof(*group), GFP_KERNEL);
+	/* flex_array supports very large thread-groups better than kmalloc. */
+	group = flex_array_alloc(sizeof(struct task_struct *), group_size,
+				 GFP_KERNEL);
 	if (!group)
 		return -ENOMEM;
+	/* pre-allocate to guarantee space while iterating in rcu read-side. */
+	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	if (retval)
+		goto out_free_group_list;
 
 	/* prevent changes to the threadgroup list while we take a snapshot. */
 	rcu_read_lock();
@@ -2037,7 +2044,12 @@ int cgroup_attach_proc(struct cgroup *cg
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
 		get_task_struct(tsk);
-		group[i] = tsk;
+		/*
+		 * saying GFP_ATOMIC has no effect here because we did prealloc
+		 * earlier, but it's good form to communicate our expectations.
+		 */
+		retval = flex_array_put_ptr(group, i, tsk, GFP_ATOMIC);
+		BUG_ON(retval != 0);
 		i++;
 	} while_each_thread(leader, tsk);
 	/* remember the number of threads in the array for later. */
@@ -2059,7 +2071,8 @@ int cgroup_attach_proc(struct cgroup *cg
 		if (ss->can_attach_task) {
 			/* run on each task in the threadgroup. */
 			for (i = 0; i < group_size; i++) {
-				retval = ss->can_attach_task(cgrp, group[i]);
+				tsk = flex_array_get_ptr(group, i);
+				retval = ss->can_attach_task(cgrp, tsk);
 				if (retval) {
 					failed_ss = ss;
 					cancel_failed_ss = true;
@@ -2075,7 +2088,7 @@ int cgroup_attach_proc(struct cgroup *cg
 	 */
 	INIT_LIST_HEAD(&newcg_list);
 	for (i = 0; i < group_size; i++) {
-		tsk = group[i];
+		tsk = flex_array_get_ptr(group, i);
 		/* nothing to do if this task is already in the cgroup */
 		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
@@ -2114,7 +2127,7 @@ int cgroup_attach_proc(struct cgroup *cg
 			ss->pre_attach(cgrp);
 	}
 	for (i = 0; i < group_size; i++) {
-		tsk = group[i];
+		tsk = flex_array_get_ptr(group, i);
 		/* leave current thread as it is if it's already there */
 		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
@@ -2167,10 +2180,12 @@ out_cancel_attach:
 		}
 	}
 	/* clean up the array of referenced threads in the group. */
-	for (i = 0; i < group_size; i++)
-		put_task_struct(group[i]);
+	for (i = 0; i < group_size; i++) {
+		tsk = flex_array_get_ptr(group, i);
+		put_task_struct(tsk);
+	}
 out_free_group_list:
-	kfree(group);
+	flex_array_free(group);
 	return retval;
 }
 
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

origin.patch


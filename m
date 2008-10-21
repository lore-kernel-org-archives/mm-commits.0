From: akpm@linux-foundation.org
Subject: - memrlimit-handle-attach_task-failure-add-can_attach-callback.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:21:42 -0700
Message-ID: <200810210021.m9L0LgLi020166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbYJUAWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com


The patch titled
     memrlimit: handle attach_task() failure, add can_attach() callback
has been removed from the -mm tree.  Its filename was
     memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

This patch was dropped because of lack of enthusiasm

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: handle attach_task() failure, add can_attach() callback
From: Balbir Singh <balbir@linux.vnet.ibm.com>

This patch fixes a task migration problem reported by Kamezawa-San.  This
patch should fix all issues with migraiton, except for a rare condition
documented in memrlimit_cgroup_move_task().  To fix that problem, we would
need to add transaction properties to cgroups.

The problem reported was that migrating to a group that did not have
sufficient limits to accept an incoming task caused a kernel warning.

Steps to reproduce

% mkdir /dev/cgroup/memrlimit/group_01
% mkdir /dev/cgroup/memrlimit/group_02
% echo 1G > /dev/cgroup/memrlimit/group_01/memrlimit.limit_in_bytes
% echo 0 >  /dev/cgroup/memrlimit/group_02/memrlimit.limit_in_bytes
% echo $$ > /dev/cgroup/memrlimit/group_01/tasks
% echo $$ > /dev/cgroup/memrlimit/group_02/tasks
% exit

memrlimit does the right thing by not moving the charges to group_02, but
the task is still put into g2 (since we did not use can_attach to fail
migration).  Once in g2, when we echo the task to the root cgroup, it
tries to uncharge the cost of the task from g2.  g2 does not have any
charge associated with the task, hence we get a warning.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   17 +++++++++++++
 mm/memrlimitcgroup.c        |   43 ++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff -puN include/linux/res_counter.h~memrlimit-handle-attach_task-failure-add-can_attach-callback include/linux/res_counter.h
--- a/include/linux/res_counter.h~memrlimit-handle-attach_task-failure-add-can_attach-callback
+++ a/include/linux/res_counter.h
@@ -174,4 +174,21 @@ static inline int res_counter_set_limit(
 	return ret;
 }
 
+/*
+ * Add the value val to the resource counter and check if we are
+ * still under the limit.
+ */
+static inline bool res_counter_can_add(struct res_counter *cnt,
+						unsigned long val)
+{
+	bool ret = false;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	if (cnt->usage + val <= cnt->limit)
+		ret = true;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
+
 #endif
diff -puN mm/memrlimitcgroup.c~memrlimit-handle-attach_task-failure-add-can_attach-callback mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-handle-attach_task-failure-add-can_attach-callback
+++ a/mm/memrlimitcgroup.c
@@ -159,6 +159,38 @@ static int memrlimit_cgroup_populate(str
 				ARRAY_SIZE(memrlimit_cgroup_files));
 }
 
+static int memrlimit_cgroup_can_move_task(struct cgroup_subsys *ss,
+					struct cgroup *cgrp,
+					struct task_struct *p)
+{
+	struct mm_struct *mm;
+	struct memrlimit_cgroup *memrcg;
+	int ret = 0;
+
+	mm = get_task_mm(p);
+	if (mm == NULL)
+		return -EINVAL;
+
+	/*
+	 * Hold mmap_sem, so that total_vm does not change underneath us
+	 */
+	down_read(&mm->mmap_sem);
+
+	rcu_read_lock();
+	if (p != rcu_dereference(mm->owner))
+		goto out;
+
+	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
+
+	if (!res_counter_can_add(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
+		ret = -ENOMEM;
+out:
+	rcu_read_unlock();
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return ret;
+}
+
 static void memrlimit_cgroup_move_task(struct cgroup_subsys *ss,
 					struct cgroup *cgrp,
 					struct cgroup *old_cgrp,
@@ -186,6 +218,16 @@ static void memrlimit_cgroup_move_task(s
 	if (memrcg == old_memrcg)
 		goto out;
 
+	/*
+	 * TBD: Even though we do the necessary checks in can_attach(),
+	 * by the time we come here, there is a chance that we still
+	 * fail (the memrlimit cgroup has grown its usage, and the
+	 * addition of total_vm will no longer fit into its limit)
+	 *
+	 * We need transactional support in cgroups to let us know
+	 * if can_attach() has failed and call attach_failed() on
+	 * cgroups for which can_attach() succeeded.
+	 */
 	if (res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
 		goto out;
 	res_counter_uncharge(&old_memrcg->as_res, (mm->total_vm << PAGE_SHIFT));
@@ -233,6 +275,7 @@ struct cgroup_subsys memrlimit_cgroup_su
 	.destroy = memrlimit_cgroup_destroy,
 	.populate = memrlimit_cgroup_populate,
 	.attach = memrlimit_cgroup_move_task,
+	.can_attach = memrlimit_cgroup_can_move_task,
 	.mm_owner_changed = memrlimit_cgroup_mm_owner_changed,
 	.early_init = 0,
 };
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch


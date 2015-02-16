From: akpm@linux-foundation.org
Subject: [merged]
 cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:21 -0800
Message-ID: <54e25015.RZSLZRbnJtvQD6lk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPUQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, lizefan@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuset: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: cpuset: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* kernel/cpuset.c::cpuset_print_task_mems_allowed() used a static
  buffer which is protected by a dedicated spinlock.  Removed.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   42 +++++++++---------------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff -puN kernel/cpuset.c~cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/cpuset.c
@@ -1707,40 +1707,27 @@ static int cpuset_common_seq_show(struct
 {
 	struct cpuset *cs = css_cs(seq_css(sf));
 	cpuset_filetype_t type = seq_cft(sf)->private;
-	ssize_t count;
-	char *buf, *s;
 	int ret = 0;
 
-	count = seq_get_buf(sf, &buf);
-	s = buf;
-
 	spin_lock_irq(&callback_lock);
 
 	switch (type) {
 	case FILE_CPULIST:
-		s += cpulist_scnprintf(s, count, cs->cpus_allowed);
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->cpus_allowed));
 		break;
 	case FILE_MEMLIST:
-		s += nodelist_scnprintf(s, count, cs->mems_allowed);
+		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->mems_allowed));
 		break;
 	case FILE_EFFECTIVE_CPULIST:
-		s += cpulist_scnprintf(s, count, cs->effective_cpus);
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->effective_cpus));
 		break;
 	case FILE_EFFECTIVE_MEMLIST:
-		s += nodelist_scnprintf(s, count, cs->effective_mems);
+		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
 	default:
 		ret = -EINVAL;
-		goto out_unlock;
 	}
 
-	if (s < buf + count - 1) {
-		*s++ = '\n';
-		seq_commit(sf, s - buf);
-	} else {
-		seq_commit(sf, -1);
-	}
-out_unlock:
 	spin_unlock_irq(&callback_lock);
 	return ret;
 }
@@ -2610,8 +2597,6 @@ int cpuset_mems_allowed_intersects(const
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
-#define CPUSET_NODELIST_LEN	(256)
-
 /**
  * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
  * @tsk: pointer to task_struct of some task.
@@ -2621,23 +2606,16 @@ int cpuset_mems_allowed_intersects(const
  */
 void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 {
-	 /* Statically allocated to prevent using excess stack. */
-	static char cpuset_nodelist[CPUSET_NODELIST_LEN];
-	static DEFINE_SPINLOCK(cpuset_buffer_lock);
 	struct cgroup *cgrp;
 
-	spin_lock(&cpuset_buffer_lock);
 	rcu_read_lock();
 
 	cgrp = task_cs(tsk)->css.cgroup;
-	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
-			   tsk->mems_allowed);
 	pr_info("%s cpuset=", tsk->comm);
 	pr_cont_cgroup_name(cgrp);
-	pr_cont(" mems_allowed=%s\n", cpuset_nodelist);
+	pr_cont(" mems_allowed=%*pbl\n", nodemask_pr_args(&tsk->mems_allowed));
 
 	rcu_read_unlock();
-	spin_unlock(&cpuset_buffer_lock);
 }
 
 /*
@@ -2715,10 +2693,8 @@ out:
 /* Display task mems_allowed in /proc/<pid>/status file. */
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_puts(m, "Mems_allowed:\t");
-	seq_nodemask(m, &task->mems_allowed);
-	seq_puts(m, "\n");
-	seq_puts(m, "Mems_allowed_list:\t");
-	seq_nodemask_list(m, &task->mems_allowed);
-	seq_puts(m, "\n");
+	seq_printf(m, "Mems_allowed:\t%*pb\n",
+		   nodemask_pr_args(&task->mems_allowed));
+	seq_printf(m, "Mems_allowed_list:\t%*pbl\n",
+		   nodemask_pr_args(&task->mems_allowed));
 }
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch


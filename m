From: akpm@linux-foundation.org
Subject: - cpuset-clean-up-cpuset-hierarchy-traversal-code.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:25 -0700
Message-ID: <200807301914.m6UJEP9b010904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbYG3TQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: clean up cpuset hierarchy traversal code
has been removed from the -mm tree.  Its filename was
     cpuset-clean-up-cpuset-hierarchy-traversal-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: clean up cpuset hierarchy traversal code
From: Li Zefan <lizf@cn.fujitsu.com>

Use cpuset.stack_list rather than kfifo, so we avoid memory allocation
for kfifo.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN kernel/cpuset.c~cpuset-clean-up-cpuset-hierarchy-traversal-code kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-clean-up-cpuset-hierarchy-traversal-code
+++ a/kernel/cpuset.c
@@ -54,7 +54,6 @@
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
 #include <linux/mutex.h>
-#include <linux/kfifo.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
 
@@ -557,7 +556,7 @@ update_domain_attr_tree(struct sched_dom
  * So the reverse nesting would risk an ABBA deadlock.
  *
  * The three key local variables below are:
- *    q  - a kfifo queue of cpuset pointers, used to implement a
+ *    q  - a linked-list queue of cpuset pointers, used to implement a
  *	   top-down scan of all cpusets.  This scan loads a pointer
  *	   to each cpuset marked is_sched_load_balance into the
  *	   array 'csa'.  For our purposes, rebuilding the schedulers
@@ -592,7 +591,7 @@ update_domain_attr_tree(struct sched_dom
 
 void rebuild_sched_domains(void)
 {
-	struct kfifo *q;	/* queue of cpusets to be scanned */
+	LIST_HEAD(q);		/* queue of cpusets to be scanned*/
 	struct cpuset *cp;	/* scans q */
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
@@ -602,7 +601,6 @@ void rebuild_sched_domains(void)
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	q = NULL;
 	csa = NULL;
 	doms = NULL;
 	dattr = NULL;
@@ -622,20 +620,19 @@ void rebuild_sched_domains(void)
 		goto rebuild;
 	}
 
-	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
-	if (IS_ERR(q))
-		goto done;
 	csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
 	if (!csa)
 		goto done;
 	csn = 0;
 
-	cp = &top_cpuset;
-	__kfifo_put(q, (void *)&cp, sizeof(cp));
-	while (__kfifo_get(q, (void *)&cp, sizeof(cp))) {
+	list_add(&top_cpuset.stack_list, &q);
+	while (!list_empty(&q)) {
 		struct cgroup *cont;
 		struct cpuset *child;   /* scans child cpusets of cp */
 
+		cp = list_first_entry(&q, struct cpuset, stack_list);
+		list_del(q.next);
+
 		if (cpus_empty(cp->cpus_allowed))
 			continue;
 
@@ -652,7 +649,7 @@ void rebuild_sched_domains(void)
 
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
-			__kfifo_put(q, (void *)&child, sizeof(cp));
+			list_add_tail(&child->stack_list, &q);
 		}
   	}
 
@@ -735,8 +732,6 @@ rebuild:
 	put_online_cpus();
 
 done:
-	if (q && !IS_ERR(q))
-		kfifo_free(q);
 	kfree(csa);
 	/* Don't kfree(doms) -- partition_sched_domains() does that. */
 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch


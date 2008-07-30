From: akpm@linux-foundation.org
Subject: - cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:17 -0700
Message-ID: <200807301914.m6UJEHtm010895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177AbYG3Tei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, cpw@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: a bit cleanup for scan_for_empty_cpusets()
has been removed from the -mm tree.  Its filename was
     cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: a bit cleanup for scan_for_empty_cpusets()
From: Li Zefan <lizf@cn.fujitsu.com>

clean up hierarchy traversal code

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~cpuset-a-bit-cleanup-for-scan_for_empty_cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-a-bit-cleanup-for-scan_for_empty_cpusets
+++ a/kernel/cpuset.c
@@ -1833,24 +1833,21 @@ static void remove_tasks_in_empty_cpuset
  */
 static void scan_for_empty_cpusets(const struct cpuset *root)
 {
+	LIST_HEAD(queue);
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
-	struct list_head queue;
 	struct cgroup *cont;
 	nodemask_t oldmems;
 
-	INIT_LIST_HEAD(&queue);
-
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
 	while (!list_empty(&queue)) {
-		cp = container_of(queue.next, struct cpuset, stack_list);
+		cp = list_first_entry(&queue, struct cpuset, stack_list);
 		list_del(queue.next);
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
 			list_add_tail(&child->stack_list, &queue);
 		}
-		cont = cp->css.cgroup;
 
 		/* Continue past cpusets with all cpus, mems online */
 		if (cpus_subset(cp->cpus_allowed, cpu_online_map) &&
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


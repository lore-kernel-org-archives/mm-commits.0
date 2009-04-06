From: akpm@linux-foundation.org
Subject: [merged] cpuset-remove-struct-cpuset_hotplug_scanner.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:04 -0700
Message-ID: <200904061935.n36JZ4Rs011857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbZDFU2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuset: remove struct cpuset_hotplug_scanner
has been removed from the -mm tree.  Its filename was
     cpuset-remove-struct-cpuset_hotplug_scanner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: remove struct cpuset_hotplug_scanner
From: Li Zefan <lizf@cn.fujitsu.com>

Use cgroup_scanner.data, instead of introducing cpuset_hotplug_scanner.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN kernel/cpuset.c~cpuset-remove-struct-cpuset_hotplug_scanner kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-remove-struct-cpuset_hotplug_scanner
+++ a/kernel/cpuset.c
@@ -128,10 +128,6 @@ static inline struct cpuset *task_cs(str
 	return container_of(task_subsys_state(task, cpuset_subsys_id),
 			    struct cpuset, css);
 }
-struct cpuset_hotplug_scanner {
-	struct cgroup_scanner scan;
-	struct cgroup *to;
-};
 
 /* bits in struct cpuset flags field */
 typedef enum {
@@ -1890,10 +1886,9 @@ int __init cpuset_init(void)
 static void cpuset_do_move_task(struct task_struct *tsk,
 				struct cgroup_scanner *scan)
 {
-	struct cpuset_hotplug_scanner *chsp;
+	struct cgroup *new_cgroup = scan->data;
 
-	chsp = container_of(scan, struct cpuset_hotplug_scanner, scan);
-	cgroup_attach_task(chsp->to, tsk);
+	cgroup_attach_task(new_cgroup, tsk);
 }
 
 /**
@@ -1909,15 +1904,15 @@ static void cpuset_do_move_task(struct t
  */
 static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
 {
-	struct cpuset_hotplug_scanner scan;
+	struct cgroup_scanner scan;
 
-	scan.scan.cg = from->css.cgroup;
-	scan.scan.test_task = NULL; /* select all tasks in cgroup */
-	scan.scan.process_task = cpuset_do_move_task;
-	scan.scan.heap = NULL;
-	scan.to = to->css.cgroup;
+	scan.cg = from->css.cgroup;
+	scan.test_task = NULL; /* select all tasks in cgroup */
+	scan.process_task = cpuset_do_move_task;
+	scan.heap = NULL;
+	scan.data = to->css.cgroup;
 
-	if (cgroup_scan_tasks(&scan.scan))
+	if (cgroup_scan_tasks(&scan))
 		printk(KERN_ERR "move_member_tasks_to_cpuset: "
 				"cgroup_scan_tasks failed\n");
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch


From: akpm@linux-foundation.org
Subject: + cpuset-remove-struct-cpuset_hotplug_scanner.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:57:29 -0800
Message-ID: <200902262257.n1QMvTlo031445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbZBZW5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cpuset: remove struct cpuset_hotplug_scanner
has been added to the -mm tree.  Its filename is
     cpuset-remove-struct-cpuset_hotplug_scanner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: remove struct cpuset_hotplug_scanner
From: Li Zefan <lizf@cn.fujitsu.com>

Use cgroup_scanner.data, instead of introducing cpuset_hotplug_scanner.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
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
@@ -1889,10 +1885,9 @@ int __init cpuset_init(void)
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
@@ -1908,15 +1903,15 @@ static void cpuset_do_move_task(struct t
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

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch


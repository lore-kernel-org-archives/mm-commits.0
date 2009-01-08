From: akpm@linux-foundation.org
Subject: - cgroups-make-root_list-contains-active-hierarchies-only.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:42 -0800
Message-ID: <200901082247.n08MlgWn027128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763029AbZAHWvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: make root_list contains active hierarchies only
has been removed from the -mm tree.  Its filename was
     cgroups-make-root_list-contains-active-hierarchies-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: make root_list contains active hierarchies only
From: Li Zefan <lizf@cn.fujitsu.com>

Don't link rootnode to the root list, so root_list contains active
hierarchies only as the comment indicates.  And rename for_each_root() to
for_each_active_root().

Also remove redundant check in cgroup_kill_sb().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN kernel/cgroup.c~cgroups-make-root_list-contains-active-hierarchies-only kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-make-root_list-contains-active-hierarchies-only
+++ a/kernel/cgroup.c
@@ -84,7 +84,7 @@ struct cgroupfs_root {
 	/* Tracks how many cgroups are currently defined in hierarchy.*/
 	int number_of_cgroups;
 
-	/* A list running through the mounted hierarchies */
+	/* A list running through the active hierarchies */
 	struct list_head root_list;
 
 	/* Hierarchy-specific flags */
@@ -148,8 +148,8 @@ static int notify_on_release(const struc
 #define for_each_subsys(_root, _ss) \
 list_for_each_entry(_ss, &_root->subsys_list, sibling)
 
-/* for_each_root() allows you to iterate across the active hierarchies */
-#define for_each_root(_root) \
+/* for_each_active_root() allows you to iterate across the active hierarchies */
+#define for_each_active_root(_root) \
 list_for_each_entry(_root, &roots, root_list)
 
 /* the list of cgroups eligible for automatic release. Protected by
@@ -1111,10 +1111,9 @@ static void cgroup_kill_sb(struct super_
 	}
 	write_unlock(&css_set_lock);
 
-	if (!list_empty(&root->root_list)) {
-		list_del(&root->root_list);
-		root_count--;
-	}
+	list_del(&root->root_list);
+	root_count--;
+
 	mutex_unlock(&cgroup_mutex);
 
 	kfree(root);
@@ -2559,7 +2558,6 @@ int __init cgroup_init_early(void)
 	INIT_HLIST_NODE(&init_css_set.hlist);
 	css_set_count = 1;
 	init_cgroup_root(&rootnode);
-	list_add(&rootnode.root_list, &roots);
 	root_count = 1;
 	init_task.cgroups = &init_css_set;
 
@@ -2666,15 +2664,12 @@ static int proc_cgroup_show(struct seq_f
 
 	mutex_lock(&cgroup_mutex);
 
-	for_each_root(root) {
+	for_each_active_root(root) {
 		struct cgroup_subsys *ss;
 		struct cgroup *cgrp;
 		int subsys_id;
 		int count = 0;
 
-		/* Skip this hierarchy if it has no active subsystems */
-		if (!root->actual_subsys_bits)
-			continue;
 		seq_printf(m, "%lu:", root->subsys_bits);
 		for_each_subsys(root, ss)
 			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch


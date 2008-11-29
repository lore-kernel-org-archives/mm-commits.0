From: akpm@linux-foundation.org
Subject: + cgroups-make-root_list-contains-active-hierarchies-only.patch added to -mm tree
Date: Fri, 28 Nov 2008 23:01:19 -0800
Message-ID: <200811290701.mAT71J04006432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbYK2HBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 02:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroups: make root_list contains active hierarchies only
has been added to the -mm tree.  Its filename is
     cgroups-make-root_list-contains-active-hierarchies-only.patch

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

memcg-memory-hotplug-fix-for-notifier-callback.patch
linux-next.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch


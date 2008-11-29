From: akpm@linux-foundation.org
Subject: + cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch added to -mm tree
Date: Fri, 28 Nov 2008 23:01:22 -0800
Message-ID: <200811290701.mAT71MwC006435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbYK2HBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 02:01:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroups: add inactive subsystems to rootnode.subsys_list
has been added to the -mm tree.  Its filename is
     cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch

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
Subject: cgroups: add inactive subsystems to rootnode.subsys_list
From: Li Zefan <lizf@cn.fujitsu.com>

Though for an inactive hierarchy, we have subsys->root == &rootnode, but
rootnode's subsys_list is always empty.

This conflicts with the code in find_css_set():

	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
		...
		if (ss->root->subsys_list.next == &ss->sibling) {
			...
		}
	}
	if (list_empty(&rootnode.subsys_list)) {
		...
	}

The above code assumes rootnode.subsys_list links all inactive
hierarchies.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-add-inactive-subsystems-to-rootnodesubsys_list kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-inactive-subsystems-to-rootnodesubsys_list
+++ a/kernel/cgroup.c
@@ -713,7 +713,7 @@ static int rebind_subsystems(struct cgro
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
-			list_add(&ss->sibling, &root->subsys_list);
+			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
 			if (ss->bind)
 				ss->bind(ss, cgrp);
@@ -727,7 +727,7 @@ static int rebind_subsystems(struct cgro
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			subsys[i]->root = &rootnode;
-			list_del(&ss->sibling);
+			list_move(&ss->sibling, &rootnode.subsys_list);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
 			BUG_ON(!cgrp->subsys[i]);
@@ -2521,6 +2521,7 @@ static void __init cgroup_init_subsys(st
 	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
 	/* Create the top cgroup state for this subsystem */
+	list_add(&ss->sibling, &rootnode.root_list);
 	ss->root = &rootnode;
 	css = ss->create(ss, dummytop);
 	/* We don't handle early failures gracefully */
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


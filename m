From: akpm@linux-foundation.org
Subject: - cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:44 -0800
Message-ID: <200901082247.n08MliJh027142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763514AbZAHWvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: add inactive subsystems to rootnode.subsys_list
has been removed from the -mm tree.  Its filename was
     cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -712,7 +712,7 @@ static int rebind_subsystems(struct cgro
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
-			list_add(&ss->sibling, &root->subsys_list);
+			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
 			if (ss->bind)
 				ss->bind(ss, cgrp);
@@ -726,7 +726,7 @@ static int rebind_subsystems(struct cgro
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
+	list_add(&ss->sibling, &rootnode.subsys_list);
 	ss->root = &rootnode;
 	css = ss->create(ss, dummytop);
 	/* We don't handle early failures gracefully */
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch


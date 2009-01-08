From: akpm@linux-foundation.org
Subject: - cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:32 -0800
Message-ID: <200901082247.n08MlW4K026981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763559AbZAHWsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: don't put struct cgroupfs_root protected by RCU
has been removed from the -mm tree.  Its filename was
     cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: don't put struct cgroupfs_root protected by RCU
From: Lai Jiangshan <laijs@cn.fujitsu.com>

We don't access struct cgroupfs_root in fast path, so we should not put
struct cgroupfs_root protected by RCU

But the comment in struct cgroup_subsys.root confuse us.

struct cgroup_subsys.root is used in these places:

1 find_css_set(): if (ss->root->subsys_list.next == &ss->sibling)
2 rebind_subsystems(): if (ss->root != &rootnode)
                       rcu_assign_pointer(ss->root, root);
                       rcu_assign_pointer(subsys[i]->root, &rootnode);
3 cgroup_has_css_refs(): if (ss->root != cgrp->root)
4 cgroup_init_subsys(): ss->root = &rootnode;
5 proc_cgroupstats_show(): ss->name, ss->root->subsys_bits,
                           ss->root->number_of_cgroups, !ss->disabled);
6 cgroup_clone(): root = subsys->root;
                  if ((root != subsys->root) ||

All these place we have held cgroup_lock() or we don't dereference to
struct cgroupfs_root.  It's means wo don't need RCU when use struct
cgroup_subsys.root, and we should not put struct cgroupfs_root protected
by RCU.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 -
 kernel/cgroup.c        |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu
+++ a/include/linux/cgroup.h
@@ -337,7 +337,6 @@ struct cgroup_subsys {
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
-	/* Protected by RCU */
 	struct cgroupfs_root *root;
 
 	struct list_head sibling;
diff -puN kernel/cgroup.c~cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu
+++ a/kernel/cgroup.c
@@ -713,7 +713,7 @@ static int rebind_subsystems(struct cgro
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_add(&ss->sibling, &root->subsys_list);
-			rcu_assign_pointer(ss->root, root);
+			ss->root = root;
 			if (ss->bind)
 				ss->bind(ss, cgrp);
 
@@ -725,7 +725,7 @@ static int rebind_subsystems(struct cgro
 				ss->bind(ss, dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
-			rcu_assign_pointer(subsys[i]->root, &rootnode);
+			subsys[i]->root = &rootnode;
 			list_del(&ss->sibling);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


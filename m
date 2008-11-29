From: akpm@linux-foundation.org
Subject: + cgroups-introduce-link_css_set-to-remove-duplicate-code.patch added to -mm tree
Date: Fri, 28 Nov 2008 23:01:25 -0800
Message-ID: <200811290701.mAT71P2s006448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbYK2HBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 02:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroups: introduce link_css_set() to remove duplicate code
has been added to the -mm tree.  Its filename is
     cgroups-introduce-link_css_set-to-remove-duplicate-code.patch

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
Subject: cgroups: introduce link_css_set() to remove duplicate code
From: Li Zefan <lizf@cn.fujitsu.com>

Add a common function link_css_set() to link a css_set to a cgroup.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   62 +++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff -puN kernel/cgroup.c~cgroups-introduce-link_css_set-to-remove-duplicate-code kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-introduce-link_css_set-to-remove-duplicate-code
+++ a/kernel/cgroup.c
@@ -384,6 +384,19 @@ static int allocate_cg_links(int count, 
 	return 0;
 }
 
+static void link_css_set(struct list_head *tmp_cg_links,
+			 struct css_set *cg, struct cgroup *cgrp)
+{
+	struct cg_cgroup_link *link;
+
+	BUG_ON(list_empty(tmp_cg_links));
+	link = list_first_entry(tmp_cg_links, struct cg_cgroup_link,
+				cgrp_link_list);
+	link->cg = cg;
+	list_move(&link->cgrp_link_list, &cgrp->css_sets);
+	list_add(&link->cg_link_list, &cg->cg_links);
+}
+
 /*
  * find_css_set() takes an existing cgroup group and a
  * cgroup object, and returns a css_set object that's
@@ -399,7 +412,6 @@ static struct css_set *find_css_set(
 	int i;
 
 	struct list_head tmp_cg_links;
-	struct cg_cgroup_link *link;
 
 	struct hlist_head *hhead;
 
@@ -444,26 +456,11 @@ static struct css_set *find_css_set(
 		 * only do it for the first subsystem in each
 		 * hierarchy
 		 */
-		if (ss->root->subsys_list.next == &ss->sibling) {
-			BUG_ON(list_empty(&tmp_cg_links));
-			link = list_entry(tmp_cg_links.next,
-					  struct cg_cgroup_link,
-					  cgrp_link_list);
-			list_del(&link->cgrp_link_list);
-			list_add(&link->cgrp_link_list, &cgrp->css_sets);
-			link->cg = res;
-			list_add(&link->cg_link_list, &res->cg_links);
-		}
-	}
-	if (list_empty(&rootnode.subsys_list)) {
-		link = list_entry(tmp_cg_links.next,
-				  struct cg_cgroup_link,
-				  cgrp_link_list);
-		list_del(&link->cgrp_link_list);
-		list_add(&link->cgrp_link_list, &dummytop->css_sets);
-		link->cg = res;
-		list_add(&link->cg_link_list, &res->cg_links);
+		if (ss->root->subsys_list.next == &ss->sibling)
+			link_css_set(&tmp_cg_links, res, cgrp);
 	}
+	if (list_empty(&rootnode.subsys_list))
+		link_css_set(&tmp_cg_links, res, dummytop);
 
 	BUG_ON(!list_empty(&tmp_cg_links));
 
@@ -989,7 +986,7 @@ static int cgroup_get_sb(struct file_sys
 		root = NULL;
 	} else {
 		/* New superblock */
-		struct cgroup *cgrp = &root->top_cgroup;
+		struct cgroup *root_cgrp = &root->top_cgroup;
 		struct inode *inode;
 		int i;
 
@@ -1030,7 +1027,7 @@ static int cgroup_get_sb(struct file_sys
 		list_add(&root->root_list, &roots);
 		root_count++;
 
-		sb->s_root->d_fsdata = &root->top_cgroup;
+		sb->s_root->d_fsdata = root_cgrp;
 		root->top_cgroup.dentry = sb->s_root;
 
 		/* Link the top cgroup in this hierarchy into all
@@ -1041,29 +1038,18 @@ static int cgroup_get_sb(struct file_sys
 			struct hlist_node *node;
 			struct css_set *cg;
 
-			hlist_for_each_entry(cg, node, hhead, hlist) {
-				struct cg_cgroup_link *link;
-
-				BUG_ON(list_empty(&tmp_cg_links));
-				link = list_entry(tmp_cg_links.next,
-						  struct cg_cgroup_link,
-						  cgrp_link_list);
-				list_del(&link->cgrp_link_list);
-				link->cg = cg;
-				list_add(&link->cgrp_link_list,
-					 &root->top_cgroup.css_sets);
-				list_add(&link->cg_link_list, &cg->cg_links);
-			}
+			hlist_for_each_entry(cg, node, hhead, hlist)
+				link_css_set(&tmp_cg_links, cg, root_cgrp);
 		}
 		write_unlock(&css_set_lock);
 
 		free_cg_links(&tmp_cg_links);
 
-		BUG_ON(!list_empty(&cgrp->sibling));
-		BUG_ON(!list_empty(&cgrp->children));
+		BUG_ON(!list_empty(&root_cgrp->sibling));
+		BUG_ON(!list_empty(&root_cgrp->children));
 		BUG_ON(root->number_of_cgroups != 1);
 
-		cgroup_populate_dir(cgrp);
+		cgroup_populate_dir(root_cgrp);
 		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&cgroup_mutex);
 	}
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


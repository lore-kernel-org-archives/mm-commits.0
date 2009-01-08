From: akpm@linux-foundation.org
Subject: - cgroups-introduce-link_css_set-to-remove-duplicate-code.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:46 -0800
Message-ID: <200901082247.n08MlkSV027181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763552AbZAHWs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: introduce link_css_set() to remove duplicate code
has been removed from the -mm tree.  Its filename was
     cgroups-introduce-link_css_set-to-remove-duplicate-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/cgroup.c |   68 ++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff -puN kernel/cgroup.c~cgroups-introduce-link_css_set-to-remove-duplicate-code kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-introduce-link_css_set-to-remove-duplicate-code
+++ a/kernel/cgroup.c
@@ -384,6 +384,25 @@ static int allocate_cg_links(int count, 
 	return 0;
 }
 
+/**
+ * link_css_set - a helper function to link a css_set to a cgroup
+ * @tmp_cg_links: cg_cgroup_link objects allocated by allocate_cg_links()
+ * @cg: the css_set to be linked
+ * @cgrp: the destination cgroup
+ */
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
@@ -399,7 +418,6 @@ static struct css_set *find_css_set(
 	int i;
 
 	struct list_head tmp_cg_links;
-	struct cg_cgroup_link *link;
 
 	struct hlist_head *hhead;
 
@@ -444,26 +462,11 @@ static struct css_set *find_css_set(
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
 
@@ -988,7 +991,7 @@ static int cgroup_get_sb(struct file_sys
 		root = NULL;
 	} else {
 		/* New superblock */
-		struct cgroup *cgrp = &root->top_cgroup;
+		struct cgroup *root_cgrp = &root->top_cgroup;
 		struct inode *inode;
 		int i;
 
@@ -1029,7 +1032,7 @@ static int cgroup_get_sb(struct file_sys
 		list_add(&root->root_list, &roots);
 		root_count++;
 
-		sb->s_root->d_fsdata = &root->top_cgroup;
+		sb->s_root->d_fsdata = root_cgrp;
 		root->top_cgroup.dentry = sb->s_root;
 
 		/* Link the top cgroup in this hierarchy into all
@@ -1040,29 +1043,18 @@ static int cgroup_get_sb(struct file_sys
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

origin.patch
linux-next.patch


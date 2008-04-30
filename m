From: akpm@linux-foundation.org
Subject: - cgroups-remove-the-css_set-linked-list.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:50 -0700
Message-ID: <200804300542.m3U5goxg029177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758294AbYD3FoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: remove the css_set linked-list
has been removed from the -mm tree.  Its filename was
     cgroups-remove-the-css_set-linked-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: remove the css_set linked-list
From: Li Zefan <lizf@cn.fujitsu.com>

Now we can run through the hash table instead of running through the
linked-list.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    6 -----
 kernel/cgroup.c        |   40 +++++++++++++++++++--------------------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-remove-the-css_set-linked-list include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-remove-the-css_set-linked-list
+++ a/include/linux/cgroup.h
@@ -150,12 +150,6 @@ struct css_set {
 	struct kref ref;
 
 	/*
-	 * List running through all cgroup groups. Protected by
-	 * css_set_lock
-	 */
-	struct list_head list;
-
-	/*
 	 * List running through all cgroup groups in the same hash
 	 * slot. Protected by css_set_lock
 	 */
diff -puN kernel/cgroup.c~cgroups-remove-the-css_set-linked-list kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-remove-the-css_set-linked-list
+++ a/kernel/cgroup.c
@@ -242,7 +242,6 @@ static void unlink_css_set(struct css_se
 {
 	write_lock(&css_set_lock);
 	hlist_del(&cg->hlist);
-	list_del(&cg->list);
 	css_set_count--;
 	while (!list_empty(&cg->cg_links)) {
 		struct cg_cgroup_link *link;
@@ -477,8 +476,6 @@ static struct css_set *find_css_set(
 
 	BUG_ON(!list_empty(&tmp_cg_links));
 
-	/* Link this cgroup group into the list */
-	list_add(&res->list, &init_css_set.list);
 	css_set_count++;
 
 	/* Add this cgroup group to the hash table */
@@ -963,7 +960,7 @@ static int cgroup_get_sb(struct file_sys
 	int ret = 0;
 	struct super_block *sb;
 	struct cgroupfs_root *root;
-	struct list_head tmp_cg_links, *l;
+	struct list_head tmp_cg_links;
 	INIT_LIST_HEAD(&tmp_cg_links);
 
 	/* First find the desired set of subsystems */
@@ -1005,6 +1002,7 @@ static int cgroup_get_sb(struct file_sys
 		/* New superblock */
 		struct cgroup *cgrp = &root->top_cgroup;
 		struct inode *inode;
+		int i;
 
 		BUG_ON(sb->s_root != NULL);
 
@@ -1049,22 +1047,25 @@ static int cgroup_get_sb(struct file_sys
 		/* Link the top cgroup in this hierarchy into all
 		 * the css_set objects */
 		write_lock(&css_set_lock);
-		l = &init_css_set.list;
-		do {
+		for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
+			struct hlist_head *hhead = &css_set_table[i];
+			struct hlist_node *node;
 			struct css_set *cg;
-			struct cg_cgroup_link *link;
-			cg = list_entry(l, struct css_set, list);
-			BUG_ON(list_empty(&tmp_cg_links));
-			link = list_entry(tmp_cg_links.next,
-					  struct cg_cgroup_link,
-					  cgrp_link_list);
-			list_del(&link->cgrp_link_list);
-			link->cg = cg;
-			list_add(&link->cgrp_link_list,
-				 &root->top_cgroup.css_sets);
-			list_add(&link->cg_link_list, &cg->cg_links);
-			l = l->next;
-		} while (l != &init_css_set.list);
+
+			hlist_for_each_entry(cg, node, hhead, hlist) {
+				struct cg_cgroup_link *link;
+
+				BUG_ON(list_empty(&tmp_cg_links));
+				link = list_entry(tmp_cg_links.next,
+						  struct cg_cgroup_link,
+						  cgrp_link_list);
+				list_del(&link->cgrp_link_list);
+				link->cg = cg;
+				list_add(&link->cgrp_link_list,
+					 &root->top_cgroup.css_sets);
+				list_add(&link->cg_link_list, &cg->cg_links);
+			}
+		}
 		write_unlock(&css_set_lock);
 
 		free_cg_links(&tmp_cg_links);
@@ -2514,7 +2515,6 @@ int __init cgroup_init_early(void)
 	int i;
 	kref_init(&init_css_set.ref);
 	kref_get(&init_css_set.ref);
-	INIT_LIST_HEAD(&init_css_set.list);
 	INIT_LIST_HEAD(&init_css_set.cg_links);
 	INIT_LIST_HEAD(&init_css_set.tasks);
 	INIT_HLIST_NODE(&init_css_set.hlist);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-acpi.patch


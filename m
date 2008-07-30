From: akpm@linux-foundation.org
Subject: - cgroup-remove-duplicate-code-in-allocate_cg_link.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:08 -0700
Message-ID: <200807301914.m6UJE8XD010886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbYG3TdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: remove duplicate code in allocate_cg_link()
has been removed from the -mm tree.  Its filename was
     cgroup-remove-duplicate-code-in-allocate_cg_link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: remove duplicate code in allocate_cg_link()
From: Li Zefan <lizf@cn.fujitsu.com>

- just call free_cg_links() in allocate_cg_links()
- the list will get initialized in allocate_cg_links(), so don't init
  it twice

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN kernel/cgroup.c~cgroup-remove-duplicate-code-in-allocate_cg_link kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-duplicate-code-in-allocate_cg_link
+++ a/kernel/cgroup.c
@@ -355,6 +355,17 @@ static struct css_set *find_existing_css
 	return NULL;
 }
 
+static void free_cg_links(struct list_head *tmp)
+{
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
+
+	list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
+		list_del(&link->cgrp_link_list);
+		kfree(link);
+	}
+}
+
 /*
  * allocate_cg_links() allocates "count" cg_cgroup_link structures
  * and chains them on tmp through their cgrp_link_list fields. Returns 0 on
@@ -363,17 +374,12 @@ static struct css_set *find_existing_css
 static int allocate_cg_links(int count, struct list_head *tmp)
 {
 	struct cg_cgroup_link *link;
-	struct cg_cgroup_link *saved_link;
 	int i;
 	INIT_LIST_HEAD(tmp);
 	for (i = 0; i < count; i++) {
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link) {
-			list_for_each_entry_safe(link, saved_link, tmp,
-						 cgrp_link_list) {
-				list_del(&link->cgrp_link_list);
-				kfree(link);
-			}
+			free_cg_links(tmp);
 			return -ENOMEM;
 		}
 		list_add(&link->cgrp_link_list, tmp);
@@ -381,17 +387,6 @@ static int allocate_cg_links(int count, 
 	return 0;
 }
 
-static void free_cg_links(struct list_head *tmp)
-{
-	struct cg_cgroup_link *link;
-	struct cg_cgroup_link *saved_link;
-
-	list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
-		list_del(&link->cgrp_link_list);
-		kfree(link);
-	}
-}
-
 /*
  * find_css_set() takes an existing cgroup group and a
  * cgroup object, and returns a css_set object that's
@@ -956,7 +951,6 @@ static int cgroup_get_sb(struct file_sys
 	struct super_block *sb;
 	struct cgroupfs_root *root;
 	struct list_head tmp_cg_links;
-	INIT_LIST_HEAD(&tmp_cg_links);
 
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch


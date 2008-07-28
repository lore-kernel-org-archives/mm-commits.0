From: akpm@linux-foundation.org
Subject: + cgroup-remove-duplicate-code-in-allocate_cg_link.patch added to -mm tree
Date: Sun, 27 Jul 2008 20:24:07 -0700
Message-ID: <200807280324.m6S3O7Cx017787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYG1DZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroup: remove duplicate code in allocate_cg_link()
has been added to the -mm tree.  Its filename is
     cgroup-remove-duplicate-code-in-allocate_cg_link.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -354,6 +354,17 @@ static struct css_set *find_existing_css
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
@@ -362,17 +373,12 @@ static struct css_set *find_existing_css
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
@@ -380,17 +386,6 @@ static int allocate_cg_links(int count, 
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
@@ -955,7 +950,6 @@ static int cgroup_get_sb(struct file_sys
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
cgroup-fix-possible-memory-leak.patch
cgroup-remove-duplicate-code-in-allocate_cg_link.patch
cgroup-uninline-cgroup_has_css_refs.patch
memcg-remove-redundant-check-in-move_task.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch


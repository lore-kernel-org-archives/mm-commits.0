From: akpm@linux-foundation.org
Subject: + cgroup-list_for_each-cleanup-v2.patch added to -mm tree
Date: Wed, 04 Jun 2008 16:46:17 -0700
Message-ID: <200806042346.m54NkH3m015347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbYFDXqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 19:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: list_for_each cleanup
has been added to the -mm tree.  Its filename is
     cgroup-list_for_each-cleanup-v2.patch

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
Subject: cgroup: list_for_each cleanup
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

--------------------------
while() {
	list_entry();
	...
}
--------------------------

is equivalent to following code.

--------------------------
list_for_each_entry(){
	...
}
--------------------------

later can review easily more.

this patch is just clean up.
it doesn't have any behavor change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff -puN kernel/cgroup.c~cgroup-list_for_each-cleanup-v2 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-list_for_each-cleanup-v2
+++ a/kernel/cgroup.c
@@ -241,17 +241,20 @@ static int use_task_css_set_links;
  */
 static void unlink_css_set(struct css_set *cg)
 {
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
+
 	write_lock(&css_set_lock);
 	hlist_del(&cg->hlist);
 	css_set_count--;
-	while (!list_empty(&cg->cg_links)) {
-		struct cg_cgroup_link *link;
-		link = list_entry(cg->cg_links.next,
-				  struct cg_cgroup_link, cg_link_list);
+
+	list_for_each_entry_safe(link, saved_link, &cg->cg_links,
+				 cg_link_list) {
 		list_del(&link->cg_link_list);
 		list_del(&link->cgrp_link_list);
 		kfree(link);
 	}
+
 	write_unlock(&css_set_lock);
 }
 
@@ -363,15 +366,14 @@ static struct css_set *find_existing_css
 static int allocate_cg_links(int count, struct list_head *tmp)
 {
 	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
 	int i;
 	INIT_LIST_HEAD(tmp);
 	for (i = 0; i < count; i++) {
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link) {
-			while (!list_empty(tmp)) {
-				link = list_entry(tmp->next,
-						  struct cg_cgroup_link,
-						  cgrp_link_list);
+			list_for_each_entry_safe(link, saved_link, tmp,
+						 cgrp_link_list) {
 				list_del(&link->cgrp_link_list);
 				kfree(link);
 			}
@@ -384,11 +386,10 @@ static int allocate_cg_links(int count, 
 
 static void free_cg_links(struct list_head *tmp)
 {
-	while (!list_empty(tmp)) {
-		struct cg_cgroup_link *link;
-		link = list_entry(tmp->next,
-				  struct cg_cgroup_link,
-				  cgrp_link_list);
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
+
+	list_for_each_entry_safe(link, saved_link, tmp, cgrp_link_list) {
 		list_del(&link->cgrp_link_list);
 		kfree(link);
 	}
@@ -1093,6 +1094,8 @@ static void cgroup_kill_sb(struct super_
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	int ret;
+	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *saved_link;
 
 	BUG_ON(!root);
 
@@ -1112,10 +1115,9 @@ static void cgroup_kill_sb(struct super_
 	 * root cgroup
 	 */
 	write_lock(&css_set_lock);
-	while (!list_empty(&cgrp->css_sets)) {
-		struct cg_cgroup_link *link;
-		link = list_entry(cgrp->css_sets.next,
-				  struct cg_cgroup_link, cgrp_link_list);
+
+	list_for_each_entry_safe(link, saved_link, &cgrp->css_sets,
+				 cgrp_link_list) {
 		list_del(&link->cg_link_list);
 		list_del(&link->cgrp_link_list);
 		kfree(link);
@@ -1756,15 +1758,11 @@ int cgroup_add_files(struct cgroup *cgrp
 int cgroup_task_count(const struct cgroup *cgrp)
 {
 	int count = 0;
-	struct list_head *l;
+	struct cg_cgroup_link *link;
 
 	read_lock(&css_set_lock);
-	l = cgrp->css_sets.next;
-	while (l != &cgrp->css_sets) {
-		struct cg_cgroup_link *link =
-			list_entry(l, struct cg_cgroup_link, cgrp_link_list);
+	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
 		count += atomic_read(&link->cg->ref.refcount);
-		l = l->next;
 	}
 	read_unlock(&css_set_lock);
 	return count;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

hugetlb-fix-lockdep-error.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch


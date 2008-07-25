From: akpm@linux-foundation.org
Subject: - cgroup-list_for_each-cleanup-v2.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:05 -0700
Message-ID: <200807252258.m6PMw5Bx003256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbYGYW6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: list_for_each cleanup
has been removed from the -mm tree.  Its filename was
     cgroup-list_for_each-cleanup-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch


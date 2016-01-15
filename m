From: akpm@linux-foundation.org
Subject: [merged] mm-ksmc-use-list_for_each_entry_safe.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:34:22 -0800
Message-ID: <569973ee.d1UUsVyG7u7vEXZR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: use list_for_each_entry_safe
has been removed from the -mm tree.  Its filename was
     mm-ksmc-use-list_for_each_entry_safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/ksm.c: use list_for_each_entry_safe

Use list_for_each_entry_safe() instead of list_for_each_safe() to simplify
the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN mm/ksm.c~mm-ksmc-use-list_for_each_entry_safe mm/ksm.c
--- a/mm/ksm.c~mm-ksmc-use-list_for_each_entry_safe
+++ a/mm/ksm.c
@@ -740,8 +740,7 @@ static int remove_stable_node(struct sta
 
 static int remove_all_stable_nodes(void)
 {
-	struct stable_node *stable_node;
-	struct list_head *this, *next;
+	struct stable_node *stable_node, *next;
 	int nid;
 	int err = 0;
 
@@ -756,8 +755,7 @@ static int remove_all_stable_nodes(void)
 			cond_resched();
 		}
 	}
-	list_for_each_safe(this, next, &migrate_nodes) {
-		stable_node = list_entry(this, struct stable_node, list);
+	list_for_each_entry_safe(stable_node, next, &migrate_nodes, list) {
 		if (remove_stable_node(stable_node))
 			err = -EBUSY;
 		cond_resched();
@@ -1583,13 +1581,11 @@ static struct rmap_item *scan_get_next_r
 		 * so prune them once before each full scan.
 		 */
 		if (!ksm_merge_across_nodes) {
-			struct stable_node *stable_node;
-			struct list_head *this, *next;
+			struct stable_node *stable_node, *next;
 			struct page *page;
 
-			list_for_each_safe(this, next, &migrate_nodes) {
-				stable_node = list_entry(this,
-						struct stable_node, list);
+			list_for_each_entry_safe(stable_node, next,
+						 &migrate_nodes, list) {
 				page = get_ksm_page(stable_node, false);
 				if (page)
 					put_page(page);
@@ -2012,8 +2008,7 @@ static void wait_while_offlining(void)
 static void ksm_check_stable_tree(unsigned long start_pfn,
 				  unsigned long end_pfn)
 {
-	struct stable_node *stable_node;
-	struct list_head *this, *next;
+	struct stable_node *stable_node, *next;
 	struct rb_node *node;
 	int nid;
 
@@ -2034,8 +2029,7 @@ static void ksm_check_stable_tree(unsign
 			cond_resched();
 		}
 	}
-	list_for_each_safe(this, next, &migrate_nodes) {
-		stable_node = list_entry(this, struct stable_node, list);
+	list_for_each_entry_safe(stable_node, next, &migrate_nodes, list) {
 		if (stable_node->kpfn >= start_pfn &&
 		    stable_node->kpfn < end_pfn)
 			remove_node_from_stable_tree(stable_node);
_

Patches currently in -mm which might be from geliangtang@163.com are

mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch


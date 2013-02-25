From: akpm@linux-foundation.org
Subject: [merged] ksm-reorganize-ksm_check_stable_tree.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:53 -0800
Message-ID: <20130225205353.B812D5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:37967 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812Ab3BYUxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:55 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347313ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: reorganize ksm_check_stable_tree
has been removed from the -mm tree.  Its filename was
     ksm-reorganize-ksm_check_stable_tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: reorganize ksm_check_stable_tree

Memory hotremove's ksm_check_stable_tree() is pitifully inefficient
(restarting whenever it finds a stale node to remove), but rearrange so
that at least it does not needlessly restart from nid 0 each time.  And
add a couple of comments: here is why we keep pfn instead of page.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff -puN mm/ksm.c~ksm-reorganize-ksm_check_stable_tree mm/ksm.c
--- a/mm/ksm.c~ksm-reorganize-ksm_check_stable_tree
+++ a/mm/ksm.c
@@ -1830,31 +1830,36 @@ void ksm_migrate_page(struct page *newpa
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static struct stable_node *ksm_check_stable_tree(unsigned long start_pfn,
-						 unsigned long end_pfn)
+static void ksm_check_stable_tree(unsigned long start_pfn,
+				  unsigned long end_pfn)
 {
+	struct stable_node *stable_node;
 	struct rb_node *node;
 	int nid;
 
-	for (nid = 0; nid < nr_node_ids; nid++)
-		for (node = rb_first(&root_stable_tree[nid]); node;
-				node = rb_next(node)) {
-			struct stable_node *stable_node;
-
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		node = rb_first(&root_stable_tree[nid]);
+		while (node) {
 			stable_node = rb_entry(node, struct stable_node, node);
 			if (stable_node->kpfn >= start_pfn &&
-			    stable_node->kpfn < end_pfn)
-				return stable_node;
+			    stable_node->kpfn < end_pfn) {
+				/*
+				 * Don't get_ksm_page, page has already gone:
+				 * which is why we keep kpfn instead of page*
+				 */
+				remove_node_from_stable_tree(stable_node);
+				node = rb_first(&root_stable_tree[nid]);
+			} else
+				node = rb_next(node);
+			cond_resched();
 		}
-
-	return NULL;
+	}
 }
 
 static int ksm_memory_callback(struct notifier_block *self,
 			       unsigned long action, void *arg)
 {
 	struct memory_notify *mn = arg;
-	struct stable_node *stable_node;
 
 	switch (action) {
 	case MEM_GOING_OFFLINE:
@@ -1874,11 +1879,12 @@ static int ksm_memory_callback(struct no
 		/*
 		 * Most of the work is done by page migration; but there might
 		 * be a few stable_nodes left over, still pointing to struct
-		 * pages which have been offlined: prune those from the tree.
+		 * pages which have been offlined: prune those from the tree,
+		 * otherwise get_ksm_page() might later try to access a
+		 * non-existent struct page.
 		 */
-		while ((stable_node = ksm_check_stable_tree(mn->start_pfn,
-					mn->start_pfn + mn->nr_pages)) != NULL)
-			remove_node_from_stable_tree(stable_node);
+		ksm_check_stable_tree(mn->start_pfn,
+				      mn->start_pfn + mn->nr_pages);
 		/* fallthrough */
 
 	case MEM_CANCEL_OFFLINE:
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch


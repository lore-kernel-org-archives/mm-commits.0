From: akpm@linux-foundation.org
Subject: [merged] ksm-get_ksm_page-locked.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:56 -0800
Message-ID: <20130225205356.C17045A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:46387 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab3BYUx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:58 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159207yen.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: get_ksm_page locked
has been removed from the -mm tree.  Its filename was
     ksm-get_ksm_page-locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: get_ksm_page locked

In some places where get_ksm_page() is used, we need the page to be locked.

When KSM migration is fully enabled, we shall want that to make sure that
the page just acquired cannot be migrated beneath us (raised page count is
only effective when there is serialization to make sure migration
notices).  Whereas when navigating through the stable tree, we certainly
do not want to lock each node (raised page count is enough to guarantee
the memcmps, even if page is migrated to another node).

Since we're about to add another use case, add the locked argument to
get_ksm_page() now.

Hmm, what's that rcu_read_lock() about?  Complete misunderstanding, I
really got the wrong end of the stick on that!  There's a configuration in
which page_cache_get_speculative() can do something cheaper than
get_page_unless_zero(), relying on its caller's rcu_read_lock() to have
disabled preemption for it.  There's no need for rcu_read_lock() around
get_page_unless_zero() (and mapping checks) here.  Cut out that silliness
before making this any harder to understand.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/ksm.c~ksm-get_ksm_page-locked mm/ksm.c
--- a/mm/ksm.c~ksm-get_ksm_page-locked
+++ a/mm/ksm.c
@@ -514,15 +514,14 @@ static void remove_node_from_stable_tree
  * but this is different - made simpler by ksm_thread_mutex being held, but
  * interesting for assuming that no other use of the struct page could ever
  * put our expected_mapping into page->mapping (or a field of the union which
- * coincides with page->mapping).  The RCU calls are not for KSM at all, but
- * to keep the page_count protocol described with page_cache_get_speculative.
+ * coincides with page->mapping).
  *
  * Note: it is possible that get_ksm_page() will return NULL one moment,
  * then page the next, if the page is in between page_freeze_refs() and
  * page_unfreeze_refs(): this shouldn't be a problem anywhere, the page
  * is on its way to being freed; but it is an anomaly to bear in mind.
  */
-static struct page *get_ksm_page(struct stable_node *stable_node)
+static struct page *get_ksm_page(struct stable_node *stable_node, bool locked)
 {
 	struct page *page;
 	void *expected_mapping;
@@ -530,7 +529,6 @@ static struct page *get_ksm_page(struct 
 	page = pfn_to_page(stable_node->kpfn);
 	expected_mapping = (void *)stable_node +
 				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
-	rcu_read_lock();
 	if (page->mapping != expected_mapping)
 		goto stale;
 	if (!get_page_unless_zero(page))
@@ -539,10 +537,16 @@ static struct page *get_ksm_page(struct 
 		put_page(page);
 		goto stale;
 	}
-	rcu_read_unlock();
+	if (locked) {
+		lock_page(page);
+		if (page->mapping != expected_mapping) {
+			unlock_page(page);
+			put_page(page);
+			goto stale;
+		}
+	}
 	return page;
 stale:
-	rcu_read_unlock();
 	remove_node_from_stable_tree(stable_node);
 	return NULL;
 }
@@ -558,11 +562,10 @@ static void remove_rmap_item_from_tree(s
 		struct page *page;
 
 		stable_node = rmap_item->head;
-		page = get_ksm_page(stable_node);
+		page = get_ksm_page(stable_node, true);
 		if (!page)
 			goto out;
 
-		lock_page(page);
 		hlist_del(&rmap_item->hlist);
 		unlock_page(page);
 		put_page(page);
@@ -1042,7 +1045,7 @@ static struct page *stable_tree_search(s
 
 		cond_resched();
 		stable_node = rb_entry(node, struct stable_node, node);
-		tree_page = get_ksm_page(stable_node);
+		tree_page = get_ksm_page(stable_node, false);
 		if (!tree_page)
 			return NULL;
 
@@ -1086,7 +1089,7 @@ static struct stable_node *stable_tree_i
 
 		cond_resched();
 		stable_node = rb_entry(*new, struct stable_node, node);
-		tree_page = get_ksm_page(stable_node);
+		tree_page = get_ksm_page(stable_node, false);
 		if (!tree_page)
 			return NULL;
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch


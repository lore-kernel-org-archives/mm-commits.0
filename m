From: akpm@linux-foundation.org
Subject: + ksm-make-ksm-page-migration-possible.patch added to -mm tree
Date: Mon, 28 Jan 2013 15:50:51 -0800
Message-ID: <20130128235052.6714F31C1F2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42314 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3A1Xuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 18:50:54 -0500
Received: by mail-ob0-f202.google.com with SMTP id lz20so703658obb.3
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 15:50:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com


The patch titled
     Subject: ksm: make KSM page migration possible
has been added to the -mm tree.  Its filename is
     ksm-make-ksm-page-migration-possible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: make KSM page migration possible

KSM page migration is already supported in the case of memory hotremove,
which takes the ksm_thread_mutex across all its migrations to keep life
simple.

But the new KSM NUMA merge_across_nodes knob introduces a problem, when
it's set to non-default 0: if a KSM page is migrated to a different NUMA
node, how do we migrate its stable node to the right tree?  And what if
that collides with an existing stable node?

So far there's no provision for that, and this patch does not attempt to
deal with it either.  But how will I test a solution, when I don't know
how to hotremove memory?  The best answer is to enable KSM page migration
in all cases now, and test more common cases.  With THP and compaction
added since KSM came in, page migration is now mainstream, and it's a
shame that a KSM page can frustrate freeing a page block.

Without worrying about merge_across_nodes 0 for now, this patch gets KSM
page migration working reliably for default merge_across_nodes 1 (but
leave the patch enabling it until near the end of the series).

It's much simpler than I'd originally imagined, and does not require an
additional tier of locking: page migration relies on the page lock, KSM
page reclaim relies on the page lock, the page lock is enough for KSM page
migration too.

Almost all the care has to be in get_ksm_page(): that's the function which
worries about when a stable node is stale and should be freed, now it also
has to worry about the KSM page being migrated.

The only new overhead is an additional put/get/lock/unlock_page when
stable_tree_search() arrives at a matching node: to make sure migration
respects the raised page count, and so does not migrate the page while
we're busy with it here.  That's probably avoidable, either by changing
internal interfaces from using kpage to stable_node, or by moving the
ksm_migrate_page() callsite into a page_freeze_refs() section (even if not
swapcache); but this works well, I've no urge to pull it apart now.

(Descents of the stable tree may pass through nodes whose KSM pages are
under migration: being unlocked, the raised page count does not prevent
that, nor need it: it's safe to memcmp against either old or new page.)

You might worry about mremap, and whether page migration's rmap_walk to
remove migration entries will find all the KSM locations where it inserted
earlier: that should already be handled, by the satisfyingly heavy hammer
of move_vma()'s call to ksm_madvise(,,,MADV_UNMERGEABLE,).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c     |   94 ++++++++++++++++++++++++++++++++++++++-----------
 mm/migrate.c |    5 ++
 2 files changed, 77 insertions(+), 22 deletions(-)

diff -puN mm/ksm.c~ksm-make-ksm-page-migration-possible mm/ksm.c
--- a/mm/ksm.c~ksm-make-ksm-page-migration-possible
+++ a/mm/ksm.c
@@ -499,6 +499,7 @@ static void remove_node_from_stable_tree
  * In which case we can trust the content of the page, and it
  * returns the gotten page; but if the page has now been zapped,
  * remove the stale node from the stable tree and return NULL.
+ * But beware, the stable node's page might be being migrated.
  *
  * You would expect the stable_node to hold a reference to the ksm page.
  * But if it increments the page's count, swapping out has to wait for
@@ -509,44 +510,77 @@ static void remove_node_from_stable_tree
  * pointing back to this stable node.  This relies on freeing a PageAnon
  * page to reset its page->mapping to NULL, and relies on no other use of
  * a page to put something that might look like our key in page->mapping.
- *
- * include/linux/pagemap.h page_cache_get_speculative() is a good reference,
- * but this is different - made simpler by ksm_thread_mutex being held, but
- * interesting for assuming that no other use of the struct page could ever
- * put our expected_mapping into page->mapping (or a field of the union which
- * coincides with page->mapping).
- *
- * Note: it is possible that get_ksm_page() will return NULL one moment,
- * then page the next, if the page is in between page_freeze_refs() and
- * page_unfreeze_refs(): this shouldn't be a problem anywhere, the page
  * is on its way to being freed; but it is an anomaly to bear in mind.
  */
 static struct page *get_ksm_page(struct stable_node *stable_node, bool locked)
 {
 	struct page *page;
 	void *expected_mapping;
+	unsigned long kpfn;
 
-	page = pfn_to_page(stable_node->kpfn);
 	expected_mapping = (void *)stable_node +
 				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
-	if (page->mapping != expected_mapping)
-		goto stale;
-	if (!get_page_unless_zero(page))
+again:
+	kpfn = ACCESS_ONCE(stable_node->kpfn);
+	page = pfn_to_page(kpfn);
+
+	/*
+	 * page is computed from kpfn, so on most architectures reading
+	 * page->mapping is naturally ordered after reading node->kpfn,
+	 * but on Alpha we need to be more careful.
+	 */
+	smp_read_barrier_depends();
+	if (ACCESS_ONCE(page->mapping) != expected_mapping)
 		goto stale;
-	if (page->mapping != expected_mapping) {
+
+	/*
+	 * We cannot do anything with the page while its refcount is 0.
+	 * Usually 0 means free, or tail of a higher-order page: in which
+	 * case this node is no longer referenced, and should be freed;
+	 * however, it might mean that the page is under page_freeze_refs().
+	 * The __remove_mapping() case is easy, again the node is now stale;
+	 * but if page is swapcache in migrate_page_move_mapping(), it might
+	 * still be our page, in which case it's essential to keep the node.
+	 */
+	while (!get_page_unless_zero(page)) {
+		/*
+		 * Another check for page->mapping != expected_mapping would
+		 * work here too.  We have chosen the !PageSwapCache test to
+		 * optimize the common case, when the page is or is about to
+		 * be freed: PageSwapCache is cleared (under spin_lock_irq)
+		 * in the freeze_refs section of __remove_mapping(); but Anon
+		 * page->mapping reset to NULL later, in free_pages_prepare().
+		 */
+		if (!PageSwapCache(page))
+			goto stale;
+		cpu_relax();
+	}
+
+	if (ACCESS_ONCE(page->mapping) != expected_mapping) {
 		put_page(page);
 		goto stale;
 	}
+
 	if (locked) {
 		lock_page(page);
-		if (page->mapping != expected_mapping) {
+		if (ACCESS_ONCE(page->mapping) != expected_mapping) {
 			unlock_page(page);
 			put_page(page);
 			goto stale;
 		}
 	}
 	return page;
+
 stale:
+	/*
+	 * We come here from above when page->mapping or !PageSwapCache
+	 * suggests that the node is stale; but it might be under migration.
+	 * We need smp_rmb(), matching the smp_wmb() in ksm_migrate_page(),
+	 * before checking whether node->kpfn has been changed.
+	 */
+	smp_rmb();
+	if (ACCESS_ONCE(stable_node->kpfn) != kpfn)
+		goto again;
 	remove_node_from_stable_tree(stable_node);
 	return NULL;
 }
@@ -1103,15 +1137,25 @@ static struct page *stable_tree_search(s
 			return NULL;
 
 		ret = memcmp_pages(page, tree_page);
+		put_page(tree_page);
 
-		if (ret < 0) {
-			put_page(tree_page);
+		if (ret < 0)
 			node = node->rb_left;
-		} else if (ret > 0) {
-			put_page(tree_page);
+		else if (ret > 0)
 			node = node->rb_right;
-		} else
+		else {
+			/*
+			 * Lock and unlock the stable_node's page (which
+			 * might already have been migrated) so that page
+			 * migration is sure to notice its raised count.
+			 * It would be more elegant to return stable_node
+			 * than kpage, but that involves more changes.
+			 */
+			tree_page = get_ksm_page(stable_node, true);
+			if (tree_page)
+				unlock_page(tree_page);
 			return tree_page;
+		}
 	}
 
 	return NULL;
@@ -1903,6 +1947,14 @@ void ksm_migrate_page(struct page *newpa
 	if (stable_node) {
 		VM_BUG_ON(stable_node->kpfn != page_to_pfn(oldpage));
 		stable_node->kpfn = page_to_pfn(newpage);
+		/*
+		 * newpage->mapping was set in advance; now we need smp_wmb()
+		 * to make sure that the new stable_node->kpfn is visible
+		 * to get_ksm_page() before it can see that oldpage->mapping
+		 * has gone stale (or that PageSwapCache has been cleared).
+		 */
+		smp_wmb();
+		set_page_stable_node(oldpage, NULL);
 	}
 }
 #endif /* CONFIG_MIGRATION */
diff -puN mm/migrate.c~ksm-make-ksm-page-migration-possible mm/migrate.c
--- a/mm/migrate.c~ksm-make-ksm-page-migration-possible
+++ a/mm/migrate.c
@@ -464,7 +464,10 @@ void migrate_page_copy(struct page *newp
 
 	mlock_migrate_page(newpage, page);
 	ksm_migrate_page(newpage, page);
-
+	/*
+	 * Please do not reorder this without considering how mm/ksm.c's
+	 * get_ksm_page() depends upon ksm_migrate_page() and PageSwapCache().
+	 */
 	ClearPageSwapCache(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix-fix.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch


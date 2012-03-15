From: akpm@linux-foundation.org
Subject: + radix-tree-use-iterators-in-find_get_pages-functions.patch added to -mm tree
Date: Wed, 14 Mar 2012 17:44:37 -0700
Message-ID: <20120315004438.1293AA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60467 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031413Ab2COAol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 20:44:41 -0400
Received: by lbbgj3 with SMTP id gj3so56909lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 17:44:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hch@lst.de, hughd@google.com, torvalds@linux-foundation.org


The patch titled
     Subject: radix-tree: use iterators in find_get_pages* functions
has been added to the -mm tree.  Its filename is
     radix-tree-use-iterators-in-find_get_pages-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: radix-tree: use iterators in find_get_pages* functions

Replace radix_tree_gang_lookup_slot() and
radix_tree_gang_lookup_tag_slot() in page-cache lookup functions with
brand-new radix-tree direct iterating.  This avoids the double-scanning
and pointer copying.

Iterator don't stop after nr_pages page-get fails in a row, it continue
lookup till the radix-tree end.  Thus we can safely remove these restart
conditions.

Unfortunately, old implementation didn't forbid nr_pages == 0, this corner
case does not fit into new code, so the patch adds an extra check at the
beginning.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   86 +++++++++++++++++++++----------------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff -puN mm/filemap.c~radix-tree-use-iterators-in-find_get_pages-functions mm/filemap.c
--- a/mm/filemap.c~radix-tree-use-iterators-in-find_get_pages-functions
+++ a/mm/filemap.c
@@ -813,20 +813,19 @@ EXPORT_SYMBOL(find_or_create_page);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 			    unsigned int nr_pages, struct page **pages)
 {
-	unsigned int i;
-	unsigned int ret;
-	unsigned int nr_found, nr_skip;
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned ret = 0;
+
+	if (unlikely(!nr_pages))
+		return 0;
 
 	rcu_read_lock();
 restart:
-	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
-				(void ***)pages, NULL, start, nr_pages);
-	ret = 0;
-	nr_skip = 0;
-	for (i = 0; i < nr_found; i++) {
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		struct page *page;
 repeat:
-		page = radix_tree_deref_slot((void **)pages[i]);
+		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
 			continue;
 
@@ -837,7 +836,7 @@ repeat:
 				 * when entry at index 0 moves out of or back
 				 * to root: none yet gotten, safe to restart.
 				 */
-				WARN_ON(start | i);
+				WARN_ON(iter.index);
 				goto restart;
 			}
 			/*
@@ -845,7 +844,6 @@ repeat:
 			 * here as an exceptional entry: so skip over it -
 			 * we only reach this from invalidate_mapping_pages().
 			 */
-			nr_skip++;
 			continue;
 		}
 
@@ -853,21 +851,16 @@ repeat:
 			goto repeat;
 
 		/* Has the page moved? */
-		if (unlikely(page != *((void **)pages[i]))) {
+		if (unlikely(page != *slot)) {
 			page_cache_release(page);
 			goto repeat;
 		}
 
 		pages[ret] = page;
-		ret++;
+		if (++ret == nr_pages)
+			break;
 	}
 
-	/*
-	 * If all entries were removed before we could secure them,
-	 * try again, because callers stop trying once 0 is returned.
-	 */
-	if (unlikely(!ret && nr_found > nr_skip))
-		goto restart;
 	rcu_read_unlock();
 	return ret;
 }
@@ -887,21 +880,22 @@ repeat:
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t index,
 			       unsigned int nr_pages, struct page **pages)
 {
-	unsigned int i;
-	unsigned int ret;
-	unsigned int nr_found;
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned int ret = 0;
+
+	if (unlikely(!nr_pages))
+		return 0;
 
 	rcu_read_lock();
 restart:
-	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
-				(void ***)pages, NULL, index, nr_pages);
-	ret = 0;
-	for (i = 0; i < nr_found; i++) {
+	radix_tree_for_each_contig(slot, &mapping->page_tree, &iter, index) {
 		struct page *page;
 repeat:
-		page = radix_tree_deref_slot((void **)pages[i]);
+		page = radix_tree_deref_slot(slot);
+		/* The hole, there no reason to continue */
 		if (unlikely(!page))
-			continue;
+			break;
 
 		if (radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page)) {
@@ -924,7 +918,7 @@ repeat:
 			goto repeat;
 
 		/* Has the page moved? */
-		if (unlikely(page != *((void **)pages[i]))) {
+		if (unlikely(page != *slot)) {
 			page_cache_release(page);
 			goto repeat;
 		}
@@ -934,14 +928,14 @@ repeat:
 		 * otherwise we can get both false positives and false
 		 * negatives, which is just confusing to the caller.
 		 */
-		if (page->mapping == NULL || page->index != index) {
+		if (page->mapping == NULL || page->index != iter.index) {
 			page_cache_release(page);
 			break;
 		}
 
 		pages[ret] = page;
-		ret++;
-		index++;
+		if (++ret == nr_pages)
+			break;
 	}
 	rcu_read_unlock();
 	return ret;
@@ -962,19 +956,20 @@ EXPORT_SYMBOL(find_get_pages_contig);
 unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
 			int tag, unsigned int nr_pages, struct page **pages)
 {
-	unsigned int i;
-	unsigned int ret;
-	unsigned int nr_found;
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned ret = 0;
+
+	if (unlikely(!nr_pages))
+		return 0;
 
 	rcu_read_lock();
 restart:
-	nr_found = radix_tree_gang_lookup_tag_slot(&mapping->page_tree,
-				(void ***)pages, *index, nr_pages, tag);
-	ret = 0;
-	for (i = 0; i < nr_found; i++) {
+	radix_tree_for_each_tagged(slot, &mapping->page_tree,
+				   &iter, *index, tag) {
 		struct page *page;
 repeat:
-		page = radix_tree_deref_slot((void **)pages[i]);
+		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
 			continue;
 
@@ -998,21 +993,16 @@ repeat:
 			goto repeat;
 
 		/* Has the page moved? */
-		if (unlikely(page != *((void **)pages[i]))) {
+		if (unlikely(page != *slot)) {
 			page_cache_release(page);
 			goto repeat;
 		}
 
 		pages[ret] = page;
-		ret++;
+		if (++ret == nr_pages)
+			break;
 	}
 
-	/*
-	 * If all entries were removed before we could secure them,
-	 * try again, because callers stop trying once 0 is returned.
-	 */
-	if (unlikely(!ret && nr_found))
-		goto restart;
 	rcu_read_unlock();
 
 	if (ret)
_
Subject: Subject: radix-tree: use iterators in find_get_pages* functions

Patches currently in -mm which might be from khlebnikov@openvz.org are

memcg-free-mem_cgroup-by-rcu-to-fix-oops.patch
linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-replace-page_migration-with-is_enabledconfig_migration.patch
mm-drain-percpu-lru-add-rotate-page-vectors-on-cpu-hot-unplug.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-kill-dead-prev_priority-stubs.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-checkpatch-fixes.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch


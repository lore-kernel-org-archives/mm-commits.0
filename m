From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:07:26 -0800
Message-ID: <5a0ce4ce.qwUixQAU/3vm4hTU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755811AbdKPBH2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:07:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hannes@cmpxchg.org, mgorman@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, truncate: remove all exceptional entries from pagevec under one lock -fix
has been removed from the -mm tree.  Its filename was
     mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock-fix.patch

This patch was dropped because it was folded into mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm, truncate: remove all exceptional entries from pagevec under one lock -fix

Patch "mm, truncate: remove all exceptional entries from pagevec" had a
problem that truncate_exceptional_pvec_entries() didn't remove exceptional
entries that were beyond end of truncated range from the pagevec.  As a
result pagevec_release() oopsed trying to treat exceptional entry as a
page pointer.  This can be reproduced by running xfstests generic/269 in a
loop while applying memory pressure until the bug triggers.

Rip out fragile passing of index of the first exceptional entry in the
pagevec and scan the full pagevec instead.  Additional pagevec pass
doesn't have measurable overhead and the code is more robust that way.

This is a fix to the mmotm patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch

Link: http://lkml.kernel.org/r/20171108164226.26788-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/truncate.c~mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock-fix mm/truncate.c
--- a/mm/truncate.c~mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock-fix
+++ a/mm/truncate.c
@@ -59,24 +59,29 @@ static void clear_shadow_entry(struct ad
  * exceptional entries similar to what pagevec_remove_exceptionals does.
  */
 static void truncate_exceptional_pvec_entries(struct address_space *mapping,
-				struct pagevec *pvec, pgoff_t *indices, int ei)
+				struct pagevec *pvec, pgoff_t *indices,
+				pgoff_t end)
 {
 	int i, j;
-	bool dax;
-
-	/* Return immediately if caller indicates there are no entries */
-	if (ei == PAGEVEC_SIZE)
-		return;
+	bool dax, lock;
 
 	/* Handled by shmem itself */
 	if (shmem_mapping(mapping))
 		return;
 
+	for (j = 0; j < pagevec_count(pvec); j++)
+		if (radix_tree_exceptional_entry(pvec->pages[j]))
+			break;
+
+	if (j == pagevec_count(pvec))
+		return;
+
 	dax = dax_mapping(mapping);
-	if (!dax)
+	lock = !dax && indices[j] < end;
+	if (lock)
 		spin_lock_irq(&mapping->tree_lock);
 
-	for (i = ei, j = ei; i < pagevec_count(pvec); i++) {
+	for (i = j; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 		pgoff_t index = indices[i];
 
@@ -85,6 +90,9 @@ static void truncate_exceptional_pvec_en
 			continue;
 		}
 
+		if (index >= end)
+			continue;
+
 		if (unlikely(dax)) {
 			dax_delete_mapping_entry(mapping, index);
 			continue;
@@ -93,7 +101,7 @@ static void truncate_exceptional_pvec_en
 		__clear_shadow_entry(mapping, index, page);
 	}
 
-	if (!dax)
+	if (lock)
 		spin_unlock_irq(&mapping->tree_lock);
 	pvec->nr = j;
 }
@@ -333,7 +341,6 @@ void truncate_inode_pages_range(struct a
 		 * in a new pagevec.
 		 */
 		struct pagevec locked_pvec;
-		int ei = PAGEVEC_SIZE;
 
 		pagevec_init(&locked_pvec, 0);
 		for (i = 0; i < pagevec_count(&pvec); i++) {
@@ -344,11 +351,8 @@ void truncate_inode_pages_range(struct a
 			if (index >= end)
 				break;
 
-			if (radix_tree_exceptional_entry(page)) {
-				if (ei == PAGEVEC_SIZE)
-					ei = i;
+			if (radix_tree_exceptional_entry(page))
 				continue;
-			}
 
 			if (!trylock_page(page))
 				continue;
@@ -368,7 +372,7 @@ void truncate_inode_pages_range(struct a
 		delete_from_page_cache_batch(mapping, &locked_pvec);
 		for (i = 0; i < pagevec_count(&locked_pvec); i++)
 			unlock_page(locked_pvec.pages[i]);
-		truncate_exceptional_pvec_entries(mapping, &pvec, indices, ei);
+		truncate_exceptional_pvec_entries(mapping, &pvec, indices, end);
 		pagevec_release(&pvec);
 		cond_resched();
 		index++;
@@ -414,8 +418,6 @@ void truncate_inode_pages_range(struct a
 
 	index = start;
 	for ( ; ; ) {
-		int ei = PAGEVEC_SIZE;
-
 		cond_resched();
 		if (!pagevec_lookup_entries(&pvec, mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE), indices)) {
@@ -444,11 +446,8 @@ void truncate_inode_pages_range(struct a
 				break;
 			}
 
-			if (radix_tree_exceptional_entry(page)) {
-				if (ei == PAGEVEC_SIZE)
-					ei = i;
+			if (radix_tree_exceptional_entry(page))
 				continue;
-			}
 
 			lock_page(page);
 			WARN_ON(page_to_index(page) != index);
@@ -456,7 +455,7 @@ void truncate_inode_pages_range(struct a
 			truncate_inode_page(mapping, page);
 			unlock_page(page);
 		}
-		truncate_exceptional_pvec_entries(mapping, &pvec, indices, ei);
+		truncate_exceptional_pvec_entries(mapping, &pvec, indices, end);
 		pagevec_release(&pvec);
 		index++;
 	}
_

Patches currently in -mm which might be from jack@suse.cz are

mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch
mm-speedup-cancel_dirty_page-for-clean-pages.patch
mm-refactor-truncate_complete_page.patch
mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch
mm-move-accounting-updates-before-page_cache_tree_delete.patch
mm-move-clearing-of-page-mapping-to-page_cache_tree_delete.patch
mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch
mm-batch-radix-tree-operations-when-truncating-pages.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch


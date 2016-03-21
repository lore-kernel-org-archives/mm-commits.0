From: akpm@linux-foundation.org
Subject: [merged] mm-use-radix_tree_iter_retry.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:52 -0700
Message-ID: <56f04070.h93Obvv9QnVVfCPi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbcCUTVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hughd@google.com, khlebnikov@openvz.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use radix_tree_iter_retry()
has been removed from the -mm tree.  Its filename was
     mm-use-radix_tree_iter_retry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm: use radix_tree_iter_retry()

Instead of a 'goto restart', we can now use radix_tree_iter_retry() to
restart from our current position.  This will make a difference when there
are more ways to happen across an indirect pointer.  And it eliminates
some confusing gotos.

[vbabka@suse.cz: remove now-obsolete-and-misleading comment]
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   53 +++++++++++++++----------------------------------
 mm/shmem.c   |   23 +++++++++++----------
 2 files changed, 29 insertions(+), 47 deletions(-)

diff -puN mm/filemap.c~mm-use-radix_tree_iter_retry mm/filemap.c
--- a/mm/filemap.c~mm-use-radix_tree_iter_retry
+++ a/mm/filemap.c
@@ -1255,7 +1255,6 @@ unsigned find_get_entries(struct address
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		struct page *page;
 repeat:
@@ -1263,8 +1262,10 @@ repeat:
 		if (unlikely(!page))
 			continue;
 		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page))
-				goto restart;
+			if (radix_tree_deref_retry(page)) {
+				slot = radix_tree_iter_retry(&iter);
+				continue;
+			}
 			/*
 			 * A shadow entry of a recently evicted page, a swap
 			 * entry from shmem/tmpfs or a DAX entry.  Return it
@@ -1317,7 +1318,6 @@ unsigned find_get_pages(struct address_s
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		struct page *page;
 repeat:
@@ -1327,13 +1327,8 @@ repeat:
 
 		if (radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page)) {
-				/*
-				 * Transient condition which can only trigger
-				 * when entry at index 0 moves out of or back
-				 * to root: none yet gotten, safe to restart.
-				 */
-				WARN_ON(iter.index);
-				goto restart;
+				slot = radix_tree_iter_retry(&iter);
+				continue;
 			}
 			/*
 			 * A shadow entry of a recently evicted page,
@@ -1384,7 +1379,6 @@ unsigned find_get_pages_contig(struct ad
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_contig(slot, &mapping->page_tree, &iter, index) {
 		struct page *page;
 repeat:
@@ -1395,12 +1389,8 @@ repeat:
 
 		if (radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page)) {
-				/*
-				 * Transient condition which can only trigger
-				 * when entry at index 0 moves out of or back
-				 * to root: none yet gotten, safe to restart.
-				 */
-				goto restart;
+				slot = radix_tree_iter_retry(&iter);
+				continue;
 			}
 			/*
 			 * A shadow entry of a recently evicted page,
@@ -1460,7 +1450,6 @@ unsigned find_get_pages_tag(struct addre
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
 				   &iter, *index, tag) {
 		struct page *page;
@@ -1471,12 +1460,8 @@ repeat:
 
 		if (radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page)) {
-				/*
-				 * Transient condition which can only trigger
-				 * when entry at index 0 moves out of or back
-				 * to root: none yet gotten, safe to restart.
-				 */
-				goto restart;
+				slot = radix_tree_iter_retry(&iter);
+				continue;
 			}
 			/*
 			 * A shadow entry of a recently evicted page.
@@ -1539,7 +1524,6 @@ unsigned find_get_entries_tag(struct add
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
 				   &iter, start, tag) {
 		struct page *page;
@@ -1549,12 +1533,8 @@ repeat:
 			continue;
 		if (radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page)) {
-				/*
-				 * Transient condition which can only trigger
-				 * when entry at index 0 moves out of or back
-				 * to root: none yet gotten, safe to restart.
-				 */
-				goto restart;
+				slot = radix_tree_iter_retry(&iter);
+				continue;
 			}
 
 			/*
@@ -2171,10 +2151,11 @@ repeat:
 		if (unlikely(!page))
 			goto next;
 		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page))
-				break;
-			else
-				goto next;
+			if (radix_tree_deref_retry(page)) {
+				slot = radix_tree_iter_retry(&iter);
+				continue;
+			}
+			goto next;
 		}
 
 		if (!page_cache_get_speculative(page))
diff -puN mm/shmem.c~mm-use-radix_tree_iter_retry mm/shmem.c
--- a/mm/shmem.c~mm-use-radix_tree_iter_retry
+++ a/mm/shmem.c
@@ -383,13 +383,10 @@ restart:
 
 		page = radix_tree_deref_slot(slot);
 
-		/*
-		 * This should only be possible to happen at index 0, so we
-		 * don't need to reset the counter, nor do we risk infinite
-		 * restarts.
-		 */
-		if (radix_tree_deref_retry(page))
-			goto restart;
+		if (radix_tree_deref_retry(page)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
 
 		if (radix_tree_exceptional_entry(page))
 			swapped++;
@@ -1951,8 +1948,10 @@ restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		page = radix_tree_deref_slot(slot);
 		if (!page || radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page))
-				goto restart;
+			if (radix_tree_deref_retry(page)) {
+				slot = radix_tree_iter_retry(&iter);
+				continue;
+			}
 		} else if (page_count(page) - page_mapcount(page) > 1) {
 			spin_lock_irq(&mapping->tree_lock);
 			radix_tree_tag_set(&mapping->page_tree, iter.index,
@@ -2006,8 +2005,10 @@ restart:
 
 			page = radix_tree_deref_slot(slot);
 			if (radix_tree_exception(page)) {
-				if (radix_tree_deref_retry(page))
-					goto restart;
+				if (radix_tree_deref_retry(page)) {
+					slot = radix_tree_iter_retry(&iter);
+					continue;
+				}
 
 				page = NULL;
 			}
_

Patches currently in -mm which might be from willy@linux.intel.com are



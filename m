From: akpm@linux-foundation.org
Subject: + mm-use-radix_tree_iter_retry.patch added to -mm tree
Date: Wed, 27 Jan 2016 13:37:47 -0800
Message-ID: <56a938ab.VB0ZtpJyCElEplua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968305AbcA0Vhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 16:37:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hughd@google.com, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use radix_tree_iter_retry()
has been added to the -mm tree.  Its filename is
     mm-use-radix_tree_iter_retry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-radix_tree_iter_retry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-radix_tree_iter_retry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm: use radix_tree_iter_retry()

Instead of a 'goto restart', we can now use radix_tree_iter_retry() to
restart from our current position.  This will make a difference when there
are more ways to happen across an indirect pointer.  And it eliminates
some confusing gotos.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   53 +++++++++++++++----------------------------------
 mm/shmem.c   |   18 +++++++++++-----
 2 files changed, 29 insertions(+), 42 deletions(-)

diff -puN mm/filemap.c~mm-use-radix_tree_iter_retry mm/filemap.c
--- a/mm/filemap.c~mm-use-radix_tree_iter_retry
+++ a/mm/filemap.c
@@ -1245,7 +1245,6 @@ unsigned find_get_entries(struct address
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		struct page *page;
 repeat:
@@ -1253,8 +1252,10 @@ repeat:
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
@@ -1307,7 +1308,6 @@ unsigned find_get_pages(struct address_s
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		struct page *page;
 repeat:
@@ -1317,13 +1317,8 @@ repeat:
 
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
@@ -1374,7 +1369,6 @@ unsigned find_get_pages_contig(struct ad
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_contig(slot, &mapping->page_tree, &iter, index) {
 		struct page *page;
 repeat:
@@ -1385,12 +1379,8 @@ repeat:
 
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
@@ -1450,7 +1440,6 @@ unsigned find_get_pages_tag(struct addre
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
 				   &iter, *index, tag) {
 		struct page *page;
@@ -1461,12 +1450,8 @@ repeat:
 
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
@@ -1529,7 +1514,6 @@ unsigned find_get_entries_tag(struct add
 		return 0;
 
 	rcu_read_lock();
-restart:
 	radix_tree_for_each_tagged(slot, &mapping->page_tree,
 				   &iter, start, tag) {
 		struct page *page;
@@ -1539,12 +1523,8 @@ repeat:
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
@@ -2160,10 +2140,11 @@ repeat:
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
@@ -388,8 +388,10 @@ restart:
 		 * don't need to reset the counter, nor do we risk infinite
 		 * restarts.
 		 */
-		if (radix_tree_deref_retry(page))
-			goto restart;
+		if (radix_tree_deref_retry(page)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
 
 		if (radix_tree_exceptional_entry(page))
 			swapped++;
@@ -1951,8 +1953,10 @@ restart:
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
@@ -2006,8 +2010,10 @@ restart:
 
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

radix-tree-fix-race-in-gang-lookup.patch
hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch
btrfs-use-radix_tree_iter_retry.patch
mm-use-radix_tree_iter_retry.patch
radix-treeshmem-introduce-radix_tree_iter_next.patch


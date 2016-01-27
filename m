From: akpm@linux-foundation.org
Subject: + radix-treeshmem-introduce-radix_tree_iter_next.patch added to
 -mm tree
Date: Wed, 27 Jan 2016 13:37:49 -0800
Message-ID: <56a938ad.O8xOptx9rM4fmjEo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968361AbcA0Vhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 16:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hughd@google.com, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree,shmem: introduce radix_tree_iter_next()
has been added to the -mm tree.  Its filename is
     radix-treeshmem-introduce-radix_tree_iter_next.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-treeshmem-introduce-radix_tree_iter_next.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-treeshmem-introduce-radix_tree_iter_next.patch

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
Subject: radix-tree,shmem: introduce radix_tree_iter_next()

shmem likes to occasionally drop the lock, schedule, then reacqire the
lock and continue with the iteration from the last place it left off. 
This is currently done with a pretty ugly goto.  Introduce
radix_tree_iter_next() and use it throughout shmem.c.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   15 +++++++++++++++
 mm/shmem.c                 |   12 +++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff -puN include/linux/radix-tree.h~radix-treeshmem-introduce-radix_tree_iter_next include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-treeshmem-introduce-radix_tree_iter_next
+++ a/include/linux/radix-tree.h
@@ -403,6 +403,21 @@ void **radix_tree_iter_retry(struct radi
 }
 
 /**
+ * radix_tree_iter_next - resume iterating when the chunk may be invalid
+ * @iter:	iterator state
+ *
+ * If the iterator needs to release then reacquire a lock, the chunk may
+ * have been invalidated by an insertion or deletion.  Call this function
+ * to continue the iteration from the next index.
+ */
+static inline __must_check
+void **radix_tree_iter_next(struct radix_tree_iter *iter)
+{
+	iter->next_index = iter->index + 1;
+	return NULL;
+}
+
+/**
  * radix_tree_chunk_size - get current chunk size
  *
  * @iter:	pointer to radix tree iterator
diff -puN mm/shmem.c~radix-treeshmem-introduce-radix_tree_iter_next mm/shmem.c
--- a/mm/shmem.c~radix-treeshmem-introduce-radix_tree_iter_next
+++ a/mm/shmem.c
@@ -376,7 +376,6 @@ unsigned long shmem_partial_swap_usage(s
 
 	rcu_read_lock();
 
-restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		if (iter.index >= end)
 			break;
@@ -398,8 +397,7 @@ restart:
 
 		if (need_resched()) {
 			cond_resched_rcu();
-			start = iter.index + 1;
-			goto restart;
+			slot = radix_tree_iter_next(&iter);
 		}
 	}
 
@@ -1949,7 +1947,6 @@ static void shmem_tag_pins(struct addres
 	start = 0;
 	rcu_read_lock();
 
-restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		page = radix_tree_deref_slot(slot);
 		if (!page || radix_tree_exception(page)) {
@@ -1966,8 +1963,7 @@ restart:
 
 		if (need_resched()) {
 			cond_resched_rcu();
-			start = iter.index + 1;
-			goto restart;
+			slot = radix_tree_iter_next(&iter);
 		}
 	}
 	rcu_read_unlock();
@@ -2004,7 +2000,6 @@ static int shmem_wait_for_pins(struct ad
 
 		start = 0;
 		rcu_read_lock();
-restart:
 		radix_tree_for_each_tagged(slot, &mapping->page_tree, &iter,
 					   start, SHMEM_TAG_PINNED) {
 
@@ -2038,8 +2033,7 @@ restart:
 continue_resched:
 			if (need_resched()) {
 				cond_resched_rcu();
-				start = iter.index + 1;
-				goto restart;
+				slot = radix_tree_iter_next(&iter);
 			}
 		}
 		rcu_read_unlock();
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


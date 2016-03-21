From: akpm@linux-foundation.org
Subject: [merged] radix-treeshmem-introduce-radix_tree_iter_next.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:55 -0700
Message-ID: <56f04073.07T9aS6FMRudSlLF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbcCUTVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hughd@google.com, koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree,shmem: introduce radix_tree_iter_next()
has been removed from the -mm tree.  Its filename was
     radix-treeshmem-introduce-radix_tree_iter_next.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree,shmem: introduce radix_tree_iter_next()

shmem likes to occasionally drop the lock, schedule, then reacqire the
lock and continue with the iteration from the last place it left off. 
This is currently done with a pretty ugly goto.  Introduce
radix_tree_iter_next() and use it throughout shmem.c.

[koct9i@gmail.com: fix bug in radix_tree_iter_next() for tagged iteration]
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   16 ++++++++++++++++
 mm/shmem.c                 |   12 +++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff -puN include/linux/radix-tree.h~radix-treeshmem-introduce-radix_tree_iter_next include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-treeshmem-introduce-radix_tree_iter_next
+++ a/include/linux/radix-tree.h
@@ -403,6 +403,22 @@ void **radix_tree_iter_retry(struct radi
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
+	iter->tags = 0;
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
@@ -393,8 +392,7 @@ restart:
 
 		if (need_resched()) {
 			cond_resched_rcu();
-			start = iter.index + 1;
-			goto restart;
+			slot = radix_tree_iter_next(&iter);
 		}
 	}
 
@@ -1944,7 +1942,6 @@ static void shmem_tag_pins(struct addres
 	start = 0;
 	rcu_read_lock();
 
-restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		page = radix_tree_deref_slot(slot);
 		if (!page || radix_tree_exception(page)) {
@@ -1961,8 +1958,7 @@ restart:
 
 		if (need_resched()) {
 			cond_resched_rcu();
-			start = iter.index + 1;
-			goto restart;
+			slot = radix_tree_iter_next(&iter);
 		}
 	}
 	rcu_read_unlock();
@@ -1999,7 +1995,6 @@ static int shmem_wait_for_pins(struct ad
 
 		start = 0;
 		rcu_read_lock();
-restart:
 		radix_tree_for_each_tagged(slot, &mapping->page_tree, &iter,
 					   start, SHMEM_TAG_PINNED) {
 
@@ -2033,8 +2028,7 @@ restart:
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



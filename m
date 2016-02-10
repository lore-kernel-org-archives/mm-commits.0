From: akpm@linux-foundation.org
Subject: [merged] radix-tree-fix-oops-after-radix_tree_iter_retry.patch
 removed from -mm tree
Date: Wed, 10 Feb 2016 11:36:07 -0800
Message-ID: <56bb9127.jHmYj1XNnN7yA0bK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbcBJTgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:36:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, jmmahler@gmail.com, ohad@wizery.com, stable@vger.kernel.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix oops after radix_tree_iter_retry
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-oops-after-radix_tree_iter_retry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: radix-tree: fix oops after radix_tree_iter_retry

Helper radix_tree_iter_retry() resets next_index to the current index.  In
following radix_tree_next_slot current chunk size becomes zero.  This
isn't checked and it tries to dereference null pointer in slot.

Tagged iterator is fine because retry happens only at slot 0 where tag
bitmask in iter->tags is filled with single bit.

Fixes: 46437f9a554f ("radix-tree: fix race in gang lookup")
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-fix-oops-after-radix_tree_iter_retry include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-fix-oops-after-radix_tree_iter_retry
+++ a/include/linux/radix-tree.h
@@ -400,7 +400,7 @@ void **radix_tree_iter_retry(struct radi
  * @iter:	pointer to radix tree iterator
  * Returns:	current chunk size
  */
-static __always_inline unsigned
+static __always_inline long
 radix_tree_chunk_size(struct radix_tree_iter *iter)
 {
 	return iter->next_index - iter->index;
@@ -434,9 +434,9 @@ radix_tree_next_slot(void **slot, struct
 			return slot + offset + 1;
 		}
 	} else {
-		unsigned size = radix_tree_chunk_size(iter) - 1;
+		long size = radix_tree_chunk_size(iter);
 
-		while (size--) {
+		while (--size > 0) {
 			slot++;
 			iter->index++;
 			if (likely(*slot))
_

Patches currently in -mm which might be from koct9i@gmail.com are

tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch
radix-tree-tests-add-regression3-test.patch


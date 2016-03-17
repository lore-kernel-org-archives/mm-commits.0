From: akpm@linux-foundation.org
Subject: [folded-merged]
 radix-treeshmem-introduce-radix_tree_iter_next-fix.patch removed from -mm
 tree
Date: Thu, 17 Mar 2016 14:01:54 -0700
Message-ID: <56eb1b42.y1+bQIBNVhmAKQyM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030437AbcCQVBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix bug in radix_tree_iter_next() for tagged iteration
has been removed from the -mm tree.  Its filename was
     radix-treeshmem-introduce-radix_tree_iter_next-fix.patch

This patch was dropped because it was folded into radix-treeshmem-introduce-radix_tree_iter_next.patch

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: radix-tree: fix bug in radix_tree_iter_next() for tagged iteration

Helper radix_tree_iter_next reset slot to NULL and next_index to index +
1, for tagger iteraction it also must reset cached tags in iterator to
abort next radix_tree_next_slot and go to slow-path into
radix_tree_next_chunk.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/radix-tree.h~radix-treeshmem-introduce-radix_tree_iter_next-fix include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-treeshmem-introduce-radix_tree_iter_next-fix
+++ a/include/linux/radix-tree.h
@@ -414,6 +414,7 @@ static inline __must_check
 void **radix_tree_iter_next(struct radix_tree_iter *iter)
 {
 	iter->next_index = iter->index + 1;
+	iter->tags = 0;
 	return NULL;
 }
 
_

Patches currently in -mm which might be from koct9i@gmail.com are

tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch
radix-treeshmem-introduce-radix_tree_iter_next.patch
radix-tree-tests-add-regression3-test.patch
radix-tree-tests-add-test-for-radix_tree_iter_next.patch


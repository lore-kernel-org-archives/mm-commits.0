From: akpm@linux-foundation.org
Subject: + radix-treeshmem-introduce-radix_tree_iter_next-fix.patch added
 to -mm tree
Date: Tue, 01 Mar 2016 13:07:42 -0800
Message-ID: <56d6049e.zgjDiPFE6hLLxmDm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbcCAVHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 16:07:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix bug in radix_tree_iter_next() for tagged iteration
has been added to the -mm tree.  Its filename is
     radix-treeshmem-introduce-radix_tree_iter_next-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-treeshmem-introduce-radix_tree_iter_next-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-treeshmem-introduce-radix_tree_iter_next-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
radix-treeshmem-introduce-radix_tree_iter_next-fix.patch
radix-tree-tests-fix-compilation.patch
radix-tree-tests-add-test-for-radix_tree_iter_next.patch
radix-tree-tests-add-regression3-test.patch


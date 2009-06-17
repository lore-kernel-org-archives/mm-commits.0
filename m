From: akpm@linux-foundation.org
Subject: [merged] readahead-remove-one-unnecessary-radix-tree-lookup.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:36 -0700
Message-ID: <200906171832.n5HIWam1031131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759717AbZFQScq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, xcf@ustc.edu.cn, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     readahead: remove one unnecessary radix tree lookup
has been removed from the -mm tree.  Its filename was
     readahead-remove-one-unnecessary-radix-tree-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: remove one unnecessary radix tree lookup
From: Wu Fengguang <fengguang.wu@intel.com>

(hit_readahead_marker != 0) means the page at @offset is present, so we
can search for non-present page starting from @offset+1.

Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/readahead.c~readahead-remove-one-unnecessary-radix-tree-lookup mm/readahead.c
--- a/mm/readahead.c~readahead-remove-one-unnecessary-radix-tree-lookup
+++ a/mm/readahead.c
@@ -395,7 +395,7 @@ ondemand_readahead(struct address_space 
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = radix_tree_next_hole(&mapping->page_tree, offset,max+1);
+		start = radix_tree_next_hole(&mapping->page_tree, offset+1,max);
 		rcu_read_unlock();
 
 		if (!start || start - offset > max)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch


From: akpm@linux-foundation.org
Subject: + mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
 added to -mm tree
Date: Fri, 27 Feb 2015 13:23:05 -0800
Message-ID: <54f0e039.MmSymlQRAkSfg5yY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbbB0VXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:23:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempolicy: migrate_to_node should only migrate to node
has been added to the -mm tree.  Its filename is
     mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: migrate_to_node should only migrate to node

migrate_to_node() is intended to migrate a page from one source node to a
target node.

Today, migrate_to_node() could end up migrating to any node, not only the
target node.  This is because the page migration allocator,
new_node_page() does not pass __GFP_THISNODE to alloc_pages_exact_node(). 
This causes the target node to be preferred but allows fallback to any
other node in order of affinity.

Prevent this by allocating with __GFP_THISNODE.  If memory is not
available, -ENOMEM will be returned as appropriate.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicy-migrate_to_node-should-only-migrate-to-node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-migrate_to_node-should-only-migrate-to-node
+++ a/mm/mempolicy.c
@@ -945,7 +945,8 @@ static struct page *new_node_page(struct
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					node);
 	else
-		return alloc_pages_exact_node(node, GFP_HIGHUSER_MOVABLE, 0);
+		return alloc_pages_exact_node(node, GFP_HIGHUSER_MOVABLE |
+						    __GFP_THISNODE, 0);
 }
 
 /*
_

Patches currently in -mm which might be from rientjes@google.com are

mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-utilc-add-kstrimdup.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
 removed from -mm tree
Date: Thu, 03 Apr 2014 14:04:59 -0700
Message-ID: <533dccfb.Jw8M352AdnwkajSK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaDCVE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, hughd@google.com, hannes@cmpxchg.org

Subject: [folded-merged] mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch removed from -mm tree
To: hannes@cmpxchg.org,hughd@google.com,minchan@kernel.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:04:59 -0700


The patch titled
     Subject: mm + fs: prepare for non-page entries in page cache radix trees fix
has been removed from the -mm tree.  Its filename was
     mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch

This patch was dropped because it was folded into mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm + fs: prepare for non-page entries in page cache radix trees fix

__pagevec_lookup() stores exceptional entries in the pagevec.  They must
be pruned before passing the pagevec along to pagevec_release() or the
kernel crashes when these non-page pointers reach the page allocator.

Add a missing pagevec_remove_exceptionals() in the truncate path.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix mm/truncate.c
--- a/mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix
+++ a/mm/truncate.c
@@ -340,6 +340,7 @@ void truncate_inode_pages_range(struct a
 			continue;
 		}
 		if (index == start && indices[0] >= end) {
+			pagevec_remove_exceptionals(&pvec);
 			pagevec_release(&pvec);
 			break;
 		}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
lib-radix_tree-tree-node-interface-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch


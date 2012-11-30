From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-fix-return-value-of-capture_free_page.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:56 -0800
Message-ID: <20121130212856.9CCFA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55005 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2K3V26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:58 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1990593vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix return value of capture_free_page()
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-return-value-of-capture_free_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: fix return value of capture_free_page()

Commit ef6c5be6 ("fix incorrect NR_FREE_PAGES accounting (appears like
memory leak)") fixes a NR_FREE_PAGE accounting leak but missed the return
value which was also missed by this reviewer until today.  That return
value is used by compaction when adding pages to a list of isolated free
pages and without this follow-up fix, there is a risk of free list
corruption.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-compaction-fix-return-value-of-capture_free_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-fix-return-value-of-capture_free_page
+++ a/mm/page_alloc.c
@@ -1422,7 +1422,7 @@ int capture_free_page(struct page *page,
 		}
 	}
 
-	return 1UL << order;
+	return 1UL << alloc_order;
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-memmap_init_zone-performance-improvement.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
mm-compaction-fix-compiler-warning.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch


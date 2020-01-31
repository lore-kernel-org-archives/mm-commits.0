From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:18:59 -0800
Message-ID: <20200131231859.SkObShycq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXTA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/huge_memory.c: reduce critical section protected by split_queue_lock
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/huge_memory.c: reduce critical section protected by split_queue_lock

split_queue_lock protects data in struct deferred_split.  We can release
the lock after delete the page from deferred_split_queue.

This patch moves the THP accounting out of the lock protection, which is
introduced in commit 65c453778aea ("mm, rmap: account shmem thp pages").

Link: http://lkml.kernel.org/r/20200110025516.23996-1-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock
+++ a/mm/huge_memory.c
@@ -2799,6 +2799,7 @@ int split_huge_page_to_list(struct page
 			ds_queue->split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
+		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
 			if (PageSwapBacked(head))
 				__dec_node_page_state(head, NR_SHMEM_THPS);
@@ -2806,7 +2807,6 @@ int split_huge_page_to_list(struct page
 				__dec_node_page_state(head, NR_FILE_THPS);
 		}
 
-		spin_unlock(&ds_queue->split_queue_lock);
 		__split_huge_page(page, list, end, flags);
 		if (PageSwapCache(head)) {
 			swp_entry_t entry = { .val = page_private(head) };
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

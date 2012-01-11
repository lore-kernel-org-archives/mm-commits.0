From: akpm@linux-foundation.org
Subject: [merged] mm-debug-test-for-online-nid-when-allocating-on-single-node.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:10 -0800
Message-ID: <20120111212711.1912020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43639 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab2AKV1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:13 -0500
Received: by werf1 with SMTP id f1so53551wer.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: test for online nid when allocating on single node
has been removed from the -mm tree.  Its filename was
     mm-debug-test-for-online-nid-when-allocating-on-single-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, debug: test for online nid when allocating on single node

Calling alloc_pages_exact_node() means the allocation only passes the
zonelist of a single node into the page allocator.  If that node isn't
online, it's zonelist may never have been initialized causing a strange
oops that may not immediately be clear.

I recently debugged an issue where node 0 wasn't online and an allocator
was passing 0 to alloc_pages_exact_node() and it resulted in a NULL
pointer on zonelist->_zoneref.  If CONFIG_DEBUG_VM is enabled, though, it
would be nice to catch this a bit earlier.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-debug-test-for-online-nid-when-allocating-on-single-node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-debug-test-for-online-nid-when-allocating-on-single-node
+++ a/include/linux/gfp.h
@@ -313,7 +313,7 @@ static inline struct page *alloc_pages_n
 static inline struct page *alloc_pages_exact_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES || !node_online(nid));
 
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch


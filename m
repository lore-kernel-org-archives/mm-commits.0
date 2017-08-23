From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-page_ext-move-page_ext_init-after-page_alloc_init_late.patch removed
 from -mm tree
Date: Wed, 23 Aug 2017 15:43:32 -0700
Message-ID: <599e0514.nIo6cZXAfkhd3QpM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdHWWne (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 18:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, vinmenon@codeaurora.org, yang.shi@linaro.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_ext: move page_ext_init() after page_alloc_init_late()
has been removed from the -mm tree.  Its filename was
     mm-page_ext-move-page_ext_init-after-page_alloc_init_late.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_ext: move page_ext_init() after page_alloc_init_late()

Commit b8f1a75d61d8 ("mm: call page_ext_init() after all struct pages are
initialized") has avoided a a NULL pointer dereference due to
DEFERRED_STRUCT_PAGE_INIT clashing with page_ext, by calling
page_ext_init() only after the deferred struct page init has finished. 
Later commit fe53ca54270a ("mm: use early_pfn_to_nid in page_ext_init")
avoided the underlying issue differently and moved the page_ext_init()
call back to where it was before.

However, there are two problems with the current code:

- on very large machines, page_ext_init() may fail to allocate the
  page_ext structures, because deferred struct page init hasn't yet
  started, and the pre-inited part might be too small.  This has been
  observed with a 3TB machine with page_owner=on.  Although it was an
  older kernel where page_owner hasn't yet been converted to stack depot,
  thus page_ext was larger, the fundamental problem is still in mainline.

- page_owner's init_pages_in_zone() is called before deferred struct
  page init has started, so it will encounter unitialized struct pages. 
  This currently happens to cause no harm, because the memmap array is are
  pre-zeroed on allocation and thus the "if (page_zone(page) != zone)"
  check is negative, but that pre-zeroing guarantee might change soon.

The second problem could be also solved by limiting init_page_in_zone() by
pgdat->first_deferred_pfn, but fixing the first issue would be more
problematic.  So this patch again moves page_ext_init() to wait for
deferred struct page init to finish.  This has some performance
implications for boot time, which should be acceptable when enabling
debugging functionality.  We however keep the benefits of parallel
initialization (one kthread per node) so it's better than e.g.  disabling
DEFERRED_STRUCT_PAGE_INIT completely when page_ext is being used.

This effectively reverts fe53ca54270a757f ("mm: use early_pfn_to_nid in
page_ext_init").

Link: http://lkml.kernel.org/r/20170720134029.25268-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c   |    3 ++-
 mm/page_ext.c |    4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN init/main.c~mm-page_ext-move-page_ext_init-after-page_alloc_init_late init/main.c
--- a/init/main.c~mm-page_ext-move-page_ext_init-after-page_alloc_init_late
+++ a/init/main.c
@@ -650,7 +650,6 @@ asmlinkage __visible void __init start_k
 		initrd_start = 0;
 	}
 #endif
-	page_ext_init();
 	debug_objects_mem_init();
 	kmemleak_init();
 	setup_per_cpu_pageset();
@@ -1053,6 +1052,8 @@ static noinline void __init kernel_init_
 	sched_init_smp();
 
 	page_alloc_init_late();
+	/* Initialize page ext after all struct pages are initializaed */
+	page_ext_init();
 
 	do_basic_setup();
 
diff -puN mm/page_ext.c~mm-page_ext-move-page_ext_init-after-page_alloc_init_late mm/page_ext.c
--- a/mm/page_ext.c~mm-page_ext-move-page_ext_init-after-page_alloc_init_late
+++ a/mm/page_ext.c
@@ -399,10 +399,8 @@ void __init page_ext_init(void)
 			 * We know some arch can have a nodes layout such as
 			 * -------------pfn-------------->
 			 * N0 | N1 | N2 | N0 | N1 | N2|....
-			 *
-			 * Take into account DEFERRED_STRUCT_PAGE_INIT.
 			 */
-			if (early_pfn_to_nid(pfn) != nid)
+			if (pfn_to_nid(pfn) != nid)
 				continue;
 			if (init_section_page_ext(pfn, nid))
 				goto oom;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-make-init_pages_in_zone-faster.patch
mm-page_ext-periodically-reschedule-during-page_ext_init.patch
mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch


From: akpm@linux-foundation.org
Subject: [folded-merged] mm-page_alloc-split-buffered_rmqueue-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:28:42 -0800
Message-ID: <58b0b39a.vmaO2+GYqXy55j07%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXW2n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:28:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, hillf.zj@alibaba-inc.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: split buffered_rmqueue -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-split-buffered_rmqueue-fix.patch

This patch was dropped because it was folded into mm-page_alloc-split-buffered_rmqueue.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: split buffered_rmqueue -fix

Vlastimil Babka pointed out that a failed per-cpu refill on a kernel with
CONFIG_DEBUG_VM may blow up on a VM_BUG_ON_PAGE.  This patch is a fix to
the mmotm patch mm-page_alloc-split-buffered_rmqueue.patch

Link: http://lkml.kernel.org/r/20170124112723.mshmgwq2ihxku2um@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-split-buffered_rmqueue-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-split-buffered_rmqueue-fix
+++ a/mm/page_alloc.c
@@ -2697,7 +2697,7 @@ struct page *rmqueue(struct zone *prefer
 	local_irq_restore(flags);
 
 out:
-	VM_BUG_ON_PAGE(bad_range(zone, page), page);
+	VM_BUG_ON_PAGE(page && bad_range(zone, page), page);
 	return page;
 
 failed:
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-buffered_rmqueue.patch
mm-page_alloc-split-alloc_pages_nodemask.patch
mm-page_alloc-drain-per-cpu-pages-from-workqueue-context.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix.patch
mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch


From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fix-a-terrible-misleading-comment.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:42 -0700
Message-ID: <55f08e46.7WNEX2O8S22Mg9ak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbbIITxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix a misleading comment
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-a-terrible-misleading-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/page_alloc.c: fix a misleading comment

The comment says that the per-cpu batchsize and zone watermarks are
determined by present_pages which is definitely wrong, they are both
calculated from managed_pages.  Fix it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 ++--
 mm/page_alloc.c             |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-page_alloc-fix-a-terrible-misleading-comment Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-page_alloc-fix-a-terrible-misleading-comment
+++ a/Documentation/sysctl/vm.txt
@@ -349,7 +349,7 @@ zone[i]'s protection[j] is calculated by
 
 (i < j):
   zone[i]->protection[j]
-  = (total sums of present_pages from zone[i+1] to zone[j] on the node)
+  = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
     / lowmem_reserve_ratio[i];
 (i = j):
    (should not be protected. = 0;
@@ -360,7 +360,7 @@ The default values of lowmem_reserve_rat
     256 (if zone[i] means DMA or DMA32 zone)
     32  (others).
 As above expression, they are reciprocal number of ratio.
-256 means 1/256. # of protection pages becomes about "0.39%" of total present
+256 means 1/256. # of protection pages becomes about "0.39%" of total managed
 pages of higher zones on the node.
 
 If you would like to protect more pages, smaller values are effective.
diff -puN mm/page_alloc.c~mm-page_alloc-fix-a-terrible-misleading-comment mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-a-terrible-misleading-comment
+++ a/mm/page_alloc.c
@@ -6022,7 +6022,7 @@ void __init mem_init_print_info(const ch
  * set_dma_reserve - set the specified number of pages reserved in the first zone
  * @new_dma_reserve: The number of pages to mark reserved
  *
- * The per-cpu batchsize and zone watermarks are determined by present_pages.
+ * The per-cpu batchsize and zone watermarks are determined by managed_pages.
  * In the DMA zone, a significant percentage may be consumed by kernel image
  * and other unfreeable allocations which can skew the watermarks badly. This
  * function may optionally be used to account for unfreeable pages in the
_

Patches currently in -mm which might be from bywxiaobai@163.com are



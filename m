From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-clear-to-access-sub-page-last-when-clearing-huge-page-fix.patch removed
 from -mm tree
Date: Wed, 06 Sep 2017 16:11:25 -0700
Message-ID: <59b0809d.a+6+y8M+eJneY8pm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754319AbdIFXL0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: improve readability of clear_huge_page
has been removed from the -mm tree.  Its filename was
     mm-clear-to-access-sub-page-last-when-clearing-huge-page-fix.patch

This patch was dropped because it was folded into mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm/memory.c: improve readability of clear_huge_page

The optimized clear_huge_page() isn't easy to read and understand.  This
is suggested by Michael Hocko to improve it.

Link: http://lkml.kernel.org/r/20170830051842.1397-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-clear-to-access-sub-page-last-when-clearing-huge-page-fix mm/memory.c
--- a/mm/memory.c~mm-clear-to-access-sub-page-last-when-clearing-huge-page-fix
+++ a/mm/memory.c
@@ -4463,12 +4463,15 @@ void clear_huge_page(struct page *page,
 	 * towards the sub-page to access
 	 */
 	for (i = 0; i < l; i++) {
+		int left_idx = base + i;
+		int right_idx = base + 2 * l - 1 - i;
+
 		cond_resched();
-		clear_user_highpage(page + base + i,
-				    addr + (base + i) * PAGE_SIZE);
+		clear_user_highpage(page + left_idx,
+				    addr + left_idx * PAGE_SIZE);
 		cond_resched();
-		clear_user_highpage(page + base + 2 * l - 1 - i,
-				    addr + (base + 2 * l - 1 - i) * PAGE_SIZE);
+		clear_user_highpage(page + right_idx,
+				    addr + right_idx * PAGE_SIZE);
 	}
 }
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch
mm-swap-add-swap-readahead-hit-statistics.patch
mm-swap-fix-swap-readahead-marking.patch
mm-swap-vma-based-swap-readahead.patch
mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch
mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap.patch
mm-clear-to-access-sub-page-last-when-clearing-huge-page.patch


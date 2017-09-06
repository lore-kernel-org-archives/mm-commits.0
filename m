From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch
 removed from -mm tree
Date: Wed, 06 Sep 2017 16:06:51 -0700
Message-ID: <59b07f8b.N+qKCy0AHHCs15Aj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47380 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753894AbdIFXGw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, arnd@arndb.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: Silence a compiler warning
has been removed from the -mm tree.  Its filename was
     mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch

This patch was dropped because it was folded into mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: Silence a compiler warning

To fix the following compiler warning,

mm/swapfile.c: In function 'reuse_swap_page':
mm/swapfile.c:1429:16: warning: 'offset' may be used uninitialized in this function [-Wmaybe-uninitialized]
  unsigned long offset;
                ^
This is a false positive report, but we should silence it anyway.

Link: http://lkml.kernel.org/r/87bmnzizjy.fsf@yhuang-dev.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix
+++ a/mm/swapfile.c
@@ -1410,7 +1410,7 @@ static int page_trans_huge_map_swapcount
 					 int *total_swapcount)
 {
 	int i, map_swapcount, _total_mapcount, _total_swapcount;
-	unsigned long offset;
+	unsigned long offset = 0;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci = NULL;
 	unsigned char *map = NULL;
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
mm-clear-to-access-sub-page-last-when-clearing-huge-page-fix.patch


From: akpm@linux-foundation.org
Subject: +
 mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch added
 to -mm tree
Date: Tue, 01 Aug 2017 15:20:10 -0700
Message-ID: <5980fe9a.IfVMlY96i07y5Bs7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39876 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdHAWUL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 18:20:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, arnd@arndb.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: Silence a compiler warning
has been added to the -mm tree.  Its filename is
     mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch


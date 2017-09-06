From: akpm@linux-foundation.org
Subject: [patch 074/119] memcg, THP, swap: avoid to duplicated
 charge THP in swap cache
Date: Wed, 06 Sep 2017 16:22:41 -0700
Message-ID: <20170906232241.31PWSel9z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50332 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754199AbdIFXWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, torvalds@linux-foundation.org, vishal.l.verma@intel.com, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: memcg, THP, swap: avoid to duplicated charge THP in swap cache

For a THP (Transparent Huge Page), tail_page->mem_cgroup is NULL.  So to
check whether the page is charged already, we need to check the head page.
This is not an issue before because it is impossible for a THP to be in
the swap cache before.  But after we add delaying splitting THP after
swapped out support, it is possible now.

Link: http://lkml.kernel.org/r/20170724051840.2309-10-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Shaohua Li <shli@kernel.org>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache
+++ a/mm/memcontrol.c
@@ -5430,7 +5430,7 @@ int mem_cgroup_try_charge(struct page *p
 		 * in turn serializes uncharging.
 		 */
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		if (page->mem_cgroup)
+		if (compound_head(page)->mem_cgroup)
 			goto out;
 
 		if (do_swap_account) {
_

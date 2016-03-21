From: akpm@linux-foundation.org
Subject: [merged]
 mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch removed from
 -mm tree
Date: Mon, 21 Mar 2016 11:38:28 -0700
Message-ID: <56f03fa4.wL4aVCodzyQxPten%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbcCUT4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aarcange@redhat.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kswapd: remove bogus check of balance_classzone_idx
has been removed from the -mm tree.  Its filename was
     mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, kswapd: remove bogus check of balance_classzone_idx

During work on kcompactd integration I have spotted a confusing check of
balance_classzone_idx, which I believe is bogus.

The balanced_classzone_idx is filled by balance_pgdat() as the highest
zone it attempted to balance.  This was introduced by commit dc83edd941f4
("mm: kswapd: use the classzone idx that kswapd was using for
sleeping_prematurely()").  The intention is that (as expressed in today's
function names), the value used for kswapd_shrink_zone() calls in
balance_pgdat() is the same as for the decisions in kswapd_try_to_sleep().
An unwanted side-effect of that commit was breaking the checks in
kswapd() whether there was another kswapd_wakeup with a tighter (=lower)
classzone_idx.  Commits 215ddd6664ce ("mm: vmscan: only read
new_classzone_idx from pgdat when reclaiming successfully") and
d2ebd0f6b895 ("kswapd: avoid unnecessary rebalance after an unsuccessful
balancing") tried to fixed, but apparently introduced a bogus check that
this patch removes.

Consider zone indexes X < Y < Z, where:
- Z is the value used for the first kswapd wakeup.
- Y is returned as balanced_classzone_idx, which means zones with index higher
  than Y (including Z) were found to be unreclaimable.
- X is the value used for the second kswapd wakeup

The new wakeup with value X means that kswapd is now supposed to balance
harder all zones with index <= X.  But instead, due to Y < Z, it will go
sleep and won't read the new value X.  This is subtly wrong.

The effect of this patch is that kswapd will react better in some
situations, where e.g.  the first wakeup is for ZONE_DMA32, the second is
for ZONE_DMA, and due to unreclaimable ZONE_NORMAL.  Before this patch,
kswapd would go sleep instead of reclaiming ZONE_DMA harder.  I expect
these situations are very rare, and more value is in better
maintainability due to the removal of confusing and bogus check.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-kswapd-remove-bogus-check-of-balance_classzone_idx mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-remove-bogus-check-of-balance_classzone_idx
+++ a/mm/vmscan.c
@@ -3468,8 +3468,7 @@ static int kswapd(void *p)
 		 * new request of a similar or harder type will succeed soon
 		 * so consider going to sleep on the basis we reclaimed at
 		 */
-		if (balanced_classzone_idx >= new_classzone_idx &&
-					balanced_order == new_order) {
+		if (balanced_order == new_order) {
 			new_order = pgdat->kswapd_max_order;
 			new_classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order =  0;
_

Patches currently in -mm which might be from vbabka@suse.cz are



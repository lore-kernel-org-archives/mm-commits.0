From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-correct-check-for-kswapd-sleeping-in-sleeping_prematurely.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:42:46 -0700
Message-ID: <201107111842.p6BIgIdi025452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758148Ab1GKSnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 14:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, P@draigBrady.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, luto@mit.edu, minchan.kim@gmail.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: vmscan: correct check for kswapd sleeping in sleeping_prematur=
ely
has been removed from the -mm tree.  Its filename was
     mm-vmscan-correct-check-for-kswapd-sleeping-in-sleeping_prematurel=
y.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm: vmscan: correct check for kswapd sleeping in sleeping_prem=
aturely
=46rom: Mel Gorman <mgorman@suse.de>

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  T=
his
is expected behaviour.  Unfortunately, if the highest zone is small, a
problem occurs.

This seems to happen most with recent sandybridge laptops but it's
probably a co-incidence as some of these laptops just happen to have a
small Normal zone.  The reproduction case is almost always during copyi=
ng
large files that kswapd pegs at 100% CPU until the file is deleted or
cache is dropped.

The problem is mostly down to sleeping_prematurely() keeping kswapd awa=
ke
when the highest zone is small and unreclaimable and compounded by the
fact we shrink slabs even when not shrinking zones causing a lot of tim=
e
to be spent in shrinkers and a lot of memory to be reclaimed.

Patch 1 corrects sleeping_prematurely to check the zones matching
	the classzone_idx instead of all zones.

Patch 2 avoids shrinking slab when we are not shrinking a zone.

Patch 3 notes that sleeping_prematurely is checking lower zones against
	a high classzone which is not what allocators or balance_pgdat()
	is doing leading to an artifical belief that kswapd should be
	still awake.

Patch 4 notes that when balance_pgdat() gives up on a high zone that th=
e
	decision is not communicated to sleeping_prematurely()

This problem affects 2.6.38.8 for certain and is expected to affect 2.6=
=2E39
and 3.0-rc4 as well.  If accepted, they need to go to -stable to be pic=
ked
up by distros and this series is against 3.0-rc4.  I've cc'd people tha=
t
reported similar problems recently to see if they still suffer from the
problem and if this fixes it.




This patch: correct the check for kswapd sleeping in sleeping_premature=
ly()

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  T=
his
is expected behaviour.

A problem occurs if the highest zone is small.  balance_pgdat() only
considers unreclaimable zones when priority is DEF_PRIORITY but
sleeping_prematurely considers all zones.  It's possible for this seque=
nce
to occur

  1. kswapd wakes up and enters balance_pgdat()
  2. At DEF_PRIORITY, marks highest zone unreclaimable
  3. At DEF_PRIORITY-1, ignores highest zone setting end_zone
  4. At DEF_PRIORITY-1, calls shrink_slab freeing memory from
        highest zone, clearing all_unreclaimable. Highest zone
        is still unbalanced
  5. kswapd returns and calls sleeping_prematurely
  6. sleeping_prematurely looks at *all* zones, not just the ones
     being considered by balance_pgdat. The highest small zone
     has all_unreclaimable cleared but the zone is not
     balanced. all_zones_ok is false so kswapd stays awake

This patch corrects the behaviour of sleeping_prematurely to check the
zones balance_pgdat() checked.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: P=E1draig Brady <P@draigBrady.com>
Tested-by: P=E1draig Brady <P@draigBrady.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-correct-check-for-kswapd-sleeping-in-sl=
eeping_prematurely mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-correct-check-for-kswapd-sleeping-in-sleepi=
ng_prematurely
+++ a/mm/vmscan.c
@@ -2326,7 +2326,7 @@ static bool sleeping_prematurely(pg_data
 		return true;
=20
 	/* Check the watermark levels */
-	for (i =3D 0; i < pgdat->nr_zones; i++) {
+	for (i =3D 0; i <=3D classzone_idx; i++) {
 		struct zone *zone =3D pgdat->node_zones + i;
=20
 		if (!populated_zone(zone))
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

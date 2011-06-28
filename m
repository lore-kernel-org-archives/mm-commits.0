From: akpm@linux-foundation.org
Subject: + mm-vmscan-do-not-apply-pressure-to-slab-if-we-are-not-applying-pressure-to-zone.patch added to -mm tree
Date: Tue, 28 Jun 2011 14:53:37 -0700
Message-ID: <201106282153.p5SLrcNE007565__17166.008699178$1309300006$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab1F1W0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 18:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, P@draigBrady.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, luto@mit.edu, minchan.kim@gmail.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: vmscan: do not apply pressure to slab if we are not applying p=
ressure to zone
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-apply-pressure-to-slab-if-we-are-not-applying-pre=
ssure-to-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm: vmscan: do not apply pressure to slab if we are not applyi=
ng pressure to zone
=46rom: Mel Gorman <mgorman@suse.de>

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  T=
his
is expected behaviour.

When kswapd applies pressure to zones during node balancing, it checks =
if
the zone is above a high+balance_gap threshold.  If it is, it does not
apply pressure but it unconditionally shrinks slab on a global basis wh=
ich
is excessive.  In the event kswapd is being kept awake due to a high sm=
all
unreclaimable zone, it skips zone shrinking but still calls shrink_slab=
().

Once pressure has been applied, the check for zone being unreclaimable =
is
being made before the check is made if all_unreclaimable should be set.=
=20
This miss of unreclaimable can cause has_under_min_watermark_zone to be
set due to an unreclaimable zone preventing kswapd backing off on
congestion_wait().

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: P=E1draig Brady <P@draigBrady.com>
Tested-by: P=E1draig Brady <P@draigBrady.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-apply-pressure-to-slab-if-we-are=
-not-applying-pressure-to-zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-apply-pressure-to-slab-if-we-are-not=
-applying-pressure-to-zone
+++ a/mm/vmscan.c
@@ -2510,18 +2510,18 @@ loop_again:
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone) + balance_gap,
-					end_zone, 0))
+					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);
-			reclaim_state->reclaimed_slab =3D 0;
-			nr_slab =3D shrink_slab(&shrink, sc.nr_scanned, lru_pages);
-			sc.nr_reclaimed +=3D reclaim_state->reclaimed_slab;
-			total_scanned +=3D sc.nr_scanned;
=20
-			if (zone->all_unreclaimable)
-				continue;
-			if (nr_slab =3D=3D 0 &&
-			    !zone_reclaimable(zone))
-				zone->all_unreclaimable =3D 1;
+				reclaim_state->reclaimed_slab =3D 0;
+				nr_slab =3D shrink_slab(&shrink, sc.nr_scanned, lru_pages);
+				sc.nr_reclaimed +=3D reclaim_state->reclaimed_slab;
+				total_scanned +=3D sc.nr_scanned;
+
+				if (nr_slab =3D=3D 0 && !zone_reclaimable(zone))
+					zone->all_unreclaimable =3D 1;
+			}
+
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -2531,6 +2531,9 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage =3D 1;
=20
+			if (zone->all_unreclaimable)
+				continue;
+
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok =3D 0;
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-vmscan-correct-check-for-kswapd-sleeping-in-sleeping_prematurely.pat=
ch
mm-vmscan-do-not-apply-pressure-to-slab-if-we-are-not-applying-pressure=
-to-zone.patch
mm-vmscan-evaluate-the-watermarks-against-the-correct-classzone.patch
mm-vmscan-only-read-new_classzone_idx-from-pgdat-when-reclaiming-succes=
sfully.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

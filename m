From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-only-read-new_classzone_idx-from-pgdat-when-reclaiming-successfully.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:42:54 -0700
Message-ID: <201107111842.p6BIgPdD025477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535Ab1GKTm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 15:42:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, P@draigBrady.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, luto@mit.edu, minchan.kim@gmail.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: vmscan: only read new_classzone_idx from pgdat when reclaiming=
 successfully
has been removed from the -mm tree.  Its filename was
     mm-vmscan-only-read-new_classzone_idx-from-pgdat-when-reclaiming-s=
uccessfully.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm: vmscan: only read new_classzone_idx from pgdat when reclai=
ming successfully
=46rom: Mel Gorman <mgorman@suse.de>

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  T=
his
is expected behaviour.  Unfortunately, if the highest zone is small, a
problem occurs.

When balance_pgdat() returns, it may be at a lower classzone_idx than i=
t
started because the highest zone was unreclaimable.  Before checking if=
 it
should go to sleep though, it checks pgdat->classzone_idx which when th=
ere
is no other activity will be MAX_NR_ZONES-1.  It interprets this as it =
has
been woken up while reclaiming, skips scheduling and reclaims again.  A=
s
there is no useful reclaim work to do, it enters into a loop of shrinki=
ng
slab consuming loads of CPU until the highest zone becomes reclaimable =
for
a long period of time.

There are two problems here.  1) If the returned classzone or order is
lower, it'll continue reclaiming without scheduling.  2) if the highest
zone was marked unreclaimable but balance_pgdat() returns immediately a=
t
DEF_PRIORITY, the new lower classzone is not communicated back to kswap=
d()
for sleeping.

This patch does two things that are related.  If the end_zone is
unreclaimable, this information is communicated back.  Second, if the
classzone or order was reduced due to failing to reclaim, new informati=
on
is not read from pgdat and instead an attempt is made to go to sleep.  =
Due
to this, it is also necessary that pgdat->classzone_idx be initialised
each time to pgdat->nr_zones - 1 to avoid re-reads being interpreted as
wakeups.

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

 mm/vmscan.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-only-read-new_classzone_idx-from-pgdat-=
when-reclaiming-successfully mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-only-read-new_classzone_idx-from-pgdat-when=
-reclaiming-successfully
+++ a/mm/vmscan.c
@@ -2451,7 +2451,6 @@ loop_again:
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone =3D i;
-				*classzone_idx =3D i;
 				break;
 			}
 		}
@@ -2531,8 +2530,11 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage =3D 1;
=20
-			if (zone->all_unreclaimable)
+			if (zone->all_unreclaimable) {
+				if (end_zone && end_zone =3D=3D i)
+					end_zone--;
 				continue;
+			}
=20
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
@@ -2712,8 +2714,8 @@ static void kswapd_try_to_sleep(pg_data_
  */
 static int kswapd(void *p)
 {
-	unsigned long order;
-	int classzone_idx;
+	unsigned long order, new_order;
+	int classzone_idx, new_classzone_idx;
 	pg_data_t *pgdat =3D (pg_data_t*)p;
 	struct task_struct *tsk =3D current;
=20
@@ -2743,17 +2745,23 @@ static int kswapd(void *p)
 	tsk->flags |=3D PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
=20
-	order =3D 0;
-	classzone_idx =3D MAX_NR_ZONES - 1;
+	order =3D new_order =3D 0;
+	classzone_idx =3D new_classzone_idx =3D pgdat->nr_zones - 1;
 	for ( ; ; ) {
-		unsigned long new_order;
-		int new_classzone_idx;
 		int ret;
=20
-		new_order =3D pgdat->kswapd_max_order;
-		new_classzone_idx =3D pgdat->classzone_idx;
-		pgdat->kswapd_max_order =3D 0;
-		pgdat->classzone_idx =3D MAX_NR_ZONES - 1;
+		/*
+		 * If the last balance_pgdat was unsuccessful it's unlikely a
+		 * new request of a similar or harder type will succeed soon
+		 * so consider going to sleep on the basis we reclaimed at
+		 */
+		if (classzone_idx >=3D new_classzone_idx && order =3D=3D new_order) =
{
+			new_order =3D pgdat->kswapd_max_order;
+			new_classzone_idx =3D pgdat->classzone_idx;
+			pgdat->kswapd_max_order =3D  0;
+			pgdat->classzone_idx =3D pgdat->nr_zones - 1;
+		}
+
 		if (order < new_order || classzone_idx > new_classzone_idx) {
 			/*
 			 * Don't sleep if someone wants a larger 'order'
@@ -2766,7 +2774,7 @@ static int kswapd(void *p)
 			order =3D pgdat->kswapd_max_order;
 			classzone_idx =3D pgdat->classzone_idx;
 			pgdat->kswapd_max_order =3D 0;
-			pgdat->classzone_idx =3D MAX_NR_ZONES - 1;
+			pgdat->classzone_idx =3D pgdat->nr_zones - 1;
 		}
=20
 		ret =3D try_to_freeze();
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

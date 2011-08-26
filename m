From: akpm@linux-foundation.org
Subject: + kswapd-avoid-unnecessary-rebalance-after-an-unsuccessful-balancing.patch added to -mm tree
Date: Fri, 26 Aug 2011 15:07:27 -0700
Message-ID: <201108262207.p7QM7Rnf015203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab1HZWIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 18:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, P@draigBrady.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com, tim.c.chen@linux.intel.com


The patch titled
     kswapd: avoid unnecessary rebalance after an unsuccessful balancin=
g
has been added to the -mm tree.  Its filename is
     kswapd-avoid-unnecessary-rebalance-after-an-unsuccessful-balancing=
=2Epatch

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
Subject: kswapd: avoid unnecessary rebalance after an unsuccessful bala=
ncing
=46rom: "Alex,Shi" <alex.shi@intel.com>

In commit 215ddd66 ("mm: vmscan: only read new_classzone_idx from pgdat
when reclaiming successfully") , Mel Gorman said kswapd is better to sl=
eep
after a unsuccessful balancing if there is tighter reclaim request pend=
ing
in the balancing.  But in the following scenario, kswapd do something t=
hat
is not matched our expectation.  The patch fixes this issue.

1, Read pgdat request A (classzone_idx, order =3D 3)
2, balance_pgdat()
3, During pgdat, a new pgdat request B (classzone_idx, order =3D 5) is =
placed
4, balance_pgdat() returns but failed since returned order =3D 0
5, pgdat of request A assigned to balance_pgdat(), and do balancing aga=
in.
   While the expectation behavior of kswapd should try to sleep.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Tested-by: P=E1draig Brady <P@draigBrady.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~kswapd-avoid-unnecessary-rebalance-after-an-unsuc=
cessful-balancing mm/vmscan.c
--- a/mm/vmscan.c~kswapd-avoid-unnecessary-rebalance-after-an-unsuccess=
ful-balancing
+++ a/mm/vmscan.c
@@ -2842,7 +2842,9 @@ static void kswapd_try_to_sleep(pg_data_
 static int kswapd(void *p)
 {
 	unsigned long order, new_order;
+	unsigned balanced_order;
 	int classzone_idx, new_classzone_idx;
+	int balanced_classzone_idx;
 	pg_data_t *pgdat =3D (pg_data_t*)p;
 	struct task_struct *tsk =3D current;
=20
@@ -2873,7 +2875,9 @@ static int kswapd(void *p)
 	set_freezable();
=20
 	order =3D new_order =3D 0;
+	balanced_order =3D 0;
 	classzone_idx =3D new_classzone_idx =3D pgdat->nr_zones - 1;
+	balanced_classzone_idx =3D classzone_idx;
 	for ( ; ; ) {
 		int ret;
=20
@@ -2882,7 +2886,8 @@ static int kswapd(void *p)
 		 * new request of a similar or harder type will succeed soon
 		 * so consider going to sleep on the basis we reclaimed at
 		 */
-		if (classzone_idx >=3D new_classzone_idx && order =3D=3D new_order) =
{
+		if (balanced_classzone_idx >=3D new_classzone_idx &&
+					balanced_order =3D=3D new_order) {
 			new_order =3D pgdat->kswapd_max_order;
 			new_classzone_idx =3D pgdat->classzone_idx;
 			pgdat->kswapd_max_order =3D  0;
@@ -2897,7 +2902,8 @@ static int kswapd(void *p)
 			order =3D new_order;
 			classzone_idx =3D new_classzone_idx;
 		} else {
-			kswapd_try_to_sleep(pgdat, order, classzone_idx);
+			kswapd_try_to_sleep(pgdat, balanced_order,
+						balanced_classzone_idx);
 			order =3D pgdat->kswapd_max_order;
 			classzone_idx =3D pgdat->classzone_idx;
 			pgdat->kswapd_max_order =3D 0;
@@ -2914,7 +2920,9 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			order =3D balance_pgdat(pgdat, order, &classzone_idx);
+			balanced_classzone_idx =3D classzone_idx;
+			balanced_order =3D balance_pgdat(pgdat, order,
+						&balanced_classzone_idx);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from alex.shi@intel.com are

linux-next.patch
kswapd-avoid-unnecessary-rebalance-after-an-unsuccessful-balancing.patc=
h

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

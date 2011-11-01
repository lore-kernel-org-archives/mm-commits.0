From: akpm@linux-foundation.org
Subject: [merged] kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:46 -0700
Message-ID: <201111012110.pA1LAkR0010614@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29138 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1KAVKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, P@draigBrady.com, mgorman@suse.de, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kswapd: assign new_order and new_classzone_idx after wake=
up in sleeping
has been removed from the -mm tree.  Its filename was
     kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-slee=
ping.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: "Alex,Shi" <alex.shi@intel.com>
Subject: kswapd: assign new_order and new_classzone_idx after wakeup in=
 sleeping

There 2 places to read pgdat in kswapd.  One is return from a successfu=
l
balance, another is waked up from kswapd sleeping.  The new_order and
new_classzone_idx represent the balance input order and classzone_idx.

But current new_order and new_classzone_idx are not assigned after
kswapd_try_to_sleep(), that will cause a bug in the following scenario.

1: after a successful balance, kswapd goes to sleep, and new_order =3D =
0;
   new_classzone_idx =3D __MAX_NR_ZONES - 1;

2: kswapd waked up with order =3D 3 and classzone_idx =3D ZONE_NORMAL

3: in the balance_pgdat() running, a new balance wakeup happened with
   order =3D 5, and classzone_idx =3D ZONE_NORMAL

4: the first wakeup(order =3D 3) finished successufly, return order =3D=
 3
   but, the new_order is still 0, so, this balancing will be treated as=
 a
   failed balance.  And then the second tighter balancing will be misse=
d.

So, to avoid the above problem, the new_order and new_classzone_idx nee=
d
to be assigned for later successful comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Tested-by: P=E1draig Brady <P@draigBrady.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~kswapd-assign-new_order-and-new_classzone_idx-aft=
er-wakeup-in-sleeping mm/vmscan.c
--- a/mm/vmscan.c~kswapd-assign-new_order-and-new_classzone_idx-after-w=
akeup-in-sleeping
+++ a/mm/vmscan.c
@@ -2887,6 +2887,8 @@ static int kswapd(void *p)
 						balanced_classzone_idx);
 			order =3D pgdat->kswapd_max_order;
 			classzone_idx =3D pgdat->classzone_idx;
+			new_order =3D order;
+			new_classzone_idx =3D classzone_idx;
 			pgdat->kswapd_max_order =3D 0;
 			pgdat->classzone_idx =3D pgdat->nr_zones - 1;
 		}
_

Patches currently in -mm which might be from alex.shi@intel.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

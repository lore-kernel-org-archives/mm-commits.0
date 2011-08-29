From: akpm@linux-foundation.org
Subject: + kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch added to -mm tree
Date: Mon, 29 Aug 2011 15:23:56 -0700
Message-ID: <201108292223.p7TMNu02002641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1H2WYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 18:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, P@draigBrady.com, mgorman@suse.de, minchan.kim@gmail.com


The patch titled
     kswapd: assign new_order and new_classzone_idx after wakeup in sle=
eping
has been added to the -mm tree.  Its filename is
     kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-slee=
ping.patch

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
Subject: kswapd: assign new_order and new_classzone_idx after wakeup in=
 sleeping
=46rom: "Alex,Shi" <alex.shi@intel.com>

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
@@ -2883,6 +2883,8 @@ static int kswapd(void *p)
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

linux-next.patch
kswapd-avoid-unnecessary-rebalance-after-an-unsuccessful-balancing.patc=
h
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.=
patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

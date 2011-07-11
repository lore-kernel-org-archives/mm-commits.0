From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-evaluate-the-watermarks-against-the-correct-classzone.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:42:52 -0700
Message-ID: <201107111842.p6BIgNnM025470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758047Ab1GKSnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 14:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, P@draigBrady.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, luto@mit.edu, minchan.kim@gmail.com, riel@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: vmscan: evaluate the watermarks against the correct classzone
has been removed from the -mm tree.  Its filename was
     mm-vmscan-evaluate-the-watermarks-against-the-correct-classzone.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm: vmscan: evaluate the watermarks against the correct classz=
one
=46rom: Mel Gorman <mgorman@suse.de>

When deciding if kswapd is sleeping prematurely, the classzone is taken
into account but this is different to what balance_pgdat() and the
allocator are doing.  Specifically, the DMA zone will be checked based =
on
the classzone used when waking kswapd which could be for a GFP_KERNEL o=
r
GFP_HIGHMEM request.  The lowmem reserve limit kicks in, the watermark =
is
not met and kswapd thinks it's sleeping prematurely keeping kswapd awak=
e in
error.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: P=E1draig Brady <P@draigBrady.com>
Tested-by: P=E1draig Brady <P@draigBrady.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-evaluate-the-watermarks-against-the-cor=
rect-classzone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-evaluate-the-watermarks-against-the-correct=
-classzone
+++ a/mm/vmscan.c
@@ -2344,7 +2344,7 @@ static bool sleeping_prematurely(pg_data
 		}
=20
 		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-							classzone_idx, 0))
+							i, 0))
 			all_zones_ok =3D false;
 		else
 			balanced +=3D zone->present_pages;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

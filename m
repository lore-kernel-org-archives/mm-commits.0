From: akpm@linux-foundation.org
Subject: + mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
 added to -mm tree
Date: Fri, 29 Aug 2014 12:52:55 -0700
Message-ID: <5400da17.J8rjSMorIITnNfLN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaH2Tw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: avoid wakeup kswapd on the unintended node
has been added to the -mm tree.  Its filename is
     mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm: page_alloc: avoid wakeup kswapd on the unintended node

When entering the page_alloc slowpath, we wakeup kswapd on every pgdat
according to the zonelist and high_zoneidx.  However, this doesn't take
nodemask into account, and could prematurely wakeup kswapd on some
unintended nodes.

This patch uses for_each_zone_zonelist_nodemask() instead of
for_each_zone_zonelist() in wake_all_kswapds() to avoid the above
situation.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node
+++ a/mm/page_alloc.c
@@ -2470,12 +2470,14 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 static void wake_all_kswapds(unsigned int order,
 			     struct zonelist *zonelist,
 			     enum zone_type high_zoneidx,
-			     struct zone *preferred_zone)
+			     struct zone *preferred_zone,
+			     nodemask_t *nodemask)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+						high_zoneidx, nodemask)
 		wakeup_kswapd(zone, order, zone_idx(preferred_zone));
 }
 
@@ -2573,7 +2575,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 restart:
 	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapds(order, zonelist, high_zoneidx, preferred_zone);
+		wake_all_kswapds(order, zonelist, high_zoneidx,
+				preferred_zone, nodemask);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch


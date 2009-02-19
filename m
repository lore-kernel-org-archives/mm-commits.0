From: akpm@linux-foundation.org
Subject: + vmscan-respect-higher-order-in-zone_reclaim.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:29:28 -0800
Message-ID: <200902192029.n1JKTSX3020974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562AbZBSUaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     vmscan: respect higher order in zone_reclaim()
has been added to the -mm tree.  Its filename is
     vmscan-respect-higher-order-in-zone_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: respect higher order in zone_reclaim()
From: Johannes Weiner <hannes@cmpxchg.org>

During page allocation, there are two stages of direct reclaim that are
applied to each zone in the preferred list.  The first stage using
zone_reclaim() reclaims unmapped file backed pages and slab pages if over
defined limits as these are cheaper to reclaim.  The caller specifies the
order of the target allocation but the scan control is not being correctly
initialised.

The impact is that the correct number of pages are being reclaimed but
that lumpy reclaim is not being applied.  This increases the chances of a
full direct reclaim via try_to_free_pages() is required.

This patch initialises the order field of the scan control as requested by
the caller.

[mel@csn.ul.ie: rewrote changelog]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~vmscan-respect-higher-order-in-zone_reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-respect-higher-order-in-zone_reclaim
+++ a/mm/vmscan.c
@@ -2295,6 +2295,7 @@ static int __zone_reclaim(struct zone *z
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
+		.order = order,
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

slab-introduce-kzfree.patch
linux-next.patch
cifs-use-kzfree.patch
md-use-kzfree.patch
s390-use-kzfree.patch
usb-use-kzfree.patch
crypto-use-kzfree.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch


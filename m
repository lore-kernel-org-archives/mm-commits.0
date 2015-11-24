From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch added to
 -mm tree
Date: Tue, 24 Nov 2015 13:32:39 -0800
Message-ID: <5654d777.QlZPhfsa9ar7kzHG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbbKXVck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 16:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, mgorman@suse.de, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: consider isolated pages in zone_reclaimable_pages
has been added to the -mm tree.  Its filename is
     mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: consider isolated pages in zone_reclaimable_pages

zone_reclaimable_pages counts how many pages are reclaimable in the given
zone.  This currently includes all pages on file lrus and anon lrus if
there is an available swap storage.  We do not consider
NR_ISOLATED_{ANON,FILE} counters though which is not correct because these
counters reflect temporarily isolated pages which are still reclaimable
because they either get back to their LRU or get freed either by the page
reclaim or page migration.

The number of these pages might be sufficiently high to confuse users of
zone_reclaimable_pages (e.g.  mbind can migrate large ranges of memory at
once).

Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages
+++ a/mm/vmscan.c
@@ -197,11 +197,13 @@ static unsigned long zone_reclaimable_pa
 	unsigned long nr;
 
 	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
-	     zone_page_state(zone, NR_INACTIVE_FILE);
+	     zone_page_state(zone, NR_INACTIVE_FILE) +
+	     zone_page_state(zone, NR_ISOLATED_FILE);
 
 	if (get_nr_swap_pages() > 0)
 		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
-		      zone_page_state(zone, NR_INACTIVE_ANON);
+		      zone_page_state(zone, NR_INACTIVE_ANON) +
+		      zone_page_state(zone, NR_ISOLATED_ANON);
 
 	return nr;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-get-rid-of-__alloc_pages_high_priority.patch
mm-do-not-loop-over-alloc_no_watermarks-without-triggering-reclaim.patch
mm-vmscan-consider-isolated-pages-in-zone_reclaimable_pages.patch


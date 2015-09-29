From: akpm@linux-foundation.org
Subject: +
 mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch added to -mm tree
Date: Tue, 29 Sep 2015 16:09:39 -0700
Message-ID: <560b1a33.zl33fZU6QlI8Egzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbI2XJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 19:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 00moses.alexander00@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, vbabka@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix types of some locals
has been added to the -mm tree.  Its filename is
     mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandru Moise <00moses.alexander00@gmail.com>
Subject: mm/vmscan.c: fix types of some locals

In zone_reclaimable_pages(), `nr' is returned by a function which is
declared as returning "unsigned long", so declare it such.  Negative
values are meaningless here.

In zone_pagecache_reclaimable() we should also declare `delta' and
`nr_pagecache_reclaimable' as being unsigned longs because they're used to
store the values returned by zone_page_state() and
zone_unmapped_file_pages() which also happen to return unsigned integers.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable
+++ a/mm/vmscan.c
@@ -194,7 +194,7 @@ static bool sane_reclaim(struct scan_con
 
 static unsigned long zone_reclaimable_pages(struct zone *zone)
 {
-	int nr;
+	unsigned long nr;
 
 	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
 	     zone_page_state(zone, NR_INACTIVE_FILE);
@@ -3695,8 +3695,8 @@ static inline unsigned long zone_unmappe
 /* Work out how many page cache pages we can reclaim in this reclaim_mode */
 static long zone_pagecache_reclaimable(struct zone *zone)
 {
-	long nr_pagecache_reclaimable;
-	long delta = 0;
+	unsigned long nr_pagecache_reclaimable;
+	unsigned long delta = 0;
 
 	/*
 	 * If RECLAIM_UNMAP is set, then all file pages are considered
_

Patches currently in -mm which might be from 00moses.alexander00@gmail.com are

mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch


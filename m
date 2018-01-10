From: akpm@linux-foundation.org
Subject: + mm-page_owner-clean-up-init_pages_in_zone.patch added to -mm
 tree
Date: Wed, 10 Jan 2018 14:38:50 -0800
Message-ID: <5a5695fa.DMSwRh/f2V2BgRMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48356 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbeAJWiv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jan 2018 17:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, iamjoonsoo.kim@lge.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: clean up init_pages_in_zone()
has been added to the -mm tree.  Its filename is
     mm-page_owner-clean-up-init_pages_in_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-clean-up-init_pages_in_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-clean-up-init_pages_in_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm/page_owner.c: clean up init_pages_in_zone()

Remove two redundant assignments in init_pages_in_zone().

Link: http://lkml.kernel.org/r/20180110084355.GA22822@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone
+++ a/mm/page_owner.c
@@ -528,14 +528,11 @@ read_page_owner(struct file *file, char
 
 static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
 {
-	struct page *page;
-	struct page_ext *page_ext;
 	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
 	unsigned long end_pfn = pfn + zone->spanned_pages;
 	unsigned long count = 0;
 
 	/* Scan block by block. First and last block may be incomplete */
-	pfn = zone->zone_start_pfn;
 
 	/*
 	 * Walk the zone in pageblock_nr_pages steps. If a page block spans
@@ -551,9 +548,9 @@ static void init_pages_in_zone(pg_data_t
 		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		page = pfn_to_page(pfn);

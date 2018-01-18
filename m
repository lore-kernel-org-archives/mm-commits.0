From: akpm@linux-foundation.org
Subject: + mm-page_owner-clean-up-init_pages_in_zone-v3.patch added to -mm tree
Date: Thu, 18 Jan 2018 13:58:00 -0800
Message-ID: <5a611868.aDNje8DwMJsY4wqY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932191AbeARV6D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 16:58:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, iamjoonsoo.kim@lge.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-clean-up-init_pages_in_zone-v3
has been added to the -mm tree.  Its filename is
     mm-page_owner-clean-up-init_pages_in_zone-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-clean-up-init_pages_in_zone-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-clean-up-init_pages_in_zone-v3.patch

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
Subject: mm-page_owner-clean-up-init_pages_in_zone-v3

v2 -> v3: Added suggestions made by Vlastimil Babka
v1 -> v2: Added suggestions made by Michal Hocko

Link: http://lkml.kernel.org/r/20180117124513.GA876@techadventures.net
Signed-off-by: Oscar Salvador (SuSe) <osalvador@techadventures.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone-v3 mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-clean-up-init_pages_in_zone-v3
+++ a/mm/page_owner.c
@@ -528,18 +528,17 @@ read_page_owner(struct file *file, char
 
 static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
 {
-	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
-	unsigned long end_pfn = pfn + zone->spanned_pages;
+	unsigned long pfn = zone->zone_start_pfn;
+	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long count = 0;
 
-	/* Scan block by block. First and last block may be incomplete */

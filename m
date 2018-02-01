From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_owner-clean-up-init_pages_in_zone-v3.patch removed from -mm tree
Date: Wed, 31 Jan 2018 16:00:08 -0800
Message-ID: <5a725888.MGw0pHUJPYMVBcoi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbeBAAAK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, iamjoonsoo.kim@lge.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-clean-up-init_pages_in_zone-v3
has been removed from the -mm tree.  Its filename was
     mm-page_owner-clean-up-init_pages_in_zone-v3.patch

This patch was dropped because it was folded into mm-page_owner-clean-up-init_pages_in_zone.patch

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

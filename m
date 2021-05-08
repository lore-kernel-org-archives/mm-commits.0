Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB572C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B82BA6101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWwI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWwG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95E2A61426;
        Sat,  8 May 2021 22:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514264;
        bh=bXQ2zKSQEbHJwk26cZ9UztIVuxrY6oQYU/BWndbrsl0=;
        h=Date:From:To:Subject:From;
        b=fo488Mn2gagxBTNhA3o+UVeOc3YLYYOd4RXuGWQNDOJm+/KuZCwhp3zJSTFsAXhSv
         jyxe8VcJ2E14YjUdL5DeFFufYPZD2dNWa2TXP1DqZ89tTbREtrcAYRnQpIakmBP6gU
         LhqyQt2pudOURYEl1Ktb0vYWFPwLVoV3XOlFf21c=
Date:   Sat, 08 May 2021 15:51:04 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mmmemory=5Fhotplug-factor-out-adjusting-present-pages-into?=
 =?US-ASCII?Q?-adjust=5Fpresent=5Fpage=5Fcount.patch?= removed from -mm
 tree
Message-ID: <20210508225104.8ZT949YB5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: factor out adjusting present pages into adjust_present_page_count()
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-factor-out-adjusting-present-pages-into-adjust_present_page_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm,memory_hotplug: factor out adjusting present pages into adjust_present_page_count()

Let's have a single place (inspired by adjust_managed_page_count()) where
we adjust present pages.  In contrast to adjust_managed_page_count(), only
memory onlining/offlining is allowed to modify the number of present
pages.

Link: https://lkml.kernel.org/r/20210421102701.25051-4-osalvador@suse.de
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-factor-out-adjusting-present-pages-into-adjust_present_page_count
+++ a/mm/memory_hotplug.c
@@ -829,6 +829,16 @@ struct zone * zone_for_pfn_range(int onl
 	return default_zone_for_pfn(nid, start_pfn, nr_pages);
 }
 
+static void adjust_present_page_count(struct zone *zone, long nr_pages)
+{
+	unsigned long flags;
+
+	zone->present_pages += nr_pages;
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
+	zone->zone_pgdat->node_present_pages += nr_pages;
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+}
+
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
 		       int online_type, int nid)
 {
@@ -884,11 +894,7 @@ int __ref online_pages(unsigned long pfn
 	}
 
 	online_pages_range(pfn, nr_pages);
-	zone->present_pages += nr_pages;
-
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	zone->zone_pgdat->node_present_pages += nr_pages;
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+	adjust_present_page_count(zone, nr_pages);
 
 	node_states_set_node(nid, &arg);
 	if (need_zonelists_rebuild)
@@ -1706,11 +1712,7 @@ int __ref offline_pages(unsigned long st
 
 	/* removal success */
 	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
-	zone->present_pages -= nr_pages;
-
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	zone->zone_pgdat->node_present_pages -= nr_pages;
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+	adjust_present_page_count(zone, -nr_pages);
 
 	init_per_zone_wmark_min();
 
_

Patches currently in -mm which might be from david@redhat.com are



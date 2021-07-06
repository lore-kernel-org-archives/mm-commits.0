Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09458C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7E8861CA0
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhGFTXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231779AbhGFTXI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78A0B61C9A;
        Tue,  6 Jul 2021 19:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599228;
        bh=BaBa9eKcVztgiS7nzzaUPf/kXmcf5yCNnlZlc0qkBMM=;
        h=Date:From:To:Subject:From;
        b=nlB1jpWjQSXrKmuCAmUsYjbJUOhziZesL8PSO80ZYPLJVP4qQIAEFt9XyTt80nkDa
         w5AopY7Oi+TNiz4neK2LUy8b5AeHGhzUhXfpket9mOhEdS/1ABhHzE8/m4VzTVltpO
         2gh462lL9lkq5bSGMLU/iCrxDAPXoUs0sjP9Z3jo=
Date:   Tue, 06 Jul 2021 12:20:28 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [merged] mmmemory_hotplug-drop-unneeded-locking.patch
 removed from -mm tree
Message-ID: <20210706192028.86vOGFng5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: drop unneeded locking
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-drop-unneeded-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_hotplug: drop unneeded locking

Currently, memory-hotplug code takes zone's span_writelock and pgdat's
resize_lock when resizing the node/zone's spanned pages via
{move_pfn_range_to_zone(),remove_pfn_range_from_zone()} and when resizing
node and zone's present pages via adjust_present_page_count().

These locks are also taken during the initialization of the system at boot
time, where it protects parallel struct page initialization, but they
should not really be needed in memory-hotplug where all operations are a)
synchronized on device level and b) serialized by the mem_hotplug_lock
lock.

[akpm@linux-foundation.org: remove now-unused locals]
Link: https://lkml.kernel.org/r/20210531093958.15021-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-drop-unneeded-locking
+++ a/mm/memory_hotplug.c
@@ -329,7 +329,6 @@ static void shrink_zone_span(struct zone
 	unsigned long pfn;
 	int nid = zone_to_nid(zone);
 
-	zone_span_writelock(zone);
 	if (zone->zone_start_pfn == start_pfn) {
 		/*
 		 * If the section is smallest section in the zone, it need
@@ -362,7 +361,6 @@ static void shrink_zone_span(struct zone
 			zone->spanned_pages = 0;
 		}
 	}
-	zone_span_writeunlock(zone);
 }
 
 static void update_pgdat_span(struct pglist_data *pgdat)
@@ -399,7 +397,7 @@ void __ref remove_pfn_range_from_zone(st
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	unsigned long pfn, cur_nr_pages, flags;
+	unsigned long pfn, cur_nr_pages;
 
 	/* Poison struct pages because they are now uninitialized again. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
@@ -424,10 +422,8 @@ void __ref remove_pfn_range_from_zone(st
 
 	clear_zone_contiguous(zone);
 
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
 	set_zone_contiguous(zone);
 }
@@ -634,19 +630,13 @@ void __ref move_pfn_range_to_zone(struct
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
-	unsigned long flags;
 
 	clear_zone_contiguous(zone);
 
-	/* TODO Huh pgdat is irqsave while zone is not. It used to be like that before */
-	pgdat_resize_lock(pgdat, &flags);
-	zone_span_writelock(zone);
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
 	resize_zone_range(zone, start_pfn, nr_pages);
-	zone_span_writeunlock(zone);
 	resize_pgdat_range(pgdat, start_pfn, nr_pages);
-	pgdat_resize_unlock(pgdat, &flags);
 
 	/*
 	 * Subsection population requires care in pfn_to_online_page().
@@ -736,12 +726,8 @@ struct zone *zone_for_pfn_range(int onli
  */
 void adjust_present_page_count(struct zone *zone, long nr_pages)
 {
-	unsigned long flags;
-
 	zone->present_pages += nr_pages;
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	zone->zone_pgdat->node_present_pages += nr_pages;
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
 
 int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
_

Patches currently in -mm which might be from osalvador@suse.de are



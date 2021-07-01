Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDD1C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62EC61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238494AbhGABzR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B187D61241;
        Thu,  1 Jul 2021 01:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104367;
        bh=mjkNQm7rxwA+vLTC+sk6AtUNMVSW2ID/DtgskL/YYF0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kDoHjj2jeM2BO36go2AUAiEKc3DOOR1Fc4O1i67XQv1oU9hNJ/3JZOp2T+lTQqeal
         z177Bhssar169fD504rKZxo271idGSX8e1KDWVtF1Io5cygz6n2KF90YL8TLVtGDCv
         h1NfGCcHbeXyZcWtM6zmjViLT+b/Qipc2GLwByZ0=
Date:   Wed, 30 Jun 2021 18:52:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 104/192] mm,memory_hotplug: drop unneeded locking
Message-ID: <20210701015246.RMwpXg9uK%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41770C47080
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFBC6135A
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhEaVun (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230433AbhEaVun (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A833561008;
        Mon, 31 May 2021 21:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622497742;
        bh=t4wAWDjch/Z2vv74Ow0F/M4rAW2tHNItkxGqJ5c+WW4=;
        h=Date:From:To:Subject:From;
        b=TqSFvjX46OePROnS61e8NmeXt2wARHNWxVTGJKK3kxY2pUXCreJ8iy8HbAkrFqEsE
         qTUubTgO9oj4nfE0g/WP5eOja5cmoU0+PbhzBrvUFHNHenzRD7cfXq2QIktFF7aPow
         R1XQDDZZB6ulOS9cQXa7Y3HLvKhkyKmFM5SxwKdo=
Date:   Mon, 31 May 2021 14:49:02 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  + mmmemory_hotplug-drop-unneeded-locking.patch added to
 -mm tree
Message-ID: <20210531214902.2bVtCoKzQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: drop unneeded locking
has been added to the -mm tree.  Its filename is
     mmmemory_hotplug-drop-unneeded-locking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmemory_hotplug-drop-unneeded-locking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmemory_hotplug-drop-unneeded-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20210531093958.15021-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 -----------
 1 file changed, 11 deletions(-)

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
@@ -424,10 +422,8 @@ void __ref remove_pfn_range_from_zone(st
 
 	clear_zone_contiguous(zone);
 
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
 	set_zone_contiguous(zone);
 }
@@ -638,15 +634,10 @@ void __ref move_pfn_range_to_zone(struct
 
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
@@ -739,9 +730,7 @@ void adjust_present_page_count(struct zo
 	unsigned long flags;
 
 	zone->present_pages += nr_pages;
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	zone->zone_pgdat->node_present_pages += nr_pages;
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
 
 int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
_

Patches currently in -mm which might be from osalvador@suse.de are

mmmemory_hotplug-drop-unneeded-locking.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61054C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBEF61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWwA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWwA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB1896144F;
        Sat,  8 May 2021 22:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514258;
        bh=4KxeEJu/3lKnmViH63K988EyvqSsPvWdSKjcVyqr+uY=;
        h=Date:From:To:Subject:From;
        b=TPnbHCzHStUNuHFLuEhRvklcf8ah3Y1NicQHOZIIcfKFCtq1LTUyuq+e77gc8/5gZ
         sQC3uu/RCjNwo5RmUjjqQdZOFNPUkKIRGqRCBhRVKnvUeo7LIec3dRMZtOzy58yrBv
         hc+rAHL8ebT33fQsZL6YGGRCevx5/LRhazVHfI3U=
Date:   Sat, 08 May 2021 15:50:57 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, david@redhat.com,
        mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-make-unpopulated-zones-pcp-structures?=
 =?US-ASCII?Q?-unreachable-during-hot-remove.patch?= removed from -mm tree
Message-ID: <20210508225057.5AubXj45K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove broken locking of zone PCP structures during hot remove
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/memory_hotplug: remove broken locking of zone PCP structures during hot remove

zone_pcp_reset allegedly protects against a race with drain_pages using
local_irq_save but this is bogus.  local_irq_save only operates on the
local CPU.  If memory hotplug is running on CPU A and drain_pages is
running on CPU B, disabling IRQs on CPU A does not affect CPU B and offers
no protection.

This patch deletes IRQ disable/enable on the grounds that IRQs protect
nothing and assumes the existing hotplug paths guarantees the PCP cannot
be used after zone_pcp_enable().  That should be the case already because
all the pages have been freed and there is no page to put on the PCP
lists.

Link: https://lkml.kernel.org/r/20210412090346.GQ3697@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/page_alloc.c~mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove
+++ a/mm/page_alloc.c
@@ -9020,12 +9020,9 @@ void zone_pcp_enable(struct zone *zone)
 
 void zone_pcp_reset(struct zone *zone)
 {
-	unsigned long flags;
 	int cpu;
 	struct per_cpu_pageset *pset;
 
-	/* avoid races with drain_pages()  */
-	local_irq_save(flags);
 	if (zone->pageset != &boot_pageset) {
 		for_each_online_cpu(cpu) {
 			pset = per_cpu_ptr(zone->pageset, cpu);
@@ -9034,7 +9031,6 @@ void zone_pcp_reset(struct zone *zone)
 		free_percpu(zone->pageset);
 		zone->pageset = &boot_pageset;
 	}
-	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
_

Patches currently in -mm which might be from mgorman@techsingularity.net are



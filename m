Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9782BC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E4C361425
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhEEBk1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhEEBk0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E28A761423;
        Wed,  5 May 2021 01:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178771;
        bh=Xw7PAsF1mSxWOd9Jrif8UNsjX5SowXA0SiWbJq8e0FI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lnJJXYt+vK0yhsazjeoVLY7wJL/Gzrkuigzw2uReGw8Buo2Srcyhgz1Engs2p5IFo
         OtuA2+wJa4k6uLkrZ87YQfrGK2qofvz3VEoMjLlyrAyAvXscsRF9WO5j+w+lqTW9UM
         PuqA7jNahxruNdWXTeoCIdLUZ0ePUSvoju0ZsobA=
Date:   Tue, 04 May 2021 18:39:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        david@redhat.com, linux-mm@kvack.org, mgorman@techsingularity.net,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        mst@redhat.com, osalvador@suse.de, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 124/143] mm/memory_hotplug: remove broken locking
 of zone PCP structures during hot remove
Message-ID: <20210505013930.bzriZCvbx%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

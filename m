Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A549C43462
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA0661413
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbhEMAbF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242316AbhEMAar (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:30:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1430461396;
        Thu, 13 May 2021 00:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620865778;
        bh=Y7/YvlygF45s1z63SbPh6UAUtbY2ZcfdV+jPKOm1Mgw=;
        h=Date:From:To:Subject:From;
        b=Atc8e31uu1Tg+RPxRBZwgewE5x44USOvANcIKWcdDJCLdaiFPvKRTwOlpG2J2PfU3
         p6jdRYhtPpxXg2OVJxoW0jKkL7BvHggcnyKMkS1D5LTozbPY+EHQFj3ZnrgPXoM3iE
         hGkq11MZJffyYjDm40niqXkK6i3ucbqvyWPJ3K44=
Date:   Wed, 12 May 2021 17:29:37 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
 added to -mm tree
Message-ID: <20210513002937.6fe4OWFzc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: reduce duration that IRQs are disabled for VM counters
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: reduce duration that IRQs are disabled for VM counters

IRQs are left disabled for the zone and node VM event counters.  This is
unnecessary as the affected counters are allowed to race for preemmption
and IRQs.

This patch reduces the scope of IRQs being disabled via
local_[lock|unlock]_irq on !PREEMPT_RT kernels.  One
__mod_zone_freepage_state is still called with IRQs disabled.  While this
could be moved out, it's not free on all architectures as some require
IRQs to be disabled for mod_zone_page_state on !PREEMPT_RT kernels.

Link: https://lkml.kernel.org/r/20210512095458.30632-7-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters
+++ a/mm/page_alloc.c
@@ -3519,11 +3519,11 @@ static struct page *rmqueue_pcplist(stru
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list = &pcp->lists[migratetype];
 	page = __rmqueue_pcplist(zone,  migratetype, alloc_flags, pcp, list);
+	local_unlock_irqrestore(&pagesets.lock, flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
 		zone_statistics(preferred_zone, zone, 1);
 	}
-	local_unlock_irqrestore(&pagesets.lock, flags);
 	return page;
 }
 
@@ -3575,15 +3575,15 @@ struct page *rmqueue(struct zone *prefer
 		if (!page)
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
 	} while (page && check_new_pages(page, order));
-	spin_unlock(&zone->lock);
 	if (!page)
 		goto failed;
+
 	__mod_zone_freepage_state(zone, -(1 << order),
 				  get_pcppage_migratetype(page));
+	spin_unlock_irqrestore(&zone->lock, flags);
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, 1);
-	local_irq_restore(flags);
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3596,7 +3596,7 @@ out:
 	return page;
 
 failed:
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&zone->lock, flags);
 	return NULL;
 }
 
@@ -5147,11 +5147,11 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		nr_populated++;
 	}
 
+	local_unlock_irqrestore(&pagesets.lock, flags);
+
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
 
-	local_unlock_irqrestore(&pagesets.lock, flags);
-
 	return nr_populated;
 
 failed_irq:
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch


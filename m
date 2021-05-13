Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089D0C43603
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0A1613CA
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhEMAbG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242898AbhEMAbB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:31:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263BB613CA;
        Thu, 13 May 2021 00:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620865782;
        bh=ERUGKFoWpIFrODUuUL0kr3xIfKngbSaiURyI7nBrIFU=;
        h=Date:From:To:Subject:From;
        b=cZmdCqYl1bmgsT4cRryvxIQ5ID5Q0qm7Z1t2A1Q2RumuBKQpQO9VLtZ49Yd3g+/AX
         EOKpjA2q+AHIyhrSDR/rZRVTAf+AnsLxJoCtQ06AmHovRRCz3u+ptoVisM8d2+b/T5
         5FmJpNehraWEV0urOG/WiPUX/gdiRPLb9lHAl9VA=
Date:   Wed, 12 May 2021 17:29:41 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
 added to -mm tree
Message-ID: <20210513002941.7fh0CbD92%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: explicitly acquire the zone lock in __free_pages_ok
has been added to the -mm tree.  Its filename is
     mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch

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
Subject: mm/page_alloc: explicitly acquire the zone lock in __free_pages_ok

__free_pages_ok() disables IRQs before calling a common helper
free_one_page() that acquires the zone lock.  This is not safe according
to Documentation/locking/locktypes.rst and in this context, IRQ disabling
is not protecting a per_cpu_pages structure either or a local_lock would
be used.

This patch explicitly acquires the lock with spin_lock_irqsave instead of
relying on a helper.  This removes the last instance of local_irq_save()
in page_alloc.c.

Link: https://lkml.kernel.org/r/20210512095458.30632-8-mgorman@techsingularity.net
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

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok
+++ a/mm/page_alloc.c
@@ -1579,21 +1579,21 @@ static void __free_pages_ok(struct page
 	unsigned long flags;
 	int migratetype;
 	unsigned long pfn = page_to_pfn(page);
+	struct zone *zone = page_zone(page);
 
 	if (!free_pages_prepare(page, order, true, fpi_flags))
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
 
-	/*
-	 * TODO FIX: Disable IRQs before acquiring IRQ-safe zone->lock
-	 * and protect vmstat updates.
-	 */
-	local_irq_save(flags);
+	spin_lock_irqsave(&zone->lock, flags);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, pfn, order, migratetype,
-		      fpi_flags);
-	local_irq_restore(flags);
+	if (unlikely(has_isolate_pageblock(zone) ||
+		is_migrate_isolate(migratetype))) {
+		migratetype = get_pfnblock_migratetype(page, pfn);
+	}
+	__free_one_page(page, pfn, zone, order, migratetype, fpi_flags);
+	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 void __free_pages_core(struct page *page, unsigned int order)
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


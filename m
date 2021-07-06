Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE09EC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C65860C3D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhGFTRa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231693AbhGFTR3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BEAE60FDB;
        Tue,  6 Jul 2021 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598890;
        bh=7AK6/K8Wak0CqyRXUaKLc+J2MyTsOjYMkPeWS2FGBUw=;
        h=Date:From:To:Subject:From;
        b=VxdoiUvWem+NOGUxKM2Xn/m74JEk0Oohag6QXA5/I3wuVnWP6a7Zfj9TEcOZFXtXS
         V2gu0dHPZUhnpShCIMb6eE536ZxZf521/7f22Fz4cxR37okV8QNms0SCUI2Y0CRsPq
         F4fHYhUh+V+OpRFQ7ZuUZEpOJF8oaqLhiEca3Z74=
Date:   Tue, 06 Jul 2021 12:14:50 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
 removed from -mm tree
Message-ID: <20210706191450.dvax2ucWs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: update PGFREE outside the zone lock in __free_pages_ok
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: update PGFREE outside the zone lock in __free_pages_ok

VM events do not need explicit protection by disabling IRQs so update the
counter with IRQs enabled in __free_pages_ok.

Link: https://lkml.kernel.org/r/20210512095458.30632-10-mgorman@techsingularity.net
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

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok
+++ a/mm/page_alloc.c
@@ -1600,13 +1600,14 @@ static void __free_pages_ok(struct page
 	migratetype = get_pfnblock_migratetype(page, pfn);
 
 	spin_lock_irqsave(&zone->lock, flags);
-	__count_vm_events(PGFREE, 1 << order);
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
 	__free_one_page(page, pfn, zone, order, migratetype, fpi_flags);
 	spin_unlock_irqrestore(&zone->lock, flags);
+
+	__count_vm_events(PGFREE, 1 << order);
 }
 
 void __free_pages_core(struct page *page, unsigned int order)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541CFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 23:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359510AbiELXdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 19:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357948AbiELXdS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 19:33:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4688E60078
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 16:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0938BB80CD2
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 23:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6F9C385B8;
        Thu, 12 May 2022 23:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652398394;
        bh=2AuBv8Mciof/AaE+QeEmm3tl6HxpdDe2CG777qQAI9w=;
        h=Date:To:From:Subject:From;
        b=pLpoYm1C/PPk+bJSywGSch9gH2S7be3RbDKEHd9qtbav39GGsF8yxiirFnJNVUbue
         YQ1ulzGtp8v6Iyf0vLEQK2p/KXKq4YXWKaY8b5vFtHE9Q6v4Zap6KBMUHUhQ1F1s1C
         hot4vxjjVy+5d1hhHzJHSSxtlCW9UgmV9AMbsk7s=
Date:   Thu, 12 May 2022 16:33:13 -0700
To:     mm-commits@vger.kernel.org, taeung@reallinux.co.kr,
        rostedt@goodmis.org, mingo@redhat.com, mgorman@suse.de,
        linuxgeek@linuxgeek.io, kimhy@etri.re.kr, bsahn@etri.re.kr,
        vvghjk1234@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-tracepoint-mm_page_alloc_zone_locked.patch added to mm-unstable branch
Message-Id: <20220512233314.8C6F9C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix tracepoint mm_page_alloc_zone_locked()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-tracepoint-mm_page_alloc_zone_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-tracepoint-mm_page_alloc_zone_locked.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wonhyuk Yang <vvghjk1234@gmail.com>
Subject: mm/page_alloc: fix tracepoint mm_page_alloc_zone_locked()

Currently, trace point mm_page_alloc_zone_locked() doesn't show correct
information.

First, when alloc_flag has ALLOC_HARDER/ALLOC_CMA, page can be allocated
from MIGRATE_HIGHATOMIC/MIGRATE_CMA.  Nevertheless, tracepoint use
requested migration type not MIGRATE_HIGHATOMIC and MIGRATE_CMA.

Second, after commit 44042b4498728 ("mm/page_alloc: allow high-order pages
to be stored on the per-cpu lists") percpu-list can store high order
pages.  But trace point determine whether it is a refiil of percpu-list by
comparing requested order and 0.

To handle these problems, make mm_page_alloc_zone_locked() only be called
by __rmqueue_smallest with correct migration type.  With a new argument
called percpu_refill, it can show roughly whether it is a refill of
percpu-list.

Link: https://lkml.kernel.org/r/20220512025307.57924-1-vvghjk1234@gmail.com
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Baik Song An <bsahn@etri.re.kr>
Cc: Hong Yeon Kim <kimhy@etri.re.kr>
Cc: Taeung Song <taeung@reallinux.co.kr>
Cc: <linuxgeek@linuxgeek.io>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   14 +++++++++-----
 mm/page_alloc.c             |   13 +++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/trace/events/kmem.h~mm-page_alloc-fix-tracepoint-mm_page_alloc_zone_locked
+++ a/include/trace/events/kmem.h
@@ -229,20 +229,23 @@ TRACE_EVENT(mm_page_alloc,
 
 DECLARE_EVENT_CLASS(mm_page,
 
-	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+	TP_PROTO(struct page *page, unsigned int order, int migratetype,
+		 int percpu_refill),
 
-	TP_ARGS(page, order, migratetype),
+	TP_ARGS(page, order, migratetype, percpu_refill),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	pfn		)
 		__field(	unsigned int,	order		)
 		__field(	int,		migratetype	)
+		__field(	int,		percpu_refill	)
 	),
 
 	TP_fast_assign(
 		__entry->pfn		= page ? page_to_pfn(page) : -1UL;
 		__entry->order		= order;
 		__entry->migratetype	= migratetype;
+		__entry->percpu_refill	= percpu_refill;
 	),
 
 	TP_printk("page=%p pfn=0x%lx order=%u migratetype=%d percpu_refill=%d",
@@ -250,14 +253,15 @@ DECLARE_EVENT_CLASS(mm_page,
 		__entry->pfn != -1UL ? __entry->pfn : 0,
 		__entry->order,
 		__entry->migratetype,
-		__entry->order == 0)
+		__entry->percpu_refill)
 );
 
 DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
 
-	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+	TP_PROTO(struct page *page, unsigned int order, int migratetype,
+		 int percpu_refill),
 
-	TP_ARGS(page, order, migratetype)
+	TP_ARGS(page, order, migratetype, percpu_refill)
 );
 
 TRACE_EVENT(mm_page_pcpu_drain,
--- a/mm/page_alloc.c~mm-page_alloc-fix-tracepoint-mm_page_alloc_zone_locked
+++ a/mm/page_alloc.c
@@ -2474,6 +2474,9 @@ struct page *__rmqueue_smallest(struct z
 		del_page_from_free_list(page, zone, current_order);
 		expand(zone, page, order, current_order, migratetype);
 		set_pcppage_migratetype(page, migratetype);
+		trace_mm_page_alloc_zone_locked(page, order, migratetype,
+				pcp_allowed_order(order) &&
+				migratetype < MIGRATE_PCPTYPES);
 		return page;
 	}
 
@@ -2997,7 +3000,7 @@ __rmqueue(struct zone *zone, unsigned in
 		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
 			page = __rmqueue_cma_fallback(zone, order);
 			if (page)
-				goto out;
+				return page;
 		}
 	}
 retry:
@@ -3010,9 +3013,6 @@ retry:
 								alloc_flags))
 			goto retry;
 	}
-out:
-	if (page)
-		trace_mm_page_alloc_zone_locked(page, order, migratetype);
 	return page;
 }
 
@@ -3673,11 +3673,8 @@ struct page *rmqueue_buddy(struct zone *
 		 * reserved for high-order atomic allocation, so order-0
 		 * request should skip it.
 		 */
-		if (order > 0 && alloc_flags & ALLOC_HARDER) {
+		if (order > 0 && alloc_flags & ALLOC_HARDER)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
-			if (page)
-				trace_mm_page_alloc_zone_locked(page, order, migratetype);
-		}
 		if (!page) {
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
 			if (!page) {
_

Patches currently in -mm which might be from vvghjk1234@gmail.com are

mm-page_alloc-cache-the-result-of-node_dirty_ok.patch
mm-page_alloc-fix-tracepoint-mm_page_alloc_zone_locked.patch


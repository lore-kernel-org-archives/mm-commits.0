Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2570C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 18:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0FF7619EC
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 18:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbhCXS5S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237703AbhCXS4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 14:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93CDD61A0A;
        Wed, 24 Mar 2021 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616612205;
        bh=PE7VKJJvzvLEaTRaKEckG5TtzKRCcChnS/1I8gpavZo=;
        h=Date:From:To:Subject:From;
        b=mBYhhmebxvcZkkXt+qHxxN1W+xgfMTCNfUeP/eSfy1ZmO5BFxqGCjbs3uZSQbcvL1
         pGjlMzFg0IPwq8GzsilaTWe4pllT4RNFMg77PzpctSW/OffXcjTYl1bm4Vgc/tXZJr
         eLPYlMn1orr0GLhYkQ8xCi9i1GOnRP4j2SyqNg0s=
Date:   Wed, 24 Mar 2021 11:56:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        georgi.djakov@linaro.org, lmark@codeaurora.org
Subject:  + mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch
 added to -mm tree
Message-ID: <20210324185645.hWFpW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: add trace events for CMA alloc perf testing
has been added to the -mm tree.  Its filename is
     mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Mark <lmark@codeaurora.org>
Subject: mm: cma: add trace events for CMA alloc perf testing

Add cma and migrate trace events to enable CMA allocation performance to
be measured via ftrace.

Link: https://lkml.kernel.org/r/20210324160740.15901-1-georgi.djakov@linaro.org
Signed-off-by: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h     |   39 ++++++++++++++++++++++++++++++-
 include/trace/events/migrate.h |   22 +++++++++++++++++
 mm/cma.c                       |    4 +++
 mm/migrate.c                   |    2 +
 4 files changed, 66 insertions(+), 1 deletion(-)

--- a/include/trace/events/cma.h~mm-cma-add-trace-events-for-cma-alloc-perf-testing
+++ a/include/trace/events/cma.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(cma_alloc,
+DECLARE_EVENT_CLASS(cma_alloc_class,
 
 	TP_PROTO(unsigned long pfn, const struct page *page,
 		 unsigned int count, unsigned int align),
@@ -61,6 +61,43 @@ TRACE_EVENT(cma_release,
 		  __entry->count)
 );
 
+TRACE_EVENT(cma_alloc_start,
+
+	TP_PROTO(unsigned int count, unsigned int align),
+
+	TP_ARGS(count, align),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, count)
+		__field(unsigned int, align)
+	),
+
+	TP_fast_assign(
+		__entry->count = count;
+		__entry->align = align;
+	),
+
+	TP_printk("count=%u align=%u",
+		  __entry->count,
+		  __entry->align)
+);
+
+DEFINE_EVENT(cma_alloc_class, cma_alloc,
+
+	TP_PROTO(unsigned long pfn, const struct page *page,
+		 unsigned int count, unsigned int align),
+
+	TP_ARGS(pfn, page, count, align)
+);
+
+DEFINE_EVENT(cma_alloc_class, cma_alloc_busy_retry,
+
+	TP_PROTO(unsigned long pfn, const struct page *page,
+		 unsigned int count, unsigned int align),
+
+	TP_ARGS(pfn, page, count, align)
+);
+
 #endif /* _TRACE_CMA_H */
 
 /* This part must be outside protection */
--- a/include/trace/events/migrate.h~mm-cma-add-trace-events-for-cma-alloc-perf-testing
+++ a/include/trace/events/migrate.h
@@ -81,6 +81,28 @@ TRACE_EVENT(mm_migrate_pages,
 		__print_symbolic(__entry->mode, MIGRATE_MODE),
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
+
+TRACE_EVENT(mm_migrate_pages_start,
+
+	TP_PROTO(enum migrate_mode mode, int reason),
+
+	TP_ARGS(mode, reason),
+
+	TP_STRUCT__entry(
+		__field(enum migrate_mode, mode)
+		__field(int, reason)
+	),
+
+	TP_fast_assign(
+		__entry->mode	= mode;
+		__entry->reason	= reason;
+	),
+
+	TP_printk("mode=%s reason=%s",
+		  __print_symbolic(__entry->mode, MIGRATE_MODE),
+		  __print_symbolic(__entry->reason, MIGRATE_REASON))
+);
+
 #endif /* _TRACE_MIGRATE_H */
 
 /* This part must be outside protection */
--- a/mm/cma.c~mm-cma-add-trace-events-for-cma-alloc-perf-testing
+++ a/mm/cma.c
@@ -443,6 +443,8 @@ struct page *cma_alloc(struct cma *cma,
 	if (!count)
 		goto out;
 
+	trace_cma_alloc_start(count, align);
+
 	mask = cma_bitmap_aligned_mask(cma, align);
 	offset = cma_bitmap_aligned_offset(cma, align);
 	bitmap_maxno = cma_bitmap_maxno(cma);
@@ -483,6 +485,8 @@ struct page *cma_alloc(struct cma *cma,
 
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
 			 __func__, pfn_to_page(pfn));
+
+		trace_cma_alloc_busy_retry(pfn, pfn_to_page(pfn), count, align);
 		/* try again with a bit different memory target */
 		start = bitmap_no + mask + 1;
 	}
--- a/mm/migrate.c~mm-cma-add-trace-events-for-cma-alloc-perf-testing
+++ a/mm/migrate.c
@@ -1423,6 +1423,8 @@ int migrate_pages(struct list_head *from
 	int rc, nr_subpages;
 	LIST_HEAD(ret_pages);
 
+	trace_mm_migrate_pages_start(mode, reason);
+
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
 
_

Patches currently in -mm which might be from lmark@codeaurora.org are

mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch


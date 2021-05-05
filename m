Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDACC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8029261423
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhEEBiV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhEEBiV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B6861029;
        Wed,  5 May 2021 01:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178645;
        bh=4vZkYpPE9GdhDRF2LEEn46CgA+WjBzcAMGJDT4QO6XE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sajz69QeB2UfB+B4MP3scwrrpKQVuDlgxeHGzUepGj30mqW6z67qsbYZ6IQfsvQc+
         /tbisW/w9t9ueSPAvgeijZ6S/xdXiWX7TfxCwxGww6PJxcj1LJne9IdrH7yE3+fH7F
         IVa1C7vtgRHEIE1jISQsHkQVvhmQwUmN9PK1o4eA=
Date:   Tue, 04 May 2021 18:37:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, georgi.djakov@linaro.org,
        linux-mm@kvack.org, lmark@codeaurora.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 087/143] mm: cma: add trace events for CMA alloc
 perf testing
Message-ID: <20210505013725.SyyMxbyuR%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Mark <lmark@codeaurora.org>
Subject: mm: cma: add trace events for CMA alloc perf testing

Add cma and migrate trace events to enable CMA allocation performance to
be measured via ftrace.

[georgi.djakov@linaro.org: add the CMA instance name to the cma_alloc_start trace event]
  Link: https://lkml.kernel.org/r/20210326155414.25006-1-georgi.djakov@linaro.org
Link: https://lkml.kernel.org/r/20210324160740.15901-1-georgi.djakov@linaro.org
Signed-off-by: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h     |   42 ++++++++++++++++++++++++++++++-
 include/trace/events/migrate.h |   22 ++++++++++++++++
 mm/cma.c                       |    4 ++
 mm/migrate.c                   |    2 +
 4 files changed, 69 insertions(+), 1 deletion(-)

--- a/include/trace/events/cma.h~mm-cma-add-trace-events-for-cma-alloc-perf-testing
+++ a/include/trace/events/cma.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(cma_alloc,
+DECLARE_EVENT_CLASS(cma_alloc_class,
 
 	TP_PROTO(unsigned long pfn, const struct page *page,
 		 unsigned int count, unsigned int align),
@@ -61,6 +61,46 @@ TRACE_EVENT(cma_release,
 		  __entry->count)
 );
 
+TRACE_EVENT(cma_alloc_start,
+
+	TP_PROTO(const char *name, unsigned int count, unsigned int align),
+
+	TP_ARGS(name, count, align),
+
+	TP_STRUCT__entry(
+		__string(name, name)
+		__field(unsigned int, count)
+		__field(unsigned int, align)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->count = count;
+		__entry->align = align;
+	),
+
+	TP_printk("name=%s count=%u align=%u",
+		  __get_str(name),
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
 
+	trace_cma_alloc_start(cma->name, count, align);
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
@@ -1418,6 +1418,8 @@ int migrate_pages(struct list_head *from
 	int rc, nr_subpages;
 	LIST_HEAD(ret_pages);
 
+	trace_mm_migrate_pages_start(mode, reason);
+
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
 
_

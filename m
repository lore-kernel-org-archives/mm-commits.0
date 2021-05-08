Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F94C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E496613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWu1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWu0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92B0C6100C;
        Sat,  8 May 2021 22:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514164;
        bh=voT9u4s817yXZuiQXoBKguRFAKV/Z4XbyOU6Aw36cJQ=;
        h=Date:From:To:Subject:From;
        b=qiybd+G1oXFRcLrS4oY7DrOjY7b0Y3sKk/MxcbIObMqloZ8LwmpvoNxmVuglMPTV3
         IQRkJlg9fzgL0pa2f1kr+pKgQRBeZTOHFS2BHGgqRDYUM1SOY+UyIN/k+XhBnjskyr
         FPYBTYF01+exveFLxVXf9DsHg3cd1sPQcmOULoqo=
Date:   Sat, 08 May 2021 15:49:24 -0700
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, lmark@codeaurora.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch removed from -mm
 tree
Message-ID: <20210508224924.j463Gr2gW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: add trace events for CMA alloc perf testing
has been removed from the -mm tree.  Its filename was
     mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from lmark@codeaurora.org are



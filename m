Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EB3C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C1361182
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhEEBi2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A30AF61029;
        Wed,  5 May 2021 01:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178651;
        bh=u0G7TADonYU++VAOHKcervEkj+U2+20M4XdZ2up7oGA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JrBwdPq13pchAn215lhgiTDSUaNjMxVh5wxkGDgQ39sr/2j7dij0GlmiVI5XNGcLS
         hu9qa5u7rP+dDE9y1Sr3gnh6ahAAbS26g4TJVC74O6opOFR+1Xd9+w6xxMXuIXmWM8
         jocXLFTPIHNt4qaGiNlC8j/5X+e6uVeTtM3X7FjM=
Date:   Tue, 04 May 2021 18:37:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, georgi.djakov@linaro.org,
        linux-mm@kvack.org, lmark@codeaurora.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 089/143] mm: cma: add the CMA instance name to cma
 trace events
Message-ID: <20210505013731.vo47JRB4e%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: cma: add the CMA instance name to cma trace events

There were missing places to add cma instance name.  To identify each CMA
instance, let's add the name for every cma trace.  This patch also changes
the existing cma_trace_alloc to cma_trace_finish since we have
cma_alloc_start[1].

[1] https://lore.kernel.org/linux-mm/20210324160740.15901-1-georgi.djakov@linaro.org

Link: https://lkml.kernel.org/r/20210330220237.748899-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Liam Mark <lmark@codeaurora.org>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h |   28 +++++++++++++++++-----------
 mm/cma.c                   |    7 ++++---
 2 files changed, 21 insertions(+), 14 deletions(-)

--- a/include/trace/events/cma.h~mm-cma-add-the-cma-instance-name-to-cma-trace-events
+++ a/include/trace/events/cma.h
@@ -10,12 +10,13 @@
 
 DECLARE_EVENT_CLASS(cma_alloc_class,
 
-	TP_PROTO(unsigned long pfn, const struct page *page,
+	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
 		 unsigned int count, unsigned int align),
 
-	TP_ARGS(pfn, page, count, align),
+	TP_ARGS(name, pfn, page, count, align),
 
 	TP_STRUCT__entry(
+		__string(name, name)
 		__field(unsigned long, pfn)
 		__field(const struct page *, page)
 		__field(unsigned int, count)
@@ -23,13 +24,15 @@ DECLARE_EVENT_CLASS(cma_alloc_class,
 	),
 
 	TP_fast_assign(
+		__assign_str(name, name);
 		__entry->pfn = pfn;
 		__entry->page = page;
 		__entry->count = count;
 		__entry->align = align;
 	),
 
-	TP_printk("pfn=%lx page=%p count=%u align=%u",
+	TP_printk("name=%s pfn=%lx page=%p count=%u align=%u",
+		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
 		  __entry->count,
@@ -38,24 +41,27 @@ DECLARE_EVENT_CLASS(cma_alloc_class,
 
 TRACE_EVENT(cma_release,
 
-	TP_PROTO(unsigned long pfn, const struct page *page,
+	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
 		 unsigned int count),
 
-	TP_ARGS(pfn, page, count),
+	TP_ARGS(name, pfn, page, count),
 
 	TP_STRUCT__entry(
+		__string(name, name)
 		__field(unsigned long, pfn)
 		__field(const struct page *, page)
 		__field(unsigned int, count)
 	),
 
 	TP_fast_assign(
+		__assign_str(name, name);
 		__entry->pfn = pfn;
 		__entry->page = page;
 		__entry->count = count;
 	),
 
-	TP_printk("pfn=%lx page=%p count=%u",
+	TP_printk("name=%s pfn=%lx page=%p count=%u",
+		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
 		  __entry->count)
@@ -85,20 +91,20 @@ TRACE_EVENT(cma_alloc_start,
 		  __entry->align)
 );
 
-DEFINE_EVENT(cma_alloc_class, cma_alloc,
+DEFINE_EVENT(cma_alloc_class, cma_alloc_finish,
 
-	TP_PROTO(unsigned long pfn, const struct page *page,
+	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
 		 unsigned int count, unsigned int align),
 
-	TP_ARGS(pfn, page, count, align)
+	TP_ARGS(name, pfn, page, count, align)
 );
 
 DEFINE_EVENT(cma_alloc_class, cma_alloc_busy_retry,
 
-	TP_PROTO(unsigned long pfn, const struct page *page,
+	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
 		 unsigned int count, unsigned int align),
 
-	TP_ARGS(pfn, page, count, align)
+	TP_ARGS(name, pfn, page, count, align)
 );
 
 #endif /* _TRACE_CMA_H */
--- a/mm/cma.c~mm-cma-add-the-cma-instance-name-to-cma-trace-events
+++ a/mm/cma.c
@@ -486,12 +486,13 @@ struct page *cma_alloc(struct cma *cma,
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
 			 __func__, pfn_to_page(pfn));
 
-		trace_cma_alloc_busy_retry(pfn, pfn_to_page(pfn), count, align);
+		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
+					   count, align);
 		/* try again with a bit different memory target */
 		start = bitmap_no + mask + 1;
 	}
 
-	trace_cma_alloc(pfn, page, count, align);
+	trace_cma_alloc_finish(cma->name, pfn, page, count, align);
 
 	/*
 	 * CMA can allocate multiple page blocks, which results in different
@@ -551,7 +552,7 @@ bool cma_release(struct cma *cma, const
 
 	free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, pfn, count);
-	trace_cma_release(pfn, pages, count);
+	trace_cma_release(cma->name, pfn, pages, count);
 
 	return true;
 }
_

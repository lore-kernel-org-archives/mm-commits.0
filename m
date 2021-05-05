Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FABC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBC0361421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhEEBia (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBia (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE9261029;
        Wed,  5 May 2021 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178654;
        bh=WxjQewgXrhmSOncZ4rZ8FkAHNjuF6mrpgocWdR8bc18=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z1TFDqkZO8adx4RkMGZgYRG61PTM/ZANmHyp6OaWkFzp8LJcd5UGeZl+3bHSR8/4V
         UOM6rfjqff9dwCYwXA9gy/k/q7y7XrVZKU+oxj8wMZPswZbxulJOoN+1XXih0WZ0hP
         0Q7WVXjfo1pAkPYCkNvKploystbUE+YbmkPx0714=
Date:   Tue, 04 May 2021 18:37:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 090/143] mm: use proper type for
 cma_[alloc|release]
Message-ID: <20210505013734.4M0QUjeb9%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: use proper type for cma_[alloc|release]

size_t in cma_alloc is confusing since it makes people think it's byte
count, not pages.  Change it to unsigned long[1].

The unsigned int in cma_release is also not right so change it.  Since we
have unsigned long in cma_release, free_contig_range should also respect
it.

[1] 67a2e213e7e9, mm: cma: fix incorrect type conversion for size during dma allocation

Link: https://lore.kernel.org/linux-mm/20210324043434.GP1719932@casper.infradead.org/
Link: https://lkml.kernel.org/r/20210331164018.710560-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h        |    4 ++--
 include/linux/gfp.h        |    2 +-
 include/trace/events/cma.h |   22 +++++++++++-----------
 mm/cma.c                   |   17 +++++++++--------
 mm/page_alloc.c            |    6 +++---
 5 files changed, 26 insertions(+), 25 deletions(-)

--- a/include/linux/cma.h~mm-use-proper-type-for-cma_
+++ a/include/linux/cma.h
@@ -44,9 +44,9 @@ extern int cma_init_reserved_mem(phys_ad
 					unsigned int order_per_bit,
 					const char *name,
 					struct cma **res_cma);
-extern struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align,
+extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
-extern bool cma_release(struct cma *cma, const struct page *pages, unsigned int count);
+extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
 #endif
--- a/include/linux/gfp.h~mm-use-proper-type-for-cma_
+++ a/include/linux/gfp.h
@@ -657,7 +657,7 @@ extern int alloc_contig_range(unsigned l
 extern struct page *alloc_contig_pages(unsigned long nr_pages, gfp_t gfp_mask,
 				       int nid, nodemask_t *nodemask);
 #endif
-void free_contig_range(unsigned long pfn, unsigned int nr_pages);
+void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 
 #ifdef CONFIG_CMA
 /* CMA stuff */
--- a/include/trace/events/cma.h~mm-use-proper-type-for-cma_
+++ a/include/trace/events/cma.h
@@ -11,7 +11,7 @@
 DECLARE_EVENT_CLASS(cma_alloc_class,
 
 	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
-		 unsigned int count, unsigned int align),
+		 unsigned long count, unsigned int align),
 
 	TP_ARGS(name, pfn, page, count, align),
 
@@ -19,7 +19,7 @@ DECLARE_EVENT_CLASS(cma_alloc_class,
 		__string(name, name)
 		__field(unsigned long, pfn)
 		__field(const struct page *, page)
-		__field(unsigned int, count)
+		__field(unsigned long, count)
 		__field(unsigned int, align)
 	),
 
@@ -31,7 +31,7 @@ DECLARE_EVENT_CLASS(cma_alloc_class,
 		__entry->align = align;
 	),
 
-	TP_printk("name=%s pfn=%lx page=%p count=%u align=%u",
+	TP_printk("name=%s pfn=%lx page=%p count=%lu align=%u",
 		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
@@ -42,7 +42,7 @@ DECLARE_EVENT_CLASS(cma_alloc_class,
 TRACE_EVENT(cma_release,
 
 	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
-		 unsigned int count),
+		 unsigned long count),
 
 	TP_ARGS(name, pfn, page, count),
 
@@ -50,7 +50,7 @@ TRACE_EVENT(cma_release,
 		__string(name, name)
 		__field(unsigned long, pfn)
 		__field(const struct page *, page)
-		__field(unsigned int, count)
+		__field(unsigned long, count)
 	),
 
 	TP_fast_assign(
@@ -60,7 +60,7 @@ TRACE_EVENT(cma_release,
 		__entry->count = count;
 	),
 
-	TP_printk("name=%s pfn=%lx page=%p count=%u",
+	TP_printk("name=%s pfn=%lx page=%p count=%lu",
 		  __get_str(name),
 		  __entry->pfn,
 		  __entry->page,
@@ -69,13 +69,13 @@ TRACE_EVENT(cma_release,
 
 TRACE_EVENT(cma_alloc_start,
 
-	TP_PROTO(const char *name, unsigned int count, unsigned int align),
+	TP_PROTO(const char *name, unsigned long count, unsigned int align),
 
 	TP_ARGS(name, count, align),
 
 	TP_STRUCT__entry(
 		__string(name, name)
-		__field(unsigned int, count)
+		__field(unsigned long, count)
 		__field(unsigned int, align)
 	),
 
@@ -85,7 +85,7 @@ TRACE_EVENT(cma_alloc_start,
 		__entry->align = align;
 	),
 
-	TP_printk("name=%s count=%u align=%u",
+	TP_printk("name=%s count=%lu align=%u",
 		  __get_str(name),
 		  __entry->count,
 		  __entry->align)
@@ -94,7 +94,7 @@ TRACE_EVENT(cma_alloc_start,
 DEFINE_EVENT(cma_alloc_class, cma_alloc_finish,
 
 	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
-		 unsigned int count, unsigned int align),
+		 unsigned long count, unsigned int align),
 
 	TP_ARGS(name, pfn, page, count, align)
 );
@@ -102,7 +102,7 @@ DEFINE_EVENT(cma_alloc_class, cma_alloc_
 DEFINE_EVENT(cma_alloc_class, cma_alloc_busy_retry,
 
 	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
-		 unsigned int count, unsigned int align),
+		 unsigned long count, unsigned int align),
 
 	TP_ARGS(name, pfn, page, count, align)
 );
--- a/mm/cma.c~mm-use-proper-type-for-cma_
+++ a/mm/cma.c
@@ -79,7 +79,7 @@ static unsigned long cma_bitmap_pages_to
 }
 
 static void cma_clear_bitmap(struct cma *cma, unsigned long pfn,
-			     unsigned int count)
+			     unsigned long count)
 {
 	unsigned long bitmap_no, bitmap_count;
 	unsigned long flags;
@@ -423,21 +423,21 @@ static inline void cma_debug_show_areas(
  * This function allocates part of contiguous memory on specific
  * contiguous memory area.
  */
-struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align,
-		       bool no_warn)
+struct page *cma_alloc(struct cma *cma, unsigned long count,
+		       unsigned int align, bool no_warn)
 {
 	unsigned long mask, offset;
 	unsigned long pfn = -1;
 	unsigned long start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
-	size_t i;
+	unsigned long i;
 	struct page *page = NULL;
 	int ret = -ENOMEM;
 
 	if (!cma || !cma->count || !cma->bitmap)
 		goto out;
 
-	pr_debug("%s(cma %p, count %zu, align %d)\n", __func__, (void *)cma,
+	pr_debug("%s(cma %p, count %lu, align %d)\n", __func__, (void *)cma,
 		 count, align);
 
 	if (!count)
@@ -505,7 +505,7 @@ struct page *cma_alloc(struct cma *cma,
 	}
 
 	if (ret && !no_warn) {
-		pr_err_ratelimited("%s: %s: alloc failed, req-size: %zu pages, ret: %d\n",
+		pr_err_ratelimited("%s: %s: alloc failed, req-size: %lu pages, ret: %d\n",
 				   __func__, cma->name, count, ret);
 		cma_debug_show_areas(cma);
 	}
@@ -534,14 +534,15 @@ out:
  * It returns false when provided pages do not belong to contiguous area and
  * true otherwise.
  */
-bool cma_release(struct cma *cma, const struct page *pages, unsigned int count)
+bool cma_release(struct cma *cma, const struct page *pages,
+		 unsigned long count)
 {
 	unsigned long pfn;
 
 	if (!cma || !pages)
 		return false;
 
-	pr_debug("%s(page %p, count %u)\n", __func__, (void *)pages, count);
+	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
 	pfn = page_to_pfn(pages);
 
--- a/mm/page_alloc.c~mm-use-proper-type-for-cma_
+++ a/mm/page_alloc.c
@@ -8973,9 +8973,9 @@ struct page *alloc_contig_pages(unsigned
 }
 #endif /* CONFIG_CONTIG_ALLOC */
 
-void free_contig_range(unsigned long pfn, unsigned int nr_pages)
+void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
-	unsigned int count = 0;
+	unsigned long count = 0;
 
 	for (; nr_pages--; pfn++) {
 		struct page *page = pfn_to_page(pfn);
@@ -8983,7 +8983,7 @@ void free_contig_range(unsigned long pfn
 		count += page_count(page) != 1;
 		__free_page(page);
 	}
-	WARN(count != 0, "%d pages are still in use!\n", count);
+	WARN(count != 0, "%lu pages are still in use!\n", count);
 }
 EXPORT_SYMBOL(free_contig_range);
 
_

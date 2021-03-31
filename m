Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CEBC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A862619CF
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhCaEZy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232627AbhCaEZh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:25:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A84566023F;
        Wed, 31 Mar 2021 04:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617164736;
        bh=okYrhJn1FOsLI4ZZl5ySxiedecGYcV7UTEu60m+LBC0=;
        h=Date:From:To:Subject:From;
        b=rWJpZ1NMzazeJQr+tODugqhTzo+SO76u21AmnHCtE3LADNtpfcXgwDz2u+QEYSRyx
         KY9Qy7u3Ox7iMXlVCHB8QPs3xr8uPLO0TF4S7W1QN2wf9tMFUF+3m/MChpR8FZBz2M
         aL7X6NqCBDwEqCo7YAllrWuKyu6kvuMXbFdBu2BQ=
Date:   Tue, 30 Mar 2021 21:25:36 -0700
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, lmark@codeaurora.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  +
 mm-cma-add-the-cma-instance-name-to-cma-trace-events.patch added to -mm
 tree
Message-ID: <20210331042536.9dPFw88Gn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: add the CMA instance name to cma trace events
has been added to the -mm tree.  Its filename is
     mm-cma-add-the-cma-instance-name-to-cma-trace-events.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-the-cma-instance-name-to-cma-trace-events.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-the-cma-instance-name-to-cma-trace-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-lru_add_drain_all-in-alloc_contig_range.patch
mm-page_alloc-dump-migrate-failed-pages.patch
mm-disable-lru-pagevec-during-the-migration-temporarily.patch
mm-replace-migrate_-with-lru_cache_.patch
mm-fs-invalidate-bh-lru-during-page-migration.patch
mm-vmstat-add-cma-statistics.patch
mm-cma-support-sysfs.patch
mm-cma-add-the-cma-instance-name-to-cma-trace-events.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625B0C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281DE61159
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhEEA5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhEEA5v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB60D61078;
        Wed,  5 May 2021 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176215;
        bh=uWXFFGKcZbOX2dNDD8yjoK70x0I9oc78l53+9PDm0O8=;
        h=Date:From:To:Subject:From;
        b=GWGTPBxS55cqM82dd4nbB2f1qZAoOCeG7FYKpBS0yEZEKmqFljCh5zYekaKihvbR7
         Gjco+7UYsdYa4c5+Vr5hisi4A7p1Ijv7orEQOkEcDpkXy/MhD+SQJketedEdmUIPos
         5jZozMTjV9Pbpxz8bnD/tGifvWepMuslo7A0C+LA=
Date:   Tue, 04 May 2021 17:56:55 -0700
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix.patch removed from
 -mm tree
Message-ID: <20210505005655.LPOe56pPQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: Add the CMA instance name to the cma_alloc_start trace event
has been removed from the -mm tree.  Its filename was
     mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix.patch

This patch was dropped because it was folded into mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch

------------------------------------------------------
From: Georgi Djakov <georgi.djakov@linaro.org>
Subject: mm: cma: Add the CMA instance name to the cma_alloc_start trace event

During CMA allocation, print also the name to identify the CMA instance.

Link: https://lkml.kernel.org/r/20210326155414.25006-1-georgi.djakov@linaro.org
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h |    9 ++++++---
 mm/cma.c                   |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/include/trace/events/cma.h~mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix
+++ a/include/trace/events/cma.h
@@ -63,21 +63,24 @@ TRACE_EVENT(cma_release,
 
 TRACE_EVENT(cma_alloc_start,
 
-	TP_PROTO(unsigned int count, unsigned int align),
+	TP_PROTO(const char *name, unsigned int count, unsigned int align),
 
-	TP_ARGS(count, align),
+	TP_ARGS(name, count, align),
 
 	TP_STRUCT__entry(
+		__string(name, name)
 		__field(unsigned int, count)
 		__field(unsigned int, align)
 	),
 
 	TP_fast_assign(
+		__assign_str(name, name);
 		__entry->count = count;
 		__entry->align = align;
 	),
 
-	TP_printk("count=%u align=%u",
+	TP_printk("name=%s count=%u align=%u",
+		  __get_str(name),
 		  __entry->count,
 		  __entry->align)
 );
--- a/mm/cma.c~mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix
+++ a/mm/cma.c
@@ -443,7 +443,7 @@ struct page *cma_alloc(struct cma *cma,
 	if (!count)
 		goto out;
 
-	trace_cma_alloc_start(count, align);
+	trace_cma_alloc_start(cma->name, count, align);
 
 	mask = cma_bitmap_aligned_mask(cma, align);
 	offset = cma_bitmap_aligned_offset(cma, align);
_

Patches currently in -mm which might be from georgi.djakov@linaro.org are

mm-page_owner-record-the-timestamp-of-all-pages-during-free.patch
mm-cma-add-trace-events-for-cma-alloc-perf-testing.patch


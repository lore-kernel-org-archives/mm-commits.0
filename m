Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA5DC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjASBQT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjASBOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0252B607
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 398EA61B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979BCC433EF;
        Thu, 19 Jan 2023 01:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090859;
        bh=qkQPtzXbid+i/Y5RJOK6M91vXkJlxQgITu2SQKVgrTY=;
        h=Date:To:From:Subject:From;
        b=QwMrL0RJ+7Yu2OfhGQc64T6m79VJmivdiA95pnbRJkDYflmS08AfPLvU+IGyusf/t
         l6rRD1O6BZoccTnTxKu++isd2xcB3vf4YFIm6ErxdT4eU16crp1MtL+PzZLUx3QTbI
         BKrrs3fYPSUat6paFnA3HqzFTT8Oc3qIFRpRz8gM=
Date:   Wed, 18 Jan 2023 17:14:19 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, haowenchao@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cma-tracing-print-alloc-result-in-trace_cma_alloc_finish.patch removed from -mm tree
Message-Id: <20230119011419.979BCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cma: tracing: print alloc result in trace_cma_alloc_finish
has been removed from the -mm tree.  Its filename was
     cma-tracing-print-alloc-result-in-trace_cma_alloc_finish.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wenchao Hao <haowenchao@huawei.com>
Subject: cma: tracing: print alloc result in trace_cma_alloc_finish
Date: Thu, 8 Dec 2022 22:21:30 +0800

The result of the allocation attempt is not printed in
trace_cma_alloc_finish, but it's important to do it so we can set filters
to catch specific errors on allocation or to trigger some operations on
specific errors.

We have printed the result in log, but the log is conditional and could
not be filtered by tracing events.

It introduces little overhead to print this result.  The result of
allocation is named `errorno' in the trace.

Link: https://lkml.kernel.org/r/20221208142130.1501195-1-haowenchao@huawei.com
Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h |   32 +++++++++++++++++++++++++++++---
 mm/cma.c                   |    2 +-
 2 files changed, 30 insertions(+), 4 deletions(-)

--- a/include/trace/events/cma.h~cma-tracing-print-alloc-result-in-trace_cma_alloc_finish
+++ a/include/trace/events/cma.h
@@ -91,12 +91,38 @@ TRACE_EVENT(cma_alloc_start,
 		  __entry->align)
 );
 
-DEFINE_EVENT(cma_alloc_class, cma_alloc_finish,
+TRACE_EVENT(cma_alloc_finish,
 
 	TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
-		 unsigned long count, unsigned int align),
+		 unsigned long count, unsigned int align, int errorno),
 
-	TP_ARGS(name, pfn, page, count, align)
+	TP_ARGS(name, pfn, page, count, align, errorno),
+
+	TP_STRUCT__entry(
+		__string(name, name)
+		__field(unsigned long, pfn)
+		__field(const struct page *, page)
+		__field(unsigned long, count)
+		__field(unsigned int, align)
+		__field(int, errorno)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->pfn = pfn;
+		__entry->page = page;
+		__entry->count = count;
+		__entry->align = align;
+		__entry->errorno = errorno;
+	),
+
+	TP_printk("name=%s pfn=0x%lx page=%p count=%lu align=%u errorno=%d",
+		  __get_str(name),
+		  __entry->pfn,
+		  __entry->page,
+		  __entry->count,
+		  __entry->align,
+		  __entry->errorno)
 );
 
 DEFINE_EVENT(cma_alloc_class, cma_alloc_busy_retry,
--- a/mm/cma.c~cma-tracing-print-alloc-result-in-trace_cma_alloc_finish
+++ a/mm/cma.c
@@ -491,7 +491,7 @@ struct page *cma_alloc(struct cma *cma,
 		start = bitmap_no + mask + 1;
 	}
 
-	trace_cma_alloc_finish(cma->name, pfn, page, count, align);
+	trace_cma_alloc_finish(cma->name, pfn, page, count, align, ret);
 
 	/*
 	 * CMA can allocate multiple page blocks, which results in different
_

Patches currently in -mm which might be from haowenchao@huawei.com are



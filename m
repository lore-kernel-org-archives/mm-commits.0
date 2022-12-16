Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101A4C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiLPXCV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPXCS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:02:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC027537E4
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7360CB81DE0
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FA1C433D2;
        Fri, 16 Dec 2022 23:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671231735;
        bh=pifphmtPxuxLtoQpm4w94gGrWAM5D2s4PMtCUfl8e94=;
        h=Date:To:From:Subject:From;
        b=btPp6NCNHjSadfCmTx4Qml/B3z8MQ/crwG5XasNkE5AB5hJi7t97C3N90x2M9Y9KM
         cM43vvatPRsOj6NPKcQa59Ghm7MizEGPP5ZZ0JNvX45X+/T6bN7QdbWVCXypHVVa6c
         Xn1m5J4Z6X7fpL+fypdBa/qkt0CV4e0BXmtONFYc=
Date:   Fri, 16 Dec 2022 15:02:14 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, haowenchao@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cma-tracing-print-alloc-result-in-trace_cma_alloc_finish.patch added to mm-unstable branch
Message-Id: <20221216230215.11FA1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cma: tracing: print alloc result in trace_cma_alloc_finish
has been added to the -mm mm-unstable branch.  Its filename is
     cma-tracing-print-alloc-result-in-trace_cma_alloc_finish.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cma-tracing-print-alloc-result-in-trace_cma_alloc_finish.patch

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

cma-tracing-print-alloc-result-in-trace_cma_alloc_finish.patch


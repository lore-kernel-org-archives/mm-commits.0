Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF66C433E4
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73DF5619A0
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhC1TLp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231469AbhC1TLf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 245BA61999;
        Sun, 28 Mar 2021 19:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958695;
        bh=ZWwkTMn7WIgk/8HVZjgXlSlym5a2ahshx2NxZcHyeCo=;
        h=Date:From:To:Subject:From;
        b=APb27bBPAA6ocBG/uTAUTskOLpDzRjdDkVU2CqJ1fKPWTo7ov98fKrX/uEAB5mdc6
         6CPYHmXex9DNhDwCX2HE6xBKw/Z0W9DAyUN8eL5YHz9LeJXptnsu/fSrJzQJNlsjLk
         qXwJJ2juRpuYAmqNoCbuBeVC6oysi0rxRLqp5Hbk=
Date:   Sun, 28 Mar 2021 12:11:34 -0700
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  +
 mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix.patch added to -mm
 tree
Message-ID: <20210328191134.mBhqNX1tC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: Add the CMA instance name to the cma_alloc_start trace event
has been added to the -mm tree.  Its filename is
     mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-cma-add-trace-events-for-cma-alloc-perf-testing-fix.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AA1C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJRWRJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJRWQ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:16:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D004495AC2
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 796CFB82184
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146F6C433C1;
        Tue, 18 Oct 2022 22:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666131415;
        bh=yRQLJXwtC5PasdAvUu8KeAp0pNQbdKZC35gnw7rzts0=;
        h=Date:To:From:Subject:From;
        b=FbhSZmQ79O3YidoiHW6NtfGpQMvjEGtpTGao6ju4tGCHzZjip0nrYWymODA6RbSya
         7C3PgwWH2oA8xS795R81gbpiJNCHLM4TrHfHi38nBKJc+Z4mYu0ztxtBiJqeAVKxN1
         5u89GOLy5naun8ZsTzXac1rjN9qmY3u8R71t5Kio=
Date:   Tue, 18 Oct 2022 15:16:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@infradead.org, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch added to mm-unstable branch
Message-Id: <20221018221655.146F6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: add purge_vmap_area_lazy trace event
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add purge_vmap_area_lazy trace event
Date: Tue, 18 Oct 2022 20:10:48 +0200

It is for debug purposes to track number of freed vmap areas including a
range it occurs on.

Link: https://lkml.kernel.org/r/20221018181053.434508-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmalloc.h |   33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/include/trace/events/vmalloc.h~mm-vmalloc-add-purge_vmap_area_lazy-trace-event
+++ a/include/trace/events/vmalloc.h
@@ -50,6 +50,39 @@ TRACE_EVENT(alloc_vmap_area,
 		__entry->vstart, __entry->vend, __entry->failed)
 );
 
+/**
+ * purge_vmap_area_lazy - called when vmap areas were lazily freed
+ * @start:		purging start address
+ * @end:		purging end address
+ * @npurged:	numbed of purged vmap areas
+ *
+ * This event is used for a debug purpose. It gives some
+ * indication about start:end range and how many objects
+ * are released.
+ */
+TRACE_EVENT(purge_vmap_area_lazy,
+
+	TP_PROTO(unsigned long start, unsigned long end,
+		unsigned int npurged),
+
+	TP_ARGS(start, end, npurged),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned int, npurged)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->npurged = npurged;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx num_purged=%u",
+		__entry->start, __entry->end, __entry->npurged)
+);
+
 #endif /*  _TRACE_VMALLOC_H */
 
 /* This part must be outside protection */
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-alloc_vmap_area-trace-event.patch
mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch
mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch
mm-vmalloc-use-trace_alloc_vmap_area-event.patch
mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch
mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch
vmalloc-add-reviewers-for-vmalloc-code.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32C0C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJRWRJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJRWRA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:17:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1368F242
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B357B82185
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201A1C433D6;
        Tue, 18 Oct 2022 22:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666131417;
        bh=ezfXvzDpRxYLpguvwBXoloJsW21C2nVAGJuyW9j8EQk=;
        h=Date:To:From:Subject:From;
        b=x9NnGTfp8VG2fQoucCI0iWjMpy8VZ5+Dz0/cvCvIgq39ODwGCl+bUDmmneBpjueyU
         ck+kBZ183VEry4okM1T6q5xaUCDlO1sY+jV1o71ghp/rllIFuQHCC77oMfBXu7pCfk
         ypFO/3ZAA0feEp2Z/UIfhPNqFNm1RZCcM520349Q=
Date:   Tue, 18 Oct 2022 15:16:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@infradead.org, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch added to mm-unstable branch
Message-Id: <20221018221657.201A1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: add free_vmap_area_noflush trace event
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch

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
Subject: mm: vmalloc: add free_vmap_area_noflush trace event
Date: Tue, 18 Oct 2022 20:10:49 +0200

This event is used in order to validate/debug a start address of freed VA,
number of currently outstanding and maximum allowed areas.

Link: https://lkml.kernel.org/r/20221018181053.434508-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmalloc.h |   34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/include/trace/events/vmalloc.h~mm-vmalloc-add-free_vmap_area_noflush-trace-event
+++ a/include/trace/events/vmalloc.h
@@ -83,6 +83,40 @@ TRACE_EVENT(purge_vmap_area_lazy,
 		__entry->start, __entry->end, __entry->npurged)
 );
 
+/**
+ * free_vmap_area_noflush - called when a vmap area is freed
+ * @va_start:		a start address of VA
+ * @nr_lazy:		number of current lazy pages
+ * @nr_lazy_max:	number of maximum lazy pages
+ *
+ * This event is used for a debug purpose. It gives some
+ * indication about a VA that is released, number of current
+ * outstanding areas and a maximum allowed threshold before
+ * dropping all of them.
+ */
+TRACE_EVENT(free_vmap_area_noflush,
+
+	TP_PROTO(unsigned long va_start, unsigned long nr_lazy,
+		unsigned long nr_lazy_max),
+
+	TP_ARGS(va_start, nr_lazy, nr_lazy_max),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, va_start)
+		__field(unsigned long, nr_lazy)
+		__field(unsigned long, nr_lazy_max)
+	),
+
+	TP_fast_assign(
+		__entry->va_start = va_start;
+		__entry->nr_lazy = nr_lazy;
+		__entry->nr_lazy_max = nr_lazy_max;
+	),
+
+	TP_printk("va_start=0x%lx nr_lazy=%lu nr_lazy_max=%lu",
+		__entry->va_start, __entry->nr_lazy, __entry->nr_lazy_max)
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


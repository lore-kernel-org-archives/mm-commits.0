Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBC4C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiKIBkc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKIBjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517DB63CF8
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3514617F0
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D4AC433C1;
        Wed,  9 Nov 2022 01:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957934;
        bh=h8jt22ycIW8Cd4dgvUS/eI52I4ERddzsN6TcShdk4Yw=;
        h=Date:To:From:Subject:From;
        b=TzhfhU6gJNGqHPEonzwtIOnMZLg2z3ve0MGWui7mznAVYGqYZ9l90Ph24+v3yPqoq
         m6NT3QIi4piE1ppIm/sslaQp8+6L8bwZ+Y2L//n9+99r4vy9CfpyYxpit35Dr7zXg7
         49f/HybfhpumHwkk0KyZ4t/yZu/4HVEtJ56OF0J8=
Date:   Tue, 08 Nov 2022 17:38:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch removed from -mm tree
Message-Id: <20221109013854.45D4AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: add free_vmap_area_noflush trace event
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add free_vmap_area_noflush trace event
Date: Tue, 18 Oct 2022 20:10:49 +0200

This event is used in order to validate/debug a start address of freed VA,
number of currently outstanding and maximum allowed areas.

Link: https://lkml.kernel.org/r/20221018181053.434508-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6DFC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiKIBkV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiKIBi5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE8B663F0
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67363B81CC7
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1494BC433C1;
        Wed,  9 Nov 2022 01:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957932;
        bh=6kx2GIrw0R5iFBYA2NKcV1O9FHgcwCLEcXf55zI771s=;
        h=Date:To:From:Subject:From;
        b=BelEg38XAcG8ObRHXIPVLMxPrgH3iKx9zt95tTF/8Rkoi6UNm4ecDBRsFFjJ5Xxih
         qGoqNmwX/wsby+Lt/L23fJfQffP7VYBkr8aa9EdFG0lY7ZbgvjeTPxZvd67acDrkjD
         raAVNpNFdqAMwEfGygAcTqhpJv9NUrCMtXPye7oc=
Date:   Tue, 08 Nov 2022 17:38:51 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-alloc_vmap_area-trace-event.patch removed from -mm tree
Message-Id: <20221109013852.1494BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: add alloc_vmap_area trace event
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-alloc_vmap_area-trace-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add alloc_vmap_area trace event
Date: Tue, 18 Oct 2022 20:10:47 +0200

Patch series "Add basic trace events for vmap/vmalloc (v2)", v2.

This small series add some basic trace events for the vmap/vmalloc code. 
Since currently we lack any, sometimes it is hard to start debuging vmap
code if an issue is reported or occured.

For example https://lore.kernel.org/linux-mm/Y0p8BZIiDXLQbde%2F@pc636/T/

The final patch adds two reviewers for vmalloc code.


This patch (of 7):

It is for debug purposes and for validation of passed parameters.

Link: https://lkml.kernel.org/r/20221018181053.434508-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20221018181053.434508-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmalloc.h |   56 +++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- /dev/null
+++ a/include/trace/events/vmalloc.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vmalloc
+
+#if !defined(_TRACE_VMALLOC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VMALLOC_H
+
+#include <linux/tracepoint.h>
+
+/**
+ * alloc_vmap_area - called when a new vmap allocation occurs
+ * @addr:	an allocated address
+ * @size:	a requested size
+ * @align:	a requested alignment
+ * @vstart:	a requested start range
+ * @vend:	a requested end range
+ * @failed:	an allocation failed or not
+ *
+ * This event is used for a debug purpose, it can give an extra
+ * information for a developer about how often it occurs and which
+ * parameters are passed for further validation.
+ */
+TRACE_EVENT(alloc_vmap_area,
+
+	TP_PROTO(unsigned long addr, unsigned long size, unsigned long align,
+		unsigned long vstart, unsigned long vend, int failed),
+
+	TP_ARGS(addr, size, align, vstart, vend, failed),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, addr)
+		__field(unsigned long, size)
+		__field(unsigned long, align)
+		__field(unsigned long, vstart)
+		__field(unsigned long, vend)
+		__field(int, failed)
+	),
+
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->size = size;
+		__entry->align = align;
+		__entry->vstart = vstart;
+		__entry->vend = vend;
+		__entry->failed = failed;
+	),
+
+	TP_printk("va_start: %lu size=%lu align=%lu vstart=0x%lx vend=0x%lx failed=%d",
+		__entry->addr, __entry->size, __entry->align,
+		__entry->vstart, __entry->vend, __entry->failed)
+);
+
+#endif /*  _TRACE_VMALLOC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
_

Patches currently in -mm which might be from urezki@gmail.com are



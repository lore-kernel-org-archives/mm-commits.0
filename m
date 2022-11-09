Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A096AC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiKIBkb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKIBjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE07657D7
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9D05CCE1D3C
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290B5C433D7;
        Wed,  9 Nov 2022 01:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957933;
        bh=DLaoCjykbIh20BZRj2jPDs7P9hZZYvLyhhuNHhE/Xss=;
        h=Date:To:From:Subject:From;
        b=RMK0wp7ldf/SLKeHyu09YoipspdOXBf1tHdicxS2yaaD0NeZ5UBGEQi8IWLCqbSzk
         IYhVErBTy8oYh6JFux6BoXe7toeIK7vJzNE/vRBDyN4DgxKvotpxeJGYODMUlBlPHP
         26oGUCcnMZnrcs1H70e21slB1Wgo/C64tBqqLaX0=
Date:   Tue, 08 Nov 2022 17:38:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch removed from -mm tree
Message-Id: <20221109013853.290B5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: add purge_vmap_area_lazy trace event
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: add purge_vmap_area_lazy trace event
Date: Tue, 18 Oct 2022 20:10:48 +0200

It is for debug purposes to track number of freed vmap areas including a
range it occurs on.

Link: https://lkml.kernel.org/r/20221018181053.434508-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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



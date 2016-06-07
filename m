From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-add-trace-events-for-zs_compact.patch added to -mm
 tree
Date: Tue, 07 Jun 2016 14:17:07 -0700
Message-ID: <575739d3.+5OKia4XtBAEVqca%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773AbcFGVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, mingo@elte.hu, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add trace events for zs_compact
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-add-trace-events-for-zs_compact.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-add-trace-events-for-zs_compact.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-add-trace-events-for-zs_compact.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: add trace events for zs_compact

Currently zsmalloc is widely used in android device.  Sometimes, we want
to see how frequently zs_compact is triggered or how may pages freed by
zs_compact(), or which zsmalloc pool is compacted.

Most of the time, user can get the brief information from
trace_mm_shrink_slab_[start | end], but in some senario, they do not use
zsmalloc shrinker, but trigger compaction manually.  So add some trace
events in zs_compact is convenient.  Also we can add some zsmalloc
specific information(pool name, total compact pages, etc) in zsmalloc
trace.

This patch add two trace events for zs_compact(), below the trace log:
-----------------------------
root@land:/ # cat /d/tracing/trace
         kswapd0-125   [007] ...1   174.176979: zsmalloc_compact_start: pool zram0
         kswapd0-125   [007] ...1   174.181967: zsmalloc_compact_end: pool zram0: 608 pages compacted(total 1794)
         kswapd0-125   [000] ...1   184.134475: zsmalloc_compact_start: pool zram0
         kswapd0-125   [000] ...1   184.135010: zsmalloc_compact_end: pool zram0: 62 pages compacted(total 1856)
         kswapd0-125   [003] ...1   226.927221: zsmalloc_compact_start: pool zram0
         kswapd0-125   [003] ...1   226.928575: zsmalloc_compact_end: pool zram0: 250 pages compacted(total 2106)
-----------------------------

Link: http://lkml.kernel.org/r/1465289804-4913-1-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/zsmalloc.h |   56 ++++++++++++++++++++++++++++++
 mm/zsmalloc.c                   |   10 +++++
 2 files changed, 66 insertions(+)

diff -puN /dev/null include/trace/events/zsmalloc.h
--- /dev/null
+++ a/include/trace/events/zsmalloc.h
@@ -0,0 +1,56 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM zsmalloc
+
+#if !defined(_TRACE_ZSMALLOC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ZSMALLOC_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(zsmalloc_compact_start,
+
+	TP_PROTO(const char *pool_name),
+
+	TP_ARGS(pool_name),
+
+	TP_STRUCT__entry(
+		__field(const char *, pool_name)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name = pool_name;
+	),
+
+	TP_printk("pool %s",
+		  __entry->pool_name)
+);
+
+TRACE_EVENT(zsmalloc_compact_end,
+
+	TP_PROTO(const char *pool_name, unsigned long pages_compacted,
+			unsigned long pages_total_compacted),
+
+	TP_ARGS(pool_name, pages_compacted, pages_total_compacted),
+
+	TP_STRUCT__entry(
+		__field(const char *, pool_name)
+		__field(unsigned long, pages_compacted)
+		__field(unsigned long, pages_total_compacted)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name = pool_name;
+		__entry->pages_compacted = pages_compacted;
+		__entry->pages_total_compacted = pages_total_compacted;
+	),
+
+	TP_printk("pool %s: %ld pages compacted(total %ld)",
+		  __entry->pool_name,
+		  __entry->pages_compacted,
+		  __entry->pages_total_compacted)
+);
+
+#endif /* _TRACE_ZSMALLOC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/zsmalloc.c~mm-zsmalloc-add-trace-events-for-zs_compact mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-add-trace-events-for-zs_compact
+++ a/mm/zsmalloc.c
@@ -30,6 +30,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#define CREATE_TRACE_POINTS
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -52,6 +54,7 @@
 #include <linux/mount.h>
 #include <linux/compaction.h>
 #include <linux/pagemap.h>
+#include <trace/events/zsmalloc.h>
 
 #define ZSPAGE_MAGIC	0x58
 
@@ -2330,6 +2333,9 @@ unsigned long zs_compact(struct zs_pool
 {
 	int i;
 	struct size_class *class;
+	unsigned long pages_compacted_before = pool->stats.pages_compacted;
+
+	trace_zsmalloc_compact_start(pool->name);
 
 	for (i = zs_size_classes - 1; i >= 0; i--) {
 		class = pool->size_class[i];
@@ -2340,6 +2346,10 @@ unsigned long zs_compact(struct zs_pool
 		__zs_compact(pool, class);
 	}
 
+	trace_zsmalloc_compact_end(pool->name,
+		pool->stats.pages_compacted - pages_compacted_before,
+		pool->stats.pages_compacted);
+
 	return pool->stats.pages_compacted;
 }
 EXPORT_SYMBOL_GPL(zs_compact);
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-zsmalloc-add-trace-events-for-zs_compact.patch


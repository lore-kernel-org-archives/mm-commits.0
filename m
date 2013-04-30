From: akpm@linux-foundation.org
Subject: [merged] mm-trace-filemap-add-and-del.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:24 -0700
Message-ID: <20130430184424.890235A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52040 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab3D3So0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:26 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so84654vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.jarzmik@free.fr, david@fromorbit.com, fweisbec@gmail.com, hughd@google.com, mingo@redhat.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: trace filemap add and del
has been removed from the -mm tree.  Its filename was
     mm-trace-filemap-add-and-del.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: mm: trace filemap add and del

Use the events API to trace filemap loading and unloading of file pieces
into the page cache.

This patch aims at tracing the eviction reload cycle of executable and
shared libraries pages in a memory constrained environment.

The typical usage is to spot a specific device and inode (for example
/lib/libc.so) to see the eviction cycles, and find out if frequently used
code is rather spread across many pages (bad) or coallesced (good).

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/filemap.h |   58 +++++++++++++++++++++++++++++++
 mm/filemap.c                   |    5 ++
 2 files changed, 63 insertions(+)

diff -puN /dev/null include/trace/events/filemap.h
--- /dev/null
+++ a/include/trace/events/filemap.h
@@ -0,0 +1,58 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM filemap
+
+#if !defined(_TRACE_FILEMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FILEMAP_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+#include <linux/memcontrol.h>
+#include <linux/device.h>
+#include <linux/kdev_t.h>
+
+DECLARE_EVENT_CLASS(mm_filemap_op_page_cache,
+
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page),
+
+	TP_STRUCT__entry(
+		__field(struct page *, page)
+		__field(unsigned long, i_ino)
+		__field(unsigned long, index)
+		__field(dev_t, s_dev)
+	),
+
+	TP_fast_assign(
+		__entry->page = page;
+		__entry->i_ino = page->mapping->host->i_ino;
+		__entry->index = page->index;
+		if (page->mapping->host->i_sb)
+			__entry->s_dev = page->mapping->host->i_sb->s_dev;
+		else
+			__entry->s_dev = page->mapping->host->i_rdev;
+	),
+
+	TP_printk("dev %d:%d ino %lx page=%p pfn=%lu ofs=%lu",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
+		__entry->i_ino,
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->index << PAGE_SHIFT)
+);
+
+DEFINE_EVENT(mm_filemap_op_page_cache, mm_filemap_delete_from_page_cache,
+	TP_PROTO(struct page *page),
+	TP_ARGS(page)
+	);
+
+DEFINE_EVENT(mm_filemap_op_page_cache, mm_filemap_add_to_page_cache,
+	TP_PROTO(struct page *page),
+	TP_ARGS(page)
+	);
+
+#endif /* _TRACE_FILEMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/filemap.c~mm-trace-filemap-add-and-del mm/filemap.c
--- a/mm/filemap.c~mm-trace-filemap-add-and-del
+++ a/mm/filemap.c
@@ -35,6 +35,9 @@
 #include <linux/cleancache.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/filemap.h>
+
 /*
  * FIXME: remove all knowledge of the buffer layer from the core VM
  */
@@ -113,6 +116,7 @@ void __delete_from_page_cache(struct pag
 {
 	struct address_space *mapping = page->mapping;
 
+	trace_mm_filemap_delete_from_page_cache(page);
 	/*
 	 * if we're uptodate, flush out into the cleancache, otherwise
 	 * invalidate any existing cleancache entries.  We can't leave
@@ -464,6 +468,7 @@ int add_to_page_cache_locked(struct page
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 			spin_unlock_irq(&mapping->tree_lock);
+			trace_mm_filemap_add_to_page_cache(page);
 		} else {
 			page->mapping = NULL;
 			/* Leave page->index set: truncation relies upon it */
_

Patches currently in -mm which might be from robert.jarzmik@free.fr are

origin.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch


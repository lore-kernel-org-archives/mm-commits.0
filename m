From: akpm@linux-foundation.org
Subject: [folded-merged] mm-trace-filemap-add-and-del-v2.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:43:21 -0700
Message-ID: <20130429214322.479F95A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:65522 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab3D2VnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:43:23 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so579318yhz.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:43:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.jarzmik@free.fr, david@fromorbit.com, fweisbec@gmail.com, hughd@google.com, mingo@redhat.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-trace-filemap-add-and-del-v2
has been removed from the -mm tree.  Its filename was
     mm-trace-filemap-add-and-del-v2.patch

This patch was dropped because it was folded into mm-trace-filemap-add-and-del.patch

------------------------------------------------------
From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: mm-trace-filemap-add-and-del-v2

 - took Stephen's comment into account (use FTrace templates)
 - took Andrew's comment into account (trace out of lock)

Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/filemap.h |   37 ++++++-------------------------
 mm/filemap.c                   |    2 -
 2 files changed, 9 insertions(+), 30 deletions(-)

diff -puN include/trace/events/filemap.h~mm-trace-filemap-add-and-del-v2 include/trace/events/filemap.h
--- a/include/trace/events/filemap.h~mm-trace-filemap-add-and-del-v2
+++ a/include/trace/events/filemap.h
@@ -11,7 +11,7 @@
 #include <linux/device.h>
 #include <linux/kdev_t.h>
 
-TRACE_EVENT(mm_filemap_delete_from_page_cache,
+DECLARE_EVENT_CLASS(mm_filemap_op_page_cache,
 
 	TP_PROTO(struct page *page),
 
@@ -42,36 +42,15 @@ TRACE_EVENT(mm_filemap_delete_from_page_
 		__entry->index << PAGE_SHIFT)
 );
 
-TRACE_EVENT(mm_filemap_add_to_page_cache,
-
+DEFINE_EVENT(mm_filemap_op_page_cache, mm_filemap_delete_from_page_cache,
 	TP_PROTO(struct page *page),
+	TP_ARGS(page)
+	);
 
-	TP_ARGS(page),
-
-	TP_STRUCT__entry(
-		__field(struct page *, page)
-		__field(unsigned long, i_ino)
-		__field(unsigned long, index)
-		__field(dev_t, s_dev)
-	),
-
-	TP_fast_assign(
-		__entry->page = page;
-		__entry->i_ino = page->mapping->host->i_ino;
-		__entry->index = page->index;
-		if (page->mapping->host->i_sb)
-			__entry->s_dev = page->mapping->host->i_sb->s_dev;
-		else
-			__entry->s_dev = page->mapping->host->i_rdev;
-	),
-
-	TP_printk("dev %d:%d ino %lx page=%p pfn=%lu ofs=%lu",
-		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
-		__entry->i_ino,
-		__entry->page,
-		page_to_pfn(__entry->page),
-		__entry->index << PAGE_SHIFT)
-);
+DEFINE_EVENT(mm_filemap_op_page_cache, mm_filemap_add_to_page_cache,
+	TP_PROTO(struct page *page),
+	TP_ARGS(page)
+	);
 
 #endif /* _TRACE_FILEMAP_H */
 
diff -puN mm/filemap.c~mm-trace-filemap-add-and-del-v2 mm/filemap.c
--- a/mm/filemap.c~mm-trace-filemap-add-and-del-v2
+++ a/mm/filemap.c
@@ -467,8 +467,8 @@ int add_to_page_cache_locked(struct page
 		if (likely(!error)) {
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
-			trace_mm_filemap_add_to_page_cache(page);
 			spin_unlock_irq(&mapping->tree_lock);
+			trace_mm_filemap_add_to_page_cache(page);
 		} else {
 			page->mapping = NULL;
 			/* Leave page->index set: truncation relies upon it */
_

Patches currently in -mm which might be from robert.jarzmik@free.fr are

origin.patch
mm-trace-filemap-add-and-del.patch


From: akpm@linux-foundation.org
Subject: + mm-trace-filemap-add-and-del-v2.patch added to -mm tree
Date: Thu, 07 Mar 2013 11:45:05 -0800
Message-ID: <20130307194505.7591C5A41D2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42337 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3CGTpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 14:45:07 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so79621vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 11:45:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert.jarzmik@free.fr, david@fromorbit.com, fweisbec@gmail.com, hughd@google.com, mingo@redhat.com, rostedt@goodmis.org


The patch titled
     Subject: mm-trace-filemap-add-and-del-v2
has been added to the -mm tree.  Its filename is
     mm-trace-filemap-add-and-del-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch


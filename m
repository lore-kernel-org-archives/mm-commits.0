From: akpm@linux-foundation.org
Subject: +
 mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch added to -mm tree
Date: Mon, 12 May 2014 14:40:27 -0700
Message-ID: <53713fcb.bAPZwaJP0RFo98CI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaELVk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 17:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mina86@mina86.com, vbabka@suse.cz

Subject: + mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch added to -mm tree
To: vbabka@suse.cz,mina86@mina86.com
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 14:40:27 -0700


The patch titled
     Subject: mm-compaction-do-not-count-migratepages-when-unnecessary-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-do-not-count-migratepages-when-unnecessary-fix

list_for_each is enough for counting the list length.  We also avoid
including struct page definition this way.

Suggested-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/trace/events/compaction.h~mm-compaction-do-not-count-migratepages-when-unnecessary-fix include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-do-not-count-migratepages-when-unnecessary-fix
+++ a/include/trace/events/compaction.h
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/tracepoint.h>
-#include <linux/mm_types.h>
 #include <trace/events/gfpflags.h>
 
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
@@ -62,7 +61,7 @@ TRACE_EVENT(mm_compaction_migratepages,
 
 	TP_fast_assign(
 		unsigned long nr_failed = 0;
-		struct page *page;
+		struct list_head *page_lru;
 
 		/*
 		 * migrate_pages() returns either a non-negative number
@@ -73,7 +72,7 @@ TRACE_EVENT(mm_compaction_migratepages,
 		if (migrate_rc >= 0)
 			nr_failed = migrate_rc;
 		else
-			list_for_each_entry(page, migratepages, lru)
+			list_for_each(page_lru, migratepages)
 				nr_failed++;
 
 		__entry->nr_migrated = nr_all - nr_failed;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-do-not-count-migratepages-when-unnecessary-fix.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 15:15:52 -0800
Message-ID: <54dbe2a8.g7yDO+ktkjE2H5vH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbbBKXPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:15:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4
has been removed from the -mm tree.  Its filename was
     mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch

This patch was dropped because it was folded into mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4

Changes from v3: Build fix for !CONFIG_COMPACTION, !CONFIG_TRACEPOINTS

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    1 -
 mm/compaction.c            |   17 +++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4 include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4
+++ a/include/linux/compaction.h
@@ -25,7 +25,6 @@
 struct alloc_context; /* in mm/internal.h */
 
 #ifdef CONFIG_COMPACTION
-extern char *compaction_status_string[];
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
diff -puN mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4
+++ a/mm/compaction.c
@@ -19,14 +19,6 @@
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
-char *compaction_status_string[] = {
-	"deferred",
-	"skipped",
-	"continue",
-	"partial",
-	"complete",
-};
-
 static inline void count_compact_event(enum vm_event_item item)
 {
 	count_vm_event(item);
@@ -42,6 +34,15 @@ static inline void count_compact_events(
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
+#ifdef CONFIG_TRACEPOINTS
+static const char const *compaction_status_string[] = {
+	"deferred",
+	"skipped",
+	"continue",
+	"partial",
+	"complete",
+};
+#endif
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/compaction.h>
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
sparc32-fix-broken-set_pte.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-page_ext-remove-unnecessary-stack_trace-field.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch


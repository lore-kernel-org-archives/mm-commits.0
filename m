From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-export-tracepoints-status-strings-to-userspace.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:08:34 -0800
Message-ID: <563d08c2.Sx/Iq/Hvn7twFa77%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966383AbbKFUIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@suse.de, mingo@redhat.com, rientjes@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: export tracepoints status strings to userspace
has been removed from the -mm tree.  Its filename was
     mm-compaction-export-tracepoints-status-strings-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: export tracepoints status strings to userspace

Some compaction tracepoints convert the integer return values to strings
using the compaction_status_string array.  This works for in-kernel
printing, but not userspace trace printing of raw captured trace such as
via trace-cmd report.

This patch converts the private array to appropriate tracepoint macros
that result in proper userspace support.

trace-cmd output before:
transhuge-stres-4235  [000]   453.149280: mm_compaction_finished: node=0
  zone=ffffffff81815d7a order=9 ret=

after:
transhuge-stres-4235  [000]   453.149280: mm_compaction_finished: node=0
  zone=ffffffff81815d7a order=9 ret=partial

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |    2 -
 include/trace/events/compaction.h |   33 ++++++++++++++++++++++++++--
 mm/compaction.c                   |   11 ---------
 3 files changed, 32 insertions(+), 14 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-export-tracepoints-status-strings-to-userspace include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-export-tracepoints-status-strings-to-userspace
+++ a/include/linux/compaction.h
@@ -15,7 +15,7 @@
 /* For more detailed tracepoint output */
 #define COMPACT_NO_SUITABLE_PAGE	5
 #define COMPACT_NOT_SUITABLE_ZONE	6
-/* When adding new state, please change compaction_status_string, too */
+/* When adding new states, please adjust include/trace/events/compaction.h */
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
 /* No contention detected */
diff -puN include/trace/events/compaction.h~mm-compaction-export-tracepoints-status-strings-to-userspace include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-export-tracepoints-status-strings-to-userspace
+++ a/include/trace/events/compaction.h
@@ -9,6 +9,35 @@
 #include <linux/tracepoint.h>
 #include <trace/events/gfpflags.h>
 
+#define COMPACTION_STATUS					\
+	EM( COMPACT_DEFERRED,		"deferred")		\
+	EM( COMPACT_SKIPPED,		"skipped")		\
+	EM( COMPACT_CONTINUE,		"continue")		\
+	EM( COMPACT_PARTIAL,		"partial")		\
+	EM( COMPACT_COMPLETE,		"complete")		\
+	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
+	EMe(COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")
+
+/*
+ * First define the enums in the above macros to be exported to userspace
+ * via TRACE_DEFINE_ENUM().
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)	TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+COMPACTION_STATUS
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)	{a, b},
+#define EMe(a, b)	{a, b}
+
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
 
 	TP_PROTO(
@@ -161,7 +190,7 @@ TRACE_EVENT(mm_compaction_end,
 		__entry->free_pfn,
 		__entry->zone_end,
 		__entry->sync ? "sync" : "async",
-		compaction_status_string[__entry->status])
+		__print_symbolic(__entry->status, COMPACTION_STATUS))
 );
 
 TRACE_EVENT(mm_compaction_try_to_compact_pages,
@@ -217,7 +246,7 @@ DECLARE_EVENT_CLASS(mm_compaction_suitab
 		__entry->nid,
 		__entry->name,
 		__entry->order,
-		compaction_status_string[__entry->ret])
+		__print_symbolic(__entry->ret, COMPACTION_STATUS))
 );
 
 DEFINE_EVENT(mm_compaction_suitable_template, mm_compaction_finished,
diff -puN mm/compaction.c~mm-compaction-export-tracepoints-status-strings-to-userspace mm/compaction.c
--- a/mm/compaction.c~mm-compaction-export-tracepoints-status-strings-to-userspace
+++ a/mm/compaction.c
@@ -35,17 +35,6 @@ static inline void count_compact_events(
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
-#ifdef CONFIG_TRACEPOINTS
-static const char *const compaction_status_string[] = {
-	"deferred",
-	"skipped",
-	"continue",
-	"partial",
-	"complete",
-	"no_suitable_page",
-	"not_suitable_zone",
-};
-#endif
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/compaction.h>
_

Patches currently in -mm which might be from vbabka@suse.cz are



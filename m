From: akpm@linux-foundation.org
Subject: +
 mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
 added to -mm tree
Date: Tue, 20 Dec 2016 14:39:08 -0800
Message-ID: <5859b30c.CMN0495GxBPag1qs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753259AbcLTWiG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:38:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, trace: extract COMPACTION_STATUS and ZONE_TYPE to a common header
has been added to the -mm tree.  Its filename is
     mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, trace: extract COMPACTION_STATUS and ZONE_TYPE to a common header

COMPACTION_STATUS resp.  ZONE_TYPE are currently used to translate enum
compact_result resp.  struct zone index into their symbolic names for an
easier post processing.  The follow up patch would like to reuse this as
well.  The code involves some preprocessor black magic which is better not
duplicated elsewhere so move it to a common mm tracing relate header.

Link: http://lkml.kernel.org/r/20161220130135.15719-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   60 +-------------------------
 include/trace/events/mmflags.h    |   64 ++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 57 deletions(-)

diff -puN include/trace/events/compaction.h~mm-trace-extract-compaction_status-and-zone_type-to-a-common-header include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-trace-extract-compaction_status-and-zone_type-to-a-common-header
+++ a/include/trace/events/compaction.h
@@ -9,62 +9,6 @@
 #include <linux/tracepoint.h>
 #include <trace/events/mmflags.h>
 
-#define COMPACTION_STATUS					\
-	EM( COMPACT_SKIPPED,		"skipped")		\
-	EM( COMPACT_DEFERRED,		"deferred")		\
-	EM( COMPACT_CONTINUE,		"continue")		\
-	EM( COMPACT_SUCCESS,		"success")		\
-	EM( COMPACT_PARTIAL_SKIPPED,	"partial_skipped")	\
-	EM( COMPACT_COMPLETE,		"complete")		\
-	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
-	EM( COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")	\
-	EMe(COMPACT_CONTENDED,		"contended")
-
-#ifdef CONFIG_ZONE_DMA
-#define IFDEF_ZONE_DMA(X) X
-#else
-#define IFDEF_ZONE_DMA(X)
-#endif
-
-#ifdef CONFIG_ZONE_DMA32
-#define IFDEF_ZONE_DMA32(X) X
-#else
-#define IFDEF_ZONE_DMA32(X)
-#endif
-
-#ifdef CONFIG_HIGHMEM
-#define IFDEF_ZONE_HIGHMEM(X) X
-#else
-#define IFDEF_ZONE_HIGHMEM(X)
-#endif
-
-#define ZONE_TYPE						\
-	IFDEF_ZONE_DMA(		EM (ZONE_DMA,	 "DMA"))	\
-	IFDEF_ZONE_DMA32(	EM (ZONE_DMA32,	 "DMA32"))	\
-				EM (ZONE_NORMAL, "Normal")	\
-	IFDEF_ZONE_HIGHMEM(	EM (ZONE_HIGHMEM,"HighMem"))	\
-				EMe(ZONE_MOVABLE,"Movable")
-
-/*
- * First define the enums in the above macros to be exported to userspace
- * via TRACE_DEFINE_ENUM().
- */
-#undef EM
-#undef EMe
-#define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
-
-COMPACTION_STATUS
-ZONE_TYPE
-
-/*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
- * that will be printed in the output.
- */
-#undef EM
-#undef EMe
-#define EM(a, b)	{a, b},
-#define EMe(a, b)	{a, b}
 
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
 
@@ -187,6 +131,7 @@ TRACE_EVENT(mm_compaction_begin,
 		__entry->sync ? "sync" : "async")
 );
 
+#ifdef CONFIG_COMPACTION
 TRACE_EVENT(mm_compaction_end,
 	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
 		unsigned long free_pfn, unsigned long zone_end, bool sync,
@@ -220,6 +165,7 @@ TRACE_EVENT(mm_compaction_end,
 		__entry->sync ? "sync" : "async",
 		__print_symbolic(__entry->status, COMPACTION_STATUS))
 );
+#endif
 
 TRACE_EVENT(mm_compaction_try_to_compact_pages,
 
@@ -248,6 +194,7 @@ TRACE_EVENT(mm_compaction_try_to_compact
 		__entry->prio)
 );
 
+#ifdef CONFIG_COMPACTION
 DECLARE_EVENT_CLASS(mm_compaction_suitable_template,
 
 	TP_PROTO(struct zone *zone,
@@ -295,7 +242,6 @@ DEFINE_EVENT(mm_compaction_suitable_temp
 	TP_ARGS(zone, order, ret)
 );
 
-#ifdef CONFIG_COMPACTION
 DECLARE_EVENT_CLASS(mm_compaction_defer_template,
 
 	TP_PROTO(struct zone *zone, int order),
diff -puN include/trace/events/mmflags.h~mm-trace-extract-compaction_status-and-zone_type-to-a-common-header include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-trace-extract-compaction_status-and-zone_type-to-a-common-header
+++ a/include/trace/events/mmflags.h
@@ -1,3 +1,6 @@
+#include <linux/node.h>
+#include <linux/mmzone.h>
+#include <linux/compaction.h>
 /*
  * The order of these masks is important. Matching masks will be seen
  * first and the left over flags will end up showing by themselves.
@@ -172,3 +175,64 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 	(flags) ? __print_flags(flags, "|",				\
 	__def_vmaflag_names						\
 	) : "none"
+
+#ifdef CONFIG_COMPACTION
+#define COMPACTION_STATUS					\
+	EM( COMPACT_SKIPPED,		"skipped")		\
+	EM( COMPACT_DEFERRED,		"deferred")		\
+	EM( COMPACT_CONTINUE,		"continue")		\
+	EM( COMPACT_SUCCESS,		"success")		\
+	EM( COMPACT_PARTIAL_SKIPPED,	"partial_skipped")	\
+	EM( COMPACT_COMPLETE,		"complete")		\
+	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
+	EM( COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")	\
+	EMe(COMPACT_CONTENDED,		"contended")
+#else
+#define COMPACTION_STATUS
+#endif
+
+#ifdef CONFIG_ZONE_DMA
+#define IFDEF_ZONE_DMA(X) X
+#else
+#define IFDEF_ZONE_DMA(X)
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+#define IFDEF_ZONE_DMA32(X) X
+#else
+#define IFDEF_ZONE_DMA32(X)
+#endif
+
+#ifdef CONFIG_HIGHMEM
+#define IFDEF_ZONE_HIGHMEM(X) X
+#else
+#define IFDEF_ZONE_HIGHMEM(X)
+#endif
+
+#define ZONE_TYPE						\
+	IFDEF_ZONE_DMA(		EM (ZONE_DMA,	 "DMA"))	\
+	IFDEF_ZONE_DMA32(	EM (ZONE_DMA32,	 "DMA32"))	\
+				EM (ZONE_NORMAL, "Normal")	\
+	IFDEF_ZONE_HIGHMEM(	EM (ZONE_HIGHMEM,"HighMem"))	\
+				EMe(ZONE_MOVABLE,"Movable")
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
+ZONE_TYPE
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)	{a, b},
+#define EMe(a, b)	{a, b}
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
bpf-do-not-use-kmalloc_shift_max.patch
mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch


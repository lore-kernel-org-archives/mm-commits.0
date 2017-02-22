From: akpm@linux-foundation.org
Subject: [patch 046/142] oom, trace: add compaction retry tracepoint
Date: Wed, 22 Feb 2017 15:42:03 -0800
Message-ID: <58ae21cb.L4TI7hIkk71iMeI9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934620AbdBVXmo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, rientjes@google.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: oom, trace: add compaction retry tracepoint

Higher order requests oom debugging is currently quite hard.  We do have
some compaction points which can tell us how the compaction is operating
but there is no trace point to tell us about compaction retry logic.  This
patch adds a one which will have the following format

            bash-3126  [001] ....  1498.220001: compact_retry: order=9 priority=COMPACT_PRIO_SYNC_LIGHT compaction_result=withdrawn retries=0 max_retries=16 should_retry=0

we can see that the order 9 request is not retried even though we are in
the highest compaction priority mode becase the last compaction attempt
was withdrawn.  This means that compaction_zonelist_suitable must have
returned false and there is no suitable zone to compact for this request
and so no need to retry further.

another example would be
           <...>-3137  [001] ....    81.501689: compact_retry: order=9 priority=COMPACT_PRIO_SYNC_LIGHT compaction_result=failed retries=0 max_retries=16 should_retry=0

in this case the order-9 compaction failed to find any suitable block.  We
do not retry anymore because this is a costly request and those do not go
below COMPACT_PRIO_SYNC_LIGHT priority.

Link: http://lkml.kernel.org/r/20161220130135.15719-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |   26 ++++++++++++++++++++
 include/trace/events/oom.h     |   39 +++++++++++++++++++++++++++++++
 mm/page_alloc.c                |   22 ++++++++++++-----
 3 files changed, 81 insertions(+), 6 deletions(-)

diff -puN include/trace/events/mmflags.h~oom-trace-add-compaction-retry-tracepoint include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~oom-trace-add-compaction-retry-tracepoint
+++ a/include/trace/events/mmflags.h
@@ -186,8 +186,32 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
 	EM( COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")	\
 	EMe(COMPACT_CONTENDED,		"contended")
+
+/* High-level compaction status feedback */
+#define COMPACTION_FAILED	1
+#define COMPACTION_WITHDRAWN	2
+#define COMPACTION_PROGRESS	3
+
+#define compact_result_to_feedback(result)	\
+({						\
+ 	enum compact_result __result = result;	\
+	(compaction_failed(__result)) ? COMPACTION_FAILED : \
+		(compaction_withdrawn(__result)) ? COMPACTION_WITHDRAWN : COMPACTION_PROGRESS; \
+})
+
+#define COMPACTION_FEEDBACK		\
+	EM(COMPACTION_FAILED,		"failed")	\
+	EM(COMPACTION_WITHDRAWN,	"withdrawn")	\
+	EMe(COMPACTION_PROGRESS,	"progress")
+
+#define COMPACTION_PRIORITY						\
+	EM(COMPACT_PRIO_SYNC_FULL,	"COMPACT_PRIO_SYNC_FULL")	\
+	EM(COMPACT_PRIO_SYNC_LIGHT,	"COMPACT_PRIO_SYNC_LIGHT")	\
+	EMe(COMPACT_PRIO_ASYNC,		"COMPACT_PRIO_ASYNC")
 #else
 #define COMPACTION_STATUS
+#define COMPACTION_PRIORITY
+#define COMPACTION_FEEDBACK
 #endif
 
 #ifdef CONFIG_ZONE_DMA
@@ -225,6 +249,8 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 #define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 COMPACTION_STATUS
+COMPACTION_PRIORITY
+COMPACTION_FEEDBACK
 ZONE_TYPE
 
 /*
diff -puN include/trace/events/oom.h~oom-trace-add-compaction-retry-tracepoint include/trace/events/oom.h
--- a/include/trace/events/oom.h~oom-trace-add-compaction-retry-tracepoint
+++ a/include/trace/events/oom.h
@@ -69,6 +69,45 @@ TRACE_EVENT(reclaim_retry_zone,
 			__entry->no_progress_loops,
 			__entry->wmark_check)
 );
+
+#ifdef CONFIG_COMPACTION
+TRACE_EVENT(compact_retry,
+
+	TP_PROTO(int order,
+		enum compact_priority priority,
+		enum compact_result result,
+		int retries,
+		int max_retries,
+		bool ret),
+
+	TP_ARGS(order, priority, result, retries, max_retries, ret),
+
+	TP_STRUCT__entry(
+		__field(	int, order)
+		__field(	int, priority)
+		__field(	int, result)
+		__field(	int, retries)
+		__field(	int, max_retries)
+		__field(	bool, ret)
+	),
+
+	TP_fast_assign(
+		__entry->order = order;
+		__entry->priority = priority;
+		__entry->result = compact_result_to_feedback(result);
+		__entry->retries = retries;
+		__entry->max_retries = max_retries;
+		__entry->ret = ret;
+	),
+
+	TP_printk("order=%d priority=%s compaction_result=%s retries=%d max_retries=%d should_retry=%d",
+			__entry->order,
+			__print_symbolic(__entry->priority, COMPACTION_PRIORITY),
+			__print_symbolic(__entry->result, COMPACTION_FEEDBACK),
+			__entry->retries, __entry->max_retries,
+			__entry->ret)
+);
+#endif /* CONFIG_COMPACTION */
 #endif
 
 /* This part must be outside protection */
diff -puN mm/page_alloc.c~oom-trace-add-compaction-retry-tracepoint mm/page_alloc.c
--- a/mm/page_alloc.c~oom-trace-add-compaction-retry-tracepoint
+++ a/mm/page_alloc.c
@@ -3197,6 +3197,9 @@ should_compact_retry(struct alloc_contex
 {
 	int max_retries = MAX_COMPACT_RETRIES;
 	int min_priority;
+	bool ret = false;
+	int retries = *compaction_retries;
+	enum compact_priority priority = *compact_priority;
 
 	if (!order)
 		return false;
@@ -3218,8 +3221,10 @@ should_compact_retry(struct alloc_contex
 	 * But do not retry if the given zonelist is not suitable for
 	 * compaction.
 	 */
-	if (compaction_withdrawn(compact_result))
-		return compaction_zonelist_suitable(ac, order, alloc_flags);
+	if (compaction_withdrawn(compact_result)) {
+		ret = compaction_zonelist_suitable(ac, order, alloc_flags);
+		goto out;
+	}
 
 	/*
 	 * !costly requests are much more important than __GFP_REPEAT
@@ -3231,8 +3236,10 @@ should_compact_retry(struct alloc_contex
 	 */
 	if (order > PAGE_ALLOC_COSTLY_ORDER)
 		max_retries /= 4;
-	if (*compaction_retries <= max_retries)
-		return true;
+	if (*compaction_retries <= max_retries) {
+		ret = true;
+		goto out;
+	}
 
 	/*
 	 * Make sure there are attempts at the highest priority if we exhausted
@@ -3241,12 +3248,15 @@ should_compact_retry(struct alloc_contex
 check_priority:
 	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
 			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
+
 	if (*compact_priority > min_priority) {
 		(*compact_priority)--;
 		*compaction_retries = 0;
-		return true;
+		ret = true;
 	}
-	return false;
+out:
+	trace_compact_retry(order, priority, compact_result, retries, max_retries, ret);
+	return ret;
 }
 #else
 static inline struct page *
_

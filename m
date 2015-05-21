From: akpm@linux-foundation.org
Subject: + tracing-add-trace-event-for-memory-failure.patch added to -mm
 tree
Date: Thu, 21 May 2015 16:18:39 -0700
Message-ID: <555e67cf.6nl4XcX0qYkSPIRj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbbEUXSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 19:18:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiexiuqi@huawei.com, gong.chen@linux.intel.com, jim.epost@gmail.com, n-horiguchi@ah.jp.nec.com, rostedt@goodmis.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: add trace event for memory-failure
has been added to the -mm tree.  Its filename is
     tracing-add-trace-event-for-memory-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-add-trace-event-for-memory-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-add-trace-event-for-memory-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: tracing: add trace event for memory-failure

RAS user space tools like rasdaemon which base on trace event, could
receive mce error event, but no memory recovery result event.  So, I want
to add this event to make this scenario complete.

This patch add a event at ras group for memory-failure.

The output like below:
#  tracer: nop
#
#  entries-in-buffer/entries-written: 2/2   #P:24
#
#                               _-----=> irqs-off
#                              / _----=> need-resched
#                             | / _---=> hardirq/softirq
#                             || / _--=> preempt-depth
#                             ||| /     delay
#            TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#               | |       |   ||||       |         |
       mce-inject-13150 [001] ....   277.019359: memory_failure_event: pfn 0x19869: recovery action for free buddy page: Delayed

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/ras/ras_event.h |   85 ++++++++++++++++++++++++++++++++++++++
 mm/memory-failure.c     |    3 +
 2 files changed, 88 insertions(+)

diff -puN include/ras/ras_event.h~tracing-add-trace-event-for-memory-failure include/ras/ras_event.h
--- a/include/ras/ras_event.h~tracing-add-trace-event-for-memory-failure
+++ a/include/ras/ras_event.h
@@ -11,6 +11,7 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/cper.h>
+#include <linux/mm.h>
 
 /*
  * MCE Extended Error Log trace event
@@ -232,6 +233,90 @@ TRACE_EVENT(aer_event,
 		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
 );
 
+/*
+ * memory-failure recovery action result event
+ *
+ * unsigned long pfn -	Page Frame Number of the corrupted page
+ * int type	-	Page types of the corrupted page
+ * int result	-	Result of recovery action
+ */
+
+#ifdef CONFIG_MEMORY_FAILURE
+#define MF_ACTION_RESULT	\
+	EM ( MF_IGNORED, "Ignored" )	\
+	EM ( MF_FAILED,  "Failed" )	\
+	EM ( MF_DELAYED, "Delayed" )	\
+	EMe ( MF_RECOVERED, "Recovered" )
+
+#define MF_PAGE_TYPE		\
+	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
+	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
+	EM ( MF_MSG_SLAB, "kernel slab page" )				\
+	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
+	EM ( MF_MSG_POISONED_HUGE, "huge page already hardware poisoned" )	\
+	EM ( MF_MSG_HUGE, "huge page" )					\
+	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
+	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
+	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
+	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
+	EM ( MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page" )	\
+	EM ( MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page" )	\
+	EM ( MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page" )	\
+	EM ( MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page" )	\
+	EM ( MF_MSG_DIRTY_LRU, "dirty LRU page" )			\
+	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
+	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
+	EM ( MF_MSG_BUDDY, "free buddy page" )				\
+	EM ( MF_MSG_BUDDY_2ND, "free buddy page (2nd try)" )		\
+	EMe ( MF_MSG_UNKNOWN, "unknown page" )
+
+/*
+ * First define the enums in MM_ACTION_RESULT to be exported to userspace
+ * via TRACE_DEFINE_ENUM().
+ */
+#undef EM
+#undef EMe
+#define EM(a, b) TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+MF_ACTION_RESULT
+MF_PAGE_TYPE
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)		{ a, b },
+#define EMe(a, b)	{ a, b }
+
+TRACE_EVENT(memory_failure_event,
+	TP_PROTO(unsigned long pfn,
+		 int type,
+		 int result),
+
+	TP_ARGS(pfn, type, result),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(int, type)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->pfn	= pfn;
+		__entry->type	= type;
+		__entry->result	= result;
+	),
+
+	TP_printk("pfn %#lx: recovery action for %s: %s",
+		__entry->pfn,
+		__print_symbolic(__entry->type, MF_PAGE_TYPE),
+		__print_symbolic(__entry->result, MF_ACTION_RESULT)
+	)
+);
+#endif /* CONFIG_MEMORY_FAILURE */
 #endif /* _TRACE_HW_EVENT_MC_H */
 
 /* This part must be outside protection */
diff -puN mm/memory-failure.c~tracing-add-trace-event-for-memory-failure mm/memory-failure.c
--- a/mm/memory-failure.c~tracing-add-trace-event-for-memory-failure
+++ a/mm/memory-failure.c
@@ -57,6 +57,7 @@
 #include <linux/mm_inline.h>
 #include <linux/kfifo.h>
 #include "internal.h"
+#include "ras/ras_event.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
 
@@ -855,6 +856,8 @@ static struct page_state {
 static void action_result(unsigned long pfn, enum mf_action_page_type type,
 			  enum mf_result result)
 {
+	trace_memory_failure_event(pfn, type, result);
+
 	pr_err("MCE %#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 }
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
tracing-add-trace-event-for-memory-failure-fix.patch


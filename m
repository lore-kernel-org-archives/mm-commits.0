Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D675B3EE1D0
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450117; cv=none; b=R3UgPVQfthW+eJRmmI4+yGzd8G6doR6/uJdFuJFAdG+uN4E8WljGin/GGUq1R/Ca924TIWGR+BnUGNyS25GAwFZad5fMKSUHPer1aiXxLmVV1MdmtLKlUQniMVb7MtIQZu2rjqQy3x1ZqtIRvS1zlhBD7of0b+ad4MlRypwKl4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450117; c=relaxed/simple;
	bh=1/ykEnvHkCiz1TOt7az94a+sIi9aqOY7Q++xxB2/wnw=;
	h=Date:To:From:Subject:Message-Id; b=Md0w71GRB/tHd3r8/13iuWbNl7SIt8HWiMnhf0O6T6I5iz6hL/4eafdvSzis9YaN9F6gPOO8V01QSkodET9BNa8x/JTKGtmI5W9T4dnaqYSoYpCwNFf+PckatYa/t9jCDODBRWgkm+MIlvxKgXP5Np6GrSyqrSlqIBsYKyfWvgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LolPhmi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LolPhmi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B99DC4CEF7;
	Wed, 25 Mar 2026 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774450117;
	bh=1/ykEnvHkCiz1TOt7az94a+sIi9aqOY7Q++xxB2/wnw=;
	h=Date:To:From:Subject:From;
	b=LolPhmi9KZSaBl1EKXKwtrkN/7Ri0rrqVu37s80RxlBZe88wBIDV9yV6j/aFun8Gz
	 oPEYbvYDlZAUiM5aJT3djFRA1Yg8mI3HLntPlShmdpkG4Tb4I+5JovETvklXw/H5H0
	 T5PhB/WjmmpkWSbcffNXtbpziuh8qNZ8rUww4SQQ=
Date: Wed, 25 Mar 2026 07:48:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lenb@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-add-tracepoints-for-zone-lock.patch removed from -mm tree
Message-Id: <20260325144837.4B99DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add tracepoints for zone lock
has been removed from the -mm tree.  Its filename was
     mm-add-tracepoints-for-zone-lock.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: add tracepoints for zone lock
Date: Fri, 27 Feb 2026 16:00:27 +0000

Add tracepoint instrumentation to zone lock acquire/release operations via
the previously introduced wrappers.

The implementation follows the mmap_lock tracepoint pattern: a lightweight
inline helper checks whether the tracepoint is enabled and calls into an
out-of-line helper when tracing is active.  When CONFIG_TRACING is
disabled, helpers compile to empty inline stubs.

The fast path is unaffected when tracing is disabled.

Link: https://lkml.kernel.org/r/ae145fe890f028409f727b4921904b547346fa0b.1772206930.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    1 
 include/linux/mmzone_lock.h      |   64 ++++++++++++++++++++++++++++-
 include/trace/events/zone_lock.h |   64 +++++++++++++++++++++++++++++
 mm/Makefile                      |    2 
 mm/zone_lock.c                   |   28 ++++++++++++
 5 files changed, 157 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone_lock.h~mm-add-tracepoints-for-zone-lock
+++ a/include/linux/mmzone_lock.h
@@ -4,6 +4,53 @@
 
 #include <linux/mmzone.h>
 #include <linux/spinlock.h>
+#include <linux/tracepoint-defs.h>
+
+DECLARE_TRACEPOINT(zone_lock_start_locking);
+DECLARE_TRACEPOINT(zone_lock_acquire_returned);
+DECLARE_TRACEPOINT(zone_lock_released);
+
+#ifdef CONFIG_TRACING
+
+void __zone_lock_do_trace_start_locking(struct zone *zone);
+void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success);
+void __zone_lock_do_trace_released(struct zone *zone);
+
+static inline void __zone_lock_trace_start_locking(struct zone *zone)
+{
+	if (tracepoint_enabled(zone_lock_start_locking))
+		__zone_lock_do_trace_start_locking(zone);
+}
+
+static inline void __zone_lock_trace_acquire_returned(struct zone *zone,
+						      bool success)
+{
+	if (tracepoint_enabled(zone_lock_acquire_returned))
+		__zone_lock_do_trace_acquire_returned(zone, success);
+}
+
+static inline void __zone_lock_trace_released(struct zone *zone)
+{
+	if (tracepoint_enabled(zone_lock_released))
+		__zone_lock_do_trace_released(zone);
+}
+
+#else /* !CONFIG_TRACING */
+
+static inline void __zone_lock_trace_start_locking(struct zone *zone)
+{
+}
+
+static inline void __zone_lock_trace_acquire_returned(struct zone *zone,
+						      bool success)
+{
+}
+
+static inline void __zone_lock_trace_released(struct zone *zone)
+{
+}
+
+#endif /* CONFIG_TRACING */
 
 static inline void zone_lock_init(struct zone *zone)
 {
@@ -12,26 +59,41 @@ static inline void zone_lock_init(struct
 
 #define zone_lock_irqsave(zone, flags)				\
 do {								\
+	bool success = true;					\
+								\
+	__zone_lock_trace_start_locking(zone);			\
 	spin_lock_irqsave(&(zone)->_lock, flags);		\
+	__zone_lock_trace_acquire_returned(zone, success);	\
 } while (0)
 
 #define zone_trylock_irqsave(zone, flags)			\
 ({								\
-	spin_trylock_irqsave(&(zone)->_lock, flags);		\
+	bool success;						\
+								\
+	__zone_lock_trace_start_locking(zone);			\
+	success = spin_trylock_irqsave(&(zone)->_lock, flags);	\
+	__zone_lock_trace_acquire_returned(zone, success);	\
+	success;						\
 })
 
 static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
 {
+	__zone_lock_trace_released(zone);
 	spin_unlock_irqrestore(&zone->_lock, flags);
 }
 
 static inline void zone_lock_irq(struct zone *zone)
 {
+	bool success = true;
+
+	__zone_lock_trace_start_locking(zone);
 	spin_lock_irq(&zone->_lock);
+	__zone_lock_trace_acquire_returned(zone, success);
 }
 
 static inline void zone_unlock_irq(struct zone *zone)
 {
+	__zone_lock_trace_released(zone);
 	spin_unlock_irq(&zone->_lock);
 }
 
diff --git a/include/trace/events/zone_lock.h a/include/trace/events/zone_lock.h
new file mode 100644
--- /dev/null
+++ a/include/trace/events/zone_lock.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM zone_lock
+
+#if !defined(_TRACE_ZONE_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ZONE_LOCK_H
+
+#include <linux/tracepoint.h>
+#include <linux/types.h>
+
+struct zone;
+
+DECLARE_EVENT_CLASS(zone_lock,
+
+	TP_PROTO(struct zone *zone),
+
+	TP_ARGS(zone),
+
+	TP_STRUCT__entry(
+		__field(struct zone *, zone)
+	),
+
+	TP_fast_assign(
+		__entry->zone = zone;
+	),
+
+	TP_printk("zone=%p", __entry->zone)
+);
+
+#define DEFINE_ZONE_LOCK_EVENT(name)			\
+	DEFINE_EVENT(zone_lock, name,			\
+		TP_PROTO(struct zone *zone),		\
+		TP_ARGS(zone))
+
+DEFINE_ZONE_LOCK_EVENT(zone_lock_start_locking);
+DEFINE_ZONE_LOCK_EVENT(zone_lock_released);
+
+TRACE_EVENT(zone_lock_acquire_returned,
+
+	TP_PROTO(struct zone *zone, bool success),
+
+	TP_ARGS(zone, success),
+
+	TP_STRUCT__entry(
+		__field(struct zone *, zone)
+		__field(bool, success)
+	),
+
+	TP_fast_assign(
+		__entry->zone = zone;
+		__entry->success = success;
+	),
+
+	TP_printk(
+		"zone=%p success=%s",
+		__entry->zone,
+		__entry->success ? "true" : "false"
+	)
+);
+
+#endif /* _TRACE_ZONE_LOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/MAINTAINERS~mm-add-tracepoints-for-zone-lock
+++ a/MAINTAINERS
@@ -16671,6 +16671,7 @@ F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/trace/events/zone_lock.h
 F:	fs/proc/meminfo.c
 F:	kernel/fork.c
 F:	mm/Kconfig
--- a/mm/Makefile~mm-add-tracepoints-for-zone-lock
+++ a/mm/Makefile
@@ -55,7 +55,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   debug.o gup.o mmap_lock.o vma_init.o $(mmu-y)
+			   debug.o gup.o mmap_lock.o zone_lock.o vma_init.o $(mmu-y)
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
diff --git a/mm/zone_lock.c a/mm/zone_lock.c
new file mode 100644
--- /dev/null
+++ a/mm/zone_lock.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/zone_lock.h>
+
+#include <linux/mmzone_lock.h>
+
+EXPORT_TRACEPOINT_SYMBOL(zone_lock_start_locking);
+EXPORT_TRACEPOINT_SYMBOL(zone_lock_acquire_returned);
+EXPORT_TRACEPOINT_SYMBOL(zone_lock_released);
+
+#ifdef CONFIG_TRACING
+
+void __zone_lock_do_trace_start_locking(struct zone *zone)
+{
+	trace_zone_lock_start_locking(zone);
+}
+
+void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success)
+{
+	trace_zone_lock_acquire_returned(zone, success);
+}
+
+void __zone_lock_do_trace_released(struct zone *zone)
+{
+	trace_zone_lock_released(zone);
+}
+
+#endif /* CONFIG_TRACING */
_

Patches currently in -mm which might be from d@ilvokhin.com are



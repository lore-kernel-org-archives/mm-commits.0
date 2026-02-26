Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13ED33343B
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772141162; cv=none; b=Ah5l3NpvX63qPwsE2Kl8kN+4j28JU0D2xpUeaCItnTLrEorCa8xVbZjQlYQHuXslUzZeHY4lff4TPqKDluuHw8uSnOh05zCQjzm48TE10cOaGYykngKkdO4dsbPJs3k2FzDgL1Xc5o09FjVXcbKR0IAf8RZCJPE9Y0Bn22UGeB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772141162; c=relaxed/simple;
	bh=QRIcx0AukvcD/UGK9MLcpDEw5wMil7/wZmX+MW2nbko=;
	h=Date:To:From:Subject:Message-Id; b=WuhRLQc4cJq8P519tmX2DXnPHSoKIj1KQyHSYjL1lEUWoD2nvzKeEyKiWD1uUuuwZPrGcsDp3if+ifPZHW24tF3whfmuKWLklihp2DsOS9AIy3TGDIK+Aj5PXGmIi9dnUGhw0hQT+Rj1awJhCbRbcTsYGqsi6CzXfYD4y6Ldwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0CqJDGAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0CqJDGAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758EBC19422;
	Thu, 26 Feb 2026 21:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772141161;
	bh=QRIcx0AukvcD/UGK9MLcpDEw5wMil7/wZmX+MW2nbko=;
	h=Date:To:From:Subject:From;
	b=0CqJDGARUvcck0Gs04/ZRFQNEShnQdEOD9xpEnGW1425iaqYtCKAlNfQAKXATKmcd
	 qKmgvBrvKzlJrvzWg1yKDNUN3XXAbCUIJCq9oYvsSvuyUjtM8U2plcsya5q+YkiM2e
	 AKFbOuCQTGSZveyrhZ0CGJNP2CTckYMURviuqtS4=
Date: Thu, 26 Feb 2026 13:26:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,benjamin.cheatham@amd.com,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-tracepoints-for-zone-lock.patch added to mm-new branch
Message-Id: <20260226212601.758EBC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add tracepoints for zone lock
has been added to the -mm mm-new branch.  Its filename is
     mm-add-tracepoints-for-zone-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-tracepoints-for-zone-lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: add tracepoints for zone lock
Date: Thu, 26 Feb 2026 18:26:22 +0000

Add tracepoint instrumentation to zone lock acquire/release operations via
the previously introduced wrappers.

The implementation follows the mmap_lock tracepoint pattern: a lightweight
inline helper checks whether the tracepoint is enabled and calls into an
out-of-line helper when tracing is active.  When CONFIG_TRACING is
disabled, helpers compile to empty inline stubs.

The fast path is unaffected when tracing is disabled.

Link: https://lkml.kernel.org/r/378089dd269249d3d7981fe10eb8b49ad551d353.1772129168.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Cheatham <benjamin.cheatham@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    2 
 include/linux/zone_lock.h        |   64 ++++++++++++++++++++++++++++-
 include/trace/events/zone_lock.h |   64 +++++++++++++++++++++++++++++
 mm/Makefile                      |    2 
 mm/zone_lock.c                   |   31 ++++++++++++++
 5 files changed, 161 insertions(+), 2 deletions(-)

--- a/include/linux/zone_lock.h~mm-add-tracepoints-for-zone-lock
+++ a/include/linux/zone_lock.h
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
@@ -16682,6 +16682,7 @@ F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
 F:	include/linux/zone_lock.h
+F:	include/trace/events/zone_lock.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
@@ -16701,6 +16702,7 @@ F:	mm/sparse.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
+F:	mm/zone_lock.c
 N:	include/linux/page[-_]*
 
 MEMORY MANAGEMENT - EXECMEM
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
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+#define CREATE_TRACE_POINTS
+#include <trace/events/zone_lock.h>
+
+#include <linux/zone_lock.h>
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
+EXPORT_SYMBOL(__zone_lock_do_trace_start_locking);
+
+void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success)
+{
+	trace_zone_lock_acquire_returned(zone, success);
+}
+EXPORT_SYMBOL(__zone_lock_do_trace_acquire_returned);
+
+void __zone_lock_do_trace_released(struct zone *zone)
+{
+	trace_zone_lock_released(zone);
+}
+EXPORT_SYMBOL(__zone_lock_do_trace_released);
+
+#endif /* CONFIG_TRACING */
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-introduce-zone-lock-wrappers.patch
mm-convert-zone-lock-users-to-wrappers.patch
mm-convert-compaction-to-zone-lock-wrappers.patch
mm-rename-zone-lock-to-zone-_lock.patch
mm-add-tracepoints-for-zone-lock.patch


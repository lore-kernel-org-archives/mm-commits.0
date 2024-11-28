Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AAB17753
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732756835; cv=none; b=gvPa48b+yT6hjvgaDDq9MjvOcVt3CjR2GunIiF/P0xwlx7ZhHoTi4BKMa9ClAZCZBJFF596LSkyyPOZuyjNxFnXp2honPjbs+77zRuXaUb2WvTk18dC1PxuSpfX6Cjy1PS0zPFK3JtR01MtyDeDnyoaIiQ0D5SJPjSM4qEUd54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732756835; c=relaxed/simple;
	bh=qP0f4+rSFiS1DCs83pVurYGuxWN6PIINwrdYPKL23bk=;
	h=Date:To:From:Subject:Message-Id; b=V9FoyekOvoYedLwZ9GVHnNssifQU2YFntSkdf/3yWXufcEVnCu8mCuoFgAHyb/sOwaoO1zHyScPLbCP633aRBFZVlSLVxnt4sF5qb6/1+FX9jzzRIhDCOrR/AnD+Tto25CX2zQPQXP4qaYECZwg0NmxQ5BRN2FZ2UDKpzSujpfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=czZX5s/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="czZX5s/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80CCC4CECC;
	Thu, 28 Nov 2024 01:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732756833;
	bh=qP0f4+rSFiS1DCs83pVurYGuxWN6PIINwrdYPKL23bk=;
	h=Date:To:From:Subject:From;
	b=czZX5s/gqg34QTYomW0CNtu8tP2SS+0IOgqP+zhVy/+2WPDXIZxT60S3NtTlcObKD
	 eANnZQMJQE/2+SdUgKZd+M0RfR8W3KMGuJ1Dx8t3D81Yulk/Cgdsu1ZZTR13cptoBg
	 TvrPPz5xmWX/P6f3ETdEmh0OE7wPPlrz9m1eI0kY=
Date: Wed, 27 Nov 2024 17:20:33 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,rostedt@goodmis.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap_lock-optimize-mmap_lock-tracepoints.patch added to mm-unstable branch
Message-Id: <20241128012033.A80CCC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mmap_lock: optimize mmap_lock tracepoints
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap_lock-optimize-mmap_lock-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap_lock-optimize-mmap_lock-tracepoints.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: mmap_lock: optimize mmap_lock tracepoints
Date: Mon, 25 Nov 2024 09:16:17 -0800

We are starting to deploy mmap_lock tracepoint monitoring across our
fleet and the early results showed that these tracepoints are consuming
significant amount of CPUs in kernfs_path_from_node when enabled.

It seems like the kernel is trying to resolve the cgroup path in the
fast path of the locking code path when the tracepoints are enabled. In
addition for some application their metrics are regressing when
monitoring is enabled.

The cgroup path resolution can be slow and should not be done in the
fast path. Most userspace tools, like bpftrace, provides functionality
to get the cgroup path from cgroup id, so let's just trace the cgroup
id and the users can use better tools to get the path in the slow path.

Link: https://lkml.kernel.org/r/20241125171617.113892-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h       |   22 ++++++++++++
 include/trace/events/mmap_lock.h |   32 ++++++++----------
 mm/mmap_lock.c                   |   50 +----------------------------
 3 files changed, 40 insertions(+), 64 deletions(-)

--- a/include/linux/memcontrol.h~mm-mmap_lock-optimize-mmap_lock-tracepoints
+++ a/include/linux/memcontrol.h
@@ -1046,6 +1046,23 @@ static inline void memcg_memory_event_mm
 
 void split_page_memcg(struct page *head, int old_order, int new_order);
 
+static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
+{
+	struct mem_cgroup *memcg;
+	u64 id;
+
+	if (mem_cgroup_disabled())
+		return 0;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (!memcg)
+		memcg = root_mem_cgroup;
+	id = cgroup_id(memcg->css.cgroup);
+	rcu_read_unlock();
+	return id;
+}
+
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
@@ -1466,6 +1483,11 @@ void count_memcg_event_mm(struct mm_stru
 static inline void split_page_memcg(struct page *head, int old_order, int new_order)
 {
 }
+
+static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG */
 
 /*
--- a/include/trace/events/mmap_lock.h~mm-mmap_lock-optimize-mmap_lock-tracepoints
+++ a/include/trace/events/mmap_lock.h
@@ -5,6 +5,7 @@
 #if !defined(_TRACE_MMAP_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_MMAP_LOCK_H
 
+#include <linux/memcontrol.h>
 #include <linux/tracepoint.h>
 #include <linux/types.h>
 
@@ -12,64 +13,61 @@ struct mm_struct;
 
 DECLARE_EVENT_CLASS(mmap_lock,
 
-	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write),
+	TP_PROTO(struct mm_struct *mm, bool write),
 
-	TP_ARGS(mm, memcg_path, write),
+	TP_ARGS(mm, write),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
-		__string(memcg_path, memcg_path)
+		__field(u64, memcg_id)
 		__field(bool, write)
 	),
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__assign_str(memcg_path);
+		__entry->memcg_id = cgroup_id_from_mm(mm);
 		__entry->write = write;
 	),
 
 	TP_printk(
-		"mm=%p memcg_path=%s write=%s",
-		__entry->mm,
-		__get_str(memcg_path),
+		"mm=%p memcg_id=%llu write=%s",
+		__entry->mm, __entry->memcg_id,
 		__entry->write ? "true" : "false"
 	)
 );
 
 #define DEFINE_MMAP_LOCK_EVENT(name)                                    \
 	DEFINE_EVENT(mmap_lock, name,                                   \
-		TP_PROTO(struct mm_struct *mm, const char *memcg_path,  \
-			bool write),                                    \
-		TP_ARGS(mm, memcg_path, write))
+		TP_PROTO(struct mm_struct *mm, bool write),		\
+		TP_ARGS(mm, write))
 
 DEFINE_MMAP_LOCK_EVENT(mmap_lock_start_locking);
 DEFINE_MMAP_LOCK_EVENT(mmap_lock_released);
 
 TRACE_EVENT(mmap_lock_acquire_returned,
 
-	TP_PROTO(struct mm_struct *mm, const char *memcg_path, bool write,
-		bool success),
+	TP_PROTO(struct mm_struct *mm, bool write, bool success),
 
-	TP_ARGS(mm, memcg_path, write, success),
+	TP_ARGS(mm, write, success),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
-		__string(memcg_path, memcg_path)
+		__field(u64, memcg_id)
 		__field(bool, write)
 		__field(bool, success)
 	),
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__assign_str(memcg_path);
+		__entry->memcg_id = cgroup_id_from_mm(mm);
 		__entry->write = write;
 		__entry->success = success;
 	),
 
 	TP_printk(
-		"mm=%p memcg_path=%s write=%s success=%s",
+		"mm=%p memcg_id=%llu write=%s success=%s",
 		__entry->mm,
-		__get_str(memcg_path),
+		__entry->memcg_id,
 		__entry->write ? "true" : "false",
 		__entry->success ? "true" : "false"
 	)
--- a/mm/mmap_lock.c~mm-mmap_lock-optimize-mmap_lock-tracepoints
+++ a/mm/mmap_lock.c
@@ -17,51 +17,7 @@ EXPORT_TRACEPOINT_SYMBOL(mmap_lock_start
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_acquire_returned);
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_released);
 
-#ifdef CONFIG_MEMCG
-
-/*
- * Size of the buffer for memcg path names. Ignoring stack trace support,
- * trace_events_hist.c uses MAX_FILTER_STR_VAL for this, so we also use it.
- */
-#define MEMCG_PATH_BUF_SIZE MAX_FILTER_STR_VAL
-
-#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)				\
-	do {								\
-		if (trace_mmap_lock_##type##_enabled()) {		\
-			char buf[MEMCG_PATH_BUF_SIZE];                  \
-			get_mm_memcg_path(mm, buf, sizeof(buf));        \
-			trace_mmap_lock_##type(mm, buf, ##__VA_ARGS__); \
-		}							\
-	} while (0)
-
-#else /* !CONFIG_MEMCG */
-
-#define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
-	trace_mmap_lock_##type(mm, "", ##__VA_ARGS__)
-
-#endif /* CONFIG_MEMCG */
-
 #ifdef CONFIG_TRACING
-#ifdef CONFIG_MEMCG
-/*
- * Write the given mm_struct's memcg path to a buffer. If the path cannot be
- * determined, empty string is written.
- */
-static void get_mm_memcg_path(struct mm_struct *mm, char *buf, size_t buflen)
-{
-	struct mem_cgroup *memcg;
-
-	buf[0] = '\0';
-	memcg = get_mem_cgroup_from_mm(mm);
-	if (memcg == NULL)
-		return;
-	if (memcg->css.cgroup)
-		cgroup_path(memcg->css.cgroup, buf, buflen);
-	css_put(&memcg->css);
-}
-
-#endif /* CONFIG_MEMCG */
-
 /*
  * Trace calls must be in a separate file, as otherwise there's a circular
  * dependency between linux/mmap_lock.h and trace/events/mmap_lock.h.
@@ -69,20 +25,20 @@ static void get_mm_memcg_path(struct mm_
 
 void __mmap_lock_do_trace_start_locking(struct mm_struct *mm, bool write)
 {
-	TRACE_MMAP_LOCK_EVENT(start_locking, mm, write);
+	trace_mmap_lock_start_locking(mm, write);
 }
 EXPORT_SYMBOL(__mmap_lock_do_trace_start_locking);
 
 void __mmap_lock_do_trace_acquire_returned(struct mm_struct *mm, bool write,
 					   bool success)
 {
-	TRACE_MMAP_LOCK_EVENT(acquire_returned, mm, write, success);
+	trace_mmap_lock_acquire_returned(mm, write, success);
 }
 EXPORT_SYMBOL(__mmap_lock_do_trace_acquire_returned);
 
 void __mmap_lock_do_trace_released(struct mm_struct *mm, bool write)
 {
-	TRACE_MMAP_LOCK_EVENT(released, mm, write);
+	trace_mmap_lock_released(mm, write);
 }
 EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #endif /* CONFIG_TRACING */
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-mmap_lock-optimize-mmap_lock-tracepoints.patch


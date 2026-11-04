Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833803;
	b=zby31DZGiddDwcON93ztUOiUrDgQrfaWo+vCabw6ZqTKs59YGUtMX3h6zJZ6M/othoK6
	 CITU+TvNPSr/CBEQ+1VajaNvlsldd8xpq79+xFCzZXaV0wJy2RG/8sO3npprU9/vnOIT9
	 0YuBZF2wo5wmo4k82uF8DuegQgUO4lvvBmC/ZMAiPMM7UlSYCAn0VhjQHxX2N2ReHK0lP
	 RCdSwYYR3HUaAVqajRRoM383z9kESnwrtbnCzeSQUKHE0WD+Nt5EGL3/7nCPeYVWJD3T2
	 1c432quvCokcjFHjz3iw1QJvx5Pi69hinxyvcjclykbBSKWHzYot6UfFEl3wkCRXx9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833803;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jz9+EMb9rH+yfH8BRIHAUzEWxKAA6Y7cnydroY7rUUQ=;
	b=TOU6gCIPfQ9BXB+HARDpqAytDglxUifBUSRqxQstFyUIVGMztumRTdQ6SKhwgBr3W+QB
	 vhKPwhOk2WusVM6BYfYMU1S/dI4/Ii0fK+VFHJXlKPYzXjVohPkSImowUIE+oJR/TZiBw
	 gmvC8bDbOKmgLk6zZNT4kcbuGyTWjPGWaxNHjDN2o/T31RT9OQ4dpZoiAWDfToSBiVmds
	 BsnR1RQ3zNoiY22HdPRi8HVksrR2HBGIb3fFAycB/VxLzDoRXFqYjEpLLgWTLHLm+r58o
	 gCv+gcYWyo+btRPiy/x2c291DiSu7u5TVvwH0ut8k/HdUUoh6Nl8JwpYfcCvXA90oog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="zWv4G/mI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19240606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 23:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zWv4G/mI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C661F00919;
	Wed,  4 Nov 2026 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793833802;
	bh=jz9+EMb9rH+yfH8BRIHAUzEWxKAA6Y7cnydroY7rUUQ=;
	h=Date:To:From:Subject;
	b=zWv4G/mITNKxJPdFWjfwQI02FtRzcNXtzy32P1U2ABZX/74xJUSvnMaV5AAkVDVEi
	 PDZ7rgID81rMEU+TZf7tBF2+XxiFG6sGr48fqQo41aC2XIQoWWxtDEGjV1gBPnOe9i
	 Cpey5jYoqNQz/A+4xGwzFN52jk1Ef1ORwrlWJ2Bo=
Date: Wed, 04 Nov 2026 15:10:01 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,
	akpm@linux-foundation.org,abhishekbapat@google.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-add-trace-events-for-tracing-allocations.patch added to mm-new branch
Message-Id: <20261104231002.78C661F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag: add trace events for tracing allocations
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-add-trace-events-for-tracing-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-add-trace-events-for-tracing-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: add trace events for tracing allocations
Date: Wed, 04 Nov 2026 19:03:36 +0000

Patch series "alloc_tag: Introduce selective tracing for MAP", v5.

The existing memory allocation profiling (MAP) tool accurately maintains
aggregate counters for overall memory accounting. However, relying
purely on aggregated counters restrics the visibility needed for
targeted debugging.

This patch series integrates three new tracepoints (alloc_tag_hit,
alloc_tag_mem_alloced and alloc_tag_mem_freed) directly into the
alloc_hooks_tag fast path.

Enabling trace events globally for all allocations introduces a severe
baseline overhead. To limit the performance overhead, we let the admin
select specific allocations to be traced.

A new IOCTL is introduced to allow privileged users to determine which
allocation tags need tracing enabled. The IOCTL utilizes the
pre-existing filtering mechanism to specify the allocation tags to
enable tracing on.


This patch (of 5):

The memory allocation profiling framework intercepts allocations across
the core subsystems, but currently lacks runtime tracing hooks for
standard observability tools to dynamically track the context (stack
traces and lifecycles of the individual memory chunks) of the
allocations made.

Introduce three standard trace events to allow this tracking:

1. `alloc_tag_hit`: Fired at the exact call site. This allows userspace
   tools to trigger and capture a call stack.
2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
   allocation. It records the allocated size, the tag, and the uniquely
   generated `ptr` value which is `codetag_ref` for slab and percpu
   allocators and the pointer to the head `struct page` for the page
   allocator.
3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory is
   freed, yielding the same `ptr` value to allow tracing tools to find
   the corresponding allocation.

Because the introduced trace events occur at different stages in the
call stack, userspace tracing tools must stitch them together to form a
complete picture of a buffer's lifetime. Here's an example of how
userspace correlates these three events:

1. On `alloc_tag_hit`: The tool captures the stack trace and caches it,
   keyed by the combination of the current thread's PID and the `tag`.
2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` from
   the event and looks up the stack trace cached in step 1. It creates a
   new active allocation record, mapping the new provided `ptr` value
   to this cached stack trace and the newly returned allocation size.
3. On `alloc_tag_mem_freed`: When the memory is freed, the event yields
   the same `ptr` value. The tool uses this reference to look up the
   original allocation record, correlates the free, and safely retires
   the tracking entry.

Modify `alloc_tag_add()` and `alloc_tag_sub()` with a `ptr` argument to
map frees to allocations in the trace events. Slab and percpu pass the
address of the object's `codetag_ref`. The page allocator passes the
head `struct page` because its `codetag_ref` is a temporary copy on the
stack.

Also, introduce `alloc_tag_trace_key` static key to minimize the
overhead when no tags are being traced (the usual case). Once tracing
for any tag is requested, the key is set, opening the path to check
whether tracing is enabled for the current tag.
Note that the mechanism to enable tag tracing is implemented in the next
patch, therefore for now, `alloc_tag_trace_key` stays always unset.

Link: https://lore.kernel.org/cover.1793818636.git.abhishekbapat@google.com
Link: https://lore.kernel.org/ba221f76f8bee0ec8ac32e7ffaba35fd78b67a7f.1793818636.git.abhishekbapat@google.com
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---

 Documentation/mm/allocation-profiling.rst |   53 ++++++++
 MAINTAINERS                               |    1 
 include/linux/alloc_tag.h                 |   69 ++++++++---
 include/trace/events/alloc_tag.h          |  122 ++++++++++++++++++++
 mm/alloc_tag.c                            |   28 ++++
 mm/page_alloc.c                           |    4 
 mm/percpu.c                               |   13 +-
 mm/slub.c                                 |    6 
 8 files changed, 270 insertions(+), 26 deletions(-)

--- a/Documentation/mm/allocation-profiling.rst~alloc_tag-add-trace-events-for-tracing-allocations
+++ a/Documentation/mm/allocation-profiling.rst
@@ -129,6 +129,59 @@ To do so:
 - Then, use the following form for your allocations:
   alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
 
+Tracing
+=======
+
+Three trace events are available under `/sys/kernel/tracing/events/alloc_tag` to
+expose the full call stack and the lifetime of individual allocations:
+
+- `alloc_tag_hit`: Fired at the exact call site, before the allocation happens.
+  Can be used to capture the call stack of the caller.
+
+- `alloc_tag_mem_alloced`: Fired once the allocation succeeds. Carries the `ptr`,
+  `tag` and `bytes` for each allocation.
+
+- `alloc_tag_mem_freed`: Fired before memory is freed. Carries the same
+  `ptr`, `tag` and `bytes` as the matching alloc event.
+
+`ptr` identifies the allocation, and its meaning depends on the allocator:
+
+- slab and percpu: the address of the object's `codetag_ref`
+- page allocator: the `struct page` pointer of the head page
+
+Correlating the events
+----------------------
+
+`alloc_tag_hit` and `alloc_tag_mem_alloced` come from different points in the
+call stack, so they have to be stitched together by the user consuming the
+events. Here's a typical flow:
+
+1. On `alloc_tag_hit`: Capture the stack trace and cache it keyed by `(pid, tag)`.
+
+2. On `alloc_tag_mem_alloced`: Look up the cached stack trace by `(pid, tag)`,
+   then create an active allocation record keyed by `ptr` that holds the stack
+   trace and `bytes`.
+
+3. On `alloc_tag_mem_freed`: Look up the record by `ptr` and retire it.
+
+Limitations
+-----------
+
+- For the page allocator, events are generated for the original allocation and
+  the free only. If the tag reference is split or moved to another folio in
+  between, no event is generated for that. As a result:
+
+  - a free event may carry a `ptr` that never appeared in an alloc event;
+  - `bytes` in a free event may be smaller than in the matching alloc event.
+
+  Tools should correlate on `ptr` but must not assume that freed bytes equal
+  allocated bytes, or that every free has a matching alloc.
+
+- Freeing a non-compound high-order page with `__free_pages()` while another CPU
+  holds a reference frees the tail pages immediately and the head page later when
+  the reference is dropped. The free event is emitted at the second point and
+  reports `PAGE_SIZE` rather than the full size.
+
 Notes
 =====
 
--- a/include/linux/alloc_tag.h~alloc_tag-add-trace-events-for-tracing-allocations
+++ a/include/linux/alloc_tag.h
@@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counter
 DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
 
+DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
+
 static inline bool mem_alloc_profiling_enabled(void)
 {
 	return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 				   &mem_alloc_profiling_key);
 }
 
+static inline bool alloc_tag_trace_enabled(void)
+{
+	return static_branch_unlikely(&alloc_tag_trace_key);
+}
+
+void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
+			       size_t bytes);
+
+void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag,
+			      size_t bytes);
+
+void __alloc_tag_trace_hit(struct alloc_tag *tag);
+
+static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
+{
+	if (alloc_tag_trace_enabled())
+		__alloc_tag_trace_hit(tag);
+}
+
 bool mem_alloc_profiling_permanently_disabled(void);
 
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
@@ -198,13 +219,19 @@ static inline bool alloc_tag_ref_set(uni
 	return true;
 }
 
-static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes)
+static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes,
+				 const void *ptr)
 {
-	if (likely(alloc_tag_ref_set(ref, tag)))
+	if (likely(alloc_tag_ref_set(ref, tag))) {
 		this_cpu_add(tag->counters->bytes, bytes);
+
+		if (alloc_tag_trace_enabled())
+			/* Trace successful allocs with their unique ptr */
+			alloc_tag_trace_mem_alloc(ptr, tag, bytes);
+	}
 }
 
-static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
+static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes, const void *ptr)
 {
 	struct alloc_tag *tag;
 
@@ -222,6 +249,10 @@ static inline void alloc_tag_sub(union c
 	this_cpu_sub(tag->counters->bytes, bytes);
 	this_cpu_dec(tag->counters->calls);
 
+	if (alloc_tag_trace_enabled())
+		/* Trace frees with their unique ptr */
+		alloc_tag_trace_mem_free(ptr, tag, bytes);
+
 	ref->ct = NULL;
 }
 
@@ -243,25 +274,29 @@ static inline bool alloc_tag_is_inaccura
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
 static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
-				 size_t bytes) {}
-static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
+				 size_t bytes, const void *ptr) {}
+static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes,
+				 const void *ptr) {}
 static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
 static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
-#define alloc_tag_record(p)	do {} while (0)
+#define alloc_tag_trace_hit(_tag)	do {} while (0)
+#define alloc_tag_record(p)		do {} while (0)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-#define alloc_hooks_tag(_tag, _do_alloc)				\
-({									\
-	typeof(_do_alloc) _res;						\
-	if (mem_alloc_profiling_enabled()) {				\
-		struct alloc_tag * __maybe_unused _old;			\
-		_old = alloc_tag_save(_tag);				\
-		_res = _do_alloc;					\
-		alloc_tag_restore(_tag, _old);				\
-	} else								\
-		_res = _do_alloc;					\
-	_res;								\
+#define alloc_hooks_tag(_tag, _do_alloc)					\
+({										\
+	typeof(_do_alloc) _res;							\
+	if (mem_alloc_profiling_enabled()) {					\
+		struct alloc_tag * __maybe_unused _old;				\
+		/* Fired here to capture the caller's stack trace */		\
+		alloc_tag_trace_hit(_tag);					\
+		_old = alloc_tag_save(_tag);					\
+		_res = _do_alloc;						\
+		alloc_tag_restore(_tag, _old);					\
+	} else									\
+		_res = _do_alloc;						\
+	_res;									\
 })
 
 #define alloc_hooks(_do_alloc)						\
diff --git a/include/trace/events/alloc_tag.h a/include/trace/events/alloc_tag.h
new file mode 100644
--- /dev/null
+++ a/include/trace/events/alloc_tag.h
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM alloc_tag
+
+#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ALLOC_TAG_H
+
+#include <linux/tracepoint.h>
+
+/*
+ * alloc_tag_hit is generated at the exact allocation call site and can be
+ * used to capture a stack trace.
+ *
+ * To link this stack trace to the actual allocated memory chunk, tools must
+ * correlate this event with the resulting alloc_tag_mem_alloced event. Since
+ * multiple threads can hit the same tag simultaneously, tools must match BOTH
+ * the `tag` field and the implicitly recorded PID provided by the core
+ * tracing subsystem.
+ */
+TRACE_EVENT(alloc_tag_hit,
+	TP_PROTO(struct alloc_tag *tag),
+
+	TP_ARGS(tag),
+
+	TP_STRUCT__entry(__field(struct alloc_tag *, tag)
+			 __string(modname, tag->ct.modname ? tag->ct.modname : "NONE")
+			 __string(filename, tag->ct.filename)
+			 __string(function, tag->ct.function)
+			 __field(unsigned int, lineno)
+	),
+
+	TP_fast_assign(__entry->tag = tag;
+		       __assign_str(modname);
+		       __assign_str(filename);
+		       __assign_str(function);
+		       __entry->lineno = tag->ct.lineno;
+	),
+
+	TP_printk("tag %p, module: %s, filename: %s, function %s, lineno %u",
+		  __entry->tag,
+		  __get_str(modname),
+		  __get_str(filename),
+		  __get_str(function),
+		  __entry->lineno
+	)
+);
+
+/*
+ * alloc_tag_mem_alloced is generated after memory is successfully allocated.
+ * It captures the exact byte size.
+ *
+ * The `ptr` value identifies the memory chunk for tracking its lifecycle
+ * (e.g., matching it with alloc_tag_mem_freed).
+ * - slab and percpu allocators: address of the object's codetag_ref
+ * - page allocator: the head struct page of the allocation
+ *
+ * Because the kernel isolates active allocations within the task struct
+ * (current->alloc_tag), this event will always share the same implicit PID as
+ * its corresponding alloc_tag_hit event. Tools should use the combination
+ * PID + `tag` to correlate them.
+ */
+TRACE_EVENT(alloc_tag_mem_alloced,
+	TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
+
+	TP_ARGS(ptr, tag, bytes),
+
+	TP_STRUCT__entry(__field(const void *, ptr)
+			 __field(struct alloc_tag *, tag)
+			 __field(size_t, bytes)
+	),
+
+	TP_fast_assign(__entry->ptr = ptr;
+		       __entry->tag = tag;
+		       __entry->bytes = bytes;
+	),
+
+	TP_printk("ptr %p, tag %p, bytes %zu",
+		  __entry->ptr,
+		  __entry->tag,
+		  __entry->bytes
+	)
+);
+
+/*
+ * alloc_tag_mem_freed event is generated immediately before memory is
+ * freed. The `ptr` value matches the one emitted during allocation,
+ * allowing tools to match it to its corresponding allocation and
+ * call stack.
+ *
+ * Page allocator caveat: Pages can be split or moved to another folio
+ * after the alloc event with no new events generated for that. As a
+ * result, a free event may carry a `ptr` that never appeared in an
+ * alloc event, and the `bytes` may be smaller than in the matching
+ * alloc event. Tools must not assume alloc bytes == free bytes, nor
+ * that every free has a matching alloc.
+ */
+TRACE_EVENT(alloc_tag_mem_freed,
+	TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
+
+	TP_ARGS(ptr, tag, bytes),
+
+	TP_STRUCT__entry(__field(const void *, ptr)
+			 __field(struct alloc_tag *, tag)
+			 __field(size_t, bytes)
+	),
+
+	TP_fast_assign(__entry->ptr = ptr;
+		       __entry->tag = tag;
+		       __entry->bytes = bytes;
+	),
+
+	TP_printk("ptr %p, tag %p, bytes %zu",
+		  __entry->ptr,
+		  __entry->tag,
+		  __entry->bytes
+	)
+);
+
+#endif /* _TRACE_ALLOC_TAG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/MAINTAINERS~alloc_tag-add-trace-events-for-tracing-allocations
+++ a/MAINTAINERS
@@ -17481,6 +17481,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
+F:	include/trace/events/alloc_tag.h
 F:	include/uapi/linux/alloc_tag.h
 F:	mm/alloc_tag.c
 F:	tools/testing/selftests/alloc_tag/
--- a/mm/alloc_tag.c~alloc_tag-add-trace-events-for-tracing-allocations
+++ a/mm/alloc_tag.c
@@ -18,6 +18,9 @@
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/alloc_tag.h>
+
 #include "internal.h"
 #include "page_alloc.h"
 
@@ -54,6 +57,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
 
 DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
 
+DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
+EXPORT_SYMBOL(alloc_tag_trace_key);
+
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
 unsigned long alloc_tag_ref_mask;
 int alloc_tag_ref_offs;
@@ -484,6 +490,28 @@ static const struct proc_ops allocinfo_p
 #endif
 };
 
+void __alloc_tag_trace_hit(struct alloc_tag *tag)
+{
+	if (unlikely(!tag))
+		return;
+	trace_alloc_tag_hit(tag);
+}
+EXPORT_SYMBOL(__alloc_tag_trace_hit);
+
+void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
+			       size_t bytes)
+{
+	trace_alloc_tag_mem_alloced(ptr, tag, bytes);
+}
+EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
+
+void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag,
+			      size_t bytes)
+{
+	trace_alloc_tag_mem_freed(ptr, tag, bytes);
+}
+EXPORT_SYMBOL(alloc_tag_trace_mem_free);
+
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
 {
 	struct codetag_iterator iter;
--- a/mm/page_alloc.c~alloc_tag-add-trace-events-for-tracing-allocations
+++ a/mm/page_alloc.c
@@ -1256,7 +1256,7 @@ void __pgalloc_tag_add(struct page *page
 	union codetag_ref ref;
 
 	if (likely(get_page_tag_ref(page, &ref, &handle))) {
-		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
+		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr, page);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
 	} else {
@@ -1285,7 +1285,7 @@ void __pgalloc_tag_sub(struct page *page
 	union codetag_ref ref;
 
 	if (get_page_tag_ref(page, &ref, &handle)) {
-		alloc_tag_sub(&ref, PAGE_SIZE * nr);
+		alloc_tag_sub(&ref, PAGE_SIZE * nr, page);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
 	}
--- a/mm/percpu.c~alloc_tag-add-trace-events-for-tracing-allocations
+++ a/mm/percpu.c
@@ -1696,17 +1696,20 @@ static void pcpu_alloc_tag_alloc_hook(st
 				      size_t full_size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
-		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, full_size);
+		union codetag_ref *ref = &chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag;
+
+		alloc_tag_add(ref, current->alloc_tag, full_size, ref);
 	}
 }
 
 static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off,
 				     size_t full_size)
 {
-	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
-		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      full_size);
+	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
+		union codetag_ref *ref = &chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag;
+
+		alloc_tag_sub(ref, full_size, ref);
+	}
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
--- a/mm/slub.c~alloc_tag-add-trace-events-for-tracing-allocations
+++ a/mm/slub.c
@@ -2436,7 +2436,7 @@ __alloc_tagging_slab_alloc_hook(struct k
 		obj_ext = slab_obj_ext(s, slab, obj_exts, object);
 		ref = slab_obj_ext_codetag_ref(slab, obj_ext);
 
-		alloc_tag_add(ref, current->alloc_tag, s->size);
+		alloc_tag_add(ref, current->alloc_tag, s->size, ref);
 
 		put_slab_obj_exts(obj_exts);
 	} else {
@@ -2476,9 +2476,11 @@ __alloc_tagging_slab_free_hook(struct km
 	get_slab_obj_exts(obj_exts);
 	for (int i = 0; i < objects; i++) {
 		struct slabobj_ext *ext;
+		union codetag_ref *ref;
 
 		ext = slab_obj_ext(s, slab, obj_exts, p[i]);
-		alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->size);
+		ref = slab_obj_ext_codetag_ref(slab, ext);
+		alloc_tag_sub(ref, s->size, ref);
 	}
 	put_slab_obj_exts(obj_exts);
 }
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-trace-events-for-tracing-allocations.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch
alloc_tag-add-a-flags-field-to-allocinfo_filter.patch
alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch
alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch


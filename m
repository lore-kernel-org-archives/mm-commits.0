Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23C01843
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 00:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721779866; cv=none; b=BfTIj1ayqDbxSNZDEdpDbyRGhzqor0Kmviqmr51V2FT+I/nel+g4+1TL8k7OyiD+KWTvRUfxds3JOYS9KnGFkzl/OhqGxAN4SxqgDmSuAoi7160zNgk8p4gmuFpK9QC7FWXbpqmmsJiaLwrHOaCfgtgbi8Jita+LXuKLLKk/Bj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721779866; c=relaxed/simple;
	bh=tAfv+ycidSbx6S/9y/9YxMe0z/vIyucCzZUvvfhDxEc=;
	h=Date:To:From:Subject:Message-Id; b=olif5ZtK3/G9C2qN6itOUzkZRP6i4NKWWUQ+ee04WY5J4TH+2908KLJkXN6pbs3f1qvvLZkybEW8o5LQ3CJq/5HK0bn0da8QTK6R2PytYLJlOJxaa0Gkm136BsVq5YoFBXEuMLKgjAB2eo/QG5nhADoYtljfx/DxTl7GIrA71co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BGA3tQML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BGA3tQML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BA3C4AF09;
	Wed, 24 Jul 2024 00:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721779866;
	bh=tAfv+ycidSbx6S/9y/9YxMe0z/vIyucCzZUvvfhDxEc=;
	h=Date:To:From:Subject:From;
	b=BGA3tQMLD40GvFfauvY781LCAPwU5JfWVwNtyykis/oK112ENj4q5XEhDG4F38HJ/
	 7cmI6E0kv2Va89iUXalvCgOtnsfSi7NoOuXSAFrnP7F7yruYiML3QijhBWwxMb8RbJ
	 q8xKQE1QzNAOdsMSr394KV+y+VqLoJGktg8mPHn0=
Date: Tue, 23 Jul 2024 17:11:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,peterz@infradead.org,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,cerasuolodomenico@gmail.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-kernel-stack-usage-histogram.patch added to mm-unstable branch
Message-Id: <20240724001106.26BA3C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmstat: kernel stack usage histogram
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-kernel-stack-usage-histogram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-kernel-stack-usage-histogram.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: vmstat: kernel stack usage histogram
Date: Thu, 18 Jul 2024 20:26:11 +0000

As part of the dynamic kernel stack project, we need to know the amount of
data that can be saved by reducing the default kernel stack size [1].

Provide a kernel stack usage histogram to aid in optimizing kernel stack
sizes and minimizing memory waste in large-scale environments.  The
histogram divides stack usage into power-of-two buckets and reports the
results in /proc/vmstat.  This information is especially valuable in
environments with millions of machines, where even small optimizations can
have a significant impact.

The histogram data is presented in /proc/vmstat with entries like
"kstack_1k", "kstack_2k", and so on, indicating the number of threads that
exited with stack usage falling within each respective bucket.

Example outputs:
Intel:
$ grep kstack /proc/vmstat
kstack_1k 3
kstack_2k 188
kstack_4k 11391
kstack_8k 243
kstack_16k 0

ARM with 64K page_size:
$ grep kstack /proc/vmstat
kstack_1k 1
kstack_2k 340
kstack_4k 25212
kstack_8k 1659
kstack_16k 0
kstack_32k 0
kstack_64k 0

Note: once the dynamic kernel stack is implemented it will depend on the
implementation the usability of this feature: On hardware that supports
faults on kernel stacks, we will have other metrics that show the total
number of pages allocated for stacks.  On hardware where faults are not
supported, we will most likely have some optimization where only some
threads are extended, and for those, these metrics will still be very
useful.

[1] https://lwn.net/Articles/974367

Link: https://lkml.kernel.org/r/20240718202611.1695164-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task_stack.h |   49 +++++++++++++++++++++++++++--
 include/linux/vm_event_item.h    |   42 ++++++++++++++++++++++++
 include/linux/vmstat.h           |   16 ---------
 mm/vmstat.c                      |   24 ++++++++++++++
 4 files changed, 113 insertions(+), 18 deletions(-)

--- a/include/linux/sched/task_stack.h~vmstat-kernel-stack-usage-histogram
+++ a/include/linux/sched/task_stack.h
@@ -95,9 +95,51 @@ static inline int object_is_on_stack(con
 extern void thread_stack_cache_init(void);
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
+#ifdef CONFIG_VM_EVENT_COUNTERS
+#include <linux/vm_event_item.h>
+
+/* Count the maximum pages reached in kernel stacks */
+static inline void kstack_histogram(unsigned long used_stack)
+{
+	if (used_stack <= 1024)
+		this_cpu_inc(vm_event_states.event[KSTACK_1K]);
+#if THREAD_SIZE > 1024
+	else if (used_stack <= 2048)
+		this_cpu_inc(vm_event_states.event[KSTACK_2K]);
+#endif
+#if THREAD_SIZE > 2048
+	else if (used_stack <= 4096)
+		this_cpu_inc(vm_event_states.event[KSTACK_4K]);
+#endif
+#if THREAD_SIZE > 4096
+	else if (used_stack <= 8192)
+		this_cpu_inc(vm_event_states.event[KSTACK_8K]);
+#endif
+#if THREAD_SIZE > 8192
+	else if (used_stack <= 16384)
+		this_cpu_inc(vm_event_states.event[KSTACK_16K]);
+#endif
+#if THREAD_SIZE > 16384
+	else if (used_stack <= 32768)
+		this_cpu_inc(vm_event_states.event[KSTACK_32K]);
+#endif
+#if THREAD_SIZE > 32768
+	else if (used_stack <= 65536)
+		this_cpu_inc(vm_event_states.event[KSTACK_64K]);
+#endif
+#if THREAD_SIZE > 65536
+	else
+		this_cpu_inc(vm_event_states.event[KSTACK_REST]);
+#endif
+}
+#else /* !CONFIG_VM_EVENT_COUNTERS */
+static inline void kstack_histogram(unsigned long used_stack) {}
+#endif /* CONFIG_VM_EVENT_COUNTERS */
+
 static inline unsigned long stack_not_used(struct task_struct *p)
 {
 	unsigned long *n = end_of_stack(p);
+	unsigned long unused_stack;
 
 	do { 	/* Skip over canary */
 # ifdef CONFIG_STACK_GROWSUP
@@ -108,10 +150,13 @@ static inline unsigned long stack_not_us
 	} while (!*n);
 
 # ifdef CONFIG_STACK_GROWSUP
-	return (unsigned long)end_of_stack(p) - (unsigned long)n;
+	unused_stack = (unsigned long)end_of_stack(p) - (unsigned long)n;
 # else
-	return (unsigned long)n - (unsigned long)end_of_stack(p);
+	unused_stack = (unsigned long)n - (unsigned long)end_of_stack(p);
 # endif
+	kstack_histogram(THREAD_SIZE - unused_stack);
+
+	return unused_stack;
 }
 #endif
 extern void set_task_stack_end_magic(struct task_struct *tsk);
--- a/include/linux/vm_event_item.h~vmstat-kernel-stack-usage-histogram
+++ a/include/linux/vm_event_item.h
@@ -155,9 +155,51 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		VMA_LOCK_RETRY,
 		VMA_LOCK_MISS,
 #endif
+#ifdef CONFIG_DEBUG_STACK_USAGE
+		KSTACK_1K,
+#if THREAD_SIZE > 1024
+		KSTACK_2K,
+#endif
+#if THREAD_SIZE > 2048
+		KSTACK_4K,
+#endif
+#if THREAD_SIZE > 4096
+		KSTACK_8K,
+#endif
+#if THREAD_SIZE > 8192
+		KSTACK_16K,
+#endif
+#if THREAD_SIZE > 16384
+		KSTACK_32K,
+#endif
+#if THREAD_SIZE > 32768
+		KSTACK_64K,
+#endif
+#if THREAD_SIZE > 65536
+		KSTACK_REST,
+#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
 		NR_VM_EVENT_ITEMS
 };
 
+#ifdef CONFIG_VM_EVENT_COUNTERS
+/*
+ * Light weight per cpu counter implementation.
+ *
+ * Counters should only be incremented and no critical kernel component
+ * should rely on the counter values.
+ *
+ * Counters are handled completely inline. On many platforms the code
+ * generated will simply be the increment of a global address.
+ */
+
+struct vm_event_state {
+	unsigned long event[NR_VM_EVENT_ITEMS];
+};
+
+DECLARE_PER_CPU(struct vm_event_state, vm_event_states);
+#endif
+
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 #define THP_FILE_ALLOC ({ BUILD_BUG(); 0; })
 #define THP_FILE_FALLBACK ({ BUILD_BUG(); 0; })
--- a/include/linux/vmstat.h~vmstat-kernel-stack-usage-histogram
+++ a/include/linux/vmstat.h
@@ -42,22 +42,6 @@ enum writeback_stat_item {
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 /*
- * Light weight per cpu counter implementation.
- *
- * Counters should only be incremented and no critical kernel component
- * should rely on the counter values.
- *
- * Counters are handled completely inline. On many platforms the code
- * generated will simply be the increment of a global address.
- */
-
-struct vm_event_state {
-	unsigned long event[NR_VM_EVENT_ITEMS];
-};
-
-DECLARE_PER_CPU(struct vm_event_state, vm_event_states);
-
-/*
  * vm counters are allowed to be racy. Use raw_cpu_ops to avoid the
  * local_irq_disable overhead.
  */
--- a/mm/vmstat.c~vmstat-kernel-stack-usage-histogram
+++ a/mm/vmstat.c
@@ -1418,6 +1418,30 @@ const char * const vmstat_text[] = {
 	"vma_lock_retry",
 	"vma_lock_miss",
 #endif
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	"kstack_1k",
+#if THREAD_SIZE > 1024
+	"kstack_2k",
+#endif
+#if THREAD_SIZE > 2048
+	"kstack_4k",
+#endif
+#if THREAD_SIZE > 4096
+	"kstack_8k",
+#endif
+#if THREAD_SIZE > 8192
+	"kstack_16k",
+#endif
+#if THREAD_SIZE > 16384
+	"kstack_32k",
+#endif
+#if THREAD_SIZE > 32768
+	"kstack_64k",
+#endif
+#if THREAD_SIZE > 65536
+	"kstack_rest",
+#endif
+#endif
 #endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

vmstat-kernel-stack-usage-histogram.patch


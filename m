Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073EC149C6E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719354878; cv=none; b=kny7D48oNlrPKrKRwoFC8Tnlm+RMoRo8gbzWCYhl9NBPIH3mRZkC+dsvSoVfyQeJH3JdVEukbM/5pOBWxJyQnh7W8QqC1u1Ob7PP4lANqZcywUcdUNGeTTZHIb46DqgD6CX61aFjpP1E9WD6es/Jn7nqM1MXqreiqtirjnOiDmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719354878; c=relaxed/simple;
	bh=SJ8wexNgGKxUoEKNboQhyfKrGpcZ5exT6z5Tsl7NlRo=;
	h=Date:To:From:Subject:Message-Id; b=L+nCg4ZbUHzrUYuy3Scm7yXmvHb0tTIJbnAN3BrDEL9WFjFuRu3r5WKAoAhSk0R/ty3qR/LmdLDF/q/1kSkaWEXqGN+VHOugC/SMFdnXEPe7XxURy0tl6IdN/4AaKJm3ZhR/fGF6CwY+Hgu4tb6+q8XthuElChkneCNGpZphCvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w9zJ0/jm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w9zJ0/jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80605C32781;
	Tue, 25 Jun 2024 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719354877;
	bh=SJ8wexNgGKxUoEKNboQhyfKrGpcZ5exT6z5Tsl7NlRo=;
	h=Date:To:From:Subject:From;
	b=w9zJ0/jmiASLPHSIHgc2nXkrl52CpBb8DYxnFNQSiJF/ND43YUw+p9sIC+d9VUkmc
	 S2oI8XCE8cM4T/y8qYtdxGJP99hq3IsNyYt5kCGiSjh8hC9QFFgAMoayMi74z4w3Tr
	 +JSFKki4HKNgX58Mw8MtyOpAZfAJBzAnwXgN72xY=
Date: Tue, 25 Jun 2024 15:34:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,peterz@infradead.org,nphamcs@gmail.com,lizhijian@fujitsu.com,kent.overstreet@linux.dev,jpoimboe@kernel.org,cerasuolodomenico@gmail.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] vmstat-kernel-stack-usage-histogram.patch removed from -mm tree
Message-Id: <20240625223437.80605C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmstat: kernel stack usage histogram
has been removed from the -mm tree.  Its filename was
     vmstat-kernel-stack-usage-histogram.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: vmstat: kernel stack usage histogram
Date: Thu, 30 May 2024 17:02:59 +0000

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

Link: https://lkml.kernel.org/r/20240530170259.852088-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
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
@@ -154,9 +154,51 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
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
@@ -1417,6 +1417,30 @@ const char * const vmstat_text[] = {
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



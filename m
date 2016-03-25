From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8.patch
 removed from -mm tree
Date: Fri, 25 Mar 2016 14:15:01 -0700
Message-ID: <56f5aa55.nEpwhh12xvoqU7ua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbcCYVPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 17:15:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dmitryc@google.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8
has been removed from the -mm tree.  Its filename was
     mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8.patch

This patch was dropped because it was folded into mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8

v8: - removed vmalloc() calls - it turned out to be hard to check if
vmalloc() is available

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig       |    1 +
 lib/stackdepot.c  |    7 +++++--
 mm/kasan/kasan.c  |    4 +---
 mm/kasan/kasan.h  |    9 ++++-----
 mm/kasan/report.c |    3 +--
 5 files changed, 12 insertions(+), 12 deletions(-)

diff -puN lib/Kconfig~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8 lib/Kconfig
--- a/lib/Kconfig~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8
+++ a/lib/Kconfig
@@ -538,5 +538,6 @@ config ARCH_HAS_MMIO_FLUSH
 
 config STACKDEPOT
 	bool
+	select STACKTRACE
 
 endmenu
diff -puN lib/stackdepot.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8 lib/stackdepot.c
--- a/lib/stackdepot.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8
+++ a/lib/stackdepot.c
@@ -34,6 +34,7 @@
 #include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/printk.h>
+#include <linux/slab.h>
 #include <linux/stacktrace.h>
 #include <linux/stackdepot.h>
 #include <linux/string.h>
@@ -203,7 +204,7 @@ depot_stack_handle_t depot_save_stack(st
 	void *prealloc = NULL;
 
 	if (unlikely(trace->nr_entries == 0))
-		goto exit;
+		goto fast_exit;
 
 	hash = hash_stack(trace->entries, trace->nr_entries);
 	/* Bad luck, we won't store this stack. */
@@ -266,10 +267,12 @@ depot_stack_handle_t depot_save_stack(st
 
 	spin_unlock_irqrestore(&depot_lock, flags);
 exit:
-	if (prealloc)
+	if (prealloc) {
 		/* Nobody used this memory, ok to free it. */
 		free_pages((unsigned long)prealloc, STACK_ALLOC_ORDER);
+	}
 	if (found)
 		retval = found->handle.handle;
+fast_exit:
 	return retval;
 }
diff -puN mm/kasan/kasan.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8 mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8
+++ a/mm/kasan/kasan.c
@@ -414,6 +414,7 @@ void kasan_poison_object_data(struct kme
 #endif
 }
 
+#ifdef CONFIG_SLAB
 static inline int in_irqentry_text(unsigned long ptr)
 {
 	return (ptr >= (unsigned long)&__irqentry_text_start &&
@@ -457,13 +458,10 @@ static inline depot_stack_handle_t save_
 
 static inline void set_track(struct kasan_track *track, gfp_t flags)
 {
-	track->cpu = raw_smp_processor_id();
 	track->pid = current->pid;
-	track->when = jiffies;
 	track->stack = save_stack(flags);
 }
 
-#ifdef CONFIG_SLAB
 struct kasan_alloc_meta *get_alloc_info(struct kmem_cache *cache,
 					const void *object)
 {
diff -puN mm/kasan/kasan.h~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8 mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8
+++ a/mm/kasan/kasan.h
@@ -68,16 +68,15 @@ enum kasan_state {
 #define KASAN_STACK_DEPTH 64
 
 struct kasan_track {
-	u64 cpu : 6;			/* for NR_CPUS = 64 */
-	u64 pid : 16;			/* 65536 processes */
-	u64 when : 42;			/* ~140 years */
-	depot_stack_handle_t stack : sizeof(depot_stack_handle_t);
+	u32 pid;
+	depot_stack_handle_t stack;
 };
 
 struct kasan_alloc_meta {
+	struct kasan_track track;
 	u32 state : 2;	/* enum kasan_state */
 	u32 alloc_size : 30;
-	struct kasan_track track;
+	u32 reserved;
 };
 
 struct kasan_free_meta {
diff -puN mm/kasan/report.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8 mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-v8
+++ a/mm/kasan/report.c
@@ -119,8 +119,7 @@ static inline bool init_task_stack_addr(
 #ifdef CONFIG_SLAB
 static void print_track(struct kasan_track *track)
 {
-	pr_err("PID = %u, CPU = %u, timestamp = %lu\n", track->pid,
-	       track->cpu, (unsigned long)track->when);
+	pr_err("PID = %u\n", track->pid);
 	if (track->stack) {
 		struct stack_trace trace;
 
_

Patches currently in -mm which might be from glider@google.com are

kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right.patch
mm-kasan-slab-support.patch
mm-kasan-added-gfp-flags-to-kasan-api.patch
arch-ftrace-for-kasan-put-hard-soft-irq-entries-into-separate-sections.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch
kasan-test-fix-warn-if-the-uaf-could-not-be-detected-in-kmalloc_uaf2.patch
mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch


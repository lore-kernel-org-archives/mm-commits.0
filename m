From: akpm@linux-foundation.org
Subject: +
 stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch added to
 -mm tree
Date: Mon, 24 Nov 2014 14:58:35 -0800
Message-ID: <5473b81b.4u/RDmeZLlrMNLQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKXW6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 17:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: stacktrace: introduce snprint_stack_trace for buffer output
has been added to the -mm tree.  Its filename is
     stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: stacktrace: introduce snprint_stack_trace for buffer output

Current stacktrace only have the function for console output.  page_owner
that will be introduced in following patch needs to print the output of
stacktrace into the buffer for our own output format so so new function,
snprint_stack_trace(), is needed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stacktrace.h |    5 +++++
 kernel/stacktrace.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN include/linux/stacktrace.h~stacktrace-introduce-snprint_stack_trace-for-buffer-output include/linux/stacktrace.h
--- a/include/linux/stacktrace.h~stacktrace-introduce-snprint_stack_trace-for-buffer-output
+++ a/include/linux/stacktrace.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_STACKTRACE_H
 #define __LINUX_STACKTRACE_H
 
+#include <linux/types.h>
+
 struct task_struct;
 struct pt_regs;
 
@@ -20,6 +22,8 @@ extern void save_stack_trace_tsk(struct 
 				struct stack_trace *trace);
 
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
+extern int snprint_stack_trace(char *buf, size_t size,
+			struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
 extern void save_stack_trace_user(struct stack_trace *trace);
@@ -32,6 +36,7 @@ extern void save_stack_trace_user(struct
 # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
 # define save_stack_trace_user(trace)			do { } while (0)
 # define print_stack_trace(trace, spaces)		do { } while (0)
+# define snprint_stack_trace(buf, size, trace, spaces)	do { } while (0)
 #endif
 
 #endif
diff -puN kernel/stacktrace.c~stacktrace-introduce-snprint_stack_trace-for-buffer-output kernel/stacktrace.c
--- a/kernel/stacktrace.c~stacktrace-introduce-snprint_stack_trace-for-buffer-output
+++ a/kernel/stacktrace.c
@@ -25,6 +25,38 @@ void print_stack_trace(struct stack_trac
 }
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
+int snprint_stack_trace(char *buf, size_t size,
+			struct stack_trace *trace, int spaces)
+{
+	int i;
+	unsigned long ip;
+	int generated;
+	int total = 0;
+
+	if (WARN_ON(!trace->entries))
+		return 0;
+
+	for (i = 0; i < trace->nr_entries; i++) {
+		ip = trace->entries[i];
+		generated = snprintf(buf, size, "%*c[<%p>] %pS\n",
+				1 + spaces, ' ', (void *) ip, (void *) ip);
+
+		total += generated;
+
+		/* Assume that generated isn't a negative number */
+		if (generated >= size) {
+			buf += size;
+			size = 0;
+		} else {
+			buf += generated;
+			size -= generated;
+		}
+	}
+
+	return total;
+}
+EXPORT_SYMBOL_GPL(snprint_stack_trace);
+
 /*
  * Architectures that do not implement save_stack_trace_tsk or
  * save_stack_trace_regs get this weak alias and a once-per-bootup warning
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-slub-coding-style-whitespaces-and-tabs-mixture.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-slab-reverse-iteration-on-find_mergeable.patch
mm-slub-fix-format-mismatches-in-slab_err-callers.patch
slab-improve-checking-for-invalid-gfp_flags.patch
slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
page-owners-correct-page-order-when-to-free-page.patch


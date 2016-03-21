From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:39:39 -0700
Message-ID: <56f03feb.MU7Mo8cAfTbbZUJB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbcCUT4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, arnd@arndb.de, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, rostedt@goodmis.org, sergey.senozhatsky.work@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ref: add tracepoint to track down page reference manipulation
has been removed from the -mm tree.  Its filename was
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_ref: add tracepoint to track down page reference manipulation

CMA allocation should be guaranteed to succeed by definition, but,
unfortunately, it would be failed sometimes.  It is hard to track down the
problem, because it is related to page reference manipulation and we don't
have any facility to analyze it.

This patch adds tracepoints to track down page reference manipulation. 
With it, we can find exact reason of failure and can fix the problem. 
Following is an example of tracepoint output.  (note: this example is
stale version that printing flags as the number.  Recent version will
print it as human readable string.)

<...>-9018  [004]    92.678375: page_ref_set:         pfn=0x17ac9 flags=0x0 count=1 mapcount=0 mapping=(nil) mt=4 val=1
<...>-9018  [004]    92.678378: kernel_stack:
 => get_page_from_freelist (ffffffff81176659)
 => __alloc_pages_nodemask (ffffffff81176d22)
 => alloc_pages_vma (ffffffff811bf675)
 => handle_mm_fault (ffffffff8119e693)
 => __do_page_fault (ffffffff810631ea)
 => trace_do_page_fault (ffffffff81063543)
 => do_async_page_fault (ffffffff8105c40a)
 => async_page_fault (ffffffff817581d8)
[snip]
<...>-9018  [004]    92.678379: page_ref_mod:         pfn=0x17ac9 flags=0x40048 count=2 mapcount=1 mapping=0xffff880015a78dc1 mt=4 val=1
[snip]
...
...
<...>-9131  [001]    93.174468: test_pages_isolated:  start_pfn=0x17800 end_pfn=0x17c00 fin_pfn=0x17ac9 ret=fail
[snip]
<...>-9018  [004]    93.174843: page_ref_mod_and_test: pfn=0x17ac9 flags=0x40068 count=0 mapcount=0 mapping=0xffff880015a78dc1 mt=4 val=-1 ret=1
 => release_pages (ffffffff8117c9e4)
 => free_pages_and_swap_cache (ffffffff811b0697)
 => tlb_flush_mmu_free (ffffffff81199616)
 => tlb_finish_mmu (ffffffff8119a62c)
 => exit_mmap (ffffffff811a53f7)
 => mmput (ffffffff81073f47)
 => do_exit (ffffffff810794e9)
 => do_group_exit (ffffffff81079def)
 => SyS_exit_group (ffffffff81079e74)
 => entry_SYSCALL_64_fastpath (ffffffff817560b6)

This output shows that problem comes from exit path.  In exit path, to
improve performance, pages are not freed immediately.  They are gathered
and processed by batch.  During this process, migration cannot be possible
and CMA allocation is failed.  This problem is hard to find without this
page reference tracepoint facility.

Enabling this feature bloat kernel text 30 KB in my configuration.

   text    data     bss     dec     hex filename
12127327        2243616 1507328 15878271         f2487f vmlinux_disabled
12157208        2258880 1507328 15923416         f2f8d8 vmlinux_enabled

Note that, due to header file dependency problem between mm.h and
tracepoint.h, this feature has to open code the static key functions for
tracepoints.  Proposed by Steven Rostedt in following link.

https://lkml.org/lkml/2015/12/9/699

[arnd@arndb.de: crypto/async_pq: use __free_page() instead of put_page()]
[iamjoonsoo.kim@lge.com: fix build failure for xtensa]
[akpm@linux-foundation.org: tweak Kconfig text, per Vlastimil]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_pq.c      |    2 
 include/linux/page_ref.h        |   98 ++++++++++++++++++++-
 include/trace/events/page_ref.h |  134 ++++++++++++++++++++++++++++++
 mm/Kconfig.debug                |   13 ++
 mm/Makefile                     |    1 
 mm/debug_page_ref.c             |   54 ++++++++++++
 6 files changed, 296 insertions(+), 6 deletions(-)

diff -puN crypto/async_tx/async_pq.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation crypto/async_tx/async_pq.c
--- a/crypto/async_tx/async_pq.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation
+++ a/crypto/async_tx/async_pq.c
@@ -444,7 +444,7 @@ static int __init async_pq_init(void)
 
 static void __exit async_pq_exit(void)
 {
-	put_page(pq_scribble_page);
+	__free_page(pq_scribble_page);
 }
 
 module_init(async_pq_init);
diff -puN include/linux/page_ref.h~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation include/linux/page_ref.h
--- a/include/linux/page_ref.h~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation
+++ a/include/linux/page_ref.h
@@ -4,6 +4,62 @@
 #include <linux/atomic.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
+#include <linux/tracepoint-defs.h>
+
+extern struct tracepoint __tracepoint_page_ref_set;
+extern struct tracepoint __tracepoint_page_ref_mod;
+extern struct tracepoint __tracepoint_page_ref_mod_and_test;
+extern struct tracepoint __tracepoint_page_ref_mod_and_return;
+extern struct tracepoint __tracepoint_page_ref_mod_unless;
+extern struct tracepoint __tracepoint_page_ref_freeze;
+extern struct tracepoint __tracepoint_page_ref_unfreeze;
+
+#ifdef CONFIG_DEBUG_PAGE_REF
+
+/*
+ * Ideally we would want to use the trace_<tracepoint>_enabled() helper
+ * functions. But due to include header file issues, that is not
+ * feasible. Instead we have to open code the static key functions.
+ *
+ * See trace_##name##_enabled(void) in include/linux/tracepoint.h
+ */
+#define page_ref_tracepoint_active(t) static_key_false(&(t).key)
+
+extern void __page_ref_set(struct page *page, int v);
+extern void __page_ref_mod(struct page *page, int v);
+extern void __page_ref_mod_and_test(struct page *page, int v, int ret);
+extern void __page_ref_mod_and_return(struct page *page, int v, int ret);
+extern void __page_ref_mod_unless(struct page *page, int v, int u);
+extern void __page_ref_freeze(struct page *page, int v, int ret);
+extern void __page_ref_unfreeze(struct page *page, int v);
+
+#else
+
+#define page_ref_tracepoint_active(t) false
+
+static inline void __page_ref_set(struct page *page, int v)
+{
+}
+static inline void __page_ref_mod(struct page *page, int v)
+{
+}
+static inline void __page_ref_mod_and_test(struct page *page, int v, int ret)
+{
+}
+static inline void __page_ref_mod_and_return(struct page *page, int v, int ret)
+{
+}
+static inline void __page_ref_mod_unless(struct page *page, int v, int u)
+{
+}
+static inline void __page_ref_freeze(struct page *page, int v, int ret)
+{
+}
+static inline void __page_ref_unfreeze(struct page *page, int v)
+{
+}
+
+#endif
 
 static inline int page_ref_count(struct page *page)
 {
@@ -18,6 +74,8 @@ static inline int page_count(struct page
 static inline void set_page_count(struct page *page, int v)
 {
 	atomic_set(&page->_count, v);
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_set))
+		__page_ref_set(page, v);
 }
 
 /*
@@ -32,46 +90,74 @@ static inline void init_page_count(struc
 static inline void page_ref_add(struct page *page, int nr)
 {
 	atomic_add(nr, &page->_count);
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
+		__page_ref_mod(page, nr);
 }
 
 static inline void page_ref_sub(struct page *page, int nr)
 {
 	atomic_sub(nr, &page->_count);
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
+		__page_ref_mod(page, -nr);
 }
 
 static inline void page_ref_inc(struct page *page)
 {
 	atomic_inc(&page->_count);
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
+		__page_ref_mod(page, 1);
 }
 
 static inline void page_ref_dec(struct page *page)
 {
 	atomic_dec(&page->_count);
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
+		__page_ref_mod(page, -1);
 }
 
 static inline int page_ref_sub_and_test(struct page *page, int nr)
 {
-	return atomic_sub_and_test(nr, &page->_count);
+	int ret = atomic_sub_and_test(nr, &page->_count);
+
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_test))
+		__page_ref_mod_and_test(page, -nr, ret);
+	return ret;
 }
 
 static inline int page_ref_dec_and_test(struct page *page)
 {
-	return atomic_dec_and_test(&page->_count);
+	int ret = atomic_dec_and_test(&page->_count);
+
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_test))
+		__page_ref_mod_and_test(page, -1, ret);
+	return ret;
 }
 
 static inline int page_ref_dec_return(struct page *page)
 {
-	return atomic_dec_return(&page->_count);
+	int ret = atomic_dec_return(&page->_count);
+
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_return))
+		__page_ref_mod_and_return(page, -1, ret);
+	return ret;
 }
 
 static inline int page_ref_add_unless(struct page *page, int nr, int u)
 {
-	return atomic_add_unless(&page->_count, nr, u);
+	int ret = atomic_add_unless(&page->_count, nr, u);
+
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_unless))
+		__page_ref_mod_unless(page, nr, ret);
+	return ret;
 }
 
 static inline int page_ref_freeze(struct page *page, int count)
 {
-	return likely(atomic_cmpxchg(&page->_count, count, 0) == count);
+	int ret = likely(atomic_cmpxchg(&page->_count, count, 0) == count);
+
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_freeze))
+		__page_ref_freeze(page, count, ret);
+	return ret;
 }
 
 static inline void page_ref_unfreeze(struct page *page, int count)
@@ -80,6 +166,8 @@ static inline void page_ref_unfreeze(str
 	VM_BUG_ON(count == 0);
 
 	atomic_set(&page->_count, count);
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_unfreeze))
+		__page_ref_unfreeze(page, count);
 }
 
 #endif
diff -puN /dev/null include/trace/events/page_ref.h
--- /dev/null
+++ a/include/trace/events/page_ref.h
@@ -0,0 +1,134 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM page_ref
+
+#if !defined(_TRACE_PAGE_REF_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PAGE_REF_H
+
+#include <linux/types.h>
+#include <linux/page_ref.h>
+#include <linux/tracepoint.h>
+#include <trace/events/mmflags.h>
+
+DECLARE_EVENT_CLASS(page_ref_mod_template,
+
+	TP_PROTO(struct page *page, int v),
+
+	TP_ARGS(page, v),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(unsigned long, flags)
+		__field(int, count)
+		__field(int, mapcount)
+		__field(void *, mapping)
+		__field(int, mt)
+		__field(int, val)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = page_to_pfn(page);
+		__entry->flags = page->flags;
+		__entry->count = page_ref_count(page);
+		__entry->mapcount = page_mapcount(page);
+		__entry->mapping = page->mapping;
+		__entry->mt = get_pageblock_migratetype(page);
+		__entry->val = v;
+	),
+
+	TP_printk("pfn=0x%lx flags=%s count=%d mapcount=%d mapping=%p mt=%d val=%d",
+		__entry->pfn,
+		show_page_flags(__entry->flags & ((1UL << NR_PAGEFLAGS) - 1)),
+		__entry->count,
+		__entry->mapcount, __entry->mapping, __entry->mt,
+		__entry->val)
+);
+
+DEFINE_EVENT(page_ref_mod_template, page_ref_set,
+
+	TP_PROTO(struct page *page, int v),
+
+	TP_ARGS(page, v)
+);
+
+DEFINE_EVENT(page_ref_mod_template, page_ref_mod,
+
+	TP_PROTO(struct page *page, int v),
+
+	TP_ARGS(page, v)
+);
+
+DECLARE_EVENT_CLASS(page_ref_mod_and_test_template,
+
+	TP_PROTO(struct page *page, int v, int ret),
+
+	TP_ARGS(page, v, ret),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(unsigned long, flags)
+		__field(int, count)
+		__field(int, mapcount)
+		__field(void *, mapping)
+		__field(int, mt)
+		__field(int, val)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = page_to_pfn(page);
+		__entry->flags = page->flags;
+		__entry->count = page_ref_count(page);
+		__entry->mapcount = page_mapcount(page);
+		__entry->mapping = page->mapping;
+		__entry->mt = get_pageblock_migratetype(page);
+		__entry->val = v;
+		__entry->ret = ret;
+	),
+
+	TP_printk("pfn=0x%lx flags=%s count=%d mapcount=%d mapping=%p mt=%d val=%d ret=%d",
+		__entry->pfn,
+		show_page_flags(__entry->flags & ((1UL << NR_PAGEFLAGS) - 1)),
+		__entry->count,
+		__entry->mapcount, __entry->mapping, __entry->mt,
+		__entry->val, __entry->ret)
+);
+
+DEFINE_EVENT(page_ref_mod_and_test_template, page_ref_mod_and_test,
+
+	TP_PROTO(struct page *page, int v, int ret),
+
+	TP_ARGS(page, v, ret)
+);
+
+DEFINE_EVENT(page_ref_mod_and_test_template, page_ref_mod_and_return,
+
+	TP_PROTO(struct page *page, int v, int ret),
+
+	TP_ARGS(page, v, ret)
+);
+
+DEFINE_EVENT(page_ref_mod_and_test_template, page_ref_mod_unless,
+
+	TP_PROTO(struct page *page, int v, int ret),
+
+	TP_ARGS(page, v, ret)
+);
+
+DEFINE_EVENT(page_ref_mod_and_test_template, page_ref_freeze,
+
+	TP_PROTO(struct page *page, int v, int ret),
+
+	TP_ARGS(page, v, ret)
+);
+
+DEFINE_EVENT(page_ref_mod_template, page_ref_unfreeze,
+
+	TP_PROTO(struct page *page, int v),
+
+	TP_ARGS(page, v)
+);
+
+#endif /* _TRACE_PAGE_COUNT_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/Kconfig.debug~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation
+++ a/mm/Kconfig.debug
@@ -79,3 +79,16 @@ config PAGE_POISONING_ZERO
 	   Enabling page poisoning with this option will disable hibernation
 
 	   If unsure, say N
+	bool
+
+config DEBUG_PAGE_REF
+	bool "Enable tracepoint to track down page reference manipulation"
+	depends on DEBUG_KERNEL
+	depends on TRACEPOINTS
+	---help---
+	  This is a feature to add tracepoint for tracking down page reference
+	  manipulation. This tracking is useful to diagnose functional failure
+	  due to migration failures caused by page reference mismatches.  Be
+	  careful when enabling this feature because it adds about 30 KB to the
+	  kernel code.  However the runtime performance overhead is virtually
+	  nil until the tracepoints are actually enabled.
diff -puN mm/Makefile~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation mm/Makefile
--- a/mm/Makefile~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation
+++ a/mm/Makefile
@@ -81,3 +81,4 @@ obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
 obj-$(CONFIG_FRAME_VECTOR) += frame_vector.o
+obj-$(CONFIG_DEBUG_PAGE_REF) += debug_page_ref.o
diff -puN /dev/null mm/debug_page_ref.c
--- /dev/null
+++ a/mm/debug_page_ref.c
@@ -0,0 +1,54 @@
+#include <linux/mm_types.h>
+#include <linux/tracepoint.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/page_ref.h>
+
+void __page_ref_set(struct page *page, int v)
+{
+	trace_page_ref_set(page, v);
+}
+EXPORT_SYMBOL(__page_ref_set);
+EXPORT_TRACEPOINT_SYMBOL(page_ref_set);
+
+void __page_ref_mod(struct page *page, int v)
+{
+	trace_page_ref_mod(page, v);
+}
+EXPORT_SYMBOL(__page_ref_mod);
+EXPORT_TRACEPOINT_SYMBOL(page_ref_mod);
+
+void __page_ref_mod_and_test(struct page *page, int v, int ret)
+{
+	trace_page_ref_mod_and_test(page, v, ret);
+}
+EXPORT_SYMBOL(__page_ref_mod_and_test);
+EXPORT_TRACEPOINT_SYMBOL(page_ref_mod_and_test);
+
+void __page_ref_mod_and_return(struct page *page, int v, int ret)
+{
+	trace_page_ref_mod_and_return(page, v, ret);
+}
+EXPORT_SYMBOL(__page_ref_mod_and_return);
+EXPORT_TRACEPOINT_SYMBOL(page_ref_mod_and_return);
+
+void __page_ref_mod_unless(struct page *page, int v, int u)
+{
+	trace_page_ref_mod_unless(page, v, u);
+}
+EXPORT_SYMBOL(__page_ref_mod_unless);
+EXPORT_TRACEPOINT_SYMBOL(page_ref_mod_unless);
+
+void __page_ref_freeze(struct page *page, int v, int ret)
+{
+	trace_page_ref_freeze(page, v, ret);
+}
+EXPORT_SYMBOL(__page_ref_freeze);
+EXPORT_TRACEPOINT_SYMBOL(page_ref_freeze);
+
+void __page_ref_unfreeze(struct page *page, int v)
+{
+	trace_page_ref_unfreeze(page, v);
+}
+EXPORT_SYMBOL(__page_ref_unfreeze);
+EXPORT_TRACEPOINT_SYMBOL(page_ref_unfreeze);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are



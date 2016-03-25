From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
 removed from -mm tree
Date: Fri, 25 Mar 2016 14:14:58 -0700
Message-ID: <56f5aa52.ws2jDm6uxA0yWGds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbcCYVO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 17:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adech.fo@gmail.com, cl@linux.com, dmitryc@google.com, dvyukov@google.com, glider@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch

This patch was dropped because it was folded into mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    6 +++---
 lib/Kconfig                |    2 +-
 lib/Kconfig.kasan          |    2 +-
 lib/stackdepot.c           |   10 +++++-----
 mm/kasan/kasan.c           |    2 +-
 mm/kasan/kasan.h           |    2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/stackdepot.h~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix include/linux/stackdepot.h
--- a/include/linux/stackdepot.h~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix
+++ a/include/linux/stackdepot.h
@@ -21,12 +21,12 @@
 #ifndef _LINUX_STACKDEPOT_H
 #define _LINUX_STACKDEPOT_H
 
-typedef u32 depot_stack_handle;
+typedef u32 depot_stack_handle_t;
 
 struct stack_trace;
 
-depot_stack_handle depot_save_stack(struct stack_trace *trace, gfp_t flags);
+depot_stack_handle_t depot_save_stack(struct stack_trace *trace, gfp_t flags);
 
-void depot_fetch_stack(depot_stack_handle handle, struct stack_trace *trace);
+void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace);
 
 #endif
diff -puN lib/Kconfig~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix lib/Kconfig
--- a/lib/Kconfig~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix
+++ a/lib/Kconfig
@@ -537,6 +537,6 @@ config ARCH_HAS_MMIO_FLUSH
 	bool
 
 config STACKDEPOT
-  bool
+	bool
 
 endmenu
diff -puN lib/Kconfig.kasan~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix
+++ a/lib/Kconfig.kasan
@@ -7,7 +7,7 @@ config KASAN
 	bool "KASan: runtime memory debugger"
 	depends on SLUB_DEBUG || (SLAB && !DEBUG_SLAB)
 	select CONSTRUCTORS
-  select STACKDEPOT if SLAB
+	select STACKDEPOT if SLAB
 	help
 	  Enables kernel address sanitizer - runtime memory debugger,
 	  designed to find out-of-bounds accesses and use-after-free bugs.
diff -puN lib/stackdepot.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix lib/stackdepot.c
--- a/lib/stackdepot.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix
+++ a/lib/stackdepot.c
@@ -39,7 +39,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
-#define DEPOT_STACK_BITS (sizeof(depot_stack_handle) * 8)
+#define DEPOT_STACK_BITS (sizeof(depot_stack_handle_t) * 8)
 
 #define STACK_ALLOC_ORDER 2 /* 'Slab' size order for stack depot, 4 pages */
 #define STACK_ALLOC_SIZE (1LL << (PAGE_SHIFT + STACK_ALLOC_ORDER))
@@ -54,7 +54,7 @@
 
 /* The compact structure to store the reference to stacks. */
 union handle_parts {
-	depot_stack_handle handle;
+	depot_stack_handle_t handle;
 	struct {
 		u32 slabindex : STACK_ALLOC_INDEX_BITS;
 		u32 offset : STACK_ALLOC_OFFSET_BITS;
@@ -173,7 +173,7 @@ static inline struct stack_record *find_
 	return NULL;
 }
 
-void depot_fetch_stack(depot_stack_handle handle, struct stack_trace *trace)
+void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace)
 {
 	union handle_parts parts = { .handle = handle };
 	void *slab = stack_slabs[parts.slabindex];
@@ -192,11 +192,11 @@ void depot_fetch_stack(depot_stack_handl
  *
  * Returns the handle of the stack struct stored in depot.
  */
-depot_stack_handle depot_save_stack(struct stack_trace *trace,
+depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
 				    gfp_t alloc_flags)
 {
 	u32 hash;
-	depot_stack_handle retval = 0;
+	depot_stack_handle_t retval = 0;
 	struct stack_record *found = NULL, **bucket;
 	unsigned long flags;
 	struct page *page = NULL;
diff -puN mm/kasan/kasan.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix
+++ a/mm/kasan/kasan.c
@@ -436,7 +436,7 @@ static inline void filter_irq_stacks(str
 		}
 }
 
-static inline depot_stack_handle save_stack(gfp_t flags)
+static inline depot_stack_handle_t save_stack(gfp_t flags)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
 	struct stack_trace trace = {
diff -puN mm/kasan/kasan.h~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix
+++ a/mm/kasan/kasan.h
@@ -71,7 +71,7 @@ struct kasan_track {
 	u64 cpu : 6;			/* for NR_CPUS = 64 */
 	u64 pid : 16;			/* 65536 processes */
 	u64 when : 42;			/* ~140 years */
-	depot_stack_handle stack : sizeof(depot_stack_handle);
+	depot_stack_handle_t stack : sizeof(depot_stack_handle_t);
 };
 
 struct kasan_alloc_meta {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sched-add-schedule_timeout_idle.patch
drivers-input-eliminate-input_compat_test-macro.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


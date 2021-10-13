Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCA3C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 23:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7337610E6
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 23:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhJMXIj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 19:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhJMXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 19:08:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03CF5610E5;
        Wed, 13 Oct 2021 23:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634166395;
        bh=VngdjA8lQCYYBnIpTfx+xAiIZOSES4awmVt03rl6c0U=;
        h=Date:From:To:Subject:From;
        b=bl8o7Kegfh/PnenGh6iVouUXTx+nMQvdeAG0ZYVDT3igLcDr0pJkbnq1Tx3g2+s1p
         jRaopdlsg5xRdsaS68WebGWifwTdu0Q7JiwwysIoTB+zljxuQUCBrcYXJzCpxtl00N
         93BlryrEb6YoSWVYwQVeJhb4GyEYwRSUTjKHrHHs=
Date:   Wed, 13 Oct 2021 16:06:34 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, elver@google.com, geert@linux-m68k.org,
        glider@google.com, glittao@gmail.com, imran.f.khan@oracle.com,
        maarten.lankhorst@linux.intel.com, mm-commits@vger.kernel.org,
        mripard@kernel.org, ryabinin.a.a@gmail.com, tzimmermann@suse.de,
        vbabka@suse.cz, vjitta@codeaurora.org
Subject:  +
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-allo?=
 =?US-ASCII?Q?cation-by-kvmalloc.patch?= added to -mm tree
Message-ID: <20211013230634.5Elts4izw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()
has been added to the -mm tree.  Its filename is
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()

Currently, enabling CONFIG_STACKDEPOT means its stack_table will be
allocated from memblock, even if stack depot ends up not actually used. 
The default size of stack_table is 4MB on 32-bit, 8MB on 64-bit.

This is fine for use-cases such as KASAN which is also a config option and
has overhead on its own.  But it's an issue for functionality that has to
be actually enabled on boot (page_owner) or depends on hardware (GPU
drivers) and thus the memory might be wasted.  This was raised as an issue
[1] when attempting to add stackdepot support for SLUB's debug object
tracking functionality.  It's common to build kernels with
CONFIG_SLUB_DEBUG and enable slub_debug on boot only when needed, or
create only specific kmem caches with debugging for testing purposes.

It would thus be more efficient if stackdepot's table was allocated only
when actually going to be used.  This patch thus makes the allocation (and
whole stack_depot_init() call) optional:

- Add a CONFIG_STACKDEPOT_ALWAYS_INIT flag to keep using the current
  well-defined point of allocation as part of mem_init(). Make CONFIG_KASAN
  select this flag.
- Other users have to call stack_depot_init() as part of their own init when
  it's determined that stack depot will actually be used. This may depend on
  both config and runtime conditions. Convert current users which are
  page_owner and several in the DRM subsystem. Same will be done for SLUB
  later.
- Because the init might now be called after the boot-time memblock allocation
  has given all memory to the buddy allocator, change stack_depot_init() to
  allocate stack_table with kvmalloc() when memblock is no longer available.
  Also handle allocation failure by disabling stackdepot (could have
  theoretically happened even with memblock allocation previously), and don't
  unnecessarily align the memblock allocation to its own size anymore.

[1] https://lore.kernel.org/all/CAMuHMdW=eoVzM1Re5FVoEN87nKfiLmM2+Ah7eNu2KXEhCvbZyA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20211013073005.11351-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com> # stackdepot
Cc: Marco Elver <elver@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_dp_mst_topology.c   |    1 
 drivers/gpu/drm/drm_mm.c                |    4 ++
 drivers/gpu/drm/i915/intel_runtime_pm.c |    3 ++
 include/linux/stackdepot.h              |   25 ++++++++++------
 init/main.c                             |    2 -
 lib/Kconfig                             |    4 ++
 lib/Kconfig.kasan                       |    2 -
 lib/stackdepot.c                        |   33 ++++++++++++++++++----
 mm/page_owner.c                         |    2 +
 9 files changed, 60 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -5490,6 +5490,7 @@ int drm_dp_mst_topology_mgr_init(struct
 	mutex_init(&mgr->probe_lock);
 #if IS_ENABLED(CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS)
 	mutex_init(&mgr->topology_ref_history_lock);
+	stack_depot_init();
 #endif
 	INIT_LIST_HEAD(&mgr->tx_msg_downq);
 	INIT_LIST_HEAD(&mgr->destroy_port_list);
--- a/drivers/gpu/drm/drm_mm.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/drivers/gpu/drm/drm_mm.c
@@ -980,6 +980,10 @@ void drm_mm_init(struct drm_mm *mm, u64
 	add_hole(&mm->head_node);
 
 	mm->scan_active = 0;
+
+#ifdef CONFIG_DRM_DEBUG_MM
+	stack_depot_init();
+#endif
 }
 EXPORT_SYMBOL(drm_mm_init);
 
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -68,6 +68,9 @@ static noinline depot_stack_handle_t __s
 static void init_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 {
 	spin_lock_init(&rpm->debug.lock);
+
+	if (rpm->available)
+		stack_depot_init();
 }
 
 static noinline depot_stack_handle_t
--- a/include/linux/stackdepot.h~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/include/linux/stackdepot.h
@@ -19,6 +19,22 @@ depot_stack_handle_t __stack_depot_save(
 					unsigned int nr_entries,
 					gfp_t gfp_flags, bool can_alloc);
 
+/*
+ * Every user of stack depot has to call this during its own init when it's
+ * decided that it will be calling stack_depot_save() later.
+ *
+ * The alternative is to select STACKDEPOT_ALWAYS_INIT to have stack depot
+ * enabled as part of mm_init(), for subsystems where it's known at compile time
+ * that stack depot will be used.
+ */
+int stack_depot_init(void);
+
+#ifdef CONFIG_STACKDEPOT_ALWAYS_INIT
+static inline int stack_depot_early_init(void)	{ return stack_depot_init(); }
+#else
+static inline int stack_depot_early_init(void)	{ return 0; }
+#endif
+
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
 				      unsigned int nr_entries, gfp_t gfp_flags);
 
@@ -30,13 +46,4 @@ int stack_depot_snprint(depot_stack_hand
 
 void stack_depot_print(depot_stack_handle_t stack);
 
-#ifdef CONFIG_STACKDEPOT
-int stack_depot_init(void);
-#else
-static inline int stack_depot_init(void)
-{
-	return 0;
-}
-#endif	/* CONFIG_STACKDEPOT */
-
 #endif
--- a/init/main.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/init/main.c
@@ -842,7 +842,7 @@ static void __init mm_init(void)
 	init_mem_debugging_and_hardening();
 	kfence_alloc_pool();
 	report_meminit();
-	stack_depot_init();
+	stack_depot_early_init();
 	mem_init();
 	mem_init_print_info();
 	/* page_owner must be initialized after buddy is ready */
--- a/lib/Kconfig~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/lib/Kconfig
@@ -671,6 +671,10 @@ config STACKDEPOT
 	bool
 	select STACKTRACE
 
+config STACKDEPOT_ALWAYS_INIT
+	bool
+	select STACKDEPOT
+
 config STACK_HASH_ORDER
 	int "stack depot hash size (12 => 4KB, 20 => 1024KB)"
 	range 12 20
--- a/lib/Kconfig.kasan~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/lib/Kconfig.kasan
@@ -38,7 +38,7 @@ menuconfig KASAN
 		    CC_HAS_WORKING_NOSANITIZE_ADDRESS) || \
 		   HAVE_ARCH_KASAN_HW_TAGS
 	depends on (SLUB && SYSFS) || (SLAB && !DEBUG_SLAB)
-	select STACKDEPOT
+	select STACKDEPOT_ALWAYS_INIT
 	help
 	  Enables KASAN (KernelAddressSANitizer) - runtime memory debugger,
 	  designed to find out-of-bounds accesses and use-after-free bugs.
--- a/lib/stackdepot.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/lib/stackdepot.c
@@ -23,6 +23,7 @@
 #include <linux/jhash.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
@@ -161,18 +162,40 @@ static int __init is_stack_depot_disable
 }
 early_param("stack_depot_disable", is_stack_depot_disabled);
 
-int __init stack_depot_init(void)
+/*
+ * __ref because of memblock_alloc(), which will not be actually called after
+ * the __init code is gone, because at that point slab_is_available() is true
+ */
+__ref int stack_depot_init(void)
 {
-	if (!stack_depot_disable) {
+	static DEFINE_MUTEX(stack_depot_init_mutex);
+
+	mutex_lock(&stack_depot_init_mutex);
+	if (!stack_depot_disable && stack_table == NULL) {
 		size_t size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
 		int i;
 
-		stack_table = memblock_alloc(size, size);
-		for (i = 0; i < STACK_HASH_SIZE;  i++)
-			stack_table[i] = NULL;
+		if (slab_is_available()) {
+			pr_info("Stack Depot allocating hash table with kvmalloc\n");
+			stack_table = kvmalloc(size, GFP_KERNEL);
+		} else {
+			pr_info("Stack Depot allocating hash table with memblock_alloc\n");
+			stack_table = memblock_alloc(size, SMP_CACHE_BYTES);
+		}
+		if (stack_table) {
+			for (i = 0; i < STACK_HASH_SIZE;  i++)
+				stack_table[i] = NULL;
+		} else {
+			pr_err("Stack Depot failed hash table allocationg, disabling\n");
+			stack_depot_disable = true;
+			mutex_unlock(&stack_depot_init_mutex);
+			return -ENOMEM;
+		}
 	}
+	mutex_unlock(&stack_depot_init_mutex);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(stack_depot_init);
 
 /* Calculate hash for a stack */
 static inline u32 hash_stack(unsigned long *entries, unsigned int size)
--- a/mm/page_owner.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc
+++ a/mm/page_owner.c
@@ -80,6 +80,8 @@ static void init_page_owner(void)
 	if (!page_owner_enabled)
 		return;
 
+	stack_depot_init();
+
 	register_dummy_stack();
 	register_failure_stack();
 	register_early_stack();
_

Patches currently in -mm which might be from vbabka@suse.cz are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch


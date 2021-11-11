Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788B2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6025E61075
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhKKCzD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E7DE6103C;
        Thu, 11 Nov 2021 02:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599135;
        bh=dBNHvIWAKZOgTcwY2zD5gOA02f0Gy9kSMCct8dtTEF4=;
        h=Date:From:To:Subject:From;
        b=p2t963xabHfC/oDqvZtk+qA5IrEIcEux/2u4iHTH+TrFpuddOqkEQC3qBGf3GUM9u
         z4XjYxlQixxK1R6ptpse2r8Mia2QMQnP8YpnXHexMxEF8CQORGkaNK4V2R12/Gq7TU
         KGERDd3VoHr9ljtPlqs8QEhsGn8QbIOF29Fx36EI=
Date:   Wed, 10 Nov 2021 18:52:14 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, geert@linux-m68k.org, glider@google.com,
        imran.f.khan@oracle.com, jani.nikula@intel.com,
        maarten.lankhorst@linux.intel.com, mm-commits@vger.kernel.org,
        mripard@kernel.org, ryabinin.a.a@gmail.com, tzimmermann@suse.de,
        vbabka@suse.cz
Subject:  [merged]
 lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch removed
 from -mm tree
Message-ID: <20211111025214.Hu7IXtQZw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib, stackdepot: add helper to print stack entries into buffer
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib, stackdepot: add helper to print stack entries into buffer

To print stack entries into a buffer, users of stackdepot, first get a
list of stack entries using stack_depot_fetch and then print this list
into a buffer using stack_trace_snprint.  Provide a helper in stackdepot
for this purpose.  Also change above mentioned users to use this helper.

[imran.f.khan@oracle.com: fix build error]
  Link: https://lkml.kernel.org/r/20210915175321.3472770-4-imran.f.khan@oracle.com
[imran.f.khan@oracle.com: export stack_depot_snprint() to modules]
  Link: https://lkml.kernel.org/r/20210916133535.3592491-4-imran.f.khan@oracle.com
Link: https://lkml.kernel.org/r/20210915014806.3206938-4-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jani Nikula <jani.nikula@intel.com>	[i915]
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_dp_mst_topology.c   |    5 ----
 drivers/gpu/drm/drm_mm.c                |    5 ----
 drivers/gpu/drm/i915/i915_vma.c         |    5 ----
 drivers/gpu/drm/i915/intel_runtime_pm.c |   20 ++++-------------
 include/linux/stackdepot.h              |    3 ++
 lib/stackdepot.c                        |   25 ++++++++++++++++++++++
 mm/page_owner.c                         |    5 ----
 7 files changed, 37 insertions(+), 31 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1668,13 +1668,10 @@ __dump_topology_ref_history(struct drm_d
 	for (i = 0; i < history->len; i++) {
 		const struct drm_dp_mst_topology_ref_entry *entry =
 			&history->entries[i];
-		ulong *entries;
-		uint nr_entries;
 		u64 ts_nsec = entry->ts_nsec;
 		u32 rem_nsec = do_div(ts_nsec, 1000000000);
 
-		nr_entries = stack_depot_fetch(entry->backtrace, &entries);
-		stack_trace_snprint(buf, PAGE_SIZE, entries, nr_entries, 4);
+		stack_depot_snprint(entry->backtrace, buf, PAGE_SIZE, 4);
 
 		drm_printf(&p, "  %d %ss (last at %5llu.%06u):\n%s",
 			   entry->count,
--- a/drivers/gpu/drm/drm_mm.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/drivers/gpu/drm/drm_mm.c
@@ -118,8 +118,6 @@ static noinline void save_stack(struct d
 static void show_leaks(struct drm_mm *mm)
 {
 	struct drm_mm_node *node;
-	unsigned long *entries;
-	unsigned int nr_entries;
 	char *buf;
 
 	buf = kmalloc(BUFSZ, GFP_KERNEL);
@@ -133,8 +131,7 @@ static void show_leaks(struct drm_mm *mm
 			continue;
 		}
 
-		nr_entries = stack_depot_fetch(node->stack, &entries);
-		stack_trace_snprint(buf, BUFSZ, entries, nr_entries, 0);
+		stack_depot_snprint(node->stack, buf, BUFSZ, 0);
 		DRM_ERROR("node [%08llx + %08llx]: inserted at\n%s",
 			  node->start, node->size, buf);
 	}
--- a/drivers/gpu/drm/i915/i915_vma.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/drivers/gpu/drm/i915/i915_vma.c
@@ -56,8 +56,6 @@ void i915_vma_free(struct i915_vma *vma)
 
 static void vma_print_allocator(struct i915_vma *vma, const char *reason)
 {
-	unsigned long *entries;
-	unsigned int nr_entries;
 	char buf[512];
 
 	if (!vma->node.stack) {
@@ -66,8 +64,7 @@ static void vma_print_allocator(struct i
 		return;
 	}
 
-	nr_entries = stack_depot_fetch(vma->node.stack, &entries);
-	stack_trace_snprint(buf, sizeof(buf), entries, nr_entries, 0);
+	stack_depot_snprint(vma->node.stack, buf, sizeof(buf), 0);
 	DRM_DEBUG_DRIVER("vma.node [%08llx + %08llx] %s: inserted at %s\n",
 			 vma->node.start, vma->node.size, reason, buf);
 }
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -65,16 +65,6 @@ static noinline depot_stack_handle_t __s
 	return stack_depot_save(entries, n, GFP_NOWAIT | __GFP_NOWARN);
 }
 
-static void __print_depot_stack(depot_stack_handle_t stack,
-				char *buf, int sz, int indent)
-{
-	unsigned long *entries;
-	unsigned int nr_entries;
-
-	nr_entries = stack_depot_fetch(stack, &entries);
-	stack_trace_snprint(buf, sz, entries, nr_entries, indent);
-}
-
 static void init_intel_runtime_pm_wakeref(struct intel_runtime_pm *rpm)
 {
 	spin_lock_init(&rpm->debug.lock);
@@ -146,12 +136,12 @@ static void untrack_intel_runtime_pm_wak
 		if (!buf)
 			return;
 
-		__print_depot_stack(stack, buf, PAGE_SIZE, 2);
+		stack_depot_snprint(stack, buf, PAGE_SIZE, 2);
 		DRM_DEBUG_DRIVER("wakeref %x from\n%s", stack, buf);
 
 		stack = READ_ONCE(rpm->debug.last_release);
 		if (stack) {
-			__print_depot_stack(stack, buf, PAGE_SIZE, 2);
+			stack_depot_snprint(stack, buf, PAGE_SIZE, 2);
 			DRM_DEBUG_DRIVER("wakeref last released at\n%s", buf);
 		}
 
@@ -183,12 +173,12 @@ __print_intel_runtime_pm_wakeref(struct
 		return;
 
 	if (dbg->last_acquire) {
-		__print_depot_stack(dbg->last_acquire, buf, PAGE_SIZE, 2);
+		stack_depot_snprint(dbg->last_acquire, buf, PAGE_SIZE, 2);
 		drm_printf(p, "Wakeref last acquired:\n%s", buf);
 	}
 
 	if (dbg->last_release) {
-		__print_depot_stack(dbg->last_release, buf, PAGE_SIZE, 2);
+		stack_depot_snprint(dbg->last_release, buf, PAGE_SIZE, 2);
 		drm_printf(p, "Wakeref last released:\n%s", buf);
 	}
 
@@ -203,7 +193,7 @@ __print_intel_runtime_pm_wakeref(struct
 		rep = 1;
 		while (i + 1 < dbg->count && dbg->owners[i + 1] == stack)
 			rep++, i++;
-		__print_depot_stack(stack, buf, PAGE_SIZE, 2);
+		stack_depot_snprint(stack, buf, PAGE_SIZE, 2);
 		drm_printf(p, "Wakeref x%lu taken at:\n%s", rep, buf);
 	}
 
--- a/include/linux/stackdepot.h~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/include/linux/stackdepot.h
@@ -25,6 +25,9 @@ depot_stack_handle_t stack_depot_save(un
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
+		       int spaces);
+
 void stack_depot_print(depot_stack_handle_t stack);
 
 #ifdef CONFIG_STACKDEPOT
--- a/lib/stackdepot.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/lib/stackdepot.c
@@ -214,6 +214,31 @@ static inline struct stack_record *find_
 }
 
 /**
+ * stack_depot_snprint - print stack entries from a depot into a buffer
+ *
+ * @handle:	Stack depot handle which was returned from
+ *		stack_depot_save().
+ * @buf:	Pointer to the print buffer
+ *
+ * @size:	Size of the print buffer
+ *
+ * @spaces:	Number of leading spaces to print
+ *
+ * Return:	Number of bytes printed.
+ */
+int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
+		       int spaces)
+{
+	unsigned long *entries;
+	unsigned int nr_entries;
+
+	nr_entries = stack_depot_fetch(handle, &entries);
+	return nr_entries ? stack_trace_snprint(buf, size, entries, nr_entries,
+						spaces) : 0;
+}
+EXPORT_SYMBOL_GPL(stack_depot_snprint);
+
+/**
  * stack_depot_print - print stack entries from a depot
  *
  * @stack:		Stack depot handle which was returned from
--- a/mm/page_owner.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/mm/page_owner.c
@@ -329,8 +329,6 @@ print_page_owner(char __user *buf, size_
 		depot_stack_handle_t handle)
 {
 	int ret, pageblock_mt, page_mt;
-	unsigned long *entries;
-	unsigned int nr_entries;
 	char *kbuf;
 
 	count = min_t(size_t, count, PAGE_SIZE);
@@ -361,8 +359,7 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	nr_entries = stack_depot_fetch(handle, &entries);
-	ret += stack_trace_snprint(kbuf + ret, count - ret, entries, nr_entries, 0);
+	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 	if (ret >= count)
 		goto err;
 
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are



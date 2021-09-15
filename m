Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06B6C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9197E61221
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 01:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbhIOB7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 21:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231979AbhIOB7e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 21:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14B6561168;
        Wed, 15 Sep 2021 01:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631671096;
        bh=I25YbKPEfJ1tMKjTAK/lb354nj3nFtxQjHcU+qRvP9I=;
        h=Date:From:To:Subject:From;
        b=Dp06UEqZ6+zDJ4ixN3JCIS3Tx8VK2LjJHUGBqmbrxPtrvhGCDEPPq4tImlvh4rWQE
         lD+gmeWKYSPoqgA36Y3Ee9oPOq4IshQlzvdNkLsabjY7SPc57C2MP5vU7Oa3wv1NTC
         fvCFr9kdhyZybr+HsIFuUTltBX+wkCIla2EoOoE4=
Date:   Tue, 14 Sep 2021 18:58:15 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, geert@linux-m68k.org, glider@google.com,
        imran.f.khan@oracle.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        ryabinin.a.a@gmail.com, tzimmermann@suse.de, vbabka@suse.cz
Subject:  +
 lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch added to
 -mm tree
Message-ID: <20210915015815.Cv--f4Z8b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib, stackdepot: add helper to print stack entries into buffer
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib, stackdepot: add helper to print stack entries into buffer

To print stack entries into a buffer, users of stackdepot, first get a
list of stack entries using stack_depot_fetch and then print this list
into a buffer using stack_trace_snprint.  Provide a helper in stackdepot
for this purpose.  Also change above mentioned users to use this helper.

Link: https://lkml.kernel.org/r/20210915014806.3206938-4-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
 drivers/gpu/drm/i915/intel_runtime_pm.c |   20 ++++--------------
 include/linux/stackdepot.h              |    3 ++
 lib/stackdepot.c                        |   24 ++++++++++++++++++++++
 mm/page_owner.c                         |    5 ----
 7 files changed, 36 insertions(+), 31 deletions(-)

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
+		stack_depot_snprint(node->stack, buf, BUFSZ);
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
+		stack_depot_print(stack, buf, PAGE_SIZE, 2);
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
 
 unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
--- a/lib/stackdepot.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer
+++ a/lib/stackdepot.c
@@ -215,6 +215,30 @@ static inline struct stack_record *find_
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

lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch
lib-stackdepot-add-helper-to-print-stack-entries.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch


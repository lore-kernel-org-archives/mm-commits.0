Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D69EC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJCVK0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCVIY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC5E12AD3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD75B81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006BBC433D6;
        Mon,  3 Oct 2022 21:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831182;
        bh=61I3vV24/PTWyC5j2sYXwWFlxPDd/lhjMQGM9Y5XnnM=;
        h=Date:To:From:Subject:From;
        b=OK9ieleL9gqhP7JwZkqaZCApPBm+Spr/Vuv7KaY6bnv8MsclION247ZZgIuLuKdJu
         Ys4FEQl+KKCM+WOcskQrJIMCjFQwfuuov1Z7yp53K14nH5E0PA23vdPkqj1l6i8KxX
         fFJCU4XhJ/W+H72wyP3E56pSwXU3zbUXU9HawCHc=
Date:   Mon, 03 Oct 2022 14:06:21 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-implement-stack-ring-for-tag-based-modes.patch removed from -mm tree
Message-Id: <20221003210622.006BBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: implement stack ring for tag-based modes
has been removed from the -mm tree.  Its filename was
     kasan-implement-stack-ring-for-tag-based-modes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: implement stack ring for tag-based modes
Date: Mon, 5 Sep 2022 23:05:45 +0200

Implement storing stack depot handles for alloc/free stack traces for slab
objects for the tag-based KASAN modes in a ring buffer.

This ring buffer is referred to as the stack ring.

On each alloc/free of a slab object, the tagged address of the object and
the current stack trace are recorded in the stack ring.

On each bug report, if the accessed address belongs to a slab object, the
stack ring is scanned for matching entries.  The newest entries are used
to print the alloc/free stack traces in the report: one entry for alloc
and one for free.

The number of entries in the stack ring is fixed in this patch, but one of
the following patches adds a command-line argument to control it.

[andreyknvl@google.com: initialize read-write lock in stack ring]
  Link: https://lkml.kernel.org/r/576182d194e27531e8090bad809e4136953895f4.1663700262.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/692de14b6b6a1bc817fd55e4ad92fc1f83c1ab59.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h       |   21 +++++++++++
 mm/kasan/report_tags.c |   71 +++++++++++++++++++++++++++++++++++++++
 mm/kasan/tags.c        |   52 ++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

--- a/mm/kasan/kasan.h~kasan-implement-stack-ring-for-tag-based-modes
+++ a/mm/kasan/kasan.h
@@ -2,6 +2,7 @@
 #ifndef __MM_KASAN_KASAN_H
 #define __MM_KASAN_KASAN_H
 
+#include <linux/atomic.h>
 #include <linux/kasan.h>
 #include <linux/kasan-tags.h>
 #include <linux/kfence.h>
@@ -233,6 +234,26 @@ struct kasan_free_meta {
 
 #endif /* CONFIG_KASAN_GENERIC */
 
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+
+struct kasan_stack_ring_entry {
+	void *ptr;
+	size_t size;
+	u32 pid;
+	depot_stack_handle_t stack;
+	bool is_free;
+};
+
+#define KASAN_STACK_RING_SIZE (32 << 10)
+
+struct kasan_stack_ring {
+	rwlock_t lock;
+	atomic64_t pos;
+	struct kasan_stack_ring_entry entries[KASAN_STACK_RING_SIZE];
+};
+
+#endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 /* Used in KUnit-compatible KASAN tests. */
 struct kunit_kasan_status {
--- a/mm/kasan/report_tags.c~kasan-implement-stack-ring-for-tag-based-modes
+++ a/mm/kasan/report_tags.c
@@ -4,8 +4,12 @@
  * Copyright (c) 2020 Google, Inc.
  */
 
+#include <linux/atomic.h>
+
 #include "kasan.h"
 
+extern struct kasan_stack_ring stack_ring;
+
 static const char *get_bug_type(struct kasan_report_info *info)
 {
 	/*
@@ -24,5 +28,72 @@ static const char *get_bug_type(struct k
 
 void kasan_complete_mode_report_info(struct kasan_report_info *info)
 {
+	unsigned long flags;
+	u64 pos;
+	struct kasan_stack_ring_entry *entry;
+	void *ptr;
+	u32 pid;
+	depot_stack_handle_t stack;
+	bool is_free;
+	bool alloc_found = false, free_found = false;
+
 	info->bug_type = get_bug_type(info);
+
+	if (!info->cache || !info->object)
+		return;
+	}
+
+	write_lock_irqsave(&stack_ring.lock, flags);
+
+	pos = atomic64_read(&stack_ring.pos);
+
+	/*
+	 * The loop below tries to find stack ring entries relevant to the
+	 * buggy object. This is a best-effort process.
+	 *
+	 * First, another object with the same tag can be allocated in place of
+	 * the buggy object. Also, since the number of entries is limited, the
+	 * entries relevant to the buggy object can be overwritten.
+	 */
+
+	for (u64 i = pos - 1; i != pos - 1 - KASAN_STACK_RING_SIZE; i--) {
+		if (alloc_found && free_found)
+			break;
+
+		entry = &stack_ring.entries[i % KASAN_STACK_RING_SIZE];
+
+		/* Paired with smp_store_release() in save_stack_info(). */
+		ptr = (void *)smp_load_acquire(&entry->ptr);
+
+		if (kasan_reset_tag(ptr) != info->object ||
+		    get_tag(ptr) != get_tag(info->access_addr))
+			continue;
+
+		pid = READ_ONCE(entry->pid);
+		stack = READ_ONCE(entry->stack);
+		is_free = READ_ONCE(entry->is_free);
+
+		if (is_free) {
+			/*
+			 * Second free of the same object.
+			 * Give up on trying to find the alloc entry.
+			 */
+			if (free_found)
+				break;
+
+			info->free_track.pid = pid;
+			info->free_track.stack = stack;
+			free_found = true;
+		} else {
+			/* Second alloc of the same object. Give up. */
+			if (alloc_found)
+				break;
+
+			info->alloc_track.pid = pid;
+			info->alloc_track.stack = stack;
+			alloc_found = true;
+		}
+	}
+
+	write_unlock_irqrestore(&stack_ring.lock, flags);
 }
--- a/mm/kasan/tags.c~kasan-implement-stack-ring-for-tag-based-modes
+++ a/mm/kasan/tags.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2020 Google, Inc.
  */
 
+#include <linux/atomic.h>
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
@@ -16,11 +17,62 @@
 #include <linux/types.h>
 
 #include "kasan.h"
+#include "../slab.h"
+
+/* Non-zero, as initial pointer values are 0. */
+#define STACK_RING_BUSY_PTR ((void *)1)
+
+struct kasan_stack_ring stack_ring = {
+	.lock = __RW_LOCK_UNLOCKED(stack_ring.lock)
+};
+
+static void save_stack_info(struct kmem_cache *cache, void *object,
+			gfp_t gfp_flags, bool is_free)
+{
+	unsigned long flags;
+	depot_stack_handle_t stack;
+	u64 pos;
+	struct kasan_stack_ring_entry *entry;
+	void *old_ptr;
+
+	stack = kasan_save_stack(gfp_flags, true);
+
+	/*
+	 * Prevent save_stack_info() from modifying stack ring
+	 * when kasan_complete_mode_report_info() is walking it.
+	 */
+	read_lock_irqsave(&stack_ring.lock, flags);
+
+next:
+	pos = atomic64_fetch_add(1, &stack_ring.pos);
+	entry = &stack_ring.entries[pos % KASAN_STACK_RING_SIZE];
+
+	/* Detect stack ring entry slots that are being written to. */
+	old_ptr = READ_ONCE(entry->ptr);
+	if (old_ptr == STACK_RING_BUSY_PTR)
+		goto next; /* Busy slot. */
+	if (!try_cmpxchg(&entry->ptr, &old_ptr, STACK_RING_BUSY_PTR))
+		goto next; /* Busy slot. */
+
+	WRITE_ONCE(entry->size, cache->object_size);
+	WRITE_ONCE(entry->pid, current->pid);
+	WRITE_ONCE(entry->stack, stack);
+	WRITE_ONCE(entry->is_free, is_free);
+
+	/*
+	 * Paired with smp_load_acquire() in kasan_complete_mode_report_info().
+	 */
+	smp_store_release(&entry->ptr, (s64)object);
+
+	read_unlock_irqrestore(&stack_ring.lock, flags);
+}
 
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
+	save_stack_info(cache, object, flags, false);
 }
 
 void kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
+	save_stack_info(cache, object, GFP_NOWAIT, true);
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


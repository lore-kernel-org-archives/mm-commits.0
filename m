Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FE6C5AD4C
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbjKTSEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbjKTSEL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:04:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18284BC
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:04:04 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E9C433C7;
        Mon, 20 Nov 2023 18:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503443;
        bh=u54jAYs6sXhX56z7S6o9RVBRyzBJ2Rm+ex1dfB7vpZY=;
        h=Date:To:From:Subject:From;
        b=Dax6926qvPSsW4Tyr4kCAaLxem5xSf75jMotZXgyouw7o1xo6HUmKHdDtnCz3RmwZ
         pEc/g5KbhoMN7bSJ1Uc0NfGSvKkKcdvv5znG+yCGe9+S+C/Tm8aejhWYETv6Yhumge
         m19kiqIjkKy2//0xvak+jLroRGDe8yeNYNJHiL8E=
Date:   Mon, 20 Nov 2023 10:04:03 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-allow-users-to-evict-stack-traces.patch added to mm-unstable branch
Message-Id: <20231120180403.A23E9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow users to evict stack traces
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-allow-users-to-evict-stack-traces.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-allow-users-to-evict-stack-traces.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: allow users to evict stack traces
Date: Mon, 20 Nov 2023 18:47:15 +0100

Add stack_depot_put, a function that decrements the reference counter on a
stack record and removes it from the stack depot once the counter reaches
0.

Internally, when removing a stack record, the function unlinks it from the
hash table bucket and returns to the freelist.

With this change, the users of stack depot can call stack_depot_put when
keeping a stack trace in the stack depot is not needed anymore.  This
allows avoiding polluting the stack depot with irrelevant stack traces and
thus have more space to store the relevant ones before the stack depot
reaches its capacity.

Link: https://lkml.kernel.org/r/1d1ad5692ee43d4fc2b3fd9d221331d30b36123f.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |   14 +++++++++++++
 lib/stackdepot.c           |   37 ++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

--- a/include/linux/stackdepot.h~lib-stackdepot-allow-users-to-evict-stack-traces
+++ a/include/linux/stackdepot.h
@@ -97,6 +97,8 @@ static inline int stack_depot_early_init
  *
  * If STACK_DEPOT_FLAG_GET is set in @depot_flags, stack depot will increment
  * the refcount on the saved stack trace if it already exists in stack depot.
+ * Users of this flag must also call stack_depot_put() when keeping the stack
+ * trace is no longer required to avoid overflowing the refcount.
  *
  * If the provided stack trace comes from the interrupt context, only the part
  * up to the interrupt entry is saved.
@@ -163,6 +165,18 @@ int stack_depot_snprint(depot_stack_hand
 		       int spaces);
 
 /**
+ * stack_depot_put - Drop a reference to a stack trace from stack depot
+ *
+ * @handle:	Stack depot handle returned from stack_depot_save()
+ *
+ * The stack trace is evicted from stack depot once all references to it have
+ * been dropped (once the number of stack_depot_evict() calls matches the
+ * number of stack_depot_save_flags() calls with STACK_DEPOT_FLAG_GET set for
+ * this stack trace).
+ */
+void stack_depot_put(depot_stack_handle_t handle);
+
+/**
  * stack_depot_set_extra_bits - Set extra bits in a stack depot handle
  *
  * @handle:	Stack depot handle returned from stack_depot_save()
--- a/lib/stackdepot.c~lib-stackdepot-allow-users-to-evict-stack-traces
+++ a/lib/stackdepot.c
@@ -394,7 +394,7 @@ static struct stack_record *depot_fetch_
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
-	lockdep_assert_held_read(&pool_rwlock);
+	lockdep_assert_held(&pool_rwlock);
 
 	if (parts.pool_index > pools_num) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
@@ -410,6 +410,14 @@ static struct stack_record *depot_fetch_
 	return stack;
 }
 
+/* Links stack into the freelist. */
+static void depot_free_stack(struct stack_record *stack)
+{
+	lockdep_assert_held_write(&pool_rwlock);
+
+	list_add(&stack->list, &free_stacks);
+}
+
 /* Calculates the hash for a stack. */
 static inline u32 hash_stack(unsigned long *entries, unsigned int size)
 {
@@ -592,6 +600,33 @@ unsigned int stack_depot_fetch(depot_sta
 }
 EXPORT_SYMBOL_GPL(stack_depot_fetch);
 
+void stack_depot_put(depot_stack_handle_t handle)
+{
+	struct stack_record *stack;
+	unsigned long flags;
+
+	if (!handle || stack_depot_disabled)
+		return;
+
+	write_lock_irqsave(&pool_rwlock, flags);
+
+	stack = depot_fetch_stack(handle);
+	if (WARN_ON(!stack))
+		goto out;
+
+	if (refcount_dec_and_test(&stack->count)) {
+		/* Unlink stack from the hash table. */
+		list_del(&stack->list);
+
+		/* Free stack. */
+		depot_free_stack(stack);
+	}
+
+out:
+	write_unlock_irqrestore(&pool_rwlock, flags);
+}
+EXPORT_SYMBOL_GPL(stack_depot_put);
+
 void stack_depot_print(depot_stack_handle_t stack)
 {
 	unsigned long *entries;
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-print-disabled-message-only-if-truly-disabled.patch
lib-stackdepot-check-disabled-flag-when-fetching.patch
lib-stackdepot-simplify-__stack_depot_save.patch
lib-stackdepot-drop-valid-bit-from-handles.patch
lib-stackdepot-add-depot_fetch_stack-helper.patch
lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch
lib-stackdepot-fix-and-clean-up-atomic-annotations.patch
lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch
lib-stackdepot-store-next-pool-pointer-in-new_pool.patch
lib-stackdepot-store-free-stack-records-in-a-freelist.patch
lib-stackdepot-use-read-write-lock.patch
lib-stackdepot-use-list_head-for-stack-record-links.patch
kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch
lib-stackdepot-kasan-add-flags-to-__stack_depot_save-and-rename.patch
lib-stackdepot-add-refcount-for-records.patch
lib-stackdepot-allow-users-to-evict-stack-traces.patch
kasan-remove-atomic-accesses-to-stack-ring-entries.patch
kasan-check-object_size-in-kasan_complete_mode_report_info.patch
kasan-use-stack_depot_put-for-tag-based-modes.patch
kasan-use-stack_depot_put-for-generic-mode.patch
lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch


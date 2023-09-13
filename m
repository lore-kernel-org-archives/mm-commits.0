Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2942BEE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjIMT3N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbjIMT3F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:29:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC9B1BCA
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:29:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DA8C433C8;
        Wed, 13 Sep 2023 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633341;
        bh=k84F5oTD+bbhSFz6aKhKlby1fmZVRZ68HXeMrXCXD6w=;
        h=Date:To:From:Subject:From;
        b=m4ZihR38eiVPn7iIe2Ykoy/U7rjk2KyNbV3eKrVxE4/3kO8YApsD9k05ifiU5lOBl
         nfXr+bvBtL3hiPaQdGbi9ZmQc9NcebvQes27naroMzL4MQu0MaXNz7FWhwhNJHAASh
         /gOVyoFR9lzdvfLM09ECgMsfOOl67S6TKp4l6f/Y=
Date:   Wed, 13 Sep 2023 12:29:00 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-use-list_head-for-stack-record-links.patch added to mm-unstable branch
Message-Id: <20230913192901.26DA8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: use list_head for stack record links
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-use-list_head-for-stack-record-links.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-use-list_head-for-stack-record-links.patch

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
Subject: lib/stackdepot: use list_head for stack record links
Date: Wed, 13 Sep 2023 19:14:37 +0200

Switch stack_record to use list_head for links in the hash table and in
the freelist.

This will allow removing entries from the hash table buckets.

This is preparatory patch for implementing the eviction of stack records
from the stack depot.

Link: https://lkml.kernel.org/r/d94caa60d28349ca5a3c709fdb67545d9374e0dc.1694625260.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   77 ++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 35 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-use-list_head-for-stack-record-links
+++ a/lib/stackdepot.c
@@ -18,6 +18,7 @@
 #include <linux/jhash.h>
 #include <linux/kernel.h>
 #include <linux/kmsan.h>
+#include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/percpu.h>
@@ -55,7 +56,7 @@ union handle_parts {
 };
 
 struct stack_record {
-	struct stack_record *next;	/* Link in hash table or freelist */
+	struct list_head list;		/* Links in hash table or freelist */
 	u32 hash;			/* Hash in hash table */
 	u32 size;			/* Number of stored frames */
 	union handle_parts handle;
@@ -77,21 +78,21 @@ static bool __stack_depot_early_init_pas
 /* Initial seed for jhash2. */
 #define STACK_HASH_SEED 0x9747b28c
 
-/* Hash table of pointers to stored stack traces. */
-static struct stack_record **stack_table;
+/* Hash table of stored stack records. */
+static struct list_head *stack_table;
 /* Fixed order of the number of table buckets. Used when KASAN is enabled. */
 static unsigned int stack_bucket_number_order;
 /* Hash mask for indexing the table. */
 static unsigned int stack_hash_mask;
 
-/* Array of memory regions that store stack traces. */
+/* Array of memory regions that store stack records. */
 static void *stack_pools[DEPOT_MAX_POOLS];
 /* Newly allocated pool that is not yet added to stack_pools. */
 static void *new_pool;
 /* Number of pools in stack_pools. */
 static int pools_num;
-/* Next stack in the freelist of stack records within stack_pools. */
-static struct stack_record *next_stack;
+/* Freelist of stack records within stack_pools. */
+static LIST_HEAD(free_stacks);
 /*
  * Stack depot tries to keep an extra pool allocated even before it runs out
  * of space in the currently used pool. This flag marks whether this extra pool
@@ -123,6 +124,15 @@ void __init stack_depot_request_early_in
 	__stack_depot_early_init_requested = true;
 }
 
+/* Initialize list_head's within the hash table. */
+static void init_stack_table(unsigned long entries)
+{
+	unsigned long i;
+
+	for (i = 0; i < entries; i++)
+		INIT_LIST_HEAD(&stack_table[i]);
+}
+
 /* Allocates a hash table via memblock. Can only be used during early boot. */
 int __init stack_depot_early_init(void)
 {
@@ -152,10 +162,10 @@ int __init stack_depot_early_init(void)
 		entries = 1UL << stack_bucket_number_order;
 	pr_info("allocating hash table via alloc_large_system_hash\n");
 	stack_table = alloc_large_system_hash("stackdepot",
-						sizeof(struct stack_record *),
+						sizeof(struct list_head),
 						entries,
 						STACK_HASH_TABLE_SCALE,
-						HASH_EARLY | HASH_ZERO,
+						HASH_EARLY,
 						NULL,
 						&stack_hash_mask,
 						1UL << STACK_BUCKET_NUMBER_ORDER_MIN,
@@ -165,6 +175,7 @@ int __init stack_depot_early_init(void)
 		stack_depot_disabled = true;
 		return -ENOMEM;
 	}
+	init_stack_table(entries);
 
 	return 0;
 }
@@ -205,7 +216,7 @@ int stack_depot_init(void)
 		entries = 1UL << STACK_BUCKET_NUMBER_ORDER_MAX;
 
 	pr_info("allocating hash table of %lu entries via kvcalloc\n", entries);
-	stack_table = kvcalloc(entries, sizeof(struct stack_record *), GFP_KERNEL);
+	stack_table = kvcalloc(entries, sizeof(struct list_head), GFP_KERNEL);
 	if (!stack_table) {
 		pr_err("hash table allocation failed, disabling\n");
 		stack_depot_disabled = true;
@@ -213,6 +224,7 @@ int stack_depot_init(void)
 		goto out_unlock;
 	}
 	stack_hash_mask = entries - 1;
+	init_stack_table(entries);
 
 out_unlock:
 	mutex_unlock(&stack_depot_init_mutex);
@@ -224,30 +236,24 @@ EXPORT_SYMBOL_GPL(stack_depot_init);
 /* Initializes a stack depol pool. */
 static void depot_init_pool(void *pool)
 {
-	const int records_in_pool = DEPOT_POOL_SIZE / DEPOT_STACK_RECORD_SIZE;
-	int i, offset;
+	int offset;
 
 	lockdep_assert_held_write(&pool_rwlock);
 
-	/* Initialize handles and link stack records to each other. */
-	for (i = 0, offset = 0;
-	     offset <= DEPOT_POOL_SIZE - DEPOT_STACK_RECORD_SIZE;
-	     i++, offset += DEPOT_STACK_RECORD_SIZE) {
+	WARN_ON(!list_empty(&free_stacks));
+
+	/* Initialize handles and link stack records into the freelist. */
+	for (offset = 0; offset <= DEPOT_POOL_SIZE - DEPOT_STACK_RECORD_SIZE;
+	     offset += DEPOT_STACK_RECORD_SIZE) {
 		struct stack_record *stack = pool + offset;
 
 		stack->handle.pool_index = pools_num;
 		stack->handle.offset = offset >> DEPOT_STACK_ALIGN;
 		stack->handle.extra = 0;
 
-		if (i < records_in_pool - 1)
-			stack->next = (void *)stack + DEPOT_STACK_RECORD_SIZE;
-		else
-			stack->next = NULL;
+		list_add(&stack->list, &free_stacks);
 	}
 
-	/* Link stack records into the freelist. */
-	WARN_ON(next_stack);
-	next_stack = pool;
 
 	/* Save reference to the pool to be used by depot_fetch_stack. */
 	stack_pools[pools_num] = pool;
@@ -289,7 +295,7 @@ static bool depot_update_pools(void **pr
 	lockdep_assert_held_write(&pool_rwlock);
 
 	/* Check if we still have objects in the freelist. */
-	if (next_stack)
+	if (!list_empty(&free_stacks))
 		goto out_keep_prealloc;
 
 	/* Check if we have a new pool saved and use it. */
@@ -340,19 +346,18 @@ depot_alloc_stack(unsigned long *entries
 		return NULL;
 
 	/* Check if we have a stack record to save the stack trace. */
-	stack = next_stack;
-	if (!stack)
+	if (list_empty(&free_stacks))
 		return NULL;
 
-	/* Advance the freelist. */
-	next_stack = stack->next;
+	/* Get and unlink the first entry from the freelist. */
+	stack = list_first_entry(&free_stacks, struct stack_record, list);
+	list_del(&stack->list);
 
 	/* Limit number of saved frames to CONFIG_STACKDEPOT_MAX_FRAMES. */
 	if (size > CONFIG_STACKDEPOT_MAX_FRAMES)
 		size = CONFIG_STACKDEPOT_MAX_FRAMES;
 
 	/* Save the stack trace. */
-	stack->next = NULL;
 	stack->hash = hash;
 	stack->size = size;
 	/* stack->handle is already filled in by depot_init_pool. */
@@ -414,15 +419,17 @@ int stackdepot_memcmp(const unsigned lon
 }
 
 /* Finds a stack in a bucket of the hash table. */
-static inline struct stack_record *find_stack(struct stack_record *bucket,
+static inline struct stack_record *find_stack(struct list_head *bucket,
 					     unsigned long *entries, int size,
 					     u32 hash)
 {
+	struct list_head *pos;
 	struct stack_record *found;
 
 	lockdep_assert_held(&pool_rwlock);
 
-	for (found = bucket; found; found = found->next) {
+	list_for_each(pos, bucket) {
+		found = list_entry(pos, struct stack_record, list);
 		if (found->hash == hash &&
 		    found->size == size &&
 		    !stackdepot_memcmp(entries, found->entries, size))
@@ -435,7 +442,8 @@ depot_stack_handle_t __stack_depot_save(
 					unsigned int nr_entries,
 					gfp_t alloc_flags, bool can_alloc)
 {
-	struct stack_record *found = NULL, **bucket;
+	struct list_head *bucket;
+	struct stack_record *found = NULL;
 	depot_stack_handle_t handle = 0;
 	struct page *page = NULL;
 	void *prealloc = NULL;
@@ -462,7 +470,7 @@ depot_stack_handle_t __stack_depot_save(
 	read_lock_irqsave(&pool_rwlock, flags);
 
 	/* Fast path: look the stack trace up without full locking. */
-	found = find_stack(*bucket, entries, nr_entries, hash);
+	found = find_stack(bucket, entries, nr_entries, hash);
 	if (found) {
 		read_unlock_irqrestore(&pool_rwlock, flags);
 		goto exit;
@@ -494,14 +502,13 @@ depot_stack_handle_t __stack_depot_save(
 
 	write_lock_irqsave(&pool_rwlock, flags);
 
-	found = find_stack(*bucket, entries, nr_entries, hash);
+	found = find_stack(bucket, entries, nr_entries, hash);
 	if (!found) {
 		struct stack_record *new =
 			depot_alloc_stack(entries, nr_entries, hash, &prealloc);
 
 		if (new) {
-			new->next = *bucket;
-			*bucket = new;
+			list_add(&new->list, bucket);
 			found = new;
 		}
 	} else if (prealloc) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

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


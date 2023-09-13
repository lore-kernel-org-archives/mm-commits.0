Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65DDEE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjIMT2q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbjIMT2o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:28:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36F2B7
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:28:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBA9C433CA;
        Wed, 13 Sep 2023 19:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633320;
        bh=GczlMjHgd1+4q29ry2Ee0Jw8bKQ4v+sIdBSeJUJ39L4=;
        h=Date:To:From:Subject:From;
        b=fRj/ZRughhxv+mNlYZB3jN3AxUHiuVa0RaNcRBJ+vmxwheBeOABjwmrnaJ9HEhYO6
         gDHhwVveGvXouSuUWxM1wJOAteCSjO9RBVT+C/nF+Z/Wp7kM4qKM6z04njpJpC40aD
         EUnohkBILdH/nna6aCcaOTnqSbzNKag3JxyQtDrQ=
Date:   Wed, 13 Sep 2023 12:28:39 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch added to mm-unstable branch
Message-Id: <20230913192840.6FBA9C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: use fixed-sized slots for stack records
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch

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
Subject: lib/stackdepot: use fixed-sized slots for stack records
Date: Wed, 13 Sep 2023 19:14:30 +0200

Instead of storing stack records in stack depot pools one right after
another, use fixed-sized slots.

Add a new Kconfig option STACKDEPOT_MAX_FRAMES that allows to select the
size of the slot in frames.  Use 64 as the default value, which is the
maximum stack trace size both KASAN and KMSAN use right now.

Also add descriptions for other stack depot Kconfig options.

This is preparatory patch for implementing the eviction of stack records
from the stack depot.

Link: https://lkml.kernel.org/r/658f5f34d4f94721844ad8ba41452d54b4f8ace5.1694625260.git.andreyknvl@google.com
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

 lib/Kconfig      |   10 ++++++++--
 lib/stackdepot.c |   13 +++++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

--- a/lib/Kconfig~lib-stackdepot-use-fixed-sized-slots-for-stack-records
+++ a/lib/Kconfig
@@ -708,13 +708,19 @@ config ARCH_STACKWALK
        bool
 
 config STACKDEPOT
-	bool
+	bool "Stack depot: stack trace storage that avoids duplication"
 	select STACKTRACE
 
 config STACKDEPOT_ALWAYS_INIT
-	bool
+	bool "Always initialize stack depot during early boot"
 	select STACKDEPOT
 
+config STACKDEPOT_MAX_FRAMES
+	int "Maximum number of frames in trace saved in stack depot"
+	range 1 256
+	default 64
+	depends on STACKDEPOT
+
 config REF_TRACKER
 	bool
 	depends on STACKTRACE_SUPPORT
--- a/lib/stackdepot.c~lib-stackdepot-use-fixed-sized-slots-for-stack-records
+++ a/lib/stackdepot.c
@@ -58,9 +58,12 @@ struct stack_record {
 	u32 hash;			/* Hash in the hash table */
 	u32 size;			/* Number of stored frames */
 	union handle_parts handle;
-	unsigned long entries[];	/* Variable-sized array of frames */
+	unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
 };
 
+#define DEPOT_STACK_RECORD_SIZE \
+	ALIGN(sizeof(struct stack_record), 1 << DEPOT_STACK_ALIGN)
+
 static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
 static bool __stack_depot_early_init_passed __initdata;
@@ -258,9 +261,7 @@ static struct stack_record *
 depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
 {
 	struct stack_record *stack;
-	size_t required_size = struct_size(stack, entries, size);
-
-	required_size = ALIGN(required_size, 1 << DEPOT_STACK_ALIGN);
+	size_t required_size = DEPOT_STACK_RECORD_SIZE;
 
 	/* Check if there is not enough space in the current pool. */
 	if (unlikely(pool_offset + required_size > DEPOT_POOL_SIZE)) {
@@ -295,6 +296,10 @@ depot_alloc_stack(unsigned long *entries
 	if (stack_pools[pool_index] == NULL)
 		return NULL;
 
+	/* Limit number of saved frames to CONFIG_STACKDEPOT_MAX_FRAMES. */
+	if (size > CONFIG_STACKDEPOT_MAX_FRAMES)
+		size = CONFIG_STACKDEPOT_MAX_FRAMES;
+
 	/* Save the stack trace. */
 	stack = stack_pools[pool_index] + pool_offset;
 	stack->hash = hash;
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


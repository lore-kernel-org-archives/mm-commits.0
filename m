Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61D1C54EE9
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiIEWtp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiIEWs6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6BD67CBF
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3159660C94
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C6AC433B5;
        Mon,  5 Sep 2022 22:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418134;
        bh=PRWNRJhKBvlTFFr6rtQ1Igx9pvSj5m+Qx4WGPn6VobQ=;
        h=Date:To:From:Subject:From;
        b=vM5Vq9betY+uxsd3LTawYCNmn3VWUH77uxyvR/JPWrPXPhL0ZSYYl2Pqba6l9pTz9
         U5wCv+3haB3z9BphQBSooBTnVGmtElj701AxBHzZhUOOXijM0547kA8i65e55GZXDq
         LxRkoDjpojSEVsyte2I9VAWvbABCA4mbKZjnUzkU=
Date:   Mon, 05 Sep 2022 15:48:53 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-dynamically-allocate-stack-ring-entries.patch added to mm-unstable branch
Message-Id: <20220905224854.89C6AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: dynamically allocate stack ring entries
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-dynamically-allocate-stack-ring-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-dynamically-allocate-stack-ring-entries.patch

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
Subject: kasan: dynamically allocate stack ring entries
Date: Mon, 5 Sep 2022 23:05:47 +0200

Instead of using a large static array, allocate the stack ring dynamically
via memblock_alloc().

The size of the stack ring is controlled by a new kasan.stack_ring_size
command-line parameter.  When kasan.stack_ring_size is not provided, the
default value of 32 << 10 is used.

When the stack trace collection is disabled via kasan.stacktrace=off, the
stack ring is not allocated.

Link: https://lkml.kernel.org/r/03b82ab60db53427e9818e0b0c1971baa10c3cbc.1662411800.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    4 +++-
 mm/kasan/kasan.h                  |    5 ++---
 mm/kasan/report_tags.c            |    4 ++--
 mm/kasan/tags.c                   |   25 ++++++++++++++++++++++++-
 4 files changed, 31 insertions(+), 7 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-dynamically-allocate-stack-ring-entries
+++ a/Documentation/dev-tools/kasan.rst
@@ -112,10 +112,12 @@ parameter can be used to control panic a
   if ``kasan_multi_shot`` is enabled.
 
 Software and Hardware Tag-Based KASAN modes (see the section about various
-modes below) support disabling stack trace collection:
+modes below) support altering stack trace collection behavior:
 
 - ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
   traces collection (default: ``on``).
+- ``kasan.stack_ring_size=<number of entries>`` specifies the number of entries
+  in the stack ring (default: ``32768``).
 
 Hardware Tag-Based KASAN mode is intended for use in production as a security
 mitigation. Therefore, it supports additional boot parameters that allow
--- a/mm/kasan/kasan.h~kasan-dynamically-allocate-stack-ring-entries
+++ a/mm/kasan/kasan.h
@@ -252,12 +252,11 @@ struct kasan_stack_ring_entry {
 	bool is_free;
 };
 
-#define KASAN_STACK_RING_SIZE (32 << 10)
-
 struct kasan_stack_ring {
 	rwlock_t lock;
+	size_t size;
 	atomic64_t pos;
-	struct kasan_stack_ring_entry entries[KASAN_STACK_RING_SIZE];
+	struct kasan_stack_ring_entry *entries;
 };
 
 #endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
--- a/mm/kasan/report_tags.c~kasan-dynamically-allocate-stack-ring-entries
+++ a/mm/kasan/report_tags.c
@@ -56,11 +56,11 @@ void kasan_complete_mode_report_info(str
 	 * entries relevant to the buggy object can be overwritten.
 	 */
 
-	for (u64 i = pos - 1; i != pos - 1 - KASAN_STACK_RING_SIZE; i--) {
+	for (u64 i = pos - 1; i != pos - 1 - stack_ring.size; i--) {
 		if (alloc_found && free_found)
 			break;
 
-		entry = &stack_ring.entries[i % KASAN_STACK_RING_SIZE];
+		entry = &stack_ring.entries[i % stack_ring.size];
 
 		/* Paired with smp_store_release() in save_stack_info(). */
 		ptr = (void *)smp_load_acquire(&entry->ptr);
--- a/mm/kasan/tags.c~kasan-dynamically-allocate-stack-ring-entries
+++ a/mm/kasan/tags.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
+#include <linux/memblock.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/static_key.h>
@@ -19,6 +20,8 @@
 #include "kasan.h"
 #include "../slab.h"
 
+#define KASAN_STACK_RING_SIZE_DEFAULT (32 << 10)
+
 enum kasan_arg_stacktrace {
 	KASAN_ARG_STACKTRACE_DEFAULT,
 	KASAN_ARG_STACKTRACE_OFF,
@@ -52,6 +55,16 @@ static int __init early_kasan_flag_stack
 }
 early_param("kasan.stacktrace", early_kasan_flag_stacktrace);
 
+/* kasan.stack_ring_size=<number of entries> */
+static int __init early_kasan_flag_stack_ring_size(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	return kstrtoul(arg, 0, &stack_ring.size);
+}
+early_param("kasan.stack_ring_size", early_kasan_flag_stack_ring_size);
+
 void __init kasan_init_tags(void)
 {
 	switch (kasan_arg_stacktrace) {
@@ -65,6 +78,16 @@ void __init kasan_init_tags(void)
 		static_branch_enable(&kasan_flag_stacktrace);
 		break;
 	}
+
+	if (kasan_stack_collection_enabled()) {
+		if (!stack_ring.size)
+			stack_ring.size = KASAN_STACK_RING_SIZE_DEFAULT;
+		stack_ring.entries = memblock_alloc(
+			sizeof(stack_ring.entries[0]) * stack_ring.size,
+			SMP_CACHE_BYTES);
+		if (WARN_ON(!stack_ring.entries))
+			static_branch_disable(&kasan_flag_stacktrace);
+	}
 }
 
 static void save_stack_info(struct kmem_cache *cache, void *object,
@@ -86,7 +109,7 @@ static void save_stack_info(struct kmem_
 
 next:
 	pos = atomic64_fetch_add(1, &stack_ring.pos);
-	entry = &stack_ring.entries[pos % KASAN_STACK_RING_SIZE];
+	entry = &stack_ring.entries[pos % stack_ring.size];
 
 	/* Detect stack ring entry slots that are being written to. */
 	old_ptr = READ_ONCE(entry->ptr);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch


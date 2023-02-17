Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01374C05027
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjBQEot (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBQEoh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DED4DE36
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BAD66112C
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F9FC433EF;
        Fri, 17 Feb 2023 04:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609074;
        bh=8H7bxQzO6Nw4MlFgcselnSmpsEFNJU1zVg3zhRsuMVg=;
        h=Date:To:From:Subject:From;
        b=F/wftM7xCRhaQ2eDosBFcWs6nsGu0V9XqJfsHoIyQrpPb4eSpHnEZp7fhS/jKNljb
         9VwoZ6ibdOCZV/icVdtszy9jb/peMUF8EQcTN8/D8EuJnbA8j5rdDThIoky67cyTCQ
         yLRZBd9W3JMqMuXyHKyk3zgJnKQz28NKrRdmEa8k=
Date:   Thu, 16 Feb 2023 20:44:34 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stacktrace-kasan-kmsan-rework-extra_bits-interface.patch removed from -mm tree
Message-Id: <20230217044434.C2F9FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stacktrace, kasan, kmsan: rework extra_bits interface
has been removed from the -mm tree.  Its filename was
     lib-stacktrace-kasan-kmsan-rework-extra_bits-interface.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stacktrace, kasan, kmsan: rework extra_bits interface
Date: Fri, 10 Feb 2023 22:16:03 +0100

The current implementation of the extra_bits interface is confusing:
passing extra_bits to __stack_depot_save makes it seem that the extra
bits are somehow stored in stack depot. In reality, they are only
embedded into a stack depot handle and are not used within stack depot.

Drop the extra_bits argument from __stack_depot_save and instead provide
a new stack_depot_set_extra_bits function (similar to the exsiting
stack_depot_get_extra_bits) that saves extra bits into a stack depot
handle.

Update the callers of __stack_depot_save to use the new interace.

This change also fixes a minor issue in the old code: __stack_depot_save
does not return NULL if saving stack trace fails and extra_bits is used.

Link: https://lkml.kernel.org/r/317123b5c05e2f82854fc55d8b285e0869d3cb77.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/stackdepot.h~lib-stacktrace-kasan-kmsan-rework-extra_bits-interface
+++ a/include/linux/stackdepot.h
@@ -57,7 +57,6 @@ static inline int stack_depot_early_init
 
 depot_stack_handle_t __stack_depot_save(unsigned long *entries,
 					unsigned int nr_entries,
-					unsigned int extra_bits,
 					gfp_t gfp_flags, bool can_alloc);
 
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
@@ -71,6 +70,9 @@ void stack_depot_print(depot_stack_handl
 int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 		       int spaces);
 
+depot_stack_handle_t __must_check stack_depot_set_extra_bits(
+			depot_stack_handle_t handle, unsigned int extra_bits);
+
 unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle);
 
 #endif
--- a/lib/stackdepot.c~lib-stacktrace-kasan-kmsan-rework-extra_bits-interface
+++ a/lib/stackdepot.c
@@ -357,7 +357,6 @@ static inline struct stack_record *find_
  *
  * @entries:		Pointer to storage array
  * @nr_entries:		Size of the storage array
- * @extra_bits:		Flags to store in unused bits of depot_stack_handle_t
  * @alloc_flags:	Allocation gfp flags
  * @can_alloc:		Allocate stack pools (increased chance of failure if false)
  *
@@ -369,10 +368,6 @@ static inline struct stack_record *find_
  * If the stack trace in @entries is from an interrupt, only the portion up to
  * interrupt entry is saved.
  *
- * Additional opaque flags can be passed in @extra_bits, stored in the unused
- * bits of the stack handle, and retrieved using stack_depot_get_extra_bits()
- * without calling stack_depot_fetch().
- *
  * Context: Any context, but setting @can_alloc to %false is required if
  *          alloc_pages() cannot be used from the current context. Currently
  *          this is the case from contexts where neither %GFP_ATOMIC nor
@@ -382,7 +377,6 @@ static inline struct stack_record *find_
  */
 depot_stack_handle_t __stack_depot_save(unsigned long *entries,
 					unsigned int nr_entries,
-					unsigned int extra_bits,
 					gfp_t alloc_flags, bool can_alloc)
 {
 	struct stack_record *found = NULL, **bucket;
@@ -471,8 +465,6 @@ exit:
 	if (found)
 		retval.handle = found->handle.handle;
 fast_exit:
-	retval.extra = extra_bits;
-
 	return retval.handle;
 }
 EXPORT_SYMBOL_GPL(__stack_depot_save);
@@ -493,7 +485,7 @@ depot_stack_handle_t stack_depot_save(un
 				      unsigned int nr_entries,
 				      gfp_t alloc_flags)
 {
-	return __stack_depot_save(entries, nr_entries, 0, alloc_flags, true);
+	return __stack_depot_save(entries, nr_entries, alloc_flags, true);
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
 
@@ -576,6 +568,38 @@ int stack_depot_snprint(depot_stack_hand
 }
 EXPORT_SYMBOL_GPL(stack_depot_snprint);
 
+/**
+ * stack_depot_set_extra_bits - Set extra bits in a stack depot handle
+ *
+ * @handle:	Stack depot handle returned from stack_depot_save()
+ * @extra_bits:	Value to set the extra bits
+ *
+ * Return: Stack depot handle with extra bits set
+ *
+ * Stack depot handles have a few unused bits, which can be used for storing
+ * user-specific information. These bits are transparent to the stack depot.
+ */
+depot_stack_handle_t __must_check stack_depot_set_extra_bits(
+			depot_stack_handle_t handle, unsigned int extra_bits)
+{
+	union handle_parts parts = { .handle = handle };
+
+	/* Don't set extra bits on empty handles. */
+	if (!handle)
+		return 0;
+
+	parts.extra = extra_bits;
+	return parts.handle;
+}
+EXPORT_SYMBOL(stack_depot_set_extra_bits);
+
+/**
+ * stack_depot_get_extra_bits - Retrieve extra bits from a stack depot handle
+ *
+ * @handle:	Stack depot handle with extra bits saved
+ *
+ * Return: Extra bits retrieved from the stack depot handle
+ */
 unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle)
 {
 	union handle_parts parts = { .handle = handle };
--- a/mm/kasan/common.c~lib-stacktrace-kasan-kmsan-rework-extra_bits-interface
+++ a/mm/kasan/common.c
@@ -43,7 +43,7 @@ depot_stack_handle_t kasan_save_stack(gf
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
-	return __stack_depot_save(entries, nr_entries, 0, flags, can_alloc);
+	return __stack_depot_save(entries, nr_entries, flags, can_alloc);
 }
 
 void kasan_set_track(struct kasan_track *track, gfp_t flags)
--- a/mm/kmsan/core.c~lib-stacktrace-kasan-kmsan-rework-extra_bits-interface
+++ a/mm/kmsan/core.c
@@ -69,13 +69,15 @@ depot_stack_handle_t kmsan_save_stack_wi
 {
 	unsigned long entries[KMSAN_STACK_DEPTH];
 	unsigned int nr_entries;
+	depot_stack_handle_t handle;
 
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
 	/* Don't sleep (see might_sleep_if() in __alloc_pages_nodemask()). */
 	flags &= ~__GFP_DIRECT_RECLAIM;
 
-	return __stack_depot_save(entries, nr_entries, extra, flags, true);
+	handle = __stack_depot_save(entries, nr_entries, flags, true);
+	return stack_depot_set_extra_bits(handle, extra);
 }
 
 /* Copy the metadata following the memmove() behavior. */
@@ -215,6 +217,7 @@ depot_stack_handle_t kmsan_internal_chai
 	u32 extra_bits;
 	int depth;
 	bool uaf;
+	depot_stack_handle_t handle;
 
 	if (!id)
 		return id;
@@ -250,8 +253,9 @@ depot_stack_handle_t kmsan_internal_chai
 	 * positives when __stack_depot_save() passes it to instrumented code.
 	 */
 	kmsan_internal_unpoison_memory(entries, sizeof(entries), false);
-	return __stack_depot_save(entries, ARRAY_SIZE(entries), extra_bits,
-				  GFP_ATOMIC, true);
+	handle = __stack_depot_save(entries, ARRAY_SIZE(entries), GFP_ATOMIC,
+				    true);
+	return stack_depot_set_extra_bits(handle, extra_bits);
 }
 
 void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
_

Patches currently in -mm which might be from andreyknvl@google.com are



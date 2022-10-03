Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0389C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiJCVIe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJCVG3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24BA4DF0A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA1BB611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A76AC433D7;
        Mon,  3 Oct 2022 21:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831153;
        bh=9XWsJddyHgre+6U4hO+J/Yiyg2lT0y0LOMB2ZGkc+Is=;
        h=Date:To:From:Subject:From;
        b=QQZ9l03nTZcIBoa/DkKt7gTGdtL9lOy+CO6/i9vsVN4tpl7W7PlCpTqcgfPuyjrRi
         lHWHvswnOrfD2gl3SU3arNvT/6tk8R2wTQ7yZVyPNSnGYkDGAsDo/PusXZOis3Dr+W
         ovgaFseGj1FiB6Dvjxp8TvKKM0b/hzDOgCmLFexA=
Date:   Mon, 03 Oct 2022 14:05:52 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-introduce-kasan_print_aux_stacks.patch removed from -mm tree
Message-Id: <20221003210553.4A76AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: introduce kasan_print_aux_stacks
has been removed from the -mm tree.  Its filename was
     kasan-introduce-kasan_print_aux_stacks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: introduce kasan_print_aux_stacks
Date: Mon, 5 Sep 2022 23:05:21 +0200

Add a kasan_print_aux_stacks() helper that prints the auxiliary stack
traces for the Generic mode.

This change hides references to alloc_meta from the common reporting code.
This is desired as only the Generic mode will be using per-object
metadata after this series.

Link: https://lkml.kernel.org/r/67c7a9ea6615533762b1f8ccc267cd7f9bafb749.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h          |    6 ++++++
 mm/kasan/report.c         |   15 +--------------
 mm/kasan/report_generic.c |   20 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 14 deletions(-)

--- a/mm/kasan/kasan.h~kasan-introduce-kasan_print_aux_stacks
+++ a/mm/kasan/kasan.h
@@ -266,6 +266,12 @@ void kasan_print_address_stack_frame(con
 static inline void kasan_print_address_stack_frame(const void *addr) { }
 #endif
 
+#ifdef CONFIG_KASAN_GENERIC
+void kasan_print_aux_stacks(struct kmem_cache *cache, const void *object);
+#else
+static inline void kasan_print_aux_stacks(struct kmem_cache *cache, const void *object) { }
+#endif
+
 bool kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 void kasan_report_invalid_free(void *object, unsigned long ip, enum kasan_report_type type);
--- a/mm/kasan/report.c~kasan-introduce-kasan_print_aux_stacks
+++ a/mm/kasan/report.c
@@ -270,20 +270,7 @@ static void describe_object_stacks(struc
 		pr_err("\n");
 	}
 
-#ifdef CONFIG_KASAN_GENERIC
-	if (!alloc_meta)
-		return;
-	if (alloc_meta->aux_stack[0]) {
-		pr_err("Last potentially related work creation:\n");
-		stack_depot_print(alloc_meta->aux_stack[0]);
-		pr_err("\n");
-	}
-	if (alloc_meta->aux_stack[1]) {
-		pr_err("Second to last potentially related work creation:\n");
-		stack_depot_print(alloc_meta->aux_stack[1]);
-		pr_err("\n");
-	}
-#endif
+	kasan_print_aux_stacks(cache, object);
 }
 
 static void describe_object(struct kmem_cache *cache, void *object,
--- a/mm/kasan/report_generic.c~kasan-introduce-kasan_print_aux_stacks
+++ a/mm/kasan/report_generic.c
@@ -132,6 +132,26 @@ void kasan_metadata_fetch_row(char *buff
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
 }
 
+void kasan_print_aux_stacks(struct kmem_cache *cache, const void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return;
+
+	if (alloc_meta->aux_stack[0]) {
+		pr_err("Last potentially related work creation:\n");
+		stack_depot_print(alloc_meta->aux_stack[0]);
+		pr_err("\n");
+	}
+	if (alloc_meta->aux_stack[1]) {
+		pr_err("Second to last potentially related work creation:\n");
+		stack_depot_print(alloc_meta->aux_stack[1]);
+		pr_err("\n");
+	}
+}
+
 #ifdef CONFIG_KASAN_STACK
 static bool __must_check tokenize_frame_descr(const char **frame_descr,
 					      char *token, size_t max_tok_len,
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


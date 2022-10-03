Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BABBC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJCVIf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJCVG3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AFB4DF0D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78144B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6C4C433C1;
        Mon,  3 Oct 2022 21:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831152;
        bh=7H39pqwJn4IA79kpGTdMtqbhLxZTy4Imb78IrBr4Dhg=;
        h=Date:To:From:Subject:From;
        b=MQgckpJ0Z+1VC7GkvP7fC4Jr4p4Rgr4lCRccHf7dGyjhWZhNMfdpNZM3kGW3QgkUn
         l9O5qUjhHorDjQFaJDhHDeMxdssaxbipGUBkIWK1BVaErSmb8E+cPv/BDOcoVpfLMv
         lEEfGRzx5MSiMAd6Kncd74CgTUS195008ZhmCrNM=
Date:   Mon, 03 Oct 2022 14:05:51 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-drop-config_kasan_tags_identify.patch removed from -mm tree
Message-Id: <20221003210552.1D6C4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: drop CONFIG_KASAN_TAGS_IDENTIFY
has been removed from the -mm tree.  Its filename was
     kasan-drop-config_kasan_tags_identify.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: drop CONFIG_KASAN_TAGS_IDENTIFY
Date: Mon, 5 Sep 2022 23:05:20 +0200

Drop CONFIG_KASAN_TAGS_IDENTIFY and related code to simplify making
changes to the reporting code.

The dropped functionality will be restored in the following patches in
this series.

Link: https://lkml.kernel.org/r/4c66ba98eb237e9ed9312c19d423bbcf4ecf88f8.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan      |    8 --------
 mm/kasan/kasan.h       |   12 +-----------
 mm/kasan/report_tags.c |   28 ----------------------------
 mm/kasan/tags.c        |   21 ++-------------------
 4 files changed, 3 insertions(+), 66 deletions(-)

--- a/lib/Kconfig.kasan~kasan-drop-config_kasan_tags_identify
+++ a/lib/Kconfig.kasan
@@ -167,14 +167,6 @@ config KASAN_STACK
 	  as well, as it adds inline-style instrumentation that is run
 	  unconditionally.
 
-config KASAN_TAGS_IDENTIFY
-	bool "Memory corruption type identification"
-	depends on KASAN_SW_TAGS || KASAN_HW_TAGS
-	help
-	  Enables best-effort identification of the bug types (use-after-free
-	  or out-of-bounds) at the cost of increased memory consumption.
-	  Only applicable for the tag-based KASAN modes.
-
 config KASAN_VMALLOC
 	bool "Check accesses to vmalloc allocations"
 	depends on HAVE_ARCH_KASAN_VMALLOC
--- a/mm/kasan/kasan.h~kasan-drop-config_kasan_tags_identify
+++ a/mm/kasan/kasan.h
@@ -169,23 +169,13 @@ struct kasan_track {
 	depot_stack_handle_t stack;
 };
 
-#if defined(CONFIG_KASAN_TAGS_IDENTIFY) && defined(CONFIG_KASAN_SW_TAGS)
-#define KASAN_NR_FREE_STACKS 5
-#else
-#define KASAN_NR_FREE_STACKS 1
-#endif
-
 struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
 	/* Generic mode stores free track in kasan_free_meta. */
 #ifdef CONFIG_KASAN_GENERIC
 	depot_stack_handle_t aux_stack[2];
 #else
-	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
-#endif
-#ifdef CONFIG_KASAN_TAGS_IDENTIFY
-	u8 free_pointer_tag[KASAN_NR_FREE_STACKS];
-	u8 free_track_idx;
+	struct kasan_track free_track;
 #endif
 };
 
--- a/mm/kasan/report_tags.c~kasan-drop-config_kasan_tags_identify
+++ a/mm/kasan/report_tags.c
@@ -5,37 +5,9 @@
  */
 
 #include "kasan.h"
-#include "../slab.h"
 
 const char *kasan_get_bug_type(struct kasan_report_info *info)
 {
-#ifdef CONFIG_KASAN_TAGS_IDENTIFY
-	struct kasan_alloc_meta *alloc_meta;
-	struct kmem_cache *cache;
-	struct slab *slab;
-	const void *addr;
-	void *object;
-	u8 tag;
-	int i;
-
-	tag = get_tag(info->access_addr);
-	addr = kasan_reset_tag(info->access_addr);
-	slab = kasan_addr_to_slab(addr);
-	if (slab) {
-		cache = slab->slab_cache;
-		object = nearest_obj(cache, slab, (void *)addr);
-		alloc_meta = kasan_get_alloc_meta(cache, object);
-
-		if (alloc_meta) {
-			for (i = 0; i < KASAN_NR_FREE_STACKS; i++) {
-				if (alloc_meta->free_pointer_tag[i] == tag)
-					return "use-after-free";
-			}
-		}
-		return "out-of-bounds";
-	}
-#endif
-
 	/*
 	 * If access_size is a negative number, then it has reason to be
 	 * defined as out-of-bounds bug type.
--- a/mm/kasan/tags.c~kasan-drop-config_kasan_tags_identify
+++ a/mm/kasan/tags.c
@@ -30,39 +30,22 @@ void kasan_save_free_info(struct kmem_ca
 				void *object, u8 tag)
 {
 	struct kasan_alloc_meta *alloc_meta;
-	u8 idx = 0;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
 	if (!alloc_meta)
 		return;
 
-#ifdef CONFIG_KASAN_TAGS_IDENTIFY
-	idx = alloc_meta->free_track_idx;
-	alloc_meta->free_pointer_tag[idx] = tag;
-	alloc_meta->free_track_idx = (idx + 1) % KASAN_NR_FREE_STACKS;
-#endif
-
-	kasan_set_track(&alloc_meta->free_track[idx], GFP_NOWAIT);
+	kasan_set_track(&alloc_meta->free_track, GFP_NOWAIT);
 }
 
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
 	struct kasan_alloc_meta *alloc_meta;
-	int i = 0;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
 	if (!alloc_meta)
 		return NULL;
 
-#ifdef CONFIG_KASAN_TAGS_IDENTIFY
-	for (i = 0; i < KASAN_NR_FREE_STACKS; i++) {
-		if (alloc_meta->free_pointer_tag[i] == tag)
-			break;
-	}
-	if (i == KASAN_NR_FREE_STACKS)
-		i = alloc_meta->free_track_idx;
-#endif
-
-	return &alloc_meta->free_track[i];
+	return &alloc_meta->free_track;
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


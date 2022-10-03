Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066DBC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJCVJz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJCVIU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B0F140D0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE53DB811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CDDC433C1;
        Mon,  3 Oct 2022 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831179;
        bh=xS3DZwa7VRUUJZqZEBzCfh75RCYe02KPeRM+6rdC7wc=;
        h=Date:To:From:Subject:From;
        b=qRyWOTAC7jb63jDzVsmUppvZ3xUr19P77ltuOdoWtURU5ZxzKKs0yjFzt70su7G98
         El0Dl9JL/M0dMGZdPZM6eZf0wJ2xBcLi9yJr/1hf9/chu0CGbVwe151Nvf42BatXSd
         ciDbgYAmFoXTSzgpc1Xp5XPKzeCSi9U4Glh6ZyGg=
Date:   Mon, 03 Oct 2022 14:06:18 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-rework-function-arguments-in-reportc.patch removed from -mm tree
Message-Id: <20221003210619.91CDDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: rework function arguments in report.c
has been removed from the -mm tree.  Its filename was
     kasan-rework-function-arguments-in-reportc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rework function arguments in report.c
Date: Mon, 5 Sep 2022 23:05:43 +0200

Pass a pointer to kasan_report_info to describe_object() and
describe_object_stacks(), instead of passing the structure's fields.

The untagged pointer and the tag are still passed as separate arguments to
some of the functions to avoid duplicating the untagging logic.

This is preparatory change for the next patch.

Link: https://lkml.kernel.org/r/2e0cdb91524ab528a3c2b12b6d8bcb69512fc4af.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/kasan/report.c~kasan-rework-function-arguments-in-reportc
+++ a/mm/kasan/report.c
@@ -213,8 +213,8 @@ static inline struct page *addr_to_page(
 	return NULL;
 }
 
-static void describe_object_addr(struct kmem_cache *cache, void *object,
-				const void *addr)
+static void describe_object_addr(const void *addr, struct kmem_cache *cache,
+				 void *object)
 {
 	unsigned long access_addr = (unsigned long)addr;
 	unsigned long object_addr = (unsigned long)object;
@@ -242,33 +242,32 @@ static void describe_object_addr(struct
 		(void *)(object_addr + cache->object_size));
 }
 
-static void describe_object_stacks(struct kmem_cache *cache, void *object,
-					const void *addr, u8 tag)
+static void describe_object_stacks(u8 tag, struct kasan_report_info *info)
 {
 	struct kasan_track *alloc_track;
 	struct kasan_track *free_track;
 
-	alloc_track = kasan_get_alloc_track(cache, object);
+	alloc_track = kasan_get_alloc_track(info->cache, info->object);
 	if (alloc_track) {
 		print_track(alloc_track, "Allocated");
 		pr_err("\n");
 	}
 
-	free_track = kasan_get_free_track(cache, object, tag);
+	free_track = kasan_get_free_track(info->cache, info->object, tag);
 	if (free_track) {
 		print_track(free_track, "Freed");
 		pr_err("\n");
 	}
 
-	kasan_print_aux_stacks(cache, object);
+	kasan_print_aux_stacks(info->cache, info->object);
 }
 
-static void describe_object(struct kmem_cache *cache, void *object,
-				const void *addr, u8 tag)
+static void describe_object(const void *addr, u8 tag,
+			    struct kasan_report_info *info)
 {
 	if (kasan_stack_collection_enabled())
-		describe_object_stacks(cache, object, addr, tag);
-	describe_object_addr(cache, object, addr);
+		describe_object_stacks(tag, info);
+	describe_object_addr(addr, info->cache, info->object);
 }
 
 static inline bool kernel_or_module_addr(const void *addr)
@@ -296,7 +295,7 @@ static void print_address_description(vo
 	pr_err("\n");
 
 	if (info->cache && info->object) {
-		describe_object(info->cache, info->object, addr, tag);
+		describe_object(addr, tag, info);
 		pr_err("\n");
 	}
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


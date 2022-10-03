Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1879C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJCVIo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJCVGn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CCF1261C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47363B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0E9C433D7;
        Mon,  3 Oct 2022 21:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831157;
        bh=bHY4npuc91LzgEEFeSxqJuDa2Oo1lWmCOme4Fw4p6eI=;
        h=Date:To:From:Subject:From;
        b=XXOJkXzUvcNCgYFOpxsQiWRnYVwPMTZNhw/R0+rmaA/yYFDHahnNrOorBMH2camG9
         h26hzSgtFSxDRudsObWjV0y/jEguh4EAU9zLDXeN+RinV0e4w5IKsymAGuwyzf2P/g
         Y+nR6itDJlWSWrQfDAv0YjgRsMwBwWdMVL/RDd94=
Date:   Mon, 03 Oct 2022 14:05:56 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-clear-metadata-functions-for-tag-based-modes.patch removed from -mm tree
Message-Id: <20221003210556.DD0E9C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: clear metadata functions for tag-based modes
has been removed from the -mm tree.  Its filename was
     kasan-clear-metadata-functions-for-tag-based-modes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clear metadata functions for tag-based modes
Date: Mon, 5 Sep 2022 23:05:24 +0200

Remove implementations of the metadata-related functions for the tag-based
modes.

The following patches in the series will provide alternative
implementations.

As of this patch, the tag-based modes no longer collect alloc and free
stack traces.  This functionality will be restored later in the series.

Link: https://lkml.kernel.org/r/470fbe5d15e8015092e76e395de354be18ccceab.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

--- a/mm/kasan/tags.c~kasan-clear-metadata-functions-for-tag-based-modes
+++ a/mm/kasan/tags.c
@@ -19,54 +19,25 @@
 
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta)
-		__memset(alloc_meta, 0, sizeof(*alloc_meta));
 }
 
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta)
-		kasan_set_track(&alloc_meta->alloc_track, flags);
 }
 
 void kasan_save_free_info(struct kmem_cache *cache,
 				void *object, u8 tag)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return;
-
-	kasan_set_track(&alloc_meta->free_track, GFP_NOWAIT);
 }
 
 struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
 						void *object)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return NULL;
-
-	return &alloc_meta->alloc_track;
+	return NULL;
 }
 
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
 						void *object, u8 tag)
 {
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return NULL;
-
-	return &alloc_meta->free_track;
+	return NULL;
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


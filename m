Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4FAC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiJCVJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJCVID (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C556B4F186
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 686BEB811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B81EC433B5;
        Mon,  3 Oct 2022 21:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831170;
        bh=27+xB6cclHaOWiZ0Wtt+7jzwgGjYqbljZmT32HoLa3s=;
        h=Date:To:From:Subject:From;
        b=G3sdhwlXljY3oB76pWF6JfcbhPOtw5XI6iW7HglbRGARzGAFskBZTtthVS8jAYSYK
         Fa3lnlrMKn9I56x6PjiCddQ0M3rrsZp+Vaydizr+yzEdDb0cSOK4yEKezt5F6MooI5
         CAoRlsmevh70L+vJHy5l9gRzci5UTx83MtkUIOug=
Date:   Mon, 03 Oct 2022 14:06:09 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-move-kasan_get_alloc-free_track-definitions.patch removed from -mm tree
Message-Id: <20221003210610.1B81EC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: move kasan_get_alloc/free_track definitions
has been removed from the -mm tree.  Its filename was
     kasan-move-kasan_get_alloc-free_track-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move kasan_get_alloc/free_track definitions
Date: Mon, 5 Sep 2022 23:05:35 +0200

Move the definitions of kasan_get_alloc/free_track() to report_*.c, as
they belong with other the reporting code.

Link: https://lkml.kernel.org/r/0cb15423956889b3905a0174b58782633bbbd72e.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c        |   21 ---------------------
 mm/kasan/report_generic.c |   21 +++++++++++++++++++++
 mm/kasan/report_tags.c    |   12 ++++++++++++
 mm/kasan/tags.c           |   12 ------------
 4 files changed, 33 insertions(+), 33 deletions(-)

--- a/mm/kasan/generic.c~kasan-move-kasan_get_alloc-free_track-definitions
+++ a/mm/kasan/generic.c
@@ -512,24 +512,3 @@ void kasan_save_free_info(struct kmem_ca
 	/* The object was freed and has free track set. */
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREETRACK;
 }
-
-struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
-						void *object)
-{
-	struct kasan_alloc_meta *alloc_meta;
-
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (!alloc_meta)
-		return NULL;
-
-	return &alloc_meta->alloc_track;
-}
-
-struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-						void *object, u8 tag)
-{
-	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREETRACK)
-		return NULL;
-	/* Free meta must be present with KASAN_SLAB_FREETRACK. */
-	return &kasan_get_free_meta(cache, object)->free_track;
-}
--- a/mm/kasan/report_generic.c~kasan-move-kasan_get_alloc-free_track-definitions
+++ a/mm/kasan/report_generic.c
@@ -127,6 +127,27 @@ const char *kasan_get_bug_type(struct ka
 	return get_wild_bug_type(info);
 }
 
+struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
+						void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return NULL;
+
+	return &alloc_meta->alloc_track;
+}
+
+struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
+						void *object, u8 tag)
+{
+	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREETRACK)
+		return NULL;
+	/* Free meta must be present with KASAN_SLAB_FREETRACK. */
+	return &kasan_get_free_meta(cache, object)->free_track;
+}
+
 void kasan_metadata_fetch_row(char *buffer, void *row)
 {
 	memcpy(buffer, kasan_mem_to_shadow(row), META_BYTES_PER_ROW);
--- a/mm/kasan/report_tags.c~kasan-move-kasan_get_alloc-free_track-definitions
+++ a/mm/kasan/report_tags.c
@@ -21,3 +21,15 @@ const char *kasan_get_bug_type(struct ka
 
 	return "invalid-access";
 }
+
+struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
+						void *object)
+{
+	return NULL;
+}
+
+struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
+						void *object, u8 tag)
+{
+	return NULL;
+}
--- a/mm/kasan/tags.c~kasan-move-kasan_get_alloc-free_track-definitions
+++ a/mm/kasan/tags.c
@@ -24,15 +24,3 @@ void kasan_save_alloc_info(struct kmem_c
 void kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 }
-
-struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
-						void *object)
-{
-	return NULL;
-}
-
-struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-						void *object, u8 tag)
-{
-	return NULL;
-}
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


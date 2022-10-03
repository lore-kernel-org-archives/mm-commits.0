Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61FDC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiJCVIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiJCVGm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CDA4DB63
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5079CE0E70
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BDAC433D6;
        Mon,  3 Oct 2022 21:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831154;
        bh=PL6A11pdMvPJgyRjCb5D3kqO6crfSUK2sMV4EWxgaEw=;
        h=Date:To:From:Subject:From;
        b=tNV5e7rDNWh/zcrARisXTH1tKt5HzQ6cYVtef9d5UeNysNEU8ebbWaurtnLc4wCnX
         lN4s082KDLaVhjReT4OaSehqriICIWAnVTmJ+vZacDe1M5kgnImRn13wQ6PjJnbNBd
         hftmC8CiYAqAJfrbNMkkhsup9nRTwQR9aOV2fLQI=
Date:   Mon, 03 Oct 2022 14:05:53 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-introduce-kasan_get_alloc_track.patch removed from -mm tree
Message-Id: <20221003210554.82BDAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: introduce kasan_get_alloc_track
has been removed from the -mm tree.  Its filename was
     kasan-introduce-kasan_get_alloc_track.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: introduce kasan_get_alloc_track
Date: Mon, 5 Sep 2022 23:05:22 +0200

Add a kasan_get_alloc_track() helper that fetches alloc_track for a slab
object and use this helper in the common reporting code.

For now, the implementations of this helper are the same for the Generic
and tag-based modes, but they will diverge later in the series.

This change hides references to alloc_meta from the common reporting code.
This is desired as only the Generic mode will be using per-object
metadata after this series.

Link: https://lkml.kernel.org/r/0c365a35f4a833fff46f9d42c3212b32f7166556.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |   14 +++++++++++++-
 mm/kasan/kasan.h   |    4 +++-
 mm/kasan/report.c  |    8 ++++----
 mm/kasan/tags.c    |   14 +++++++++++++-
 4 files changed, 33 insertions(+), 7 deletions(-)

--- a/mm/kasan/generic.c~kasan-introduce-kasan_get_alloc_track
+++ a/mm/kasan/generic.c
@@ -381,8 +381,20 @@ void kasan_save_free_info(struct kmem_ca
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREETRACK;
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
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-				void *object, u8 tag)
+						void *object, u8 tag)
 {
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREETRACK)
 		return NULL;
--- a/mm/kasan/kasan.h~kasan-introduce-kasan_get_alloc_track
+++ a/mm/kasan/kasan.h
@@ -283,8 +283,10 @@ depot_stack_handle_t kasan_save_stack(gf
 void kasan_set_track(struct kasan_track *track, gfp_t flags);
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
 void kasan_save_free_info(struct kmem_cache *cache, void *object, u8 tag);
+struct kasan_track *kasan_get_alloc_track(struct kmem_cache *cache,
+						void *object);
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-				void *object, u8 tag);
+						void *object, u8 tag);
 
 #if defined(CONFIG_KASAN_GENERIC) && \
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
--- a/mm/kasan/report.c~kasan-introduce-kasan_get_alloc_track
+++ a/mm/kasan/report.c
@@ -255,12 +255,12 @@ static void describe_object_addr(struct
 static void describe_object_stacks(struct kmem_cache *cache, void *object,
 					const void *addr, u8 tag)
 {
-	struct kasan_alloc_meta *alloc_meta;
+	struct kasan_track *alloc_track;
 	struct kasan_track *free_track;
 
-	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta) {
-		print_track(&alloc_meta->alloc_track, "Allocated");
+	alloc_track = kasan_get_alloc_track(cache, object);
+	if (alloc_track) {
+		print_track(alloc_track, "Allocated");
 		pr_err("\n");
 	}
 
--- a/mm/kasan/tags.c~kasan-introduce-kasan_get_alloc_track
+++ a/mm/kasan/tags.c
@@ -38,8 +38,20 @@ void kasan_save_free_info(struct kmem_ca
 	kasan_set_track(&alloc_meta->free_track, GFP_NOWAIT);
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
 struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-				void *object, u8 tag)
+						void *object, u8 tag)
 {
 	struct kasan_alloc_meta *alloc_meta;
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch


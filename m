Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C286EC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE10221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781482;
	bh=bMPlmWUVN/ErHwKvXeAt3vBfRTf0jIS/FfXPen0RXJI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RE6LIdfRn45Bq1HuMtdp5eh8eDbMc03V8Sg/B0IRQQACR56Vp9DPJ8QvMIlXJ5LuD
	 I++wkQcMlgoxgCLW3TSp9IJZSm4C3m3TLEg25U8mnOu6W6zvvVumv5K6YBCMAVeE58
	 vFmU/3szjLsjISYhw2rS/TXqLqlFR9HcDqx+hxFQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgHGGYm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGYm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9088F22C9F;
        Fri,  7 Aug 2020 06:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781480;
        bh=bMPlmWUVN/ErHwKvXeAt3vBfRTf0jIS/FfXPen0RXJI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RldolIukXe6PUDVo94+DQ4t3c1xAEsp69mcDzd354n/tisQnGKdh00HjpUjZKYaER
         Mlx4RxxXcrhrm0+02XPeUalf+K6uH3Ne+ffHXMhGF4iMNeRAf8Gn2J8LEJLdZblzde
         nxwo3cOLoo6N5VPSbyB7XIF8oWrAGc0gmJ2gVY0Y=
Date:   Thu, 06 Aug 2020 23:24:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com,
        glider@google.com, jiangshanlai@gmail.com, joel@joelfernandes.org,
        josh@joshtriplett.org, linux-mm@kvack.org,
        mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject:  [patch 131/163] kasan: record and print the free track
Message-ID: <20200807062439.m2Dbm5uOQ%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: record and print the free track

Move free track from kasan_alloc_meta to kasan_free_meta in order to make
struct kasan_alloc_meta and kasan_free_meta size are both 16 bytes.  It is
a good size because it is the minimal redzone size and a good number of
alignment.

For free track, we make some modifications as shown below:
1) Remove the free_track from struct kasan_alloc_meta.
2) Add the free_track into struct kasan_free_meta.
3) Add a macro KASAN_KMALLOC_FREETRACK in order to check whether
   it can print free stack in KASAN report.

[1]https://bugzilla.kernel.org/show_bug.cgi?id=198437

[walter-zh.wu@mediatek.com: build fix]
  Link: http://lkml.kernel.org/r/20200710162440.23887-1-walter-zh.wu@mediatek.com
Link: http://lkml.kernel.org/r/20200601051022.1230-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Co-developed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c         |   22 +--------------------
 mm/kasan/generic.c        |   22 +++++++++++++++++++++
 mm/kasan/generic_report.c |    1 
 mm/kasan/kasan.h          |   16 ++++++++++++---
 mm/kasan/quarantine.c     |    1 
 mm/kasan/report.c         |   26 +++----------------------
 mm/kasan/tags.c           |   37 ++++++++++++++++++++++++++++++++++++
 7 files changed, 80 insertions(+), 45 deletions(-)

--- a/mm/kasan/common.c~kasan-record-and-print-the-free-track
+++ a/mm/kasan/common.c
@@ -50,7 +50,7 @@ depot_stack_handle_t kasan_save_stack(gf
 	return stack_depot_save(entries, nr_entries, flags);
 }
 
-static inline void set_track(struct kasan_track *track, gfp_t flags)
+void kasan_set_track(struct kasan_track *track, gfp_t flags)
 {
 	track->pid = current->pid;
 	track->stack = kasan_save_stack(flags);
@@ -298,24 +298,6 @@ struct kasan_free_meta *get_free_info(st
 	return (void *)object + cache->kasan_info.free_meta_offset;
 }
 
-
-static void kasan_set_free_info(struct kmem_cache *cache,
-		void *object, u8 tag)
-{
-	struct kasan_alloc_meta *alloc_meta;
-	u8 idx = 0;
-
-	alloc_meta = get_alloc_info(cache, object);
-
-#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
-	idx = alloc_meta->free_track_idx;
-	alloc_meta->free_pointer_tag[idx] = tag;
-	alloc_meta->free_track_idx = (idx + 1) % KASAN_NR_FREE_STACKS;
-#endif
-
-	set_track(&alloc_meta->free_track[idx], GFP_NOWAIT);
-}
-
 void kasan_poison_slab(struct page *page)
 {
 	unsigned long i;
@@ -491,7 +473,7 @@ static void *__kasan_kmalloc(struct kmem
 		KASAN_KMALLOC_REDZONE);
 
 	if (cache->flags & SLAB_KASAN)
-		set_track(&get_alloc_info(cache, object)->alloc_track, flags);
+		kasan_set_track(&get_alloc_info(cache, object)->alloc_track, flags);
 
 	return set_tag(object, tag);
 }
--- a/mm/kasan/generic.c~kasan-record-and-print-the-free-track
+++ a/mm/kasan/generic.c
@@ -345,3 +345,25 @@ void kasan_record_aux_stack(void *addr)
 	alloc_info->aux_stack[1] = alloc_info->aux_stack[0];
 	alloc_info->aux_stack[0] = kasan_save_stack(GFP_NOWAIT);
 }
+
+void kasan_set_free_info(struct kmem_cache *cache,
+				void *object, u8 tag)
+{
+	struct kasan_free_meta *free_meta;
+
+	free_meta = get_free_info(cache, object);
+	kasan_set_track(&free_meta->free_track, GFP_NOWAIT);
+
+	/*
+	 *  the object was freed and has free track set
+	 */
+	*(u8 *)kasan_mem_to_shadow(object) = KASAN_KMALLOC_FREETRACK;
+}
+
+struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
+				void *object, u8 tag)
+{
+	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_KMALLOC_FREETRACK)
+		return NULL;
+	return &get_free_info(cache, object)->free_track;
+}
--- a/mm/kasan/generic_report.c~kasan-record-and-print-the-free-track
+++ a/mm/kasan/generic_report.c
@@ -80,6 +80,7 @@ static const char *get_shadow_bug_type(s
 		break;
 	case KASAN_FREE_PAGE:
 	case KASAN_KMALLOC_FREE:
+	case KASAN_KMALLOC_FREETRACK:
 		bug_type = "use-after-free";
 		break;
 	case KASAN_ALLOCA_LEFT:
--- a/mm/kasan/kasan.h~kasan-record-and-print-the-free-track
+++ a/mm/kasan/kasan.h
@@ -17,15 +17,17 @@
 #define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
 #define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
 #define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
+#define KASAN_KMALLOC_FREETRACK 0xFA  /* object was freed and has free track set */
 #else
 #define KASAN_FREE_PAGE         KASAN_TAG_INVALID
 #define KASAN_PAGE_REDZONE      KASAN_TAG_INVALID
 #define KASAN_KMALLOC_REDZONE   KASAN_TAG_INVALID
 #define KASAN_KMALLOC_FREE      KASAN_TAG_INVALID
+#define KASAN_KMALLOC_FREETRACK KASAN_TAG_INVALID
 #endif
 
-#define KASAN_GLOBAL_REDZONE    0xFA  /* redzone for global variable */
-#define KASAN_VMALLOC_INVALID   0xF9  /* unallocated space in vmapped page */
+#define KASAN_GLOBAL_REDZONE    0xF9  /* redzone for global variable */
+#define KASAN_VMALLOC_INVALID   0xF8  /* unallocated space in vmapped page */
 
 /*
  * Stack redzone shadow values
@@ -110,8 +112,9 @@ struct kasan_alloc_meta {
 	 * The free stack is stored into struct kasan_free_meta.
 	 */
 	depot_stack_handle_t aux_stack[2];
-#endif
+#else
 	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
+#endif
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	u8 free_pointer_tag[KASAN_NR_FREE_STACKS];
 	u8 free_track_idx;
@@ -126,6 +129,9 @@ struct kasan_free_meta {
 	 * Otherwise it might be used for the allocator freelist.
 	 */
 	struct qlist_node quarantine_link;
+#ifdef CONFIG_KASAN_GENERIC
+	struct kasan_track free_track;
+#endif
 };
 
 struct kasan_alloc_meta *get_alloc_info(struct kmem_cache *cache,
@@ -167,6 +173,10 @@ void kasan_report_invalid_free(void *obj
 struct page *kasan_addr_to_page(const void *addr);
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags);
+void kasan_set_track(struct kasan_track *track, gfp_t flags);
+void kasan_set_free_info(struct kmem_cache *cache, void *object, u8 tag);
+struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
+				void *object, u8 tag);
 
 #if defined(CONFIG_KASAN_GENERIC) && \
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
--- a/mm/kasan/quarantine.c~kasan-record-and-print-the-free-track
+++ a/mm/kasan/quarantine.c
@@ -145,6 +145,7 @@ static void qlink_free(struct qlist_node
 	if (IS_ENABLED(CONFIG_SLAB))
 		local_irq_save(flags);
 
+	*(u8 *)kasan_mem_to_shadow(object) = KASAN_KMALLOC_FREE;
 	___cache_free(cache, object, _THIS_IP_);
 
 	if (IS_ENABLED(CONFIG_SLAB))
--- a/mm/kasan/report.c~kasan-record-and-print-the-free-track
+++ a/mm/kasan/report.c
@@ -165,26 +165,6 @@ static void describe_object_addr(struct
 		(void *)(object_addr + cache->object_size));
 }
 
-static struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
-		void *object, u8 tag)
-{
-	struct kasan_alloc_meta *alloc_meta;
-	int i = 0;
-
-	alloc_meta = get_alloc_info(cache, object);
-
-#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
-	for (i = 0; i < KASAN_NR_FREE_STACKS; i++) {
-		if (alloc_meta->free_pointer_tag[i] == tag)
-			break;
-	}
-	if (i == KASAN_NR_FREE_STACKS)
-		i = alloc_meta->free_track_idx;
-#endif
-
-	return &alloc_meta->free_track[i];
-}
-
 static void describe_object(struct kmem_cache *cache, void *object,
 				const void *addr, u8 tag)
 {
@@ -196,8 +176,10 @@ static void describe_object(struct kmem_
 		print_track(&alloc_info->alloc_track, "Allocated");
 		pr_err("\n");
 		free_track = kasan_get_free_track(cache, object, tag);
-		print_track(free_track, "Freed");
-		pr_err("\n");
+		if (free_track) {
+			print_track(free_track, "Freed");
+			pr_err("\n");
+		}
 
 #ifdef CONFIG_KASAN_GENERIC
 		if (alloc_info->aux_stack[0]) {
--- a/mm/kasan/tags.c~kasan-record-and-print-the-free-track
+++ a/mm/kasan/tags.c
@@ -161,3 +161,40 @@ void __hwasan_tag_memory(unsigned long a
 	kasan_poison_shadow((void *)addr, size, tag);
 }
 EXPORT_SYMBOL(__hwasan_tag_memory);
+
+void kasan_set_free_info(struct kmem_cache *cache,
+				void *object, u8 tag)
+{
+	struct kasan_alloc_meta *alloc_meta;
+	u8 idx = 0;
+
+	alloc_meta = get_alloc_info(cache, object);
+
+#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
+	idx = alloc_meta->free_track_idx;
+	alloc_meta->free_pointer_tag[idx] = tag;
+	alloc_meta->free_track_idx = (idx + 1) % KASAN_NR_FREE_STACKS;
+#endif
+
+	kasan_set_track(&alloc_meta->free_track[idx], GFP_NOWAIT);
+}
+
+struct kasan_track *kasan_get_free_track(struct kmem_cache *cache,
+				void *object, u8 tag)
+{
+	struct kasan_alloc_meta *alloc_meta;
+	int i = 0;
+
+	alloc_meta = get_alloc_info(cache, object);
+
+#ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
+	for (i = 0; i < KASAN_NR_FREE_STACKS; i++) {
+		if (alloc_meta->free_pointer_tag[i] == tag)
+			break;
+	}
+	if (i == KASAN_NR_FREE_STACKS)
+		i = alloc_meta->free_track_idx;
+#endif
+
+	return &alloc_meta->free_track[i];
+}
_
